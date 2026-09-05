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

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/ssh/sso/key"

        if ($PSBoundParameters.ContainsKey('format')) {
            $URI = "$URI`?format=$format"
        }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            #The key is returned as application/x-pem-file. Get-IDResponse passes non-JSON content
            #straight through as the raw byte[] Content, which the pipeline unrolls to a sequence of
            #bytes - reassemble it to the PEM text.
            if (($result -is [byte[]]) -or (($result -is [array]) -and ($result[0] -is [byte]))) {
                [System.Text.Encoding]::UTF8.GetString([byte[]]$result)
            } else {
                $result
            }

        }

    }#process

    end { }#end

}
