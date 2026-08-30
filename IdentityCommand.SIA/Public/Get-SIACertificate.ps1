# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIACertificate {
    [CmdletBinding()]
    param(

    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/certificates"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result.certificates.items

        }

    }#process

    END {

    }#end

}