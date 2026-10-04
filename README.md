# Stats Magic Host downloads

[![Current version](https://img.shields.io/github/v/release/SteeZyT33/stats-magic-host-downloads?display_name=tag&label=current%20version)](https://github.com/SteeZyT33/stats-magic-host-downloads/releases/latest)

Public distribution of Stats Magic Host by Amara’s Lab. This repository contains the download page, installation instructions, and release assets. It does not contain the Stats Magic application source.

## Windows

Download [the latest sm-host for Windows](https://github.com/SteeZyT33/stats-magic-host-downloads/releases/latest/download/sm-host-windows-amd64.zip) ([release notes](https://github.com/SteeZyT33/stats-magic-host-downloads/releases/latest)), extract the ZIP, and run `sm-host.exe`. Keep the `_internal` directory beside the executable. Follow the prompts and pair using the code from your Stats Magic website.

The package is unsigned. Windows may show a SmartScreen warning.

## Linux (x86_64)

Download [the latest sm-host for Linux](https://github.com/SteeZyT33/stats-magic-host-downloads/releases/latest/download/sm-host-linux-amd64.tar.gz), then run `tar -xzf sm-host-linux-amd64.tar.gz` and start `./sm-host` from the extracted folder. Pair using the code from your Stats Magic website. Linux packages are included from v1.13.4 onward.

## Integrity

Each release includes SHA256SUMS. On Windows, compare it with `Get-FileHash .\sm-host-windows-amd64.zip -Algorithm SHA256` in PowerShell. On Linux, run `sha256sum -c SHA256SUMS --ignore-missing` in the download folder.

## Maintainers

Only publish reviewed release packages and public documentation here. Never upload device.json, credentials, local state, private logs, or a checkout of the application repository. Do not overwrite existing release assets: publish a new version for changes.

Releases are published here automatically by the CS2-Stats-Magic release workflow. index.html links to the latest release and reads its version, sizes and checksums from the GitHub API, so it needs no edit per release. latest.json is not updated automatically. The website is served by GitHub Pages from main at the repository root. Custom domain target: downloads.amaras-lab.com. DNS CNAME target: SteeZyT33.github.io.
