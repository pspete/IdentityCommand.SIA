# .ExternalHelp IdentityCommand.SIA-help.xml
function Set-SIASSHHostKeyFingerprint {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 255)]
        [String]$target_id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 255)]
        [String]$fingerprint
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/ssh-fingerprints"

        #Create Request Body
        $body = $PSBoundParameters | Get-Parameter | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess($target_id, 'Update SIA SSH Host Key Fingerprint')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method PUT -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
