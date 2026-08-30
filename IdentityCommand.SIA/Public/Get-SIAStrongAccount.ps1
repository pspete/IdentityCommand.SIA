# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAStrongAccount {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ProvisionerUser', 'PCloudAccount', 'IdentityUser', 'IdentityMgmtUser', 'TargetCertificate', 'General')]
        [String[]]$secret_type
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/secrets"

        $QueryString = $($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)

        If ($null -ne $QueryString) {
            $URI = "$URI`?$QueryString"
        }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result

        }

    }#process

    END { }#end

}
