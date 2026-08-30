# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAHttpsRelay {
    [CmdletBinding()]
    param(

    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/https-relays"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result.items

        }

    }#process

    END { }#end

}
