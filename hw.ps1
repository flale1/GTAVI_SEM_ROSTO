# Prints "<RAM GB> <VRAM GB>" for preset.cmd. VRAM comes from the display driver's registry
# entry (64-bit), because Win32_VideoController.AdapterRAM stops at 4 GB.
$ram = 0
$vram = 0
try {
    $ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
} catch {}
try {
    $class = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}'
    Get-ChildItem $class -ErrorAction SilentlyContinue | ForEach-Object {
        $value = (Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'
        if ($value) {
            $gb = [math]::Round([double]$value / 1GB)
            if ($gb -gt $vram) { $vram = $gb }
        }
    }
} catch {}
"$ram $vram"
