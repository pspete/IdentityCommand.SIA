# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAVirtualMachine {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$filter,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('CLOUD', 'MANUAL', 'USERDRIVEN')]
        [String]$source,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$sort,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$search
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/infrastructure/virtual-machines"

        $URI = Add-QueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter)

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            #The pagination token is reported as cloud_N|onprem_M, and comes back as cloud_0|onprem_0
            #rather than empty once the set is exhausted - so paging ends on the first page returning
            #no items, not on an empty token.
            Get-PagedResult -InitialResult $result -URI $URI -Style Cursor -ResultProperty 'items' -CursorRequestKey 'next_token' -CursorResponseKey 'nextToken'

        }

    }#process

    end { }#end

}
