# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIASSHHostKeyFingerprint {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 255)]
        [String]$target_id
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/ssh-fingerprints/$target_id"

        if ($PSCmdlet.ShouldProcess($target_id, 'Delete SIA SSH Host Key Fingerprint')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
