Configuration DSCRunDemo
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
        {
            Script DSCRunDemo
                {
                    SetScript =
                        {
                        Write-Verbose -Message $(whoami)
                        }
                    TestScript =
                        {
                        return $false
                        }
                    GetScript =
                        {
                        return @{}
                        }
            }
        }
}

DSCRunDemo -OutputPath C:\Demo\DSCConfig

Start-DscConfiguration -Path C:\Demo\DSCConfig -Wait -Verbose
