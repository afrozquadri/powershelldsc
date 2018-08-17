$ClientGuid= ([guid]::NewGuid()).GUid

New-Item -Path C:\DSCClient\ -Name GUID.txt -ItemType File -Value $ClientGuid -Force

$ClientCertificate = Get-ChildItem Cert:\LocalMachine\My | ?{$_.Thumbprint -like "*834"}

$secpasswd = ConvertTo-SecureString “123#ntms123#” -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential (“dscadmin”, $secpasswd)

[DSCLocalConfigurationManager()]
configuration SmbClientPullConfig
{
    Node $AllNodes.NodeName
    {
        Settings
        {
            RefreshMode = 'Pull'
            RefreshFrequencyMins = 30
            RebootNodeIfNeeded = $true
            ConfigurationID    = $ClientGuid
            CertificateID = $ClientCertificate.Thumbprint
            AllowModuleOverwrite = $true
            ConfigurationMode = "ApplyandMonitor"
        }

         ConfigurationRepositoryShare SmbConfigShare
        {
            SourcePath = '\\Powershell-dsc\Dscshare'
            Credential = $mycreds
        }

        ResourceRepositoryShare SmbResourceShare
        {
            SourcePath = '\\Powershell-dsc\Dscshare'
            Credential = $mycreds

        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            
            NodeName="DSCClient"
            PSDscAllowPlainTextPassword = $true
        })
}

SmbClientPullConfig -OutputPath C:\DSCClient\SMBConfig -ConfigurationData $ConfigurationData



Set-DSCLocalConfigurationManager DSCClient –Path C:\DSCClient\SMBConfig –Verbose 

Get-DscLocalConfigurationManager
