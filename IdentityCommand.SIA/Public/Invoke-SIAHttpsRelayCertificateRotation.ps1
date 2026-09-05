# .ExternalHelp IdentityCommand.SIA-help.xml
function Invoke-SIAHttpsRelayCertificateRotation {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$https_relay_id
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/https-relays/$https_relay_id/rotate"

        #The API requires an (empty) JSON body
        $body = '{}'

        if ($PSCmdlet.ShouldProcess($https_relay_id, 'Rotate SIA HTTPS Relay Certificate')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
