@{
    AllNodes =
    @(
        @{
            NodeName = '*'
            ScriptDestinationPath = 'C:\Scripts'
            OSSourcePath = '\\S16-JB\Share\S16OS\Sources\Sxs'
        }
            @{
            NodeName = 'WebServer01'
            Role = 'WebServer'
            Environment = 'Production'
        }
        
        @{
            NodeName = 'WebServer02'
            Role = 'WebServer'
            Environment = 'Production'
        }
        
        @{
            NodeName = 'WebServer03'
            Role = 'WebServer'
            Environment = 'Development'
        }
       
        @{
            NodeName = 'WebServer04'
            Role = 'WebServer'
            Environment = 'Development'
        }

        @{
            NodeName = 'DBServer01'
            Role = 'DBServer'
            Environment = 'Production'
        }
       
        @{
            NodeName = 'DBServer02'
            Role = 'DBServer'
            Environment = 'Development'
        }
    )
    
    EnvironmentData =
    @{
        'WebServer' = @{
                            'Production' = @{
                            'ScriptsPath' = '\\S16-JB\Share\Websetup-Prod.zip'
                            }
                            'Development' = @{
                            'ScriptsPath' = '\\S16-JB\Share\Websetup-Dev.zip'
                            }
                        }
    'DBServer' = @{
                        'Production' = @{
                        'ScriptsPath' = '\\S16-JB\Share\DBsetup-Prod.zip'
                        }
                        'Development' = @{
                        'ScriptsPath' = '\\S16-JB\Share\DBsetup-Dev.zip'
                        }
                        }
    }
}


Configuration WebDBDemo
{
    Import-DscResource -ModuleName PsDscResources -Name Archive
    Import-DscResource -ModuleName PSDesiredStateConfiguration -Name WindowsFeature
    
    #Add what is specific to web server role
    Node $AllNodes.Where{$_.Role -eq 'WebServer'}.NodeName
    {
        WindowsFeature WebServer
        {
        Name = 'Web-Server'
        IncludeAllSubFeature = $true
        Ensure = 'Present'
        }
    }

    #Add what is specific to DB server role
    Node $AllNodes.Where{$_.Role -eq 'DBServer'}.NodeName
    {
        WindowsFeature NET35
        {
        Name = 'NET-Framework-Core'
        Source = $Node.OSSourcePath
        Ensure = 'Present'
        }
    }
    #Add configuration that is common across but may have separate environment data
    
    Node $AllNodes.NodeName
    {
    $NodeRole = $Node.Role
    $NodeEnvironment = $Node.Environment
    Archive SetupScripts
    {
        Path = $ConfigurationData.EnvironmentData.$NodeRole.
        $NodeEnvironment.ScriptsPath
        Destination = $Node.ScriptDestinationPath
        Force = $true
    }
    }
}
WebDBDemo -ConfigurationData C:\Scripts\ConfigurationData.psd1 -Verbose