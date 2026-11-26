# Roda o jogo com log completo e, ao fechar, junta o diagnóstico num zip para enviar.
# Uso, no PowerShell, dentro desta pasta:
#   powershell -ExecutionPolicy Bypass -File .\Diagnostico.ps1
# Ajustes opcionais antes (exemplo para placa de 16 GB):
#   $env:VICTORY_RENDER_SCALE = '0.75'; $env:VICTORY_CARD_BUFFERS_MB = '2048'
$ErrorActionPreference = 'Continue'
$here = $PSScriptRoot
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$out = Join-Path $here "diagnostico-$stamp"
New-Item -ItemType Directory -Force $out | Out-Null

# 1. Sistema
$gpu = Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, DriverDate
$vram = Get-ChildItem 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}' -ErrorAction SilentlyContinue |
    ForEach-Object { $p = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue; if ($p.'HardwareInformation.qwMemorySize') { '{0}: {1:N1} GB' -f $p.DriverDesc, ($p.'HardwareInformation.qwMemorySize' / 1GB) } }
$cs = Get-CimInstance Win32_ComputerSystem
$cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1).Name
$os = Get-CimInstance Win32_OperatingSystem
@(
    "Windows: $($os.Caption) $($os.Version)"
    "CPU: $cpu"
    ('RAM: {0:N1} GB' -f ($cs.TotalPhysicalMemory / 1GB))
    "VRAM: $($vram -join '; ')"
    ($gpu | Format-Table -AutoSize | Out-String)
    'Pagefile:'
    (Get-CimInstance Win32_PageFileUsage | Select-Object Name, AllocatedBaseSize | Format-Table -AutoSize | Out-String)
    'Variaveis VICTORY_* definidas antes:'
    (Get-ChildItem Env:VICTORY_* | Format-Table -AutoSize | Out-String)
) | Set-Content -Encoding utf8 (Join-Path $out 'sistema.txt')

# 2. Medidor de memória em paralelo (a cada 10 s, enquanto o jogo roda)
$csv = Join-Path $out 'memoria.csv'
$sampler = Start-Job -ArgumentList $csv -ScriptBlock {
    param($csv)
    'hora;priv_mb;ws_mb;commit_gb;limite_gb;ram_livre_gb' | Set-Content -Encoding utf8 $csv
    $t0 = Get-Date
    while (-not (Get-Process victory -ErrorAction SilentlyContinue)) { if (((Get-Date) - $t0).TotalSeconds -gt 300) { return }; Start-Sleep 2 }
    while ($p = Get-Process victory -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $o = Get-CimInstance Win32_OperatingSystem
        '{0};{1};{2};{3:N1};{4:N1};{5:N1}' -f (Get-Date -Format HH:mm:ss), [int]($p.PrivateMemorySize64 / 1MB), [int]($p.WorkingSet64 / 1MB),
            (($o.TotalVirtualMemorySize - $o.FreeVirtualMemory) / 1MB), ($o.TotalVirtualMemorySize / 1MB), ($o.FreePhysicalMemory / 1MB) |
            Add-Content -Encoding utf8 $csv
        Start-Sleep 10
    }
}

# 3. Jogo com log completo (avisos + mapa de memória + shaders)
if (-not $env:VICTORY_LOG) { $env:VICTORY_LOG = 'info' }
$log = Join-Path $out 'log.txt'
Write-Host 'Abrindo o jogo. Jogue até aparecer o problema e feche a janela do jogo.'
cmd /c "`"$here\Play-VIctory.cmd`" > `"$log`" 2>&1"
Wait-Job $sampler -Timeout 30 | Out-Null; Remove-Job $sampler -Force

# 4. Crash log do emulador, se houver
Get-ChildItem "$env:LOCALAPPDATA\victory" -Recurse -Filter crashes.log -ErrorAction SilentlyContinue | Copy-Item -Destination $out

# 5. Zip para enviar
$zip = Join-Path $here "diagnostico-$stamp.zip"
Compress-Archive -Path "$out\*" -DestinationPath $zip -Force
Write-Host "Pronto. Envie este arquivo: $zip"
