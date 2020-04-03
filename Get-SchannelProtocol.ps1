<#
.Synopsis
Get the SSL and TLS protocol Schannel settings from the registry.
.DESCRIPTION
Get the SSL and TLS protocol Schannel settings from the registry including
client and server components.
.PARAMETER Protocol
Specify the protocol you want to query.
.PARAMETER CommunicationMode
Specify the communication mode: server/client.
.EXAMPLE
Get-SchannelProtocol
.EXAMPLE
Get-NetCertificate -Protocol TLS1.2 -CommunicationMode Server
.NOTES
Created by: Jason Wasser
Modified: 4/3/2020 01:20:20 PM 
#>
function Get-SchannelProtocol {
    [cmdletbinding()]
    param (
        [ValidateSet('SSL2', 'SSL3', 'TLS1.0', 'TLS1.1', 'TLS1.2','TLS1.3')]
        [string[]]$Protocol = ('SSL2', 'SSL3', 'TLS1.0', 'TLS1.1', 'TLS1.2','TLS1.3'),
        [ValidateSet('Client', 'Server')]
        [string[]]$CommunicationMode = ('Client', 'Server')
    )
    begin {
        $SCHANNELProtocolsRegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols'
        function Get-ProtocolStatus {
            param (
                [ValidateSet('Client', 'Server')]
                [string]$Mode,
                [ValidateSet('Enabled', 'DisabledByDefault')]
                [string]$StatusCheck
            )

            try {
                Write-Verbose "Checking Protocol $Proto $Mode at $SCHANNELProtocolsRegistryPath\$ProtocolName\$Mode"
                $ProtocolStatusRegValue = Get-ItemProperty -Path "$SCHANNELProtocolsRegistryPath\$ProtocolName\$Mode" -ErrorAction Stop
        
                if ($ProtocolStatusRegValue.$StatusCheck -eq 1) {
                    Write-Verbose "Protocol Status Registry Value for $StatusCheck is $($ProtocolStatusRegValue.$StatusCheck)"
                    $ProtocolStatus = $true
                }
                elseif ($ProtocolStatusRegValue.$StatusCheck -eq 0) {
                    Write-Verbose "Protocol Status Registry Value for $StatusCheck is $($ProtocolStatusRegValue.$StatusCheck)"
                    $ProtocolStatus = $false
                }
                else {
                    Write-Verbose "Protocol Status Registry Value for $StatusCheck is not present."
                    $ProtocolStatus = 'Not Set'
                }
        
            }
            catch [System.Exception] {
                switch ($_.Exception.GetType().FullName) {
                    'System.Management.Automation.ItemNotFoundException' {
                        Write-Verbose "Unable to find protocol status value at $SCHANNELProtocolsRegistryPath\$ProtocolName\$Mode"
                        $ProtocolStatus = 'Not Set'
                    }
                    default {
                        Write-Verbose "Unknown error"
                        $ProtocolStatus = 'Unknown'
                    }    
                }
            }
            Write-Output $ProtocolStatus
        }
    }
    process {
        foreach ($Proto in $Protocol) {
            foreach ($Mode in $CommunicationMode) {
                Write-Verbose "Checking Protocol and Mode : $Proto $Mode"
                switch ($Proto) {
                    'SSL2' {
                        $ProtocolName = 'SSL 2.0'
                    }
                    'SSL3' {
                        $ProtocolName = 'SSL 3.0'
                    }
                    'TLS1.0' {
                        $ProtocolName = 'TLS 1.0'
                    }
                    'TLS1.1' {
                        $ProtocolName = 'TLS 1.1'
                    }
                    'TLS1.2' {
                        $ProtocolName = 'TLS 1.2'
                    }
                }

                $DisabledByDefault = Get-ProtocolStatus -Mode $Mode -StatusCheck DisabledByDefault
                $Enabled = Get-ProtocolStatus -Mode $Mode -StatusCheck Enabled

                $SchannelProtocolProperties = @{
                    Protocol          = $Proto
                    CommunicationMode = $Mode
                    DisabledByDefault = $DisabledByDefault
                    Enabled           = $Enabled
                }
                $SchannelProtocol = New-Object -TypeName PSCustomObject -Property $SchannelProtocolProperties
                if ($PSVersionTable.PSVersion.Major -lt 3) {
                    $SchannelProtocol | Select-Object -Property Protocol, CommunicationMode, Enabled, DisabledByDefault
                }
                else {
                    $SchannelProtocol
                }
            }
        }
    }
    end { }
}