# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIAStrongAccount {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('id')]
        [String]$secret_id
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/secrets/$secret_id"

        if ($PSCmdlet.ShouldProcess($secret_id, 'Delete SIA Strong Account')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE

            if ($null -ne $result) {

                $result

            }
        }

    }#process

    end { }#end

}
