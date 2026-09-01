# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIAStrongAccount {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$secret_id
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/secrets/$secret_id"

        if ($PSCmdlet.ShouldProcess($secret_id, 'Delete SIA Strong Account')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE

            if ($null -ne $result) {

                $result

            }
        }

    }#process

    END { }#end

}
