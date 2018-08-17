
Find-Module xsmbshare | Install-Module
Find-Module xnetworking | Install-Module
Find-Module cNtfsAccessControl | Install-Module

$configData = @{
    AllNodes=@(
    @{
        NodeName="Powershell-dsc"
        CertificateFile = "$cert.path"
        Thumbprint = "$Cert.thumbprint"
        Path = "C:\DscSmbShare"
        ShareName = "DSCConfig"
        SourcePath = "C:\DSCResourceZip"
        ReadAccess = "Everyone"
        FullAccess = "Administrators"  
     }
    );
}


Configuration SmbShare
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xSmbShare
    Import-DscResource -ModuleName cNtfsAccessControl 

    Node $AllNodes.NodeName
    {

        File CreateFolder
        {
            DestinationPath = $Node.Path
            Type = 'Directory'
            Ensure = 'Present'
        }

        xSMBShare CreateShare
        {
            Name = 'DscSmbShare'
            Path = $Node.Path
            FullAccess = $Node.FullAccess
            ReadAccess = $Node.ReadAccess
            Ensure = 'Present'
            DependsOn = '[File]CreateFolder'
        }

        cNtfsPermissionEntry PermissionSet1
        {
            Ensure = 'Present'
            Path = $Node.Path
            Principal = $Node.ReadAccess
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'ReadAndExecute'
                    Inheritance = 'ThisFolderSubfoldersAndFiles'
                    NoPropagateInherit = $false
                }
            )
            DependsOn = '[File]CreateFolder'
        }


    }
}

mkdir C:\smbpullserverconfig

SmbShare -OutputPath C:\smbpullserverconfig -ConfigurationData $configData

Start-DscConfiguration -Path C:\smbpullserverconfig -Wait -Verbose