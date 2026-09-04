# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAStrongAccount {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ProvisionerUser', 'PCloudAccount', 'IdentityUser', 'IdentityMgmtUser', 'TargetCertificate', 'General')]
        [String[]]$secret_type,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [int]$count
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/secrets"

        $QueryString = $($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)

        If ($null -ne $QueryString) {
            $URI = "$URI`?$QueryString"
        }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            #/api/secrets returns a bare array with no total count in-band, and its own
            #'count' query parameter is not enforced server-side - so the total has to come
            #from a dedicated endpoint, and pagination here is defensive: it only loops
            #further if fewer records came back than that reported total.
            $CountURI = "$($ISPSSSession.tenant_url)/api/secrets/count"

            $CountQueryString = $($PSBoundParameters | Get-Parameter -ParametersToKeep secret_type | ConvertTo-QueryString)

            If ($null -ne $CountQueryString) {
                $CountURI = "$CountURI`?$CountQueryString"
            }

            $CountResult = Invoke-IDRestMethod -Uri $CountURI -Method GET

            Get-SIAPagedResult -InitialResult $result -URI $URI -Style Offset -OffsetRequestKey 'offset' -TotalCount $CountResult.count

        }

    }#process

    END { }#end

}
