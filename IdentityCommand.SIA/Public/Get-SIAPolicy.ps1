# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAPolicy {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ById'
        )]
        [String]$policyid,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [int]$limit,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [String]$sort
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/access-policies/$policyid"

        if (-not $PSBoundParameters.ContainsKey('policyid')) {

            $QueryString = $($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)

            If ($null -ne $QueryString) {
                $URI = "$URI`?$QueryString"
            }

        }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            if ($PSBoundParameters.ContainsKey('policyid')) { $result }
            else { Get-SIAPagedResult -InitialResult $result -URI $URI -Style Offset -ResultProperty 'items' }

        }

    }#process

    end { }#end

}
