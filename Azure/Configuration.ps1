get-module -ListAvailable AzureRm

Connect-AzureRmAccount

Import-AzureRmAutomationDscConfiguration -AutomationAccountName "dscautomation" -SourcePath "C:\Users\g559871\powershelldsc\Azure\service.ps1" -ResourceGroupName powershelldsc1  -Published


Start-AzureRmAutomationDscCompilationJob -ConfigurationName 'service' -ResourceGroupName powershelldsc1 -AutomationAccountName dscautomation


Register-AzureRmAutomationDscNode -ResourceGroupName powershelldsc1 -AutomationAccountName dscautomation -AzureVMName dscclient -ConfigurationMode ApplyAndAutocorrect

# Run a DSC check every 15 minutes ideally it should be minimum 60 
Register-AzureRmAutomationDscNode -ResourceGroupName powershelldsc1 -AutomationAccountName dscautomation -AzureVMName dscclient -ConfigurationModeFrequencyMins 15


# Get the ID of the DSC node
$node = Get-AzureRmAutomationDscNode -ResourceGroupName powershelldsc1 -AutomationAccountName dscautomation -Name dscclient

# Assign the node configuration to the DSC node
Get-AzureRmAutomationDscNodeConfiguration -ResourceGroupName powershelldsc1 -AutomationAccountName dscautomation | select name
Set-AzureRmAutomationDscNode -ResourceGroupName powershelldsc1 -AutomationAccountName dscautomation -NodeConfigurationName service.localhost -Id $node.Id


#By default, the DSC node is checked for compliance with the node configuration every 30 minutes.

# Get an array of status reports for the DSC node
$reports = Get-AzureRmAutomationDscNodeReport -ResourceGroupName powershelldsc1 -AutomationAccountName dscautomation -NodeId $node.Id

# Display the most recent report
$reports[0]

