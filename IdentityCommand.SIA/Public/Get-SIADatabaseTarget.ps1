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
        [int]$limit
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/database-targets"

        $URI = Add-QueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter)

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            Get-PagedResult -InitialResult $result -URI $URI -Style Cursor -ResultProperty 'items'

        }

    }#process

    end { }#end

}
