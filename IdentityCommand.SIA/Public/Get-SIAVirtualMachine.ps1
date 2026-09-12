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

        #TODO the published SIA VM Infrastructure API spec documents -limit (1-1000, default 100) and
        #-offset (0-1999, default 0) on GET /api/infrastructure/virtual-machines alongside filter,
        #source, next_token, sort and search - neither is exposed here, so page size and the
        #single-source offset start point can't be controlled, only the cursor. Confirm against a
        #tenant before adding them.
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
