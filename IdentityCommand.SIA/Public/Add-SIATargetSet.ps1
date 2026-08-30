# .ExternalHelp IdentityCommand.SIA-help.xml
function Add-SIATargetSet {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$strong_account_id,

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
        [ValidateSet('IdentityUser', 'IdentityMgmtUser', 'ProvisionerUser', 'TargetCertificate', 'PCloudAccount', 'EphemeralUser', 'General')]
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

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/discovery/targetsets/bulk"

        #Build the target set from the target set parameters
        $targetSet = $PSBoundParameters | Get-Parameter -ParametersToRemove strong_account_id

        if ( -not ($PSBoundParameters.ContainsKey('provision_format'))) {
            #Use default provision format if none specified
            $targetSet['provision_format'] = '<user>-<session-guid>'
        }

        #Create Request Body - map the target set to the strong account
        $requestBody = @{
            'target_sets_mapping' = @(
                @{
                    'strong_account_id' = $strong_account_id
                    'target_sets'       = @($targetSet)
                }
            )
        }

        $body = $requestBody | ConvertTo-Json -Depth 5

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

        if ($null -ne $result) {

            $result.results

        }

    }#process

    END { }#end

}
