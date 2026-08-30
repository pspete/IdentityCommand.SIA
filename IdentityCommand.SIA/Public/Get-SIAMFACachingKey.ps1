# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAMFACachingKey {
    [CmdletBinding()]
    param(

    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/ssh/sso/key"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result

        }

    }#process

    END { }#end

}
