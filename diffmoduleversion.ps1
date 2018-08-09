
$Client="DESKTOP-MKOHOM6"

if($cred -eq $null)
{
$cred = Get-Credential
}


configuration clientconfig
{

    Import-DscResource -Name xHostsFile -ModuleName xNetworking -ModuleVersion 4.0.0.0
    Import-DscResource -Name xPowerShellExecutionPolicy
    node $Client
    {
             xPowerShellExecutionPolicy MyExecutionPolicy

        {

            ExecutionPolicy = "RemoteSigned"

        }
      
            xHostsFile HostsFileConfiguration
                {
                IPAddress = '10.0.0.1'
                   HostName = 'TestHost10'
                   DependsOn = "[xPowerShellExecutionPolicy]MyExecutionPolicy"
                }
     
    
    }


}

clientconfig -OutputPath C:\temp\ 


$Cimsessionopt=New-CimSessionOption -UseSsl

$Cismsession= New-CimSession -SessionOption $Cimsessionopt -ComputerName $Client -Credential $Cred -port 5986 -Verbose

Start-DscConfiguration -Path C:\temp  -wait -Verbose  -CimSession $Cismsession -Force

Start-DscConfiguration -Path C:\temp -Credential $cred -wait -verbose

Find-Module -name cWindowsOS | select -ExpandProperty Additionalmetadata 