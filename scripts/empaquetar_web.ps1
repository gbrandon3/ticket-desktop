$ErrorActionPreference = 'Stop'
$taskProjectRoot = Split-Path -Parent $PSScriptRoot
$taskWeb = Join-Path $taskProjectRoot 'build/web'
foreach ($taskRequired in @("$taskWeb/index.html", "$taskWeb/main.dart.js", "$taskProjectRoot/node_modules/express/package.json")) {
    if (-not (Test-Path -LiteralPath $taskRequired)) { throw "Falta compilar o instalar: $taskRequired" }
}
$taskReleases = Join-Path $taskProjectRoot 'releases'
New-Item -ItemType Directory -Path $taskReleases -Force | Out-Null
$taskStage = Join-Path $taskProjectRoot ('build/entrega_web_' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path "$taskStage/build" -Force | Out-Null
foreach ($taskFile in @('server.js', 'package.json', 'package-lock.json')) {
    Copy-Item -LiteralPath (Join-Path $taskProjectRoot $taskFile) -Destination $taskStage
}
foreach ($taskFolder in @('server', 'api', 'node_modules')) {
    Copy-Item -LiteralPath (Join-Path $taskProjectRoot $taskFolder) -Destination (Join-Path $taskStage $taskFolder) -Recurse
}
Copy-Item -LiteralPath $taskWeb -Destination "$taskStage/build/web" -Recurse
@'
@echo off
cd /d "%~dp0"
node server.js
pause
'@ | Set-Content -LiteralPath "$taskStage/iniciar_web.cmd" -Encoding ascii
@'
# Santi Inc: release web

Requiere Node.js 22.13 o superior (recomendado Node.js 24).

1. Descomprima todo el ZIP en una carpeta.
2. Abra una terminal en esa carpeta y ejecute: npm start
3. Abra http://localhost:3000 en el navegador.

En Windows también puede abrir iniciar_web.cmd.
Un solo servidor ejecuta la API y sirve el frontend compilado.
Las dependencias están incluidas: no necesita Flutter ni npm install.
Detenga el servidor con Ctrl+C.

Esta entrega no incluye datos ni credenciales. En una carpeta nueva,
complete el asistente de configuración inicial. Si actualiza una instalación,
detenga el servidor y conserve sus carpetas data y backups.

Para acceder desde un celular en la misma red, use la IP del computador
con el puerto 3000, por ejemplo http://192.168.1.10:3000.
'@ | Set-Content -LiteralPath "$taskStage/README.md" -Encoding utf8
Compress-Archive -Path "$taskStage/*" -DestinationPath "$taskReleases/tickets_app_web_release.zip" -Force
Write-Host "Release web con backend incluido: $taskReleases/tickets_app_web_release.zip"
Write-Host "Carpeta de verificación: $taskStage"
