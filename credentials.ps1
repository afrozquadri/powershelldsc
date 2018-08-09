# USe Of Credentials in DSC

#Lets try to connect some shared drive from DSC and copy the things.

$Client="DESKTOP-MKOHOM6"

if($cred -eq $null)
{
$cred = Get-Credential
}


if($sharecred -eq $null)
    {
        $sharecred = Get-Credential
    }

configuration clientconfig
{

    Import-DscResource -Modulename PSDesiredStateConfiguration -ModuleVersion 1.1

    node $Client
    {
        
        Script DSCRunDemo
            {
                SetScript =
                    {
                        Write-Verbose -Message $(whoami) # Must do something
                    }
                TestScript =
                    {
                         return $false # Must return boolen values
                    }
                GetScript =
                    {
                        return @{} # Must return Hash Table
                    }
            }
      
        
        
        
        File FileCopyDemo
            {
            SourcePath = '\\DSC-SRV\share\cert.pfx'
            DestinationPath = 'C:\Temp\cert.pfx'
            Type = 'File'
            Force = $true
            }
    
    }


}

clientconfig -OutputPath C:\temp\ 


$Cimsessionopt=New-CimSessionOption -UseSsl

$Cismsession= New-CimSession -SessionOption $Cimsessionopt -ComputerName $Client -Credential $Cred -port 5986 -Verbose

Start-DscConfiguration -Path C:\temp  -wait -Verbose  -CimSession $Cismsession -Force

#Start-DscConfiguration -Path C:\temp -Credential $cred -wait -verbose

#Find-Module -name cWindowsOS | select -ExpandProperty Additionalmetadata 



#it looks like we have to provide the credentials to connect to share drive

configuration clientconfigwithcredential
{
            Param
        (
        [Parameter(Mandatory)]
        [pscredential] $Credential
        )



    Import-DscResource -Modulename PSDesiredStateConfiguration -ModuleVersion 1.1

    node $Client
    {
                
        Script DSCRunDemo
            {
                SetScript =
                    {
                        Write-Verbose -Message $(whoami) # Must do something
                    }
                TestScript =
                    {
                         return $false # Must return boolen values
                    }
                GetScript =
                    {
                        return @{} # Must return Hash Table
                    }
            }
      
        
        
        
        File FileCopyDemo
            {
            SourcePath = '\\DSC-SRV\share\cert.pfx'
            DestinationPath = 'C:\Temp\cert.pfx'
            Type = 'File'
            Force = $true
            Credential = $Credential
            }
    
    }


}

clientconfigwithcredential -OutputPath C:\temp\ -Credential (get-credential)

# Checkout what happens





#two ways to get out of this
<#
• Allowing the PSDscAllowPlainTextPassword key in
configuration data
• Using certificates to encrypt passwords in a configuration
#>
$configurationData = @{
                        AllNodes =
                            @(
                                @{
                                    NodeName = $Client
                                    PsDscAllowPlainTextPassword = $true
                                    #PSDscAllowDomainUser = $true
                                }
                              )
                       }

configuration clientconfigwithcredentialplain
{
            Param
        (
        [Parameter(Mandatory)]
        [pscredential] $Credential
        )



    Import-DscResource -Modulename PSDesiredStateConfiguration -ModuleVersion 1.1

    node $Client
    {
             
        Script DSCRunDemo
            {
                SetScript =
                    {
                        Write-Verbose -Message $(whoami) # Must do something
                    }
                TestScript =
                    {
                         return $false # Must return boolen values
                    }
                GetScript =
                    {
                        return @{} # Must return Hash Table
                    }
            }
      
        
        
        
        File FileCopyDemo
            {
            SourcePath = '\\DSC-SRV\share\cert.pfx'
            DestinationPath = 'C:\Temp\cert.pfx'
            Type = 'File'
            Force = $true
            Credential = $Credential
            }
    
    }


}

clientconfigwithcredentialplain -OutputPath C:\temp\ -Credential $sharecred -ConfigurationData $configurationData


# Using Credentials

#ON Target machine

$certificate = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName ${env:ComputerName} -HashAlgorithm SHA256
$null = $certificate | Export-Certificate -FilePath "${env:Temp}\${env:ComputerName}.cer" -Force


# On Target machine

$requiredCertificate = Get-ChildItem -Path Cert:\LocalMachine\My\587101AF9F0B16AEF4DD46ED4F1064D72D5B9A03

#Define meta configuration
[DscLocalConfigurationManager()]
Configuration CertificateConfig
{
Settings
{
    CertificateID = $requiredCertificate.Thumbprint
}
}
#Compile meta configuration
CertificateConfig -OutputPath C:\LCMConfig -verbose
#Enact LCM Configuration
Set-DscLocalConfigurationManager -Path C:\LCMConfig -Verbose

#check the configuration
#==============================



#Now back to Configuration
$certconfigurationData = @{
                        AllNodes =
                            @(
                                @{
                                    NodeName = $Client
                                    CertificateFile = 'C:\publicKey\DESKTOP-MKOHOM6.cer'
                                    Thumbprint = '1B69216846C166B47C5D3A01084BEF3C335719CC'
                                }
                              )
                       }

configuration clientconfigwithcredentialencrypt
{
            Param
        (
        [Parameter(Mandatory)]
        [pscredential] $Credential
        )



    Import-DscResource -Modulename PSDesiredStateConfiguration -ModuleVersion 1.1

    node $Client
    {
             
        
        
        File FileCopyDemo
            {
            SourcePath = '\\DSC-SRV\share\cert.pfx'
            DestinationPath = 'C:\Temp\cert.pfx'
            Type = 'File'
            Force = $true
            Credential = $Credential
            }
    
    }


}

clientconfigwithcredentialencrypt -OutputPath C:\temp\ -Credential $sharecred -ConfigurationData $certconfigurationData

Start-DscConfiguration -Path C:\temp  -wait -CimSession $Cismsession -Force -Debug


#Separating Configuration Data from Environment Data

Configuration WebDBDemo
{
        Import-DscResource -ModuleName PsDscResources -Name Archive
        Import-DscResource -ModuleName PSDesiredStateConfiguration -Name WindowsFeature
        
        Node @('WebServer01', 'WebServer02', 'WebServer03', 'WebServer04')
            {
                WindowsFeature WebServer
                    {
                    Name = 'Web-Server'
                    IncludeAllSubFeature = $true
                    Ensure = 'Present'
                    }
                Archive SetupScripts
                    {
                    Path = '\\S16-JB\Share\Websetup.zip'
                    Destination = 'C:\Scripts'
                    Force = $true
                    }
            }
        
        Node @('DBServer01','DBServer02')
        {
            WindowsFeature NET35
                {
                Name = 'NET-Framework-Core'
                Source = '\\S16-JB\Share\S16OS\Sources\Sxs'
                Ensure = 'Present'
                }
            Archive SetupScripts
                {
                Path = '\\S16-JB\Share\DBSetupScripts.zip'
                Destination = 'C:\Scripts'
                Force = $true
                }
        }
}

