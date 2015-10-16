# Source all ps1 scripts in current directory.
Get-ChildItem (Join-Path $PSScriptRoot *.ps1) | foreach {. $_.FullName}

# Making Parent Functions Available
Export-ModuleMember -Function Get-CertificateFile
Export-ModuleMember -Function Get-CertificateHealth
Export-ModuleMember -Function Get-UnhealthyCertificate
Export-ModuleMember -Function Get-UnhealthyCertificateNagios