# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIASSHHostKeyFingerprint {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$target_id
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/ssh-fingerprints/$target_id"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result

        }

    }#process

    END { }#end

}
