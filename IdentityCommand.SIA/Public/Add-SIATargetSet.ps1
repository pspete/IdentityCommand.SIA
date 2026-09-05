# .ExternalHelp IdentityCommand.SIA-help.xml
function Add-SIATargetSet {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$name,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$provision_format,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$description,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [bool]$enable_certificate_validation,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ProvisionerUser', 'PCloudAccount', 'IdentityUser', 'IdentityMgmtUser', 'TargetCertificate', 'General')]
        [string]$secret_type,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$secret_id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('Domain', 'Suffix', 'Target')]
        [string]$type

    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/targetsets"

        #Create Request Body
        $boundParameters = $PSBoundParameters | Get-Parameter

        if (-not $boundParameters.ContainsKey('provision_format')) {
            #Use a default provision format when the caller didn't supply one
            $boundParameters['provision_format'] = '<user>-<session-guid>'
        }

        $body = $boundParameters | ConvertTo-Json

        #Send Request
        if ($PSCmdlet.ShouldProcess($name, 'Add SIA Target Set')) {

            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result.target_set

            }

        }

    }#process

    end { }#end

}
