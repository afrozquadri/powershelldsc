#DSC Config1


configuration azuredscdinesh # Configuration name and the script name has to the same.
{

    Import-DscResource -ModuleName PsDesiredStateconfiguration

    WindowsFeature WebServer
    {
        Ensure = "Present"
        name ="Web-Server"
        
    }

}