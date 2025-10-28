# ============================================
# MASTER STARTUP SCRIPT
# Starts: n8n + HTML Server
# Access via Tailscale IP only (no Funnel)
# ============================================

Write-Host "🚀 Starting all servers..." -ForegroundColor Cyan
Write-Host ""

# ============================================
# STEP 1: Stop any existing processes
# ============================================
Write-Host "🛑 Stopping existing processes..." -ForegroundColor Yellow

# Stop n8n (node processes)
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force

# Stop Python servers
Get-Process python -ErrorAction SilentlyContinue | Stop-Process -Force

Start-Sleep -Seconds 3
Write-Host "✅ Cleanup complete" -ForegroundColor Green
Write-Host ""

# ============================================
# STEP 2: Start n8n
# ============================================
Write-Host "🔧 Starting n8n..." -ForegroundColor Yellow

# Set environment variable to disable secure cookie
$env:N8N_SECURE_COOKIE = "false"

# Start n8n in background
Start-Process powershell -ArgumentList "`$env:N8N_SECURE_COOKIE='false'; n8n start" -WindowStyle Hidden

Start-Sleep -Seconds 5

# Verify n8n started
$n8nProcess = Get-Process node -ErrorAction SilentlyContinue
if ($n8nProcess) {
    Write-Host "✅ n8n is running on port 5678" -ForegroundColor Green
} else {
    Write-Host "❌ n8n failed to start" -ForegroundColor Red
}
Write-Host ""

# ============================================
# STEP 3: Start HTML Server
# ============================================
Write-Host "🌐 Starting HTML server..." -ForegroundColor Yellow

# Get script directory (where this script is located)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Start server from script directory
Start-Process powershell -ArgumentList "cd '$scriptDir'; python -m http.server 8000" -WindowStyle Hidden

Start-Sleep -Seconds 3

# Verify HTML server started
$htmlProcess = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
if ($htmlProcess) {
    Write-Host "✅ HTML server is running on port 8000" -ForegroundColor Green
} else {
    Write-Host "❌ HTML server failed to start" -ForegroundColor Red
}
Write-Host ""

# ============================================
# SUMMARY
# ============================================
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "✅ ALL SERVERS STARTED!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 Access URLs (via Tailscale):" -ForegroundColor Yellow
Write-Host "   HTML Page: http://100.118.164.23:8000" -ForegroundColor White
Write-Host "   n8n:       http://100.118.164.23:5678" -ForegroundColor White
Write-Host ""
Write-Host "🔍 To verify processes are running:" -ForegroundColor Yellow
Write-Host "   Get-Process node, python" -ForegroundColor White
Write-Host ""
Write-Host "🛑 To stop all servers:" -ForegroundColor Yellow
Write-Host "   Get-Process node, python | Stop-Process -Force" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
