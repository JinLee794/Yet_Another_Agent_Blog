<#
.SYNOPSIS
  Renders /resume/print/ to assets/Jin-Lee-Resume.pdf using headless Microsoft Edge.

.DESCRIPTION
  The PDF and the .docx are both generated from _data/resume_ats.yml:
    tools/build_resume_docx.py -> assets/Jin-Lee-Resume.docx
    tools/build_resume_pdf.ps1 -> assets/Jin-Lee-Resume.pdf

  Requires the Jekyll site to be serving locally, because the print page is a
  Liquid template. Start it first, e.g.:

    docker run -d --name yaab-jekyll -p 4000:4000 -e JEKYLL_NO_BUNDLER_REQUIRE=true `
      -v "${PWD}:/srv/jekyll:ro" -w /srv/jekyll ruby:3.3 bash -lc `
      "gem install 'jekyll:~>4.3' jekyll-feed jekyll-seo-tag --bindir /usr/local/bin --no-document && `
       jekyll serve --host 0.0.0.0 --port 4000 --destination /tmp/site --disable-disk-cache --baseurl /Yet_Another_Agent_Blog"

.EXAMPLE
  pwsh tools/build_resume_pdf.ps1
#>
[CmdletBinding()]
param(
  [string]$Url = 'http://localhost:4000/Yet_Another_Agent_Blog/resume/print/',
  [string]$OutFile
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $OutFile) { $OutFile = Join-Path $repoRoot 'assets\Jin-Lee-Resume.pdf' }

$edge = @(
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $edge) { throw 'Microsoft Edge was not found; cannot render the PDF.' }

try {
  Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 15 | Out-Null
} catch {
  throw "Print page is not reachable at $Url. Start the local Jekyll server first."
}

if (Test-Path $OutFile) { Remove-Item $OutFile -Force }

# A fresh profile per run guarantees Edge never renders a cached copy.
$profileDir = Join-Path $env:TEMP ("yaab-edge-pdf-" + [guid]::NewGuid().ToString('N'))

# Edge logs benign renderer warnings to stderr; with ErrorActionPreference=Stop
# PowerShell would turn those into a terminating NativeCommandError.
$previousPreference = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
  & $edge --headless=new --disable-gpu --no-first-run --no-pdf-header-footer `
    --user-data-dir="$profileDir" --print-to-pdf="$OutFile" $Url 2>&1 | Out-Null
} finally {
  $ErrorActionPreference = $previousPreference
  Remove-Item $profileDir -Recurse -Force -ErrorAction SilentlyContinue
}

for ($i = 0; $i -lt 20 -and -not (Test-Path $OutFile); $i++) { Start-Sleep -Milliseconds 500 }

if (-not (Test-Path $OutFile)) { throw "Edge did not produce $OutFile." }

'Wrote {0} ({1:N0} bytes)' -f $OutFile, (Get-Item $OutFile).Length
