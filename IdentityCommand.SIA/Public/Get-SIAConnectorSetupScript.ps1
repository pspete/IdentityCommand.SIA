# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAConnectorSetupScript {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AWS', 'AZURE', 'ON-PREMISE', 'GCP')]
        [String]$connector_type,

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
        [String]$connector_pool_id
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/setup-script"

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