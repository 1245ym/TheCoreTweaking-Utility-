Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ------------------------------
# Admin Check
# ------------------------------
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# ------------------------------
# SECTIONS & TWEAKS (20 each)
# ------------------------------
$Sections = @{}

# --- Gaming Performance (20 tweaks) ---
$Sections["Gaming Performance"] = @(
    # 20 tweaks including the original + extra
    [PSCustomObject]@{ Name="Disable GameDVR"; Cat="Gaming Performance"; Ben="Stops Xbox Game Bar recording to save CPU/GPU."; Cmd={ Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Enable HAGS"; Cat="Gaming Performance"; Ben="Enables hardware-accelerated GPU scheduling (HAGS)."; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Type DWord -Value 2 -Force } }
    [PSCustomObject]@{ Name="Disable Fullscreen Optimizations"; Cat="Gaming Performance"; Ben="Prevents Windows from applying fullscreen optimizations to games."; Cmd={ Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Set GPU Priority High"; Cat="Gaming Performance"; Ben="Prioritizes GPU for games over background apps."; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8 -Force } }
    [PSCustomObject]@{ Name="Disable Power Throttling"; Cat="Gaming Performance"; Ben="Prevents CPU power throttling during heavy load."; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1 -Force } }
    [PSCustomObject]@{ Name="Disable Nagle Algorithm"; Cat="Gaming Performance"; Ben="Can reduce network latency for online gaming."; Cmd={ New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpAckFrequency" -PropertyType DWord -Value 1 -Force | Out-Null } }
    [PSCustomObject]@{ Name="Increase Network Packet Priority"; Cat="Gaming Performance"; Ben="Boosts priority of multimedia network traffic."; Cmd={ New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -PropertyType DWord -Value 0 -Force | Out-Null } }
    [PSCustomObject]@{ Name="Disable Mouse Acceleration"; Cat="Gaming Performance"; Ben="Disables pointer acceleration for consistent mouse input."; Cmd={ Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0 -Force; Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0 -Force; Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Enable High Precision Timer"; Cat="Gaming Performance"; Ben="Improves timing precision for games."; Cmd={ New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" -Name "PerfCountFrequency" -PropertyType DWord -Value 1 -Force | Out-Null } }
    [PSCustomObject]@{ Name="Disable Xbox Services"; Cat="Gaming Performance"; Ben="Stops Xbox Game Save service."; Cmd={ Stop-Service "XblGameSave" -ErrorAction SilentlyContinue; Set-Service "XblGameSave" -StartupType Disabled -ErrorAction SilentlyContinue } }
    [PSCustomObject]@{ Name="Set Game Priority to High"; Cat="Gaming Performance"; Ben="Sets multimedia games task priority to high."; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6 -Force } }
    [PSCustomObject]@{ Name="Disable Fullscreen AutoMinimize"; Cat="Gaming Performance"; Ben="Helps prevent games from minimizing when using Alt+Tab."; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableAutoMinimize" -Value 1 -Force } }
    [PSCustomObject]@{ Name="Disable GPU Background Throttling"; Cat="Gaming Performance"; Ben="Disables TDR level to avoid some GPU timeouts (use with care)."; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "TdrLevel" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Disable V-Sync (NVIDIA Global)"; Cat="Gaming Performance"; Ben="Disables global V-Sync in NVIDIA control policy (if key exists)."; Cmd={ New-Item -Path "HKCU:\Software\NVIDIA Corporation\Global\NvCplApi\Policies" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\Software\NVIDIA Corporation\Global\NvCplApi\Policies" -Name "SyncToVBlank" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Disable Windows Game Recording Overlay"; Cat="Gaming Performance"; Ben="Disables GameDVR app capture."; Cmd={ New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Enable Ultimate Game Mode"; Cat="Gaming Performance"; Ben="Turns on Windows Game Mode features"; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\GameMode" -Name "Enable" -Value 1 -Force } }
    [PSCustomObject]@{ Name="Set GPU High Performance Preference"; Cat="Gaming Performance"; Ben="Sets GPU preference for high-performance apps"; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\DirectX" -Name "HighPerformanceGPU" -Value 1 -Force } }
    [PSCustomObject]@{ Name="Maximize FPS (Priority)"; Cat="Gaming Performance"; Ben="Prioritizes games for maximum FPS"; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 10 -Force } }
    [PSCustomObject]@{ Name="Disable Game Bar Notifications"; Cat="Gaming Performance"; Ben="Stops annoying game notifications"; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\XboxGameOverlay" -Name "AllowGameDVR" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Enable DirectX Raytracing"; Cat="Gaming Performance"; Ben="Optimizes DirectX 12 ray tracing"; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\DX12" -Name "RayTracingEnabled" -Value 1 -Force } }
)

# --- Network & Internet (20 tweaks) ---
$Sections["Network & Internet"] = @(
    # Original 15 + 5 extra
    [PSCustomObject]@{ Name="Enable TCP RSS"; Cat="Network & Internet"; Ben="Receive Side Scaling"; Cmd={ netsh int tcp set global rss=enabled | Out-Null } }
    [PSCustomObject]@{ Name="Flush DNS Cache"; Cat="Network & Internet"; Ben="Clears DNS cache"; Cmd={ ipconfig /flushdns | Out-Null; netsh winsock reset | Out-Null } }
    [PSCustomObject]@{ Name="Enable TCP Fast Open"; Cat="Network & Internet"; Ben="Faster TCP handshakes"; Cmd={ netsh int tcp set global fastopen=enabled | Out-Null } }
    [PSCustomObject]@{ Name="Increase Max User Ports"; Cat="Network & Internet"; Ben="Increases dynamic TCP port range"; Cmd={ netsh int ipv4 set dynamicport tcp start=1025 num=64511 | Out-Null } }
    [PSCustomObject]@{ Name="Disable NetBIOS over TCP"; Cat="Network & Internet"; Ben="Improves security"; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "EnableNetbios" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Increase TCP Window Size"; Cat="Network & Internet"; Ben="Larger TCP window"; Cmd={ New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpWindowSize" -PropertyType DWord -Value 131400 -Force | Out-Null } }
    [PSCustomObject]@{ Name="Disable IPv6 (if unused)"; Cat="Network & Internet"; Ben="Disables IPv6 components"; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters" -Name "DisabledComponents" -Value 0xFF -Force } }
    [PSCustomObject]@{ Name="Set DNS to Google"; Cat="Network & Internet"; Ben="Google DNS"; Cmd={ Try { Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "8.8.8.8","8.8.4.4" } Catch {} } }
    [PSCustomObject]@{ Name="Enable Jumbo Frames"; Cat="Network & Internet"; Ben="Allows large network packets"; Cmd={ Try { Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Jumbo Packet" -DisplayValue "9014 Bytes" -ErrorAction SilentlyContinue } Catch {} } }
    [PSCustomObject]@{ Name="Disable Auto-Tuning"; Cat="Network & Internet"; Ben="Disables TCP receive window auto-tuning"; Cmd={ netsh interface tcp set global autotuninglevel=disabled | Out-Null } }
    [PSCustomObject]@{ Name="Disable SMBv1"; Cat="Network & Internet"; Ben="Legacy protocol off"; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Enable TCP Chimney Offload"; Cat="Network & Internet"; Ben="Offload to NIC"; Cmd={ netsh int tcp set global chimney=enabled | Out-Null } }
    [PSCustomObject]@{ Name="Set Network Profile to Private"; Cat="Network & Internet"; Ben="Ethernet private"; Cmd={ Try { Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private } Catch {} } }
    [PSCustomObject]@{ Name="Disable Large Send Offload"; Cat="Network & Internet"; Ben="Reduces latency"; Cmd={ Try { Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Large Send Offload v2 (IPv4)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Large Send Offload v2 (IPv6)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue } Catch {} } }
    [PSCustomObject]@{ Name="Disable Delivery Optimization"; Cat="Network & Internet"; Ben="Prevents P2P Windows updates"; Cmd={ New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Force | Out-Null; Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Increase MTU (Ethernet)"; Cat="Network & Internet"; Ben="Sets network MTU"; Cmd={ netsh interface ipv4 set subinterface "Ethernet" mtu=1500 store=persistent } }
    [PSCustomObject]@{ Name="Disable Windows Auto Proxy"; Cat="Network & Internet"; Ben="Stops auto proxy detection"; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "AutoDetect" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Disable NetBIOS Name Resolution"; Cat="Network & Internet"; Ben="Security tweak"; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "EnableLmHosts" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Enable QoS Packet Scheduler"; Cat="Network & Internet"; Ben="Prioritizes traffic"; Cmd={ Enable-NetAdapterQos -Name "*" -ErrorAction SilentlyContinue } }
    [PSCustomObject]@{ Name="Disable IPv6 Tunneling"; Cat="Network & Internet"; Ben="Removes Teredo & ISATAP"; Cmd={ netsh interface teredo set state disabled | Out-Null; netsh interface isatap set state disabled | Out-Null } }
)

# ------------------------------
# Privacy & Security (20 tweaks)
# ------------------------------
$Sections["Privacy & Security"] = @(
    [PSCustomObject]@{ Name="Disable Telemetry Service"; Cat="Privacy & Security"; Ben="Disables Connected User Experiences and Telemetry service."; Cmd={ Stop-Service 'DiagTrack' -ErrorAction SilentlyContinue; Set-Service 'DiagTrack' -StartupType Disabled -ErrorAction SilentlyContinue } }
    [PSCustomObject]@{ Name="Disable Advertising ID"; Cat="Privacy & Security"; Ben="Disables per-user advertising ID."; Cmd={ New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Disable Feedback Requests"; Cat="Privacy & Security"; Ben="Prevents Windows from requesting feedback."; Cmd={ New-Item -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Disable Cortana Search Service"; Cat="Privacy & Security"; Ben="Disables Windows Search service (affects Start menu search)."; Cmd={ Stop-Service "WSearch" -ErrorAction SilentlyContinue; Set-Service "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue } }
    [PSCustomObject]@{ Name="Disable Location Tracking"; Cat="Privacy & Security"; Ben="Denies location access for the user."; Cmd={ New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" -Force } }
    [PSCustomObject]@{ Name="Disable OneDrive Sync Service"; Cat="Privacy & Security"; Ben="Stops OneDrive sync service."; Cmd={ Stop-Service "OneSyncSvc" -ErrorAction SilentlyContinue; Set-Service "OneSyncSvc" -StartupType Disabled -ErrorAction SilentlyContinue } }
    [PSCustomObject]@{ Name="Disable Windows Error Reporting"; Cat="Privacy & Security"; Ben="Disables Windows Error Reporting."; Cmd={ New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null; Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 1 -Force } }
    [PSCustomObject]@{ Name="Disable App Suggestions"; Cat="Privacy & Security"; Ben="Disables suggested apps in Start and elsewhere."; Cmd={ New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Stop Edge & OneDrive Background"; Cat="Privacy & Security"; Ben="Stops Microsoft Edge and OneDrive processes (current session)."; Cmd={ Get-Process | Where-Object { $_.Name -in @("MicrosoftEdge","msedge","OneDrive") } | Stop-Process -Force -ErrorAction SilentlyContinue } }
    [PSCustomObject]@{ Name="Disable Windows Spotlight"; Cat="Privacy & Security"; Ben="Disables Spotlight on lock screen."; Cmd={ New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenEnabled" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Reduce Diagnostic Data"; Cat="Privacy & Security"; Ben="Sets diagnostic data collection to minimum."; Cmd={ New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null; Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force } }
    [PSCustomObject
