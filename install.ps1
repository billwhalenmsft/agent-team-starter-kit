# Agent Team Starter Kit — Windows one-liner installer
# Usage: irm https://raw.githubusercontent.com/billwhalenmsft/agent-team-starter-kit/main/install.ps1 | iex

$ErrorActionPreference = 'Stop'

function Write-Header {
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║   🤖  Agent Team Starter Kit             ║" -ForegroundColor Cyan
    Write-Host "  ║   Autonomous AI agent team in a box      ║" -ForegroundColor Cyan
    Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Check-Deps {
    $missing = @()
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) { $missing += 'Python 3.9+' }
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { $missing += 'Git' }
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { $missing += 'GitHub CLI (gh)' }
    if ($missing.Count -gt 0) {
        Write-Host "Missing dependencies: $($missing -join ', ')" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Install them first:"
        Write-Host "  Python: https://python.org/downloads"
        Write-Host "  Git:    https://git-scm.com/download/win"
        Write-Host "  gh CLI: winget install GitHub.cli"
        exit 1
    }
}

Write-Header
Check-Deps

$Dest = Join-Path $PWD 'agent-team-starter-kit'
if (Test-Path $Dest) {
    Write-Host "▶ Updating existing install..." -ForegroundColor Green
    Set-Location $Dest
    git pull --quiet
    Set-Location ..
} else {
    Write-Host "▶ Cloning Agent Team Starter Kit..." -ForegroundColor Green
    git clone --quiet https://github.com/billwhalenmsft/agent-team-starter-kit.git $Dest
}

Write-Host ""
Write-Host "✅ Ready! Running setup..." -ForegroundColor Green
Write-Host ""
Set-Location $Dest
python setup_agent_team.py
