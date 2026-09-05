# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAHttpsRelay {
    [CmdletBinding()]
    param(

    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/https-relays"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result.items

        }

    }#process

    end { }#end

}
