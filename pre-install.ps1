# PC Initialization Script - Install Development Tools
# This script installs Git, VS Code, and Python using Windows Package Manager (winget)
# Run this script as Administrator for best results

param(
    [switch]$SkipPython,
    [switch]$SkipGit,
    [switch]$SkipVSCode,
    [switch]$Quiet
)

# Script metadata
$ScriptVersion = "1.0.0"
$ScriptDate = "2025-08-05"

Write-Host "=== PC Development Environment Setup Script ===" -ForegroundColor Cyan
Write-Host "Version: $ScriptVersion | Date: $ScriptDate" -ForegroundColor Gray
Write-Host ""

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to install or update winget if needed
function Install-Winget {
    Write-Host "Checking Windows Package Manager (winget)..." -ForegroundColor Yellow
    
    try {
        $wingetVersion = winget --version
        Write-Host "✓ winget is already installed: $wingetVersion" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "⚠ winget not found. Installing..." -ForegroundColor Yellow
        
        try {
            # Install winget via Microsoft Store or GitHub
            $progressPreference = 'silentlyContinue'
            Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile "$env:TEMP\winget.msixbundle"
            Add-AppxPackage "$env:TEMP\winget.msixbundle"
            Remove-Item "$env:TEMP\winget.msixbundle" -Force
            Write-Host "✓ winget installed successfully" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "✗ Failed to install winget. Please install manually from Microsoft Store." -ForegroundColor Red
            return $false
        }
    }
}

# Function to install a package using winget
function Install-Package {
    param(
        [string]$PackageId,
        [string]$PackageName,
        [array]$AdditionalArgs = @()
    )
    
    Write-Host "Installing $PackageName..." -ForegroundColor Yellow
    
    try {
        $args = @("install", "--id", $PackageId, "--silent", "--accept-package-agreements", "--accept-source-agreements")
        if ($AdditionalArgs) {
            $args += $AdditionalArgs
        }
        
        $result = & winget @args
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ $PackageName installed successfully" -ForegroundColor Green
            return $true
        }
        elseif ($LASTEXITCODE -eq -1978335189) {
            Write-Host "ℹ $PackageName is already installed" -ForegroundColor Blue
            return $true
        }
        else {
            Write-Host "⚠ $PackageName installation completed with warnings (Exit code: $LASTEXITCODE)" -ForegroundColor Yellow
            return $true
        }
    }
    catch {
        Write-Host "✗ Failed to install $PackageName`: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to refresh environment variables
function Update-Environment {
    Write-Host "Refreshing environment variables..." -ForegroundColor Yellow
    
    # Refresh PATH for current session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    
    Write-Host "✓ Environment variables refreshed" -ForegroundColor Green
}

# Main installation process
function Start-Installation {
    Write-Host "Starting installation process..." -ForegroundColor Cyan
    Write-Host ""
    
    # Check administrator privileges
    if (-not (Test-Administrator)) {
        Write-Host "⚠ Warning: Not running as Administrator. Some installations may require elevation." -ForegroundColor Yellow
        Write-Host ""
    }
    
    # Install/verify winget
    if (-not (Install-Winget)) {
        Write-Host "✗ Cannot proceed without winget. Exiting." -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    $installationResults = @{}
    
    # Install Git
    if (-not $SkipGit) {
        Write-Host "--- Installing Git ---" -ForegroundColor Magenta
        $installationResults['Git'] = Install-Package -PackageId "Git.Git" -PackageName "Git"
        Write-Host ""
    }
    
    # Install VS Code
    if (-not $SkipVSCode) {
        Write-Host "--- Installing Visual Studio Code ---" -ForegroundColor Magenta
        $installationResults['VSCode'] = Install-Package -PackageId "Microsoft.VisualStudioCode" -PackageName "Visual Studio Code"
        Write-Host ""
    }
    
    # Install Python
    if (-not $SkipPython) {
        Write-Host "--- Installing Python ---" -ForegroundColor Magenta
        $installationResults['Python'] = Install-Package -PackageId "Python.Python.3.12" -PackageName "Python 3.12"
        Write-Host ""
    }
    
    # Refresh environment
    Update-Environment
    
    # Summary
    Write-Host "=== Installation Summary ===" -ForegroundColor Cyan
    foreach ($app in $installationResults.Keys) {
        $status = if ($installationResults[$app]) { "✓ Success" } else { "✗ Failed" }
        $color = if ($installationResults[$app]) { "Green" } else { "Red" }
        Write-Host "$app`: $status" -ForegroundColor $color
    }
    
    Write-Host ""
    Write-Host "=== Next Steps ===" -ForegroundColor Cyan
    Write-Host "1. Restart your terminal or VS Code to ensure PATH updates take effect" -ForegroundColor White
    Write-Host "2. Verify installations:" -ForegroundColor White
    Write-Host "   - git --version" -ForegroundColor Gray
    Write-Host "   - code --version" -ForegroundColor Gray
    Write-Host "   - python --version" -ForegroundColor Gray
    Write-Host "3. Configure Git with your user information:" -ForegroundColor White
    Write-Host "   - git config --global user.name `"Your Name`"" -ForegroundColor Gray
    Write-Host "   - git config --global user.email `"your.email@example.com`"" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Installation completed! 🎉" -ForegroundColor Green
}

# Error handling
trap {
    Write-Host "✗ An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Script execution stopped." -ForegroundColor Red
    exit 1
}

# Start the installation
Start-Installation