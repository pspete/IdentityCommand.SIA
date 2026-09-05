# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIACertificate {
    [CmdletBinding()]
    param(

    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/certificates"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result.certificates.items

        }

    }#process

    end {

    }#end

}