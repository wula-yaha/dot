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

        # Alacritty
        (Join-Path (Join-Path $DotDir "alacritty") "alacritty.toml") = (Join-Path (Join-Path $env:APPDATA "alacritty") "alacritty.toml")

        # Emacs
        (Join-Path (Join-Path $DotDir "emacs") "early-init.el") = (Join-Path (Join-Path $env:APPDATA ".emacs.d") "early-inig.el")
        (Join-Path (Join-Path $DotDir "emacs") "init.el") = (Join-Path (Join-Path $env:APPDATA ".emacs.d") "init.el")

        # Helix
        (Join-Path (Join-Path $DotDir "helix") "config.toml") = (Join-Path (Join-Path $env:APPDATA "helix") "config.toml")
        (Join-Path (Join-Path $DotDir "helix") "themes") = (Join-Path (Join-Path $env:APPDATA "helix") "themes")

        # Komorebi
        (Join-Path (Join-Path $DotDir "komorebi") "komorebi.json") = (Join-Path $env:APPDATA "komorebi.json")
        (Join-Path (Join-Path $DotDir "komorebi") "komorebi.bar.json") = (Join-Path $env:APPDATA "komorebi.bar.json")
        
        # Neovim
        (Join-Path (Join-Path $DotDir "nvim") "init.lua") = (Join-Path (Join-Path $env:LOCALAPPDATA "nvim") "init.lua")

        # Vim
        (Join-Path (Join-Path $DotDir "vim") "init.vim") = (Join-Path $env:USERPROFILE "_vimrc")

        # VSCode
        (Join-Path (Join-Path $DotDir "vscode") "settings.json") = (Join-Path (Join-Path (Join-Path $env:APPDATA "Code") "User") "settings.json")
        (Join-Path (Join-Path $DotDir "vscode") "keybindings.json") = (Join-Path (Join-Path (Join-Path $env:APPDATA "Code") "User") "keybindings.json")

        # WezTerm
        (Join-Path (Join-Path $DotDir "wezterm") "wezterm.lua") = (Join-Path $env:USERPROFILE ".wezterm.lua")

        # WHKD
        (Join-Path (Join-Path $DotDir "whkd") "whkdrc") = (Join-Path (Join-Path $env:USERPROFILE ".config") "whkdrc")
        
        # WindowsTerminal
        (Join-Path (Join-Path $DotDir "WindowsTerminal") "settings.json") = (Join-Path (Join-Path (Join-Path (Join-Path $env:LOCALAPPDATA "Packages") "Microsoft.WindowsTerminal_8wekyb3d8bbwe") "LocalState") "settings.json")

        # Zed
        (Join-Path (Join-Path $DotDir "zed") "settings.json") = (Join-Path (Join-Path $env:APPDATA "Zed") "settings.json")
        (Join-Path (Join-Path $DotDir "zed") "keymap.json") = (Join-Path (Join-Path $env:APPDATA "Zed") "keymap.json")

    }

    foreach ($source in $linkMap.Keys) {
        $destination = $LinkMap[$source]
        New-Link -Source $source -Destination $destination
    }

}

Main
