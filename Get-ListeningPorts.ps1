# Enumerate Local Listening Ports
param (
    $Ports = @(22,25,443,465,587,636,993,995,3389)
)

$ListeningPorts = Get-NetTCPConnection -LocalAddress 0.0.0.0 -State Listen
#$ListeningPorts
$InterestingListeningPorts = @()
foreach ($Port in $ListeningPorts) {
    if ($Ports -contains $Port.LocalPort) {
        Write-Output $Port
    }
}