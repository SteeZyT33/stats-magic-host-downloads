"""Sign plugins/catalog.json, the plugin list Stats Magic Host reads.

    python tools/sign_catalog.py new-key           private key on stdout, public key on stderr
    python tools/sign_catalog.py sign plugins/catalog.json
    python tools/sign_catalog.py verify plugins/catalog.json PUBLIC_KEY_HEX

``sign`` reads the private key from the PLUGIN_SIGNING_KEY environment variable, refuses a list whose
serial is not higher than the one in the previous commit, and writes plugins/catalog.json.sig.
host_ed25519.py is a copy of backend/host_ed25519.py from Stats Magic Host.
"""
from __future__ import annotations

import json
import os
import secrets
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import host_ed25519  # noqa: E402


def _serial(raw: bytes) -> int:
    payload = json.loads(raw.decode("utf-8"))
    serial = payload.get("serial") if isinstance(payload, dict) else None
    if not isinstance(payload, dict) or payload.get("format") != 1 or not isinstance(serial, int) or serial < 1:
        raise SystemExit("catalog.json needs \"format\": 1 and a whole-number \"serial\" of 1 or more.")
    if not isinstance(payload.get("plugins"), dict):
        raise SystemExit("catalog.json needs a \"plugins\" object.")
    return serial


def _previous_serial(path: Path) -> int:
    """The serial in the commit before this one, or 0 for the first list."""
    shown = subprocess.run(["git", "show", f"HEAD~1:{path.as_posix()}"], capture_output=True, check=False)
    return _serial(shown.stdout) if shown.returncode == 0 else 0


def main(argv: list[str]) -> int:
    if argv[:1] == ["new-key"]:
        seed = secrets.token_bytes(32)
        print(seed.hex())
        print(f"Public key for sm-host: {host_ed25519.public_key(seed).hex()}", file=sys.stderr)
        return 0
    if len(argv) == 2 and argv[0] == "sign":
        path = Path(argv[1])
        raw = path.read_bytes()
        serial, previous = _serial(raw), _previous_serial(path)
        if serial <= previous:
            raise SystemExit(f"Serial {serial} is not higher than the last list's {previous}. Raise it and commit again.")
        seed = bytes.fromhex(os.environ["PLUGIN_SIGNING_KEY"].strip())
        signature = host_ed25519.sign(seed, raw)
        assert host_ed25519.verify(host_ed25519.public_key(seed), raw, signature)
        Path(f"{path}.sig").write_text(signature.hex() + "\n", encoding="ascii")
        print(f"Signed serial {serial} with key {host_ed25519.public_key(seed).hex()}.")
        return 0
    if len(argv) == 3 and argv[0] == "verify":
        path = Path(argv[1])
        signature = bytes.fromhex(Path(f"{path}.sig").read_text(encoding="ascii").strip())
        good = host_ed25519.verify(bytes.fromhex(argv[2]), path.read_bytes(), signature)
        print("Signature OK." if good else "Signature does NOT match.")
        return 0 if good else 1
    print(__doc__, file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
