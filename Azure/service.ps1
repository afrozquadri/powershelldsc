configuration service
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration 
    Node localhost
    {
    
        service Bits
        {
            ensure ="Present"
            name = "BITS"
            State ='Stopped'
        
        }
    
    }




}


