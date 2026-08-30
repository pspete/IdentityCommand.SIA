# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIAPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$policyid
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/access-policies/$policyid"

        if ($PSCmdlet.ShouldProcess($policyid, 'Delete SIA Policy')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE

            if ($null -ne $result) {

                $result

            }
        }
    }#process

    END {

    }#end

}