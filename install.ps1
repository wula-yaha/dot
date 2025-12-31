$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

function New-Link {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    # Source file existence checking
    if (-not (Test-Path $Source)) {
        Write-Warning "Source file not found, skipping: $Source"
        return
    }

    # Parent directory existence checking
    $ParentDir = Split-Path -Path $Destination -Parent
    if (-not (Test-Path $ParentDir)) {
        Write-Verbose "Destination directory not found. Creating '$ParentDir'."
        if ($PSCmdlet.ShouldProcess($ParentDir, "Create Directory")) {
            New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
        }
    }

    # If the destination path is already occupied, back up 
    # the existing item unless it is already the correct symbolic link.
    if (Test-Path $Destination -PathType Any) {
        $DestItem = Get-Item -Path $Destination -Force
        if ($DestItem.Attributes.ToString().Contains("ReparsePoint")) {
            if ($DestItem.Target -eq $Source) {
                Write-Verbose "$Destination is already linked to the correct file."
                return
            }
        }
        else {
            $TimeStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
            $BackupPath = "${Destination}.bak.${TimeStamp}"
            if ($PSCmdlet.ShouldProcess($Destination, "Backup to '$backupPath'")) {
                Write-Host "Backup: $Destination -> $BackupPath" -ForegroundColor Yellow
                Move-Item -Path $Destination -Destination $BackupPath -Force
            }
        }
    }

    # Softlink creating
    if ($PSCmdlet.ShouldProcess($Destination, "Create SymbolicLink pointing to '$Source'")) {
        Write-Host "Link: $Destination -> $Source" -ForegroundColor Green
        New-Item -ItemType SymbolicLink -Path $Destination -Value $Source -Force | Out-Null
    }
}

function Main {

    $DotDir = $PSScriptRoot

    $LinkMap = @{

        # Neovim
        (Join-Path (Join-Path $DotDir "nvim") "init.lua") = (Join-Path (Join-Path $env:LOCALAPPDATA "nvim") "init.lua")

        # WezTerm
        (Join-Path (Join-Path $DotDir "wezterm") "wezterm.lua") = (Join-Path $env:USERPROFILE ".wezterm.lua")

    }

    foreach ($source in $linkMap.Keys) {
        $destination = $LinkMap[$source]
        New-Link -Source $source -Destination $destination
    }

}

Main
