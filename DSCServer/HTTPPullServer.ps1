<#
    A server running:
WMF/PowerShell 5.0 or greater
IIS server role
DSC Service
Ideally, some means of generating a certificate, to secure credentials passed to the Local Configuration Manager (LCM) on target nodes


#>

$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "$($env:COMPUTERNAME)"
$cert | Export-Certificate -FilePath C:\HTTPPullServerconfig\Powershell-dsc.cer -Force

$registrationkey = ([guid]::NewGuid()).Guid


configuration DSCPullServerConfig
{
    param
    (
        [string[]]$NodeName = 'localhost',

        [ValidateNotNullOrEmpty()]
        [string] $certificateThumbPrint,

        [Parameter(HelpMessage='This should be a string with enough entropy (randomness) to protect the registration of clients to the pull server.  We will use new GUID by default.')]
        [ValidateNotNullOrEmpty()]
        [string] $RegistrationKey   # A guid that clients use to initiate conversation with pull server
    )

    Import-DSCResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    

    Node $NodeName
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name   = "DSC-Service"
        }

        xDscWebService PSDSCPullServer
        {
            Ensure                  = "Present"
            EndpointName            = "PSDSCPullServer"
            Port                    = 8080
            PhysicalPath            = "$env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint   = $certificateThumbPrint
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            State                   = "Started"
            DependsOn               = "[WindowsFeature]DSCServiceFeature"
            RegistrationKeyPath     = "$env:PROGRAMFILES\WindowsPowerShell\DscService"
            AcceptSelfSignedCertificates = $true
            Enable32BitAppOnWin64   = $false
            UseSecurityBestPractices = $true
        }

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = $RegistrationKey
        }
    }
}

mkdir C:\HTTPPullServerconfig

DSCPullServerConfig -OutputPath C:\HTTPPullServerconfig -certificateThumbPrint $Cert.Thumbprint -RegistrationKey $registrationkey

Start-DscConfiguration -Path C:\HTTPPullServerconfig -wait -Verbose
Get-DscConfiguration -CimSession localhost -Verbose


