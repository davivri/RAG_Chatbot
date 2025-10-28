# ============================================
# STOP ALL SERVERS SCRIPT
# Stops: n8n + HTML Server
# ============================================

Write-Host "🛑 Stopping all servers..." -ForegroundColor Yellow
Write-Host ""

# Stop n8n
Write-Host "Stopping n8n..." -ForegroundColor Gray
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force

# Stop HTML server
Write-Host "Stopping HTML server..." -ForegroundColor Gray
Get-Process python -ErrorAction SilentlyContinue | Stop-Process -Force

Start-Sleep -Seconds 2

Write-Host ""
Write-Host "✅ All servers stopped!" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
