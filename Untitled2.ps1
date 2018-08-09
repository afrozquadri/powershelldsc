

for ($i=1;$i -le 10 ; $i++)
{
    $state=Invoke-WebRequest -Uri "http://P$i.boxtopsapi.genmills.com/V1/UserManagement.svc"

    if($state.StatusCode -eq "200")
    {
        Write-Host "$i is good"
        
    }
    else
    {
        Write-Error "$i is not good"
    }


}