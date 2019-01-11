
Enable-psremoting

New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP

$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName $env:COMPUTERNAME

Export-Certificate  -Cert $Cert -FilePath "C:\Temp\cert.cer"

get-childItem -Path WSMan:\LocalHost\Listener | %{$_.Transport -eq "HTTPS"}



New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force 

Set-Item wsman:\localhost\Client\TrustedHosts -Value "*" -Concatenate -Force

Set-NetConnectionProfile -NetworkCategory Private
