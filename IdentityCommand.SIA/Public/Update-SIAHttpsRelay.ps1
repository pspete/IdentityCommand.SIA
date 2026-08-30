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

        $URI = "$($ISPSSSession.tenant_url)/api/https-relay/$https_relay_id/upgrade"

        if ($PSCmdlet.ShouldProcess($https_relay_id, 'Upgrade SIA HTTPS Relay')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END { }#end

}
