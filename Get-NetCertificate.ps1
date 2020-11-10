<#
.Synopsis
Get the TLS certificate from a remote server.
.DESCRIPTION
Obtain the TLS certificate from a remote server by name or IP address and TCP port.
.PARAMETER ComputerName
Specify the DNS name or IP address of the URL you want to query.
.PARAMETER Port
Specify the port of the destination server.
.EXAMPLE
Get-NetCertificate -ComputerName www.google.com -Port 443
.EXAMPLE
Get-NetCertificate -IP 8.8.8.8 -Port 853
.NOTES
Adapted by: Jason Wasser
Original code by: Rob VandenBrink
Inspiration
https://isc.sans.edu/forums/diary/Assessing+Remote+Certificates+with+Powershell/20645/

Modified: 1/9/2020 02:16:05 PM
# Need to verify if this supports server name indication (SNI) for certificates
Modified: 11/10/2020
Reconciled use of $TCPClient and $TcpSocket
Comments added at change locations for integration
#>
function Get-NetCertificate {
    Param (
        [Alias('IP')]
        [string]$ComputerName,
        [int]$Port=443
    )

    #Commenting this out because it isn't actually used
    #$TCPClient = New-Object -TypeName System.Net.Sockets.TCPClient
    try {
        #Adding typename parameter and fully qualifying TcpClient
        $TcpSocket = New-Object -TypeName System.Net.Sockets.TcpClient($ComputerName, $Port)
        $tcpstream = $TcpSocket.GetStream()
        #$sender is flagged by VSCode as an automatic variable and recommends changing it. Changed to caller and functionality seems undeminished
        $Callback = { param($caller, $cert, $chain, $errors) return $true }
        $SSLStream = New-Object -TypeName System.Net.Security.SSLStream -ArgumentList @($tcpstream, $True, $Callback)
        try {
            $SSLStream.AuthenticateAsClient($ComputerName)
            $Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($SSLStream.RemoteCertificate)
        }
        finally {
            $SSLStream.Dispose()
        }
    }
    finally {
        #Changing following from TCPClient to TcpSocket since that is what is actually used
        $TcpSocket.Dispose()
    }
    Write-Output $Certificate
}
