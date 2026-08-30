# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIAHttpsRelay {
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

        $URI = "$($ISPSSSession.tenant_url)/api/https-relay/$https_relay_id"

        if ($PSCmdlet.ShouldProcess($https_relay_id, 'Delete SIA HTTPS Relay')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END { }#end

}
