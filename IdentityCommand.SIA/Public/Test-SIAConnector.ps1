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

        #Create Request Body. Each target is an object: @{ hostname = '<host>'; port = <int> } (port defaults to 22).
        #ConvertTo-SIAJsonBody keeps a single supplied target a one-element JSON array.
        $requestBody = @{ checkBackendEndpoints = [bool]$checkBackendEndpoints }

        if (($PSBoundParameters.ContainsKey('targets')) -and (@($targets).Count -gt 0)) {

            $requestBody['targets'] = @($targets)

        }

        $body = ConvertTo-SIAJsonBody -Body $requestBody -Depth 3

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

        if ($null -ne $result) {

            $result

        }

    }#process

    END { }#end

}
