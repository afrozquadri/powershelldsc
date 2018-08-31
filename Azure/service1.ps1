configuration service1
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


