<#
.SYNOPSIS
  Verifies the generated resume artifacts are two pages and ATS-safe.

.DESCRIPTION
  Checks assets/Jin-Lee-Resume.pdf directly, and renders
  assets/Jin-Lee-Resume.docx through Word to confirm its real pagination
  (python-docx cannot compute page counts).

  The .docx is copied to a temp file before Word opens it, because Word keeps
  an exclusive lock on whatever it has open and that would block the next
  tools/build_resume_docx.py run.

  Run this from an interactive PowerShell session. Word automation needs an
  STA apartment and can hang indefinitely when this script is launched from a
  nested, non-interactive `powershell -File` child process.

.EXAMPLE
  pwsh tools/check_resume.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$docxPath = Join-Path $repoRoot 'assets\Jin-Lee-Resume.docx'
$pdfPath = Join-Path $repoRoot 'assets\Jin-Lee-Resume.pdf'

$inspect = Join-Path $PSScriptRoot 'inspect_resume_pdf.py'

if (Test-Path $pdfPath) {
  'PDF  -> ' + (python $inspect $pdfPath)
} else {
  Write-Warning "Missing $pdfPath (run tools/build_resume_pdf.ps1)."
}

if (-not (Test-Path $docxPath)) {
  Write-Warning "Missing $docxPath (run tools/build_resume_docx.py)."
  return
}

$tempDocx = Join-Path $env:TEMP 'resume-page-check.docx'
$tempPdf = Join-Path $env:TEMP 'resume-page-check.pdf'
Copy-Item $docxPath $tempDocx -Force
if (Test-Path $tempPdf) { Remove-Item $tempPdf -Force }

$word = $null
$document = $null
try {
  $word = New-Object -ComObject Word.Application
  $word.Visible = $false
  # Without this Word can block forever on an invisible modal dialog.
  $word.DisplayAlerts = 0
  $document = $word.Documents.Open($tempDocx, $false, $true)
  $document.ExportAsFixedFormat($tempPdf, 17)  # wdExportFormatPDF
} catch {
  Write-Warning "Word is unavailable, skipping .docx pagination check: $($_.Exception.Message)"
  return
} finally {
  if ($document) { $document.Close($false) | Out-Null }
  if ($word) { $word.Quit() | Out-Null }
}

'DOCX -> ' + (python $inspect $tempPdf)

Remove-Item $tempDocx, $tempPdf -Force -ErrorAction SilentlyContinue
