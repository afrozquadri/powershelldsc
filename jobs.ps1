Synchronous vs. asynchronous


Creating a local job

start-job -scriptblock { dir }


start-job -scriptblock { get-eventlog security -computer server-r2 }

WMI, as a job
get-wmiobject win32_operatingsystem -computername (get-content allservers.txt) –asjob

Remote Job

invoke-command -command { get-process } -computername (get-content .\allservers.txt ) -asjob -jobname MyRemoteJob

get-job

get-job -id 38 | format-list *

receive-job -id 36


start-job -scriptblock { dir c:\ }


 Remove-Job—This deletes a job, and any output still cached with it, from memory.
 Stop-Job—If a job seems to be stuck, this command terminates it. You can still
receive whatever results were generated to that point.
 Wait-Job—This is useful if a script is going to start a job and you want the script
to continue only when the job is done. This command forces the shell to stop
and wait until the job is completed, and then allows the shell to continue.

Wait-Job -Job

