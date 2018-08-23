$Client = "dscclient"

$secpasswd = ConvertTo-SecureString "123#ntms123#" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("dscclientadmin", $secpasswd)
 
Invoke-Command -ComputerName $Client -Credential $Cred -UseSSL -ScriptBlock {Get-Service}

