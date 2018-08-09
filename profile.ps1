
1 $pshome\profile.ps1—This will execute for all users of the computer, no matter
which host they’re using (remember that $pshome is predefined within Power-
Shell and contains the path of the PowerShell installation folder).
2 $pshome\Microsoft.PowerShell_profile.ps1—This will execute for all users of
the computer if they’re using the console host. If they’re using the PowerShell
ISE, the $pshome/Microsoft.PowerShellISE_profile.ps1 script will be executed
instead.
3 $home\Documents\WindowsPowerShell\profile.ps1—This will execute only for
the current user (because it lives under the user’s home directory), no matter
which host they’re using.
 $home\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1—
This will execute for the current user if they’re using the console host. If they’re
using the PowerShell ISE, the $home\Documents\WindowsPowerShell\Microsoft
.PowerShellISE_profile.ps1 script will be executed instead.


function prompt {
$time = (Get-Date).ToShortTimeString()
#"$time [$env:COMPUTERNAME]:> "
"test:>"
}

function test-hello
{
    Write-Host "Hello"
    }