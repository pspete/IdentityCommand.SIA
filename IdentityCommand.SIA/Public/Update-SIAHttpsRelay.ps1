# .ExternalHelp IdentityCommand.SIA-help.xml
function Update-SIAHttpsRelay {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$https_relay_id
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/https-relays/$https_relay_id/upgrade"

        #The API requires an (empty) JSON body
        $body = '{}'

        if ($PSCmdlet.ShouldProcess($https_relay_id, 'Upgrade SIA HTTPS Relay')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END { }#end

}
