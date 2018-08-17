[DSCLocalConfigurationManager()]
configuration oDataHTTPSPullClient
{
    param
    (
        [Parameter()]
        [String]
        $NodeName = 'localhost',

        [Parameter(Mandatory = $true)]
        [String]
        $RegistrationKey,

        [Parameter(Mandatory = $true)]
        [String]
        $PullSvcEndpoint,

        [Parameter(Mandatory = $true)]
        [String[]]
        $ConfigNames
    )

    Node $NodeName
    {
        Settings
        {
            RefreshMode        = 'Pull'
        }

        ConfigurationRepositoryWeb HTTPSPullSvc
        {
            ServerURL          = $PullSvcEndpoint
            RegistrationKey    = $RegistrationKey
            ConfigurationNames = $ConfigNames
        }

        ResourceRepositoryWeb HTTPSPullSvc
        {
            ServerURL          = $PullSvcEndpoint
            RegistrationKey    = $RegistrationKey
        }
    }
}

oDataHTTPSPullClient -RegistrationKey '5b2670df-0a7f-4bc6-8fa8-f1367a2fb00b' -PullSvcEndpoint 'https://powershell-dsc:8080/PSDSCPullServer.svc/' -ConfigNames @('OSConfig')

Get-Certificate -CertStoreLocation Cert:\LocalMachine\My -Template User

Get-ChildItem Cert:\LocalMachine\My | ?{$_.Thumbprint -like "*834"} | Export-Certificate -FilePath C:\Temp\ceet.cer