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

    begin {
        $Request = @{
            'Method' = 'DELETE'
        }
    }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/targetsets"

        if ($name.count -eq 1) {
            $URI = "$URI/$name"
        } elseif ($name.count -gt 1) {
            $URI = "$URI/bulk"
            $boundParameters = $PSBoundParameters | Get-Parameter
            $body = ConvertTo-SIAJsonBody -Body $boundParameters['name']
            $Request.Add('Body', $body)
        }

        $Request.Add('Uri', $URI)

        if ($PSCmdlet.ShouldProcess($name, 'Delete SIA Target Set')) {
            #Send Request
            $result = Invoke-IDRestMethod @Request

            if ($null -ne $result) {
                $result.results
            }
        }

    }#process

    end { }#end

}
