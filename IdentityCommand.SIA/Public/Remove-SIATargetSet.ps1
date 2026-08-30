# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIATargetSet {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String[]]$name
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/discovery/targetsets/bulk"

        #Request body is a JSON array of the target set names to delete
        $body = '[{0}]' -f (($name | ForEach-Object { $PSItem | ConvertTo-Json }) -join ',')

        if ($PSCmdlet.ShouldProcess($name, 'Delete SIA Target Set')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE -Body $body

            if ($null -ne $result) {

                $result.results

            }

        }

    }#process

    END { }#end

}
