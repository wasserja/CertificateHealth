# CertificateHealth PowerShell Module #

The **CertificateHealth** PowerShell module gathers the certificates from the filesystem or certificate store(s) and displays their health for pending expiration, key length, and deprecated signature algorithms. 

~~~~
PS C:\> Get-Command -Module CertificateHealth

CommandType Name                           Version Source
----------- ----                           ------- ------
Function    Get-CertificateFile            1.5     CertificateHealth
Function    Get-CertificateHealth          1.5     CertificateHealth
Function    Get-ListeningPort              1.5     CertificateHealth
Function    Get-NetCertificate             1.5     CertificateHealth
Function    Get-NetCertificateHealth       1.5     CertificateHealth
Function    Get-UnhealthyCertificate       1.5     CertificateHealth
Function    Get-UnhealthyCertificateNagios 1.5     CertificateHealth
Function    Save-NetCertificate            1.5     CertificateHealth
Function    Test-LocalNetPortCertificate   1.5     CertificateHealth
~~~~
