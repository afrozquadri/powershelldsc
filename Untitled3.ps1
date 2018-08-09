Start-job -ScriptBlock {get-service BITS}



Get-Job -id 5| fl *

get-job -id 6 | fl *