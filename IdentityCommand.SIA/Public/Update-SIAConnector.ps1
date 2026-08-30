# .ExternalHelp IdentityCommand.SIA-help.xml
function Update-SIAConnector {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$connector_id
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/$connector_id/upgrade"

        if ($PSCmdlet.ShouldProcess($connector_id, 'Upgrade SIA Connector')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END { }#end

}
