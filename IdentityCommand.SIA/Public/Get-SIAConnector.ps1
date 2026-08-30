# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAConnector {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$connector_id
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/$connector_id"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            If ($PSBoundParameters.ContainsKey('connector_id')) {
                $result
            } Else {
                $result.items
            }
        }

    }#process

    END {

    }#end

}