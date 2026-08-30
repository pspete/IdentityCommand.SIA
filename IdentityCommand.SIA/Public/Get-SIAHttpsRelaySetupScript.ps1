# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAHttpsRelaySetupScript {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('windows', 'darwin', 'linux')]
        [String]$https_relay_os,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateRange(15, 240)]
        [int]$expiration_minutes,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [hashtable]$protocol_port_map,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$proxy_host,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [int]$proxy_port,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$windows_installation_path
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/https-relays/setup-script"

        #Create Request Body
        $body = $PSBoundParameters | Get-Parameter | ConvertTo-Json

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

        if ($null -ne $result) {

            $result

        }

    }#process

    END { }#end

}
