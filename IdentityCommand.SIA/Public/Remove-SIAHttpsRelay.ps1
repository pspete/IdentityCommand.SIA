# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIAHttpsRelay {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$https_relay_id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [switch]$force_delete
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/https-relays/$https_relay_id"

        if ($force_delete.IsPresent) {
            $URI = "$URI`?force_delete=true"
        }

        if ($PSCmdlet.ShouldProcess($https_relay_id, 'Delete SIA HTTPS Relay')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
