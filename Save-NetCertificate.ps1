<#
.Synopsis
Save the TLS certificate from a remote server as a certificate file.
.DESCRIPTION
Obtain the TLS certificate from a remote server by name or IP address and TCP port and save it to disk.
.EXAMPLE
Save-NetCertificate -ComputerName www.google.com -Port 443 -Path C:\Temp\server.crt
.EXAMPLE
Save-NetCertificate -IP 8.8.8.8 -Port 853 -Path C:\Temp\server.crt
.NOTES
Adapted by: Jason Wasser
Original code by: Rob VandenBrink
Inspiration
https://isc.sans.edu/forums/diary/Assessing+Remote+Certificates+with+Powershell/20645/
Modified: 1/9/2020 02:16:05 PM 
#>
function Save-NetCertificate {
    Param (
        [Alias('IP')]
        $ComputerName,
        [int]$Port=443,
        $Path = 'C:\Scratch\certificate.cer'
    )

    $Certificate = Get-NetCertificate -ComputerName $ComputerName -Port $Port
    [byte[]]$CertificateInBytes = $Certificate.Export('Cert')
    Set-Content -Path $Path -Value $CertificateInBytes -Encoding Byte
}