# .ExternalHelp IdentityCommand.SIA-help.xml
function Remove-SIATargetSet {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String[]]$name
    )

    BEGIN {
        $Request = @{
            'Method' = 'DELETE'
        }
    }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/targetsets"

        if ($name.Count -eq 1) {

            #Single target set - delete by name
            $URI = "$URI/$name"

        } elseif ($name.Count -gt 1) {

            #Multiple target sets - bulk delete with a JSON array of names in the body
            $URI = "$URI/bulk"
            $Request['Body'] = '[{0}]' -f (($name | ForEach-Object { $PSItem | ConvertTo-Json }) -join ',')

        }

        $Request['Uri'] = $URI

        if ($PSCmdlet.ShouldProcess($name, 'Delete SIA Target Set')) {

            #Send Request
            $result = Invoke-IDRestMethod @Request

            if ($null -ne $result) {

                $result.results

            }

        }

    }#process

    END { }#end

}
