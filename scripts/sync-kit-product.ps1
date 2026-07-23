# Sync kit SSOT from a kit root (submodule/embedded) into a product workspace .cursor/
# Channel A: project-kit rules + shared/skills + project-kit/skills + shared/agents + harness hooks
# Channel B: full shared + project-kit -> .cursor/rules|skills|agents + harness hooks

param(
    [Parameter(Mandatory = $true)]
    [string]$WorkspaceRoot,
    [Parameter(Mandatory = $true)]
    [string]$KitRoot,
    [Parameter(Mandatory = $false)]
    [ValidateSet("A", "B")]
    [string]$Channel = "B"
)

$ErrorActionPreference = "Stop"
$WorkspaceRoot = (Resolve-Path -LiteralPath $WorkspaceRoot).Path
$KitRoot = (Resolve-Path -LiteralPath $KitRoot).Path

$cursorDest = Join-Path $WorkspaceRoot ".cursor"
$rulesDest = Join-Path $cursorDest "rules"
$skillsDest = Join-Path $cursorDest "skills"
$agentsDest = Join-Path $cursorDest "agents"

$projectKitRules = Join-Path $KitRoot "project-kit\.cursor\rules"
$projectKitSkills = Join-Path $KitRoot "project-kit\.cursor\skills"
$sharedRules = Join-Path $KitRoot "shared\rules"
$sharedOptional = Join-Path $KitRoot "shared\optional"
$sharedSkills = Join-Path $KitRoot "shared\skills"
$sharedAgents = Join-Path $KitRoot "shared\agents"

function Ensure-Dir {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Copy-MdcFiles {
    param([string]$SourceDir, [string]$DestDir)
    if (-not (Test-Path -LiteralPath $SourceDir)) { return 0 }
    Ensure-Dir -Path $DestDir
    $n = 0
    Get-ChildItem -Path $SourceDir -Filter "*.mdc" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $DestDir $_.Name) -Force
        $n++
    }
    return $n
}

function Copy-SkillFolders {
    param([string]$SourceDir, [string]$DestDir, [switch]$ReplaceAll)
    if (-not (Test-Path -LiteralPath $SourceDir)) { return 0 }
    Ensure-Dir -Path $DestDir
    if ($ReplaceAll) {
        Get-ChildItem -Path $DestDir -Directory -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
    }
    $n = 0
    Get-ChildItem -Path $SourceDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $target = Join-Path $DestDir $_.Name
        if (Test-Path -LiteralPath $target) { Remove-Item -LiteralPath $target -Recurse -Force }
        Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse -Force
        $n++
    }
    return $n
}

function Copy-AgentFiles {
    param([string]$SourceDir, [string]$DestDir, [switch]$ReplaceAll)
    if (-not (Test-Path -LiteralPath $SourceDir)) { return 0 }
    Ensure-Dir -Path $DestDir
    if ($ReplaceAll) {
        Get-ChildItem -Path $DestDir -Filter "*.md" -ErrorAction SilentlyContinue | Remove-Item -Force
    }
    $n = 0
    Get-ChildItem -Path $SourceDir -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $DestDir $_.Name) -Force
        $n++
    }
    return $n
}

function Invoke-SyncKitProductHooks {
    param(
        [string]$WorkspaceRoot,
        [string]$KitRoot
    )
    $hooksSync = Join-Path $KitRoot "scripts\Sync-KitProductHooks.ps1"
    if (-not (Test-Path -LiteralPath $hooksSync)) {
        Write-Host "sync-kit-product-hooks: skip (Sync-KitProductHooks.ps1 not found)"
        return
    }
    & powershell -NoProfile -ExecutionPolicy Bypass -File $hooksSync `
        -WorkspaceRoot $WorkspaceRoot -KitRoot $KitRoot
    if ($LASTEXITCODE -ne 0) {
        throw "Sync-KitProductHooks.ps1 failed (exit $LASTEXITCODE)"
    }
}

# Channel A: project-kit rules only + these shared globals (planning/ops defaults).
$script:SharedGlobalRuleNames = @(
    "encoding-utf8-global.mdc"
    "product-monetization-default.mdc"
)

function Copy-SharedGlobalRules {
    param(
        [string]$SharedRulesDir,
        [string]$DestDir
    )
    $n = 0
    Ensure-Dir -Path $DestDir
    foreach ($name in $script:SharedGlobalRuleNames) {
        $src = Join-Path $SharedRulesDir $name
        if (-not (Test-Path -LiteralPath $src)) { continue }
        Copy-Item -LiteralPath $src -Destination (Join-Path $DestDir $name) -Force
        $n++
    }
    return $n
}

function Get-KitSsotSkillNames {
    $names = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    foreach ($dir in @($sharedSkills, $projectKitSkills)) {
        if (-not (Test-Path -LiteralPath $dir)) { continue }
        Get-ChildItem -Path $dir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            [void]$names.Add($_.Name)
        }
    }
    return $names
}

function Get-KitSsotProjectRuleNames {
    $names = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    if (Test-Path -LiteralPath $projectKitRules) {
        Get-ChildItem -Path $projectKitRules -Filter "*.mdc" -ErrorAction SilentlyContinue | ForEach-Object {
            [void]$names.Add($_.Name)
        }
    }
    return $names
}

# Channel A does not wipe .cursor/skills (product-local skills may exist).
# Prune only kit-managed removals: previous sync list + known retirements.
$script:RetiredKitSkillNames = @(
    "context-organization"
)
$script:RetiredProjectKitRuleNames = @(
    "64-context-organization.mdc"
)

function Remove-KitSkillOrphans {
    param(
        [string]$DestDir,
        [string]$StatePath,
        [System.Collections.Generic.HashSet[string]]$SsotNames
    )
    if (-not (Test-Path -LiteralPath $DestDir)) { return 0 }
    $prev = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    if (Test-Path -LiteralPath $StatePath) {
        try {
            $raw = Get-Content -LiteralPath $StatePath -Raw -Encoding UTF8
            $parsed = $raw | ConvertFrom-Json
            foreach ($n in @($parsed.skills)) {
                if ($n) { [void]$prev.Add([string]$n) }
            }
        } catch {
            # ignore corrupt state; still apply retirements
        }
    }

    $removed = 0
    # Always drop known retirements (even if a stale vendor kit still ships them).
    foreach ($name in $script:RetiredKitSkillNames) {
        $path = Join-Path $DestDir $name
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Recurse -Force
            $removed++
            Write-Host "sync-kit-product: pruned retired skill '$name'"
        }
    }

    Get-ChildItem -Path $DestDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $name = $_.Name
        if ($SsotNames.Contains($name)) { return }
        if (-not $prev.Contains($name)) { return }
        Remove-Item -LiteralPath $_.FullName -Recurse -Force
        $removed++
        Write-Host "sync-kit-product: pruned skill orphan '$name'"
    }
    return $removed
}

function Remove-KitProjectRuleOrphans {
    param(
        [string]$DestDir,
        [System.Collections.Generic.HashSet[string]]$SsotRuleNames
    )
    if (-not (Test-Path -LiteralPath $DestDir)) { return 0 }
    $removed = 0
    foreach ($name in $script:RetiredProjectKitRuleNames) {
        if ($SsotRuleNames.Contains($name)) { continue }
        $path = Join-Path $DestDir $name
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Force
            $removed++
            Write-Host "sync-kit-product: pruned rule orphan '$name'"
        }
    }
    return $removed
}

function Write-KitSyncedSkillsState {
    param(
        [string]$StatePath,
        [System.Collections.Generic.HashSet[string]]$SsotNames
    )
    $stateDir = Split-Path -Parent $StatePath
    Ensure-Dir -Path $stateDir
    $payload = [ordered]@{
        updatedAt = (Get-Date).ToString("o")
        skills = @($SsotNames | Sort-Object)
    }
    $json = $payload | ConvertTo-Json -Depth 4
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($StatePath, $json, $utf8NoBom)
}

$rulesCount = 0
$skillsCount = 0
$agentsCount = 0
$skillsStatePath = Join-Path $cursorDest "state\kit-synced-skills.json"
$ssotSkillNames = Get-KitSsotSkillNames
$ssotProjectRuleNames = Get-KitSsotProjectRuleNames

if ($Channel -eq "A") {
    $rulesCount = Copy-MdcFiles -SourceDir $projectKitRules -DestDir $rulesDest
    $rulesCount += Copy-SharedGlobalRules -SharedRulesDir $sharedRules -DestDir $rulesDest
    [void](Remove-KitProjectRuleOrphans -DestDir $rulesDest -SsotRuleNames $ssotProjectRuleNames)
    if (Test-Path -LiteralPath $sharedSkills) {
        $skillsCount = Copy-SkillFolders -SourceDir $sharedSkills -DestDir $skillsDest
    }
    $skillsCount += Copy-SkillFolders -SourceDir $projectKitSkills -DestDir $skillsDest
    [void](Remove-KitSkillOrphans -DestDir $skillsDest -StatePath $skillsStatePath -SsotNames $ssotSkillNames)
    Write-KitSyncedSkillsState -StatePath $skillsStatePath -SsotNames $ssotSkillNames
    if (Test-Path -LiteralPath $sharedAgents) {
        $agentsCount = Copy-AgentFiles -SourceDir $sharedAgents -DestDir $agentsDest
    }
    Invoke-SyncKitProductHooks -WorkspaceRoot $WorkspaceRoot -KitRoot $KitRoot
    Write-Host "sync-kit-product (channel A): rules=$rulesCount skill-folders=$skillsCount agents=$agentsCount"
}
else {
    Ensure-Dir -Path $rulesDest
    Get-ChildItem -Path $rulesDest -Filter "*.mdc" -ErrorAction SilentlyContinue | Remove-Item -Force
    $rulesCount += Copy-MdcFiles -SourceDir $sharedRules -DestDir $rulesDest
    $rulesCount += Copy-MdcFiles -SourceDir $sharedOptional -DestDir $rulesDest
    $rulesCount += Copy-MdcFiles -SourceDir $projectKitRules -DestDir $rulesDest
    $skillsCount = Copy-SkillFolders -SourceDir $sharedSkills -DestDir $skillsDest -ReplaceAll
    $skillsCount += Copy-SkillFolders -SourceDir $projectKitSkills -DestDir $skillsDest
    # Stale vendor kits can still ship removed skills; prune retirements after copy.
    [void](Remove-KitSkillOrphans -DestDir $skillsDest -StatePath $skillsStatePath -SsotNames $ssotSkillNames)
    Write-KitSyncedSkillsState -StatePath $skillsStatePath -SsotNames $ssotSkillNames
    $agentsCount = Copy-AgentFiles -SourceDir $sharedAgents -DestDir $agentsDest -ReplaceAll

    Invoke-SyncKitProductHooks -WorkspaceRoot $WorkspaceRoot -KitRoot $KitRoot
    Write-Host "sync-kit-product (channel B): rules=$rulesCount skills=$skillsCount agents=$agentsCount"
}

$encodingScript = Join-Path $KitRoot "scripts\Ensure-ProductEncodingAssets.ps1"
if (Test-Path -LiteralPath $encodingScript) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $encodingScript -WorkspaceRoot $WorkspaceRoot -KitRoot $KitRoot
    if ($LASTEXITCODE -ne 0) { throw "Ensure-ProductEncodingAssets.ps1 failed (exit $LASTEXITCODE)" }
}
