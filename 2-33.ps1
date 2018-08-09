$cred = Get-Credential

Enter-PSSession -ComputerName "Win10-Client" -Credential $cred -Verbose -UseSSL

New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP

Export-Certificate 

dsc-client

$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "DESKTOP-MKOHOM6"

Export-Certificate  -Cert $Cert -FilePath "C:\Temp"

Get-ChildItem Cert:\LocalMachine\My | Export-Certificate -FilePath C:\Temp


New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint –Force



Set-Item wsman:\localhost\Client\TrustedHosts -Value 192.168.2.30 -Concatenate -Force

Restart-Service winrm

Invoke-Command -ComputerName 192.168.2.31 -ArgumentList "Notepad.exe" -ScriptBlock {get-process | ?{$_.name -eq "Args[0]"}} -Credential $cred 

$cimSessionOption = New-CimSessionOption -UseSsl -SkipCACheck -SkipCNCheck
$cimSession = New-CimSession -SessionOption $cimSessionOption -ComputerName "192.168.2.31" -Port 5986  -Credential $cred -Verbose

$pssessionoption=New-PSSessionOption -SkipCACheck -SkipCNCheck

$pssession=New-PSSession -ComputerName "192.168.2.31" -SessionOption $pssessionoption -Port 5986 -Credential $cred -UseSSL -Verbose

winrm set winrm/config/client @{TrustedHosts="192.168.2.31"}

	
Set-Item  WSMan:\localhost\Client\TrustedHosts -Value "10.0.2.33" -Force

Set-NetConnectionProfile -NetworkCategory Private






$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "FQDN"

New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint –Force





New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" 
-Profile Any -LocalPort 5986 -Protocol TCP