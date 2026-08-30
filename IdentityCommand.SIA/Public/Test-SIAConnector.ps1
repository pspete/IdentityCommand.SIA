# .ExternalHelp IdentityCommand.SIA-help.xml
function Test-SIAConnector {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$connector_id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String[]]$targets,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [bool]$checkBackendEndpoints
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/$connector_id/reachability"

        #Create Request Body
        $requestBody = @{
            'targets'               = @($targets)
            'checkBackendEndpoints' = [bool]$checkBackendEndpoints
        }

        $body = $requestBody | ConvertTo-Json

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

        if ($null -ne $result) {

            $result

        }

    }#process

    END { }#end

}
