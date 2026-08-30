# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIADatabaseTarget {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateRange(1, 1000)]
        [int]$limit,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$cursor
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/database-targets"

        $QueryString = $($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)

        If ($null -ne $QueryString) {
            $URI = "$URI`?$QueryString"
        }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            if ($null -ne $result.nextCursor) {
                ##TODO Result Pagination
            }

            $result.items

        }

    }#process

    END { }#end

}
