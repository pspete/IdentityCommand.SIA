# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAConnectorSetupScript {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('windows', 'darwin', 'linux')]
        [String]$connector_os,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$connector_pool_id,

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

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/setup-script"

        #Create Request Body
        $Body = $PSBoundParameters | Get-Parameter | ConvertTo-Json

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $Body

        if ($null -ne $result) {

            $result

        }

    }#process

    END {

    }#end

}
