# Installs or upgrades Stats Magic Host + SM² on Windows from PowerShell:
#   irm https://steezyt33.github.io/stats-magic-host-downloads/install.ps1 | iex
# Host only (managed on the website instead of SM²):
#   $env:STATSMAGIC_EDITION = 'HostOnly'; irm https://steezyt33.github.io/stats-magic-host-downloads/install.ps1 | iex
# Downloads the newest sm2-v* Setup release, checks it against that release's SHA256SUMS, then runs
# Setup, which asks for administrator rights itself. Served from the downloads site with setup.sh.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$repo = 'SteeZyT33/stats-magic-host-downloads'
$name = if ($env:STATSMAGIC_EDITION -eq 'HostOnly') { 'StatsMagicHost-HostOnly-Setup.exe' } else { 'StatsMagicHost-Setup.exe' }

# The 1.13 downloads stay "Latest", so look for the newest sm2-v release by name.
# Windows PowerShell passes a JSON array down the pipeline as one object, so unroll it first.
$releases = @(Invoke-RestMethod "https://api.github.com/repos/$repo/releases?per_page=30" -UseBasicParsing)
$release = $releases | ForEach-Object { $_ } |
  Where-Object { $_.tag_name -match '^sm2-v\d+\.\d+\.\d+$' -and -not $_.draft -and -not $_.prerelease } |
  Select-Object -First 1
if (-not $release) { throw 'No Stats Magic Setup release was found on the downloads page.' }
$tag = $release.tag_name
$base = "https://github.com/$repo/releases/download/$tag"

$dir = Join-Path $env:TEMP "statsmagic-$tag"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$exe = Join-Path $dir $name
$sums = Join-Path $dir 'SHA256SUMS'
Write-Host "Downloading $name ($tag)..."
Invoke-WebRequest "$base/$name" -OutFile $exe -UseBasicParsing
Invoke-WebRequest "$base/SHA256SUMS" -OutFile $sums -UseBasicParsing

$line = Get-Content $sums | Where-Object { $_ -match "^[0-9a-f]{64}  $([regex]::Escape($name))$" } | Select-Object -First 1
$want = if ($line) { $line.Substring(0, 64) } else { '' }
$got = (Get-FileHash -Algorithm SHA256 -Path $exe).Hash.ToLowerInvariant()
if (-not $want -or $got -ne $want) {
  Remove-Item -Force $exe
  throw "$name did not match the SHA256SUMS of $tag, so it was deleted and not run."
}

Write-Host "Starting Setup. Windows asks for administrator rights next."
Start-Process -FilePath $exe -Wait
