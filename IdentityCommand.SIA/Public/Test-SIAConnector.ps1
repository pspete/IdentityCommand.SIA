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

        #Create Request Body - build explicitly so an empty/single target list serialises as a JSON array.
        #Each target is an object: @{ hostname = '<host>'; port = <int> } (port defaults to 22).
        $bodyParts = @('"checkBackendEndpoints": {0}' -f ([bool]$checkBackendEndpoints).ToString().ToLower())

        if (($PSBoundParameters.ContainsKey('targets')) -and (@($targets).Count -gt 0)) {

            $targetItems = @($targets | ForEach-Object { $PSItem | ConvertTo-Json -Compress -Depth 3 })
            $bodyParts += '"targets": [{0}]' -f ($targetItems -join ', ')

        }

        $body = '{{ {0} }}' -f ($bodyParts -join ', ')

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

        if ($null -ne $result) {

            $result

        }

    }#process

    END { }#end

}
