write-output "Creating Nomad directories"
New-Item -Path "C:\opt\nomad\data" -ItemType Directory -Force
New-Item -Path "C:\opt\nomad\jobs" -ItemType Directory -Force

write-output "Downloading Nomad"
$nomadUrl = "https://releases.hashicorp.com/nomad/0.4.1/nomad_0.4.1_windows_amd64.zip"
$nomadFilePath = "$($env:TEMP)\nomad.zip"
(New-Object System.Net.WebClient).DownloadFile($nomadUrl, $nomadFilePath)

write-output "Copying Nomad"
$shell = New-Object -ComObject Shell.Application
$nomadZip = $shell.NameSpace($nomadFilePath)
$nomadDestination = $shell.Namespace("C:\opt\nomad")
$copyFlags = 0x04 + 0x10  # hide progress + overwrite existing
$nomadDestination.CopyHere($nomadZip.Items(), $copyFlags)

write-output "Cleanup"
Remove-Item -Force -Path $nomadFilePath

write-output "Creating Nomad service"
C:\opt\nssm.exe install nomad "C:\opt\nomad\nomad.exe" agent -client -config "C:\etc\nomad.d"

write-output "Stopping Nomad service"
Stop-Service nomad -EA silentlycontinue
Set-Service nomad -StartupType Manual

write-output "Setting firewall"
netsh advfirewall firewall add rule name="Nomad HTTP" dir=in action=allow protocol=TCP localport=4646
netsh advfirewall firewall add rule name="Nomad RPC" dir=in action=allow protocol=TCP localport=4647
netsh advfirewall firewall add rule name="Nomad Serf TCP" dir=in action=allow protocol=TCP localport=4648
netsh advfirewall firewall add rule name="Nomad Serf UDP" dir=in action=allow protocol=UDP localport=4648
netsh advfirewall firewall add rule name="Nomad dynamic ports TCP" dir=in action=allow protocol=TCP localport=20000-60000
netsh advfirewall firewall add rule name="Nomad dynamic ports UDP" dir=in action=allow protocol=UDP localport=20000-60000
