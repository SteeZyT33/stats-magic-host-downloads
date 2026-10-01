# Stats Magic Host downloads

[![Current version](https://img.shields.io/github/v/release/SteeZyT33/stats-magic-host-downloads?display_name=tag&label=current%20version)](https://github.com/SteeZyT33/stats-magic-host-downloads/releases/latest)

Public distribution of Stats Magic Host by Amara’s Lab. This repository contains the download page, installation instructions, and release assets. It does not contain the Stats Magic application source.

## Windows

Download [the latest sm-host for Windows](https://github.com/SteeZyT33/stats-magic-host-downloads/releases/latest/download/sm-host-windows-amd64.zip) ([release notes](https://github.com/SteeZyT33/stats-magic-host-downloads/releases/latest)), extract the ZIP, and run `sm-host.exe`. Keep the `_internal` directory beside the executable. Follow the prompts and pair using the code from your Stats Magic website.

The package is unsigned. Windows may show a SmartScreen warning. Linux packages are not available yet.

## Integrity

Each release includes SHA256SUMS. Compare it with `Get-FileHash .\sm-host-windows-amd64.zip -Algorithm SHA256` in PowerShell.

## Maintainers

Only publish reviewed release packages and public documentation here. Never upload device.json, credentials, local state, private logs, or a checkout of the application repository. Do not overwrite existing release assets: publish a new version for changes.

For each new release, verify the source artifact checksum, publish the ZIP and SHA256SUMS together, and update the version, size, links and hash in index.html and latest.json. The website is served by GitHub Pages from main at the repository root. Custom domain target: downloads.amaras-lab.com. DNS CNAME target: SteeZyT33.github.io.
