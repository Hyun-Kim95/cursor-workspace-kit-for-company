# Sync harness hook SSOT from shared/hooks/ into .cursor/hooks/ (whitelist only; does not remove other hooks).

$ErrorActionPreference = "Stop"
$KitRoot = Split-Path -Parent $PSScriptRoot
$SourceDir = Join-Path $KitRoot "shared\hooks"
$DestDir = Join-Path $KitRoot ".cursor\hooks"

$whitelist = @(
    "guard-shell.ps1",
    "guard-shell.patterns.json",
    "quality-gate.ps1",
    "dev-server-harness.ps1",
    "rule-signal-capture.ps1",
    "rule-signal-patterns.json",
    "work-log-on-prompt.ps1",
    "kit-wiki-on-prompt.ps1"
)

if (-not (Test-Path -LiteralPath $SourceDir)) {
    Write-Host "sync-hooks: no shared/hooks (skip)"
    exit 0
}

if (-not (Test-Path -LiteralPath $DestDir)) {
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
}

$n = 0
foreach ($name in $whitelist) {
    $src = Join-Path $SourceDir $name
    if (Test-Path -LiteralPath $src) {
        Copy-Item -LiteralPath $src -Destination (Join-Path $DestDir $name) -Force
        $n++
    }
}

Write-Host "sync-hooks: copied $n harness file(s) to .cursor/hooks"

# Kit-self dogfooding: seed .cursor/quality-gate.json from the committed example
# once (the real file is gitignored). Never overwrite local edits.
$qgExample = Join-Path $KitRoot ".cursor\quality-gate.json.example"
$qgReal = Join-Path $KitRoot ".cursor\quality-gate.json"
if ((Test-Path -LiteralPath $qgExample) -and -not (Test-Path -LiteralPath $qgReal)) {
    Copy-Item -LiteralPath $qgExample -Destination $qgReal -Force
    Write-Host "sync-hooks: seeded .cursor/quality-gate.json from example (kit self quality gate)"
}
