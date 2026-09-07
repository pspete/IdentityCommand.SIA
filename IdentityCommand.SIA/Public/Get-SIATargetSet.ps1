# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIATargetSet {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$name,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$strongAccountId
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/targetsets"

        $URI = Add-QueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter)

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            Get-PagedResult -InitialResult $result -URI $URI -Style Cursor -ResultProperty 'target_sets' -CursorRequestKey 'b64StartKey' -CursorResponseKey 'b64_last_evaluated_key'

        }

    }#process

    end { }#end

}
