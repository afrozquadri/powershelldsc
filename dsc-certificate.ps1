You must generate encryption certificates and copy the public keys to
the authoring station.
• You must configure the target node LCM to use the certificate to
decrypt credentials.
• You must author a configuration document that uses credential
encryption.

Generate the certificate on the authoring station, and copy and install
the entire certificate pair on the target node.
• Generate the certificate on the target node, and export and copy only
the public key to the authoring station.


New-SelfSignedCertificate -Type DocumentEncryption
CertLegacyCsp -DnsName ${env:ComputerName} -HashAlgorithm SHA256

$null = $certificate | Export-Certificate -FilePath "${env:Temp}\${env:
ComputerName}.cer" -Force

requiredCertificate = Get-ChildItem -Path Cert:\LocalMachine\My
|Where-Object {
($_.Subject -eq "CN=${env:COMPUTERNAME}") -and `
($_.EnhancedKeyUsageList.FriendlyName -contains
'Document Encryption')
}

[DscLocalConfigurationManager()]
Configuration CertificateConfig
{
Settings
{
CertificateID = $requiredCertificate.Thumbprint
}
}




$configurationData =
@{
AllNodes =
@(
@{
NodeName = 'S16-01'
CertificateFile = 'C:\publicKeys\S16-01.cer'
Thumbprint = 'E62AAD02E93E8C3082E96AA408032D0325C23FD6'
PsDscAllowDomainUser = $true
}
)
}