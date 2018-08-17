$RegistrationKey = "9d644875-3ccf-4110-a7bc-65b060f23168"
$Clientkey = ([guid]::NewGuid()).Guid

[DSCLocalConfigurationManager()]
configuration HTTPLCmConfiguration
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [string] $NodeName = 'localhost',

        [ValidateNotNullOrEmpty()]
        [string] $RegistrationKey, #same as the one used to setup pull server in previous configuration

        [ValidateNotNullOrEmpty()]
        [string] $ServerName = 'localhost' #node name of the pull server, same as $NodeName used in previous configuration
    )

    Node $NodeName
    {
        Settings
        {
            RefreshMode        = 'Pull'
           # ConfigurationID = "$Clientkey"
        }

        ConfigurationRepositoryWeb DSC-PullSrv
        {
            ServerURL          = "https://$ServerName`:8080/PSDSCPullServer.svc" # notice it is https
            RegistrationKey    = $RegistrationKey
            ConfigurationNames = @('WebServerConfig')
        }

        ReportServerWeb DSC-PullSrv
        {
            ServerURL       = "https://$ServerName`:8080/PSDSCPullServer.svc" # notice it is https
            RegistrationKey = $RegistrationKey
        }
    }
}

#mkdir C:\httplcmconfiguration 

HTTPLCmConfiguration -RegistrationKey $RegistrationKey -OutputPath C:\httplcmconfiguration -Servername "Powersehll-dsc" -NodeName "DSCClient"

Set-DscLocalConfigurationManager -ComputerName "DSCClient" -Path C:\httplcmconfiguration -Verbose -Force