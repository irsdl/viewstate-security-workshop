# LAB ONLY – turns off most of Defender's protection

Set-MpPreference -DisableRealtimeMonitoring $true          # no real-time AV
Set-MpPreference -DisableScriptScanning    $true          # no AMSI/script scanning
Set-MpPreference -DisableIOAVProtection    $true          # no web/download scanning
Set-MpPreference -DisableBehaviorMonitoring $true         # no behavior monitoring
Set-MpPreference -DisableBlockAtFirstSeen  $true          # no cloud "first seen" blocking
