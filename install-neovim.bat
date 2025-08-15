@echo off
REM ========================================
REM Neovim Auto-Installation Script Launcher
REM ========================================

echo.
echo ========================================
echo    NEOVIM AUTO-INSTALLATION SCRIPT
echo ========================================
echo.
echo This script will install Neovim and essential system dependencies
echo for Windows 11 through Scoop package manager
echo.
echo NOTE: All Neovim plugins, LSP servers, and development tools
echo will be automatically installed by Lazy loader and Mason!
echo.

REM Check if PowerShell is available
powershell -Command "Get-Host" >nul 2>&1
if errorlevel 1 (
    echo ERROR: PowerShell is not available on this system
    echo Please install PowerShell and try again
    pause
    exit /b 1
)

REM Run PowerShell script
echo Running PowerShell script...
powershell -ExecutionPolicy Bypass -File "%~dp0install-neovim.ps1"

echo.
echo Script completed!
echo.
echo Next steps:
echo 1. Open Neovim: nvim
echo 2. Wait for Lazy loader to install plugins automatically
echo 3. Wait for Mason to install LSP servers and tools automatically
pause
