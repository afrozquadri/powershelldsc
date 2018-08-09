#Configuration Data

Special Hastable with additional Config instructions 
Includes an AllNodes hashtable

Configuration data can be stored as a .psd1 file
can include non-code data


Demo Data

@{
    #Node specific data
    AllNodes = @( 
       @{NodeName = "*";Features = @("Telnet-Client","Windows-Server-Backup")},
       @{NodeName = "CHI-FP02"; Role = "FilePrint"},
       @{NodeName = "CHI-CORE01" ; Role = "Test"}
    )
    ;
    #non-node Specific data. No code allowed
    NonNodeData = @{Services = "bits","remoteregistry","wuauserv"}
}

Encryot the credentials

Certificates

Securing pull servers with SSL
encryption Credentials


Use Computer Template for authentication

CERT:\LocalMachine\My

Export as .cer file
    Export-Certificate

LCM configured to use certificate thumbprint

CertificateID




