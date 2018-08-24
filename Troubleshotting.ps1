# Check winrm dependancies

#Q: Let me know how can we test the same



$secpasswd = ConvertTo-SecureString "123#ntms123#" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("dscclientadmin", $secpasswd)

$client="DSCClient"
$cimSessionOption = New-CimSessionOption -UseSsl -SkipCACheck -SkipCNCheck
$cimSession = New-CimSession -SessionOption $cimSessionOption -ComputerName $client -Port 5986  -Credential $Cred -Verbose

# Try Get-DscConfigurationStatus
$status = Get-DscConfigurationStatus -CimSession $cimSession

$status | fl *


$status.Error


Get-DscConfigurationStatus -CimSession $cimSession -All



#check event logs 
Get-WinEvent -LogName "Microsoft-Windows-Dsc/Operational"

$dscoperationalevents=Invoke-Command -ComputerName dscclient -Credential $Cred -Port 5986 -UseSSL -ScriptBlock {Get-WinEvent -LogName "Microsoft-Windows-Dsc/Operational"}

$dscoperationalevents.message


#run below command in clinet machine to enable few more logging

$DscEvents=Invoke-Command -ComputerName dscclient -Credential $Cred -Port 5986 -UseSSL -ScriptBlock {trace-xdscoperation }

wevtutil.exe set-log "Microsoft-Windows-Dsc/Analytic" /q:true /e:true
wevtutil.exe set-log "Microsoft-Windows-Dsc/Debug" /q:true /e:true




$DscEvents=[System.Array](Get-WinEvent "Microsoft-Windows-Dsc/Operational")+ [System.Array](Get-WinEvent "Microsoft-Windows-Dsc/Analytic" -Oldest) + [System.Array](Get-WinEvent "Microsoft-Windows-Dsc/Debug" -Oldest)


$SeparateDscOperations = $DscEvents | Group {$_.Properties[0].value}

$SeparateDscOperations | Where-Object {$_.Group.LevelDisplayName -contains "Error"}

$DateLatest = (Get-Date).AddMinutes(-30)
$SeparateDscOperations | Where-Object {$_.Group.TimeCreated -gt $DateLatest}

# You can use xdscdiagnostics module available online

get-xdscoperation

get-xdscoperation -newest 2

trace-xdscoperation 