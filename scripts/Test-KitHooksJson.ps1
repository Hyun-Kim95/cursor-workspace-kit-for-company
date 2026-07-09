# Consistency check for .cursor/hooks.json (kit repo self).
# Verifies: valid JSON, no duplicate command per event, no UTF-8 BOM,
# every referenced .cursor/hooks/*.ps1 script exists, and each hook script
# parses under Windows PowerShell 5.1 (BOM-less files with Korean literals
# are read as ANSI/CP949 and can fail to parse -> hook silently dead).
# Exit 0 = OK, 1 = problem found. Used by the kit-self quality gate.

param(
    [Parameter(Mandatory = $false)]
    [string]$WorkspaceRoot = ""
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($WorkspaceRoot)) {
    $scriptsDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $WorkspaceRoot = Split-Path -Parent $scriptsDir
}
$hooksPath = Join-Path $WorkspaceRoot ".cursor\hooks.json"
$fail = 0

if (-not (Test-Path -LiteralPath $hooksPath)) {
    Write-Host "Test-KitHooksJson: no .cursor/hooks.json (skip)"
    exit 0
}

$bytes = [System.IO.File]::ReadAllBytes($hooksPath)
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Write-Host "FAIL: hooks.json has UTF-8 BOM (encoding-utf8-global: BOM 없음)"
    $fail++
}

try {
    $doc = Get-Content -LiteralPath $hooksPath -Raw -Encoding UTF8 | ConvertFrom-Json
}
catch {
    Write-Host "FAIL: hooks.json is not valid JSON — $($_.Exception.Message)"
    exit 1
}

if (-not ($doc.PSObject.Properties | Where-Object { $_.Name -eq "hooks" })) {
    Write-Host "FAIL: hooks.json has no 'hooks' object"
    exit 1
}

foreach ($ev in $doc.hooks.PSObject.Properties) {
    $cmds = @($ev.Value) | ForEach-Object { [string]$_.command }
    $dupes = $cmds | Group-Object | Where-Object { $_.Count -gt 1 }
    if ($dupes) {
        foreach ($d in $dupes) {
            Write-Host ("FAIL: duplicate in event '" + $ev.Name + "': " + $d.Name)
        }
        $fail++
    }

    foreach ($cmd in $cmds) {
        if ($cmd -match '\.cursor[/\\]hooks[/\\]([^\s"]+\.ps1)') {
            $scriptRel = $Matches[1]
            $scriptPath = Join-Path $WorkspaceRoot (".cursor\hooks\" + $scriptRel)
            if (-not (Test-Path -LiteralPath $scriptPath)) {
                Write-Host ("FAIL: event '" + $ev.Name + "' references missing script: .cursor/hooks/" + $scriptRel)
                $fail++
                continue
            }
            $parseErrors = $null
            [System.Management.Automation.Language.Parser]::ParseFile($scriptPath, [ref]$null, [ref]$parseErrors) | Out-Null
            if (@($parseErrors).Count -gt 0) {
                Write-Host ("FAIL: hook script does not parse under PS 5.1: .cursor/hooks/" + $scriptRel + " (" + @($parseErrors).Count + " errors; non-ASCII literals need a UTF-8 BOM)")
                $fail++
            }

            # Cursor may prefix the stdin payload with a UTF-8 BOM; bare
            # [Console]::In.ReadToEnd() decodes as CP949 or leaves U+FEFF and
            # ConvertFrom-Json then fails. Hooks must use Read-HookStdinJson /
            # a UTF-8 StreamReader instead (docs/agent/encoding.md).
            $src = [System.IO.File]::ReadAllText($scriptPath)
            if ($src -match '\[Console\]::In\.ReadToEnd\(\)' -and $src -notmatch 'OpenStandardInput') {
                Write-Host ("FAIL: hook reads stdin via [Console]::In (BOM/CP949-unsafe): .cursor/hooks/" + $scriptRel)
                $fail++
            }
        }
    }
}

if ($fail -gt 0) {
    Write-Host "Test-KitHooksJson: $fail problem(s) found."
    exit 1
}

Write-Host "Test-KitHooksJson: OK"
exit 0
