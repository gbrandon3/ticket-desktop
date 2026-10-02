param([switch]$GenerarPdf)
$ErrorActionPreference = 'Stop'
$taskProjectRoot = Split-Path -Parent $PSScriptRoot
Push-Location -LiteralPath $taskProjectRoot
try {
    $taskNode = (Get-Command node -ErrorAction Stop).Source
    $taskFlutterCommand = (Get-Command flutter -ErrorAction Stop).Source
    $taskFlutterBin = Split-Path -Parent $taskFlutterCommand
    $taskDart = Join-Path $taskFlutterBin 'cache/dart-sdk/bin/dart.exe'
    $taskFlutterSnapshot = Join-Path $taskFlutterBin 'cache/flutter_tools.snapshot'

    function Invoke-ProjectFlutter {
        param([string[]]$Arguments)
        if ((Test-Path -LiteralPath $taskDart) -and (Test-Path -LiteralPath $taskFlutterSnapshot)) {
            & $taskDart $taskFlutterSnapshot @Arguments
        } else {
            & $taskFlutterCommand @Arguments
        }
        if ($LASTEXITCODE -ne 0) { throw 'La verificación de Flutter falló' }
    }

    $taskTests = @(Get-ChildItem -LiteralPath 'server/tests' -Filter '*.test.js' | ForEach-Object { $_.FullName })
    & $taskNode --test @taskTests
    if ($LASTEXITCODE -ne 0) { throw 'Las pruebas del backend fallaron' }
    Invoke-ProjectFlutter -Arguments @('pub', 'get', '--offline')
    Invoke-ProjectFlutter -Arguments @('analyze', '--no-pub')
    $taskPreviousPdfSetting = $env:GENERATE_PDF_EVIDENCE
    try {
        if ($GenerarPdf) { $env:GENERATE_PDF_EVIDENCE = '1' }
        Invoke-ProjectFlutter -Arguments @('test', '--no-pub')
    } finally {
        $env:GENERATE_PDF_EVIDENCE = $taskPreviousPdfSetting
    }
    Write-Host 'Verificación completa: backend, análisis de Flutter y pruebas aprobados.'
} finally {
    Pop-Location
}
