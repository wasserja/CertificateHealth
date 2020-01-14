# Enumerate Local Listening Ports
function Get-ListeningPort {
    param (
        $Ports = @(22,25,443,465,587,636,993,995,3389)
    )
    
    $IPv4Regex = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
    $ListeningPorts = Get-NetTCPConnection -State Listen | Where-Object -FilterScript {$_.LocalAddress -match $IPv4Regex}
    foreach ($Port in $ListeningPorts) {
        if ($Ports -contains $Port.LocalPort) {
            Write-Output $Port
        }
    }
}
