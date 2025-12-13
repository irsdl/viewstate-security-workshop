# Re-enables Defender's protection after lab use

Set-MpPreference -DisableRealtimeMonitoring $false         # real-time AV enabled
Set-MpPreference -DisableScriptScanning    $false         # AMSI/script scanning enabled
Set-MpPreference -DisableIOAVProtection    $false         # web/download scanning enabled
Set-MpPreference -DisableBehaviorMonitoring $false        # behavior monitoring enabled
Set-MpPreference -DisableBlockAtFirstSeen  $false         # cloud "first seen" blocking enabled
