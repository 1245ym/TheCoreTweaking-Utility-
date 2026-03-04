Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Admin check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# ------------------------------
# SECTIONS & TWEAKS
# ------------------------------
$Sections = @{}

# --- Gaming Performance ---
$Sections["Gaming Performance"] = @(
    # Original 15 + extra safe tweaks
    [PSCustomObject]@{ Name="Enable Ultimate Game Mode"; Cat="Gaming Performance"; Ben="Turns on Windows Game Mode features"; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\GameMode" -Name "Enable" -Value 1 -Force } }
    [PSCustomObject]@{ Name="Set GPU High Performance Preference"; Cat="Gaming Performance"; Ben="Sets GPU preference for high-performance apps"; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\DirectX" -Name "HighPerformanceGPU" -Value 1 -Force } }
)

# --- Network & Internet ---
$Sections["Network & Internet"] = @(
    [PSCustomObject]@{ Name="Enable TCP Fast Open"; Cat="Network & Internet"; Ben="Faster TCP handshakes"; Cmd={ netsh int tcp set global fastopen=enabled | Out-Null } }
    [PSCustomObject]@{ Name="Enable Jumbo Frames (if supported)"; Cat="Network & Internet"; Ben="Allows larger network packets"; Cmd={ Try { Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Jumbo Packet" -DisplayValue "9014 Bytes" -ErrorAction SilentlyContinue } Catch {} } }
)

# --- Privacy & Security ---
$Sections["Privacy & Security"] = @(
    [PSCustomObject]@{ Name="Disable Windows Spotlight"; Cat="Privacy & Security"; Ben="Stops Spotlight content"; Cmd={ New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenEnabled" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Disable Feedback Notifications"; Cat="Privacy & Security"; Ben="Prevents Windows feedback prompts"; Cmd={ New-Item -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Force } }
)

# --- System Performance ---
$Sections["System Performance"] = @(
    [PSCustomObject]@{ Name="Enable Ultimate Performance Plan"; Cat="System Performance"; Ben="Unlocks hidden Ultimate Performance power plan"; Cmd={ powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null } }
    [PSCustomObject]@{ Name="Disable Startup Delay"; Cat="System Performance"; Ben="Removes startup delay"; Cmd={ New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Force | Out-Null; Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Name "StartupDelayInMSec" -Value 0 -Force } }
)

# --- Cleanup & Maintenance ---
$Sections["Cleanup & Maintenance"] = @(
    [PSCustomObject]@{ Name="Clean Temp Files"; Cat="Cleanup & Maintenance"; Ben="Removes temp files"; Cmd={ Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue } }
    [PSCustomObject]@{ Name="Clear Windows Update Cache"; Cat="Cleanup & Maintenance"; Ben="Clears SoftwareDistribution cache"; Cmd={ Stop-Service wuauserv -Force; Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue; Start-Service wuauserv } }
)

# --- Explorer/UI Tweaks ---
$Sections["Explorer/UI Tweaks"] = @(
    [PSCustomObject]@{ Name="Show File Extensions"; Cat="Explorer/UI Tweaks"; Ben="Always show file extensions"; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Force } }
    [PSCustomObject]@{ Name="Show Hidden Files"; Cat="Explorer/UI Tweaks"; Ben="Displays hidden files"; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -Force } }
)

# --- Winget Apps (25+ ready) ---
$Sections["Winget Apps"] = @(
    [PSCustomObject]@{ Name="Google Chrome"; Cat="Winget Apps"; Ben="Installs Chrome"; Cmd={ & winget install --id "Google.Chrome" -e --source winget } }
    [PSCustomObject]@{ Name="Mozilla Firefox"; Cat="Winget Apps"; Ben="Installs Firefox"; Cmd={ & winget install --id "Mozilla.Firefox" -e --source winget } }
    [PSCustomObject]@{ Name="Microsoft Edge"; Cat="Winget Apps"; Ben="Installs Edge"; Cmd={ & winget install --id "Microsoft.Edge" -e --source winget } }
    [PSCustomObject]@{ Name="7-Zip"; Cat="Winget Apps"; Ben="Installs 7-Zip"; Cmd={ & winget install --id "7zip.7zip" -e --source winget } }
    [PSCustomObject]@{ Name="VLC Media Player"; Cat="Winget Apps"; Ben="Installs VLC"; Cmd={ & winget install --id "VideoLAN.VLC" -e --source winget } }
    [PSCustomObject]@{ Name="Notepad++"; Cat="Winget Apps"; Ben="Installs Notepad++"; Cmd={ & winget install --id "Notepad++.Notepad++" -e --source winget } }
    [PSCustomObject]@{ Name="Visual Studio Code"; Cat="Winget Apps"; Ben="Installs VS Code"; Cmd={ & winget install --id "Microsoft.VisualStudioCode" -e --source winget } }
    [PSCustomObject]@{ Name="Git"; Cat="Winget Apps"; Ben="Installs Git"; Cmd={ & winget install --id "Git.Git" -e --source winget } }
    [PSCustomObject]@{ Name="Spotify"; Cat="Winget Apps"; Ben="Installs Spotify"; Cmd={ & winget install --id "Spotify.Spotify" -e --source winget } }
    [PSCustomObject]@{ Name="Steam"; Cat="Winget Apps"; Ben="Installs Steam"; Cmd={ & winget install --id "Valve.Steam" -e --source winget } }
    [PSCustomObject]@{ Name="Discord"; Cat="Winget Apps"; Ben="Installs Discord"; Cmd={ & winget install --id "Discord.Discord" -e --source winget } }
    [PSCustomObject]@{ Name="OBS Studio"; Cat="Winget Apps"; Ben="Installs OBS Studio"; Cmd={ & winget install --id "OBSProject.OBSStudio" -e --source winget } }
    [PSCustomObject]@{ Name="Zoom"; Cat="Winget Apps"; Ben="Installs Zoom"; Cmd={ & winget install --id "Zoom.Zoom" -e --source winget } }
    [PSCustomObject]@{ Name="FileZilla"; Cat="Winget Apps"; Ben="Installs FileZilla"; Cmd={ & winget install --id "FileZilla.FileZilla" -e --source winget } }
    [PSCustomObject]@{ Name="Paint.NET"; Cat="Winget Apps"; Ben="Installs Paint.NET"; Cmd={ & winget install --id "dotPDN.Paint.NET" -e --source winget } }
    [PSCustomObject]@{ Name="WinRAR"; Cat="Winget Apps"; Ben="Installs WinRAR"; Cmd={ & winget install --id "RARLab.WinRAR" -e --source winget } }
    [PSCustomObject]@{ Name="Python"; Cat="Winget Apps"; Ben="Installs Python"; Cmd={ & winget install --id "Python.Python.3" -e --source winget } }
    [PSCustomObject]@{ Name="Node.js LTS"; Cat="Winget Apps"; Ben="Installs Node.js"; Cmd={ & winget install --id "OpenJS.NodeJS.LTS" -e --source winget } }
    [PSCustomObject]@{ Name="PowerShell 7"; Cat="Winget Apps"; Ben="Installs PowerShell 7"; Cmd={ & winget install --id "Microsoft.Powershell" -e --source winget } }
    [PSCustomObject]@{ Name="Docker Desktop"; Cat="Winget Apps"; Ben="Installs Docker Desktop"; Cmd={ & winget install --id "Docker.DockerDesktop" -e --source winget } }
    [PSCustomObject]@{ Name="Postman"; Cat="Winget Apps"; Ben="Installs Postman"; Cmd={ & winget install --id "Postman.Postman" -e --source winget } }
    [PSCustomObject]@{ Name="Visual Studio 2022 Community"; Cat="Winget Apps"; Ben="Installs VS2022 Community"; Cmd={ & winget install --id "Microsoft.VisualStudio.2022.Community" -e --source winget } }
    [PSCustomObject]@{ Name="Malwarebytes"; Cat="Winget Apps"; Ben="Installs Malwarebytes"; Cmd={ & winget install --id "Malwarebytes.Malwarebytes" -e --source winget } }
    [PSCustomObject]@{ Name="Rufus"; Cat="Winget Apps"; Ben="Installs Rufus"; Cmd={ & winget install --id "Akeo.Rufus" -e --source winget } }
    [PSCustomObject]@{ Name="Everything Search"; Cat="Winget Apps"; Ben="Installs Everything"; Cmd={ & winget install --id "Voidtools.Everything" -e --source winget } }
)

# ------------------------------
# GUI CREATION
# ------------------------------
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "YMs Ultra Lean Optimization Utility - POWERHOUSE BEAST MODE"
$Form.Size = New-Object System.Drawing.Size(1200,1000)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = [System.Drawing.Color]::FromArgb(10,10,15)

# Benefit label
$Intel = New-Object System.Windows.Forms.Label
$Intel.Text = ">>> Hover over a tweak to see its benefit."
$Intel.Font = New-Object System.Drawing.Font("Consolas",12,[System.Drawing.FontStyle]::Bold)
$Intel.ForeColor = [System.Drawing.Color]::Lime
$Intel.BackColor = [System.Drawing.Color]::FromArgb(20,20,25)
$Intel.Size = New-Object System.Drawing.Size(1150,50)
$Intel.Location = New-Object System.Drawing.Point(20,10)
$Intel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$Intel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$Form.Controls.Add($Intel)

# Tab control
$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Size = New-Object System.Drawing.Size(1150,800)
$TabControl.Location = New-Object System.Drawing.Point(20,70)
$Form.Controls.Add($TabControl)

$TabPages = @{}
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
    $FlowPanel.Padding = New-Object System.Windows.Forms.Padding(10)

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
        $CB.Font = New-Object System.Drawing.Font("Segoe UI",10)
        $CB.Add_MouseEnter({ param($s,$a) $Intel.Text=">>> Benefit: "+$s.Tag.Ben })
        $CB.Add_MouseLeave({ param($s,$a) $Intel.Text=">>> Hover over a tweak to see its benefit." })
        $TabPages[$Cat].Controls["FlowPanel"].Controls.Add($CB)
        $Checkboxes.Add($CB) | Out-Null
    }
}

# ------------------------------
# Buttons: Backup, Apply, Revert
# ------------------------------
$BackupBtn = New-Object System.Windows.Forms.Button
$BackupBtn.Text = "CREATE SYSTEM RESTORE POINT"
$BackupBtn.Size = New-Object System.Drawing.Size(360,50)
$BackupBtn.Location = New-Object System.Drawing.Point(20,880)
$BackupBtn.BackColor = [System.Drawing.Color]::FromArgb(40,40,40)
$BackupBtn.ForeColor = [System.Drawing.Color]::Yellow
$BackupBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$BackupBtn.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$BackupBtn.Add_Click({
    $Intel.Text="Creating system restore point..."
    Try { Checkpoint-Computer -Description "YMs_Powerhouse_Backup" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop; [System.Windows.Forms.MessageBox]::Show("Restore point created successfully.","Restore Point"); $Intel.Text="Restore point created successfully." } 
    Catch { [System.Windows.Forms.MessageBox]::Show("Failed. Run PowerShell as Admin.","Error"); $Intel.Text="Failed. Try running as Admin." }
})
$Form.Controls.Add($BackupBtn)

$RunBtn = New-Object System.Windows.Forms.Button
$RunBtn.Text = "APPLY SELECTED TWEAKS"
$RunBtn.Size = New-Object System.Drawing.Size(360,50)
$RunBtn.Location = New-Object System.Drawing.Point(400,880)
$RunBtn.BackColor = [System.Drawing.Color]::FromArgb(30,30,40)
$RunBtn.ForeColor = [System.Drawing.Color]::Cyan
$RunBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$RunBtn.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$RunBtn.Add_Click({
    $Applied=0
    foreach ($CB in $Checkboxes) { if ($CB.Checked) { Try { & $CB.Tag.Cmd; $Applied++ } Catch {} } }
    [System.Windows.Forms.MessageBox]::Show("$Applied tweak(s) applied. Restart recommended.","Tweaks Applied")
})
$Form.Controls.Add($RunBtn)

$RevertBtn = New-Object System.Windows.Forms.Button
$RevertBtn.Text = "REVERT SELECTED TWEAKS"
$RevertBtn.Size = New-Object System.Drawing.Size(360,50)
$RevertBtn.Location = New-Object System.Drawing.Point(780,880)
$RevertBtn.BackColor = [System.Drawing.Color]::FromArgb(30,30,40)
$RevertBtn.ForeColor = [System.Drawing.Color]::OrangeRed
$RevertBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$RevertBtn.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$RevertBtn.Add_Click({
    $Reverted=0
    foreach ($CB in $Checkboxes) { if ($CB.Checked) { Try { if ($CB.Tag.RevertCmd) { & $CB.Tag.RevertCmd; $Reverted++ } } Catch {} } }
    [System.Windows.Forms.MessageBox]::Show("$Reverted tweak(s) reverted.","Tweaks Reverted")
})
$Form.Controls.Add($RevertBtn)

# ------------------------------
# Log panel
# ------------------------------
$LogBox = New-Object System.Windows.Forms.TextBox
$LogBox.Multiline = $true
$LogBox.ScrollBars = "Vertical"
$LogBox.Font = New-Object System.Drawing.Font("Consolas",10)
$LogBox.Size = New-Object System.Drawing.Size(1150,100)
$LogBox.Location = New-Object System.Drawing.Point(20,940)
$LogBox.BackColor = [System.Drawing.Color]::FromArgb(15,15,20)
$LogBox.ForeColor = [System.Drawing.Color]::White
$Form.Controls.Add($LogBox)

# ------------------------------
# Show GUI
# ------------------------------
[void]$Form.ShowDialog()
