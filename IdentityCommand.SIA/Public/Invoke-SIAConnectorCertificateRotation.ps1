# .ExternalHelp IdentityCommand.SIA-help.xml
function Invoke-SIAConnectorCertificateRotation {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('id')]
        [String]$connector_id
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/$connector_id/rotate"

        #The API requires an (empty) JSON body
        $body = '{}'

        if ($PSCmdlet.ShouldProcess($connector_id, 'Rotate SIA Connector Certificate')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END { }#end

}
