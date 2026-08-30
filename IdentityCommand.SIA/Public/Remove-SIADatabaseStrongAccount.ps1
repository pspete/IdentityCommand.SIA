# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIADatabaseStrongAccount {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('id')]
        [String]$strong_account_id
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/database-strong-accounts/$strong_account_id"

        if ($PSCmdlet.ShouldProcess($strong_account_id, 'Delete SIA Database Strong Account')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE

            if ($null -ne $result) {

                $result

            }
        }

    }#process

    END { }#end

}
