# Test local ports
function Test-LocalNetPortCertificate {
    $Ports = Get-ListeningPort
    foreach ($Port in $Ports) {
        if ($Port.LocalAddress -eq '0.0.0.0') {
            Get-NetCertificateHealth -ComputerName 127.0.0.1 -Port $Port.LocalPort
        }
        else {
            Get-NetCertificateHealth -ComputerName $Port.LocalAddress -Port $Port.LocalPort
        }
    }
}