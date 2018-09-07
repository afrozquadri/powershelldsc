<#
Components

DSC Nodes
DSC Configurations
DSC Config Gallery
DSC Node conigurations
#>

#Create Configuration and save it as a configuration name .ps1 file

#Let's take example azuredscdinesh.ps1

psedit azuredscdinesh.ps1

<#

    Pro's and cons

    Pricing
    Reporting
    Credential Storage
#>


#Let's create a configuration and add it in azure.

$AdminCreds = Get-AutomationPSCredential -Name $AdminName






#Command is Import-AzureRmAutomationDscConfiguration
