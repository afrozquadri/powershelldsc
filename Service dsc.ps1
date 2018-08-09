configuration test
{
    Import-DscResource -ModuleName PsDscResources

    node localhost
    {
    
    

     service hardenservice
     {
        name="BITS"
        State = "Stopped"
        Ensure = "Present"
     
     }
     
    }

}

Find-DscResource -Name file -ModuleName PsdscResources 