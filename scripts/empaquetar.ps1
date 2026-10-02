$ErrorActionPreference = 'Stop'
$taskProjectRoot = Split-Path -Parent $PSScriptRoot
Push-Location -LiteralPath $taskProjectRoot
try {
    $taskWindows = Join-Path $taskProjectRoot 'build/windows/x64/runner/Release'
    $taskWeb = Join-Path $taskProjectRoot 'build/web'
    foreach ($taskRequired in @("$taskWindows/tickets_app.exe", "$taskWeb/index.html", 'node_modules/express/package.json')) {
        if (-not (Test-Path -LiteralPath $taskRequired)) { throw "Falta compilar o instalar: $taskRequired" }
    }
    $taskReleases = Join-Path $taskProjectRoot 'releases'
    New-Item -ItemType Directory -Path $taskReleases -Force | Out-Null
    Compress-Archive -Path "$taskWindows/*" -DestinationPath "$taskReleases/tickets_app_windows_x64.zip" -Force
    Compress-Archive -Path "$taskWeb/*" -DestinationPath "$taskReleases/tickets_app_web_release.zip" -Force

    $taskStage = Join-Path $taskProjectRoot ('build/entrega_backend_' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path "$taskStage/build" -Force | Out-Null
    foreach ($taskFile in @('server.js', 'package.json', 'package-lock.json', 'README.md', 'CONTEXTO.md')) {
        Copy-Item -LiteralPath $taskFile -Destination $taskStage
    }
    foreach ($taskFolder in @('server', 'api', 'node_modules')) {
        Copy-Item -LiteralPath $taskFolder -Destination (Join-Path $taskStage $taskFolder) -Recurse
    }
    Copy-Item -LiteralPath $taskWeb -Destination "$taskStage/build/web" -Recurse
    @'
@echo off
cd /d "%~dp0"
node server.js
pause
'@ | Set-Content -LiteralPath "$taskStage/iniciar_backend.cmd" -Encoding ascii
    Compress-Archive -Path "$taskStage/*" -DestinationPath "$taskReleases/tickets_app_backend.zip" -Force
    Write-Host 'Paquetes generados en releases/: Windows, web y backend con la web incluida.'
} finally {
    Pop-Location
}
