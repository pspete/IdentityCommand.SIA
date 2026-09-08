# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIAVirtualMachine {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('machineId')]
        [String]$machine_id
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/infrastructure/virtual-machines/$machine_id"

        if ($PSCmdlet.ShouldProcess($machine_id, 'Delete SIA VM Infrastructure Target')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
