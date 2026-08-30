# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAMFAKey {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('openssh', 'ppk')]
        [String]$format
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/ssh/sso/key"

        if ($PSBoundParameters.ContainsKey('format')) {
            $URI = "$URI`?format=$format"
        }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result

        }

    }#process

    END { }#end

}
