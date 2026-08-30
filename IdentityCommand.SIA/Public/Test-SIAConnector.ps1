# .ExternalHelp IdentityCommand.SIA-help.xml
function Test-SIAConnector {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
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
        [hashtable[]]$targets,

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
        #Each target is an object: @{ hostname = '<host>'; port = <int> } (port defaults to 22)
        $requestBody = @{
            'targets'               = @($targets)
            'checkBackendEndpoints' = [bool]$checkBackendEndpoints
        }

        $body = $requestBody | ConvertTo-Json -Depth 4

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

        if ($null -ne $result) {

            $result

        }

    }#process

    END { }#end

}
