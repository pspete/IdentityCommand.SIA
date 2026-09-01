# .ExternalHelp IdentityCommand.SIA-help.xml
function Add-SIASSHHostKeyFingerprint {
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

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/ssh-fingerprints"

        #Create Request Body
        $body = $PSBoundParameters | Get-Parameter | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess($target_id, 'Add SIA SSH Host Key Fingerprint')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END { }#end

}
