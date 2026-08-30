# .ExternalHelp IdentityCommand.SIA-help.xml
function Invoke-SIAConnectorCertificateRotation {
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

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/$connector_id/rotate"

        if ($PSCmdlet.ShouldProcess($connector_id, 'Rotate SIA Connector Certificate')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END { }#end

}
