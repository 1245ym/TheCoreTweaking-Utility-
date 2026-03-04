Add-Type -AssemblyName System.Windows.Forms, System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

# --- DEFINE SECTIONS AND TWEAKS ---
$Sections = @{}

# --- Gaming Performance (15 tweaks) ---
$Sections["Gaming Performance"] = @(
    [PSCustomObject]@{
        Name = "Disable GameDVR"
        Cat  = "Gaming Performance"
        Ben  = "Stops Xbox Game Bar recording to save CPU/GPU."
        Cmd  = { Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Force }
    }
    [PSCustomObject]@{
        Name = "Enable HAGS"
        Cat  = "Gaming Performance"
        Ben  = "Enables hardware-accelerated GPU scheduling (HAGS)."
        Cmd  = { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Type DWord -Value 2 -Force }
    }
    [PSCustomObject]@{
        Name = "Disable Fullscreen Optimizations"
        Cat  = "Gaming Performance"
        Ben  = "Prevents Windows from applying fullscreen optimizations to games."
        Cmd  = { Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 0 -Force }
    }
    [PSCustomObject]@{
        Name = "Set GPU Priority High"
        Cat  = "Gaming Performance"
        Ben  = "Prioritizes GPU for games over background apps."
        Cmd  = { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8 -Force }
    }
    [PSCustomObject]@{
        Name = "Disable Power Throttling"
        Cat  = "Gaming Performance"
        Ben  = "Prevents CPU power throttling during heavy load."
        Cmd  = { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1 -Force }
    }
    [PSCustomObject]@{
        Name = "Disable Nagle Algorithm"
        Cat  = "Gaming Performance"
        Ben  = "Can reduce network latency for online gaming."
        Cmd  = {
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpAckFrequency" -PropertyType DWord -Value 1 -Force | Out-Null
        }
    }
    [PSCustomObject]@{
        Name = "Increase Network Packet Priority"
        Cat  = "Gaming Performance"
        Ben  = "Boosts priority of multimedia network traffic."
        Cmd  = {
            New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -PropertyType DWord -Value 0 -Force | Out-Null
        }
    }
    [PSCustomObject]@{
        Name = "Disable Mouse Acceleration"
        Cat  = "Gaming Performance"
        Ben  = "Disables pointer acceleration for consistent mouse input."
        Cmd  = {
            Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0 -Force
            Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0 -Force
            Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Enable High Precision Timer"
        Cat  = "Gaming Performance"
        Ben  = "Improves timing precision for games."
        Cmd  = {
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" -Name "PerfCountFrequency" -PropertyType DWord -Value 1 -Force | Out-Null
        }
    }
    [PSCustomObject]@{
        Name = "Disable Xbox Services"
        Cat  = "Gaming Performance"
        Ben  = "Stops Xbox Game Save service."
        Cmd  = {
            Stop-Service "XblGameSave" -ErrorAction SilentlyContinue
            Set-Service "XblGameSave" -StartupType Disabled -ErrorAction SilentlyContinue
        }
    }
    [PSCustomObject]@{
        Name = "Set Game Priority to High"
        Cat  = "Gaming Performance"
        Ben  = "Sets multimedia games task priority to high."
        Cmd  = {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable Fullscreen AutoMinimize"
        Cat  = "Gaming Performance"
        Ben  = "Helps prevent games from minimizing when using Alt+Tab."
        Cmd  = {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableAutoMinimize" -Value 1 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable GPU Background Throttling"
        Cat  = "Gaming Performance"
        Ben  = "Disables TDR level to avoid some GPU timeouts (use with care)."
        Cmd  = {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "TdrLevel" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable V-Sync (NVIDIA Global)"
        Cat  = "Gaming Performance"
        Ben  = "Disables global V-Sync in NVIDIA control policy (if key exists)."
        Cmd  = {
            New-Item -Path "HKCU:\Software\NVIDIA Corporation\Global\NvCplApi\Policies" -Force | Out-Null
            Set-ItemProperty -Path "HKCU:\Software\NVIDIA Corporation\Global\NvCplApi\Policies" -Name "SyncToVBlank" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable Windows Game Recording Overlay"
        Cat  = "Gaming Performance"
        Ben  = "Disables GameDVR app capture."
        Cmd  = {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Force | Out-Null
            Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Force
        }
    }
)

# --- Network & Internet (15 tweaks) ---
$Sections["Network & Internet"] = @(
    [PSCustomObject]@{
        Name = "Enable TCP RSS"
        Cat  = "Network & Internet"
        Ben  = "Enables Receive Side Scaling for multi-core packet processing."
        Cmd  = { netsh int tcp set global rss=enabled | Out-Null }
    }
    [PSCustomObject]@{
        Name = "Flush DNS Cache"
        Cat  = "Network & Internet"
        Ben  = "Clears DNS cache and resets Winsock."
        Cmd  = {
            ipconfig /flushdns | Out-Null
            netsh winsock reset | Out-Null
        }
    }
    [PSCustomObject]@{
        Name = "Enable TCP Fast Open"
        Cat  = "Network & Internet"
        Ben  = "Enables TCP Fast Open for faster handshakes."
        Cmd  = { netsh int tcp set global fastopen=enabled | Out-Null }
    }
    [PSCustomObject]@{
        Name = "Increase Max User Ports"
        Cat  = "Network & Internet"
        Ben  = "Increases dynamic TCP port range."
        Cmd  = { netsh int ipv4 set dynamicport tcp start=1025 num=64511 | Out-Null }
    }
    [PSCustomObject]@{
        Name = "Disable NetBIOS over TCP"
        Cat  = "Network & Internet"
        Ben  = "Improves security by disabling NetBIOS over TCP/IP."
        Cmd  = {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "EnableNetbios" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Increase TCP Window Size"
        Cat  = "Network & Internet"
        Ben  = "Sets a larger TCP window size for high-latency links."
        Cmd  = {
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpWindowSize" -PropertyType DWord -Value 131400 -Force | Out-Null
        }
    }
    [PSCustomObject]@{
        Name = "Disable IPv6 (if unused)"
        Cat  = "Network & Internet"
        Ben  = "Disables IPv6 components (only if you do not use IPv6)."
        Cmd  = {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters" -Name "DisabledComponents" -Value 0xFF -Force
        }
    }
    [PSCustomObject]@{
        Name = "Set DNS to Google (Ethernet)"
        Cat  = "Network & Internet"
        Ben  = "Sets DNS servers to Google Public DNS on 'Ethernet' adapter."
        Cmd  = {
            Try {
                Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "8.8.8.8","8.8.4.4"
            } Catch {}
        }
    }
    [PSCustomObject]@{
        Name = "Enable Jumbo Frames"
        Cat  = "Network & Internet"
        Ben  = "Enables Jumbo Packets (if supported by adapter)."
        Cmd  = {
            Try {
                Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Jumbo Packet" -DisplayValue "9014 Bytes" -ErrorAction SilentlyContinue
            } Catch {}
        }
    }
    [PSCustomObject]@{
        Name = "Disable Windows Auto-Tuning"
        Cat  = "Network & Internet"
        Ben  = "Disables TCP receive window auto-tuning."
        Cmd  = { netsh interface tcp set global autotuninglevel=disabled | Out-Null }
    }
    [PSCustomObject]@{
        Name = "Disable SMBv1"
        Cat  = "Network & Internet"
        Ben  = "Disables legacy SMBv1 server protocol for better security."
        Cmd  = {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Enable TCP Chimney Offload"
        Cat  = "Network & Internet"
        Ben  = "Enables TCP chimney offload (if supported)."
        Cmd  = { netsh int tcp set global chimney=enabled | Out-Null }
    }
    [PSCustomObject]@{
        Name = "Set Network Profile to Private (Ethernet)"
        Cat  = "Network & Internet"
        Ben  = "Sets Ethernet network profile to Private."
        Cmd  = {
            Try {
                Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private
            } Catch {}
        }
    }
    [PSCustomObject]@{
        Name = "Disable Large Send Offload"
        Cat  = "Network & Internet"
        Ben  = "Disables Large Send Offload to reduce latency."
        Cmd  = {
            Try {
                Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Large Send Offload v2 (IPv4)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
                Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Large Send Offload v2 (IPv6)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
            } Catch {}
        }
    }
    [PSCustomObject]@{
        Name = "Disable Windows Peer-to-Peer Updates"
        Cat  = "Network & Internet"
        Ben  = "Prevents Delivery Optimization from using your bandwidth for others."
        Cmd  = {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Force | Out-Null
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Value 0 -Force
        }
    }
)

# --- Privacy & Security (15 tweaks) ---
$Sections["Privacy & Security"] = @(
    [PSCustomObject]@{
        Name = "Disable Telemetry Service"
        Cat  = "Privacy & Security"
        Ben  = "Disables Connected User Experiences and Telemetry service."
        Cmd  = {
            Stop-Service 'DiagTrack' -ErrorAction SilentlyContinue
            Set-Service 'DiagTrack' -StartupType Disabled -ErrorAction SilentlyContinue
        }
    }
    [PSCustomObject]@{
        Name = "Disable Advertising ID"
        Cat  = "Privacy & Security"
        Ben  = "Disables per-user advertising ID."
        Cmd  = {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Force | Out-Null
            Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable Feedback Requests"
        Cat  = "Privacy & Security"
        Ben  = "Prevents Windows from requesting feedback."
        Cmd  = {
            New-Item -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Force | Out-Null
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable Cortana Search Service"
        Cat  = "Privacy & Security"
        Ben  = "Disables Windows Search service (affects Start menu search)."
        Cmd  = {
            Stop-Service "WSearch" -ErrorAction SilentlyContinue
            Set-Service "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue
        }
    }
    [PSCustomObject]@{
        Name = "Disable Location Tracking"
        Cat  = "Privacy & Security"
        Ben  = "Denies location access for the user."
        Cmd  = {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
            Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable OneDrive Sync Service"
        Cat  = "Privacy & Security"
        Ben  = "Stops OneDrive sync service."
        Cmd  = {
            Stop-Service "OneSyncSvc" -ErrorAction SilentlyContinue
            Set-Service "OneSyncSvc" -StartupType Disabled -ErrorAction SilentlyContinue
        }
    }
    [PSCustomObject]@{
        Name = "Disable Windows Error Reporting"
        Cat  = "Privacy & Security"
        Ben  = "Disables Windows Error Reporting."
        Cmd  = {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 1 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable App Suggestions"
        Cat  = "Privacy & Security"
        Ben  = "Disables suggested apps in Start and elsewhere."
        Cmd  = {
            New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force | Out-Null
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Stop Edge & OneDrive Background"
        Cat  = "Privacy & Security"
        Ben  = "Stops Microsoft Edge and OneDrive processes (current session)."
        Cmd  = {
            Get-Process | Where-Object { $_.Name -in @("MicrosoftEdge","msedge","OneDrive") } | Stop-Process -Force -ErrorAction SilentlyContinue
        }
    }
    [PSCustomObject]@{
        Name = "Disable Windows Spotlight"
        Cat  = "Privacy & Security"
        Ben  = "Disables Spotlight on lock screen."
        Cmd  = {
            New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force | Out-Null
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenEnabled" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Reduce Diagnostic Data"
        Cat  = "Privacy & Security"
        Ben  = "Sets diagnostic data collection to minimum."
        Cmd  = {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable Connected User Experience Uploads"
        Cat  = "Privacy & Security"
        Ben  = "Stops telemetry upload service if running."
        Cmd  = {
            Stop-Service "DiagTrack" -ErrorAction SilentlyContinue
        }
    }
    [PSCustomObject]@{
        Name = "Disable SmartScreen (Explorer)"
        Cat  = "Privacy & Security"
        Ben  = "Turns off SmartScreen for apps and files in Explorer (reduces protection)."
        Cmd  = {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Force | Out-Null
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable Wi-Fi Sense OEM AutoConnect"
        Cat  = "Privacy & Security"
        Ben  = "Prevents OEM Wi-Fi auto-connect behavior."
        Cmd  = {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Force | Out-Null
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "AutoConnectAllowedOEM" -Value 0 -Force
        }
    }
    [PSCustomObject]@{
        Name = "Disable Bing Web Search in Start"
        Cat  = "Privacy & Security"
        Ben  = "Disables Bing web search integration in Start menu."
        Cmd  = {
            New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Force | Out-Null
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Force
        }
    }
)

# --- Winget Apps (15 apps) ---
$Sections["Winget Apps"] = @(
    [PSCustomObject]@{
        Name = "Install Google Chrome"
        Cat  = "Winget Apps"
        Ben  = "Installs Google Chrome via winget."
        Cmd  = { & winget install --id "Google.Chrome" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install 7-Zip"
        Cat  = "Winget Apps"
        Ben  = "Installs 7-Zip file archiver."
        Cmd  = { & winget install --id "7zip.7zip" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install VLC"
        Cat  = "Winget Apps"
        Ben  = "Installs VLC Media Player."
        Cmd  = { & winget install --id "VideoLAN.VLC" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install Firefox"
        Cat  = "Winget Apps"
        Ben  = "Installs Mozilla Firefox."
        Cmd  = { & winget install --id "Mozilla.Firefox" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install Discord"
        Cat  = "Winget Apps"
        Ben  = "Installs Discord client."
        Cmd  = { & winget install --id "Discord.Discord" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install Notepad++"
        Cat  = "Winget Apps"
        Ben  = "Installs Notepad++ editor."
        Cmd  = { & winget install --id "Notepad++.Notepad++" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install Spotify"
        Cat  = "Winget Apps"
        Ben  = "Installs Spotify desktop app."
        Cmd  = { & winget install --id "Spotify.Spotify" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install Steam"
        Cat  = "Winget Apps"
        Ben  = "Installs Steam game client."
        Cmd  = { & winget install --id "Valve.Steam" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install OBS Studio"
        Cat  = "Winget Apps"
        Ben  = "Installs OBS Studio for recording/streaming."
        Cmd  = { & winget install --id "OBSProject.OBSStudio" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install Zoom"
        Cat  = "Winget Apps"
        Ben  = "Installs Zoom client."
        Cmd  = { & winget install --id "Zoom.Zoom" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install Microsoft Edge"
        Cat  = "Winget Apps"
        Ben  = "Installs Microsoft Edge browser."
        Cmd  = { & winget install --id "Microsoft.Edge" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install Paint.NET"
        Cat  = "Winget Apps"
        Ben  = "Installs Paint.NET image editor."
        Cmd  = { & winget install --id "dotPDN.Paint.NET" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install FileZilla"
        Cat  = "Winget Apps"
        Ben  = "Installs FileZilla FTP client."
        Cmd  = { & winget install --id "FileZilla.FileZilla" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install Git"
        Cat  = "Winget Apps"
        Ben  = "Installs Git version control."
        Cmd  = { & winget install --id "Git.Git" -e --source winget }
    }
    [PSCustomObject]@{
        Name = "Install VS Code"
        Cat  = "Winget Apps"
        Ben  = "Installs Visual Studio Code."
        Cmd  = { & winget install --id "Microsoft.VisualStudioCode" -e --source winget }
    }
)

# --- GUI CREATION ---

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "YMs Ultra Lean Optimization Utility - Control Center"
$Form.Size = New-Object System.Drawing.Size(1200, 900)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = [System.Drawing.Color]::FromArgb(10,10,15)

$Intel = New-Object System.Windows.Forms.Label
$Intel.Text = ">>> Hover over a tweak to see its benefit."
$Intel.Font = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)
$Intel.ForeColor = [System.Drawing.Color]::Lime
$Intel.BackColor = [System.Drawing.Color]::FromArgb(20,20,25)
$Intel.Size = New-Object System.Drawing.Size(1150, 50)
$Intel.Location = New-Object System.Drawing.Point(20, 10)
$Intel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$Intel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$Form.Controls.Add($Intel)

$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Size = New-Object System.Drawing.Size(1150, 700)
$TabControl.Location = New-Object System.Drawing.Point(20, 70)
$Form.Controls.Add($TabControl)

$TabPages   = @{}
$Checkboxes = New-Object System.Collections.Generic.List[System.Windows.Forms.CheckBox]

foreach ($Cat in $Sections.Keys) {
    $Tab = New-Object System.Windows.Forms.TabPage
    $Tab.Text = $Cat
    $Tab.BackColor = [System.Drawing.Color]::FromArgb(15,15,20)

    $FlowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $FlowPanel.Name = "FlowPanel"
    $FlowPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $FlowPanel.AutoScroll = $true
    $FlowPanel.WrapContents = $false
    $FlowPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown

    $Tab.Controls.Add($FlowPanel)
    $TabPages[$Cat] = $Tab
    [void]$TabControl.TabPages.Add($Tab)
}

foreach ($Cat in $Sections.Keys) {
    foreach ($Tweak in $Sections[$Cat]) {
        $CB = New-Object System.Windows.Forms.CheckBox
        $CB.Text = $Tweak.Name
        $CB.Tag  = $Tweak
        $CB.AutoSize = $true
        $CB.ForeColor = [System.Drawing.Color]::White
        $CB.BackColor = [System.Drawing.Color]::FromArgb(15,15,20)
        $CB.Font = New-Object System.Drawing.Font("Segoe UI", 10)

        $CB.Add_MouseEnter({
            param($sender, $args)
            $Intel.Text = ">>> Benefit: " + $sender.Tag.Ben
        })
        $CB.Add_MouseLeave({
            param($sender, $args)
            $Intel.Text = ">>> Hover over a tweak to see its benefit."
        })

        $TabPages[$Cat].Controls["FlowPanel"].Controls.Add($CB)
        $Checkboxes.Add($CB) | Out-Null
    }
}

$BackupBtn = New-Object System.Windows.Forms.Button
$BackupBtn.Text = "CREATE SYSTEM RESTORE POINT"
$BackupBtn.Size = New-Object System.Drawing.Size(550, 50)
$BackupBtn.Location = New-Object System.Drawing.Point(20, 780)
$BackupBtn.BackColor = [System.Drawing.Color]::FromArgb(40,40,40)
$BackupBtn.ForeColor = [System.Drawing.Color]::Yellow
$BackupBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$BackupBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$BackupBtn.Add_Click({
    $Intel.Text = "Creating system restore point (this may take a while)..."
    Try {
        Checkpoint-Computer -Description "YMs_UltraLean_Backup" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        [System.Windows.Forms.MessageBox]::Show("System restore point created successfully.","Restore Point")
        $Intel.Text = "Restore point created successfully."
    } Catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to create restore point. Run PowerShell as Administrator.","Restore Point Error")
        $Intel.Text = "Failed to create restore point. Try running as Administrator."
    }
})
$Form.Controls.Add($BackupBtn)

$RunBtn = New-Object System.Windows.Forms.Button
$RunBtn.Text = "APPLY SELECTED TWEAKS"
$RunBtn.Size = New-Object System.Drawing.Size(550, 50)
$RunBtn.Location = New-Object System.Drawing.Point(620, 780)
$RunBtn.BackColor = [System.Drawing.Color]::FromArgb(30,30,40)
$RunBtn.ForeColor = [System.Drawing.Color]::Cyan
$RunBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$RunBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$RunBtn.Add_Click({
    $Applied = 0
    foreach ($CB in $Checkboxes) {
        if ($CB.Checked) {
            $Tweak = $CB.Tag
            Write-Host "Applying: $($Tweak.Name)" -ForegroundColor Cyan
            Try {
                & $Tweak.Cmd
                $Applied++
            } Catch {
                Write-Host "Failed: $($Tweak.Name) - $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
    [System.Windows.Forms.MessageBox]::Show("$Applied tweak(s) applied. A restart is recommended for all changes to take full effect.","Tweaks Applied")
})

$Form.Controls.Add($RunBtn)

[void]$Form.ShowDialog()
