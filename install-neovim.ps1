# ========================================
# Neovim Auto-Installation Script for Windows 11
# ========================================
# Automatic installation script for Neovim and essential system dependencies only
# Uses Scoop package manager exclusively
# Lazy loader will handle all Neovim plugins and tools

param(
    [switch]$SkipConfirmation,
    [switch]$SkipNeovim,
    [switch]$SkipNodeJS,
    [switch]$SkipScoop
)

# Colors for output
$Colors = @{
    Info = "Cyan"
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Header = "Magenta"
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Colors[$Color]
}

function Write-Header {
    param([string]$Message)
    Write-ColorOutput "`n=== $Message ===" "Header"
}

function Write-Info {
    param([string]$Message)
    Write-ColorOutput "[INFO] $Message" "Info"
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "[SUCCESS] $Message" "Success"
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "[WARNING] $Message" "Warning"
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "[ERROR] $Message" "Error"
}

# Check if running as Administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check Windows version
function Test-WindowsVersion {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $version = [Version]$os.Version
    
    if ($version.Major -lt 10) {
        Write-Error "This script requires Windows 10 or Windows 11. Current version: $($os.Caption)"
        exit 1
    }
    
    Write-Success "Windows version: $($os.Caption) $($os.Version)"
}

# Install Scoop if not present
function Install-Scoop {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Success "Scoop is already installed"
        return
    }
    
    Write-Info "Installing Scoop..."
    try {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        Write-Success "Scoop has been installed successfully"
    }
    catch {
        Write-Error "Could not install Scoop: $($_.Exception.Message)"
        exit 1
    }
}

# Install Neovim via Scoop
function Install-Neovim {
    if (Get-Command nvim -ErrorAction SilentlyContinue) {
        Write-Success "Neovim is already installed"
        return
    }
    
    Write-Info "Installing Neovim..."
    try {
        scoop install neovim
        Write-Success "Neovim has been installed successfully"
    }
    catch {
        Write-Error "Could not install Neovim: $($_.Exception.Message)"
        exit 1
    }
}

# Install Node.js via Scoop (required for some LSP servers)
function Install-NodeJS {
    if (Get-Command node -ErrorAction SilentlyContinue) {
        Write-Success "Node.js is already installed"
        return
    }
    
    Write-Info "Installing Node.js LTS..."
    try {
        scoop install nodejs-lts
        Write-Success "Node.js LTS has been installed successfully"
    }
    catch {
        Write-Error "Could not install Node.js: $($_.Exception.Message)"
        exit 1
    }
}

# Install essential system tools only (not managed by Lazy loader)
function Install-EssentialSystemTools {
    Write-Info "Installing essential system tools..."
    
    $systemTools = @(
        "git",           # Required for Lazy loader to clone plugins
        "ripgrep",       # Required for Telescope fuzzy finder
        "fzf",          # Required for Telescope fuzzy finder
        "python",       # Required for some LSP servers and tools
        "php",          # Required for PHP LSP server
        "dart",         # Required for Dart/Flutter LSP server
        "deno",         # Required for Deno LSP server
        "live-server"   # Required for live preview of web projects
    )
    
    foreach ($tool in $systemTools) {
        try {
            if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
                Write-Info "Installing $tool..."
                scoop install $tool
                Write-Success "$tool has been installed"
            } else {
                Write-Success "$tool is already available"
            }
        }
        catch {
            Write-Warning "Could not install $tool - $($_.Exception.Message)"
        }
    }
}

# Clone Neovim configuration
function Clone-NeovimConfig {
    $nvimPath = "$env:LOCALAPPDATA\nvim"
    
    if (Test-Path $nvimPath) {
        Write-Warning "Directory $nvimPath already exists"
        $response = Read-Host "Do you want to remove and clone again? (y/N)"
        if ($response -eq 'y' -or $response -eq 'Y') {
            Remove-Item -Recurse -Force $nvimPath
        } else {
            Write-Info "Keeping current configuration"
            return
        }
    }
    
    Write-Info "Cloning Neovim configuration from GitHub..."
    try {
        git clone https://github.com/Catherine1401/nvim.git $nvimPath
        Write-Success "Neovim configuration has been cloned successfully"
    }
    catch {
        Write-Error "Could not clone configuration: $($_.Exception.Message)"
        exit 1
    }
}

# Create desktop shortcut
function Create-DesktopShortcut {
    Write-Info "Creating desktop shortcut..."
    
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = "$desktopPath\Neovim.lnk"
    
    try {
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($shortcutPath)
        $Shortcut.TargetPath = "nvim"
        $Shortcut.WorkingDirectory = "$env:USERPROFILE"
        $Shortcut.Description = "Neovim Editor"
        $Shortcut.IconLocation = "$env:LOCALAPPDATA\Programs\neovim\Neovim\bin\nvim.exe,0"
        $Shortcut.Save()
        
        Write-Success "Shortcut has been created at: $shortcutPath"
    }
    catch {
        Write-Warning "Could not create shortcut: $($_.Exception.Message)"
    }
}

# Main installation function
function Start-Installation {
    Write-Header "STARTING NEOVIM INSTALLATION FOR WINDOWS 11"
    
    # Check Windows version
    Test-WindowsVersion
    
    # Check if running as Administrator
    if (-not (Test-Administrator)) {
        Write-Warning "This script is not running with Administrator privileges"
        Write-Info "Scoop installations typically don't require admin rights"
    }
    
    # Install Scoop (if not skipped)
    if (-not $SkipScoop) {
        Install-Scoop
    }
    
    # Install Neovim via Scoop (if not skipped)
    if (-not $SkipNeovim) {
        Install-Neovim
    }
    
    # Install Node.js via Scoop (if not skipped)
    if (-not $SkipNodeJS) {
        Install-NodeJS
    }
    
    # Install essential system tools only
    Install-EssentialSystemTools
    
    # Clone Neovim configuration
    Clone-NeovimConfig
    
    # Create desktop shortcut
    Create-DesktopShortcut
    
    Write-Header "INSTALLATION COMPLETE!"
    Write-Success "Neovim has been installed successfully via Scoop!"
    Write-Info "To get started:"
    Write-Info "1. Open Neovim: nvim"
    Write-Info "2. Wait for Lazy loader to install all plugins automatically"
    Write-Info "3. Wait for Mason to install LSP servers and tools automatically"
    Write-Info "4. Use :checkhealth to check system health"
    Write-Info "5. Use :Lazy sync to update plugins"
    Write-Info ""
    Write-Info "IMPORTANT: All Neovim plugins, LSP servers, and development tools"
    Write-Info "will be automatically installed by Lazy loader and Mason!"
    Write-Info "No need to install them manually."
}

# Script execution
try {
    if (-not $SkipConfirmation) {
        Write-Header "NEOVIM AUTO-INSTALLATION SCRIPT"
        Write-Info "This script will install (via Scoop only):"
        Write-Info "- Neovim"
        Write-Info "- Node.js LTS"
        Write-Info "- Essential system tools (git, ripgrep, fzf, python, php, dart, deno, live-server)"
        Write-Info "- Neovim configuration from GitHub"
        Write-Info ""
        Write-Info "NOTE: All Neovim plugins, LSP servers, and development tools"
        Write-Info "will be automatically installed by Lazy loader and Mason!"
        Write-Info ""
        Write-Info "Do you want to continue? (Y/n)"
        $response = Read-Host
        if ($response -eq 'n' -or $response -eq 'N') {
            Write-Info "Installation cancelled"
            exit 0
        }
    }
    
    Start-Installation
}
catch {
    Write-Error "Unexpected error: $($_.Exception.Message)"
    Write-Error "Stack trace: $($_.Exception.StackTrace)"
    exit 1
}
