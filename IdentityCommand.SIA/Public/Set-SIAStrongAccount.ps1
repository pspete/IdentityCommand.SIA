# .ExternalHelp IdentityCommand.SIA-help.xml
function Set-SIAStrongAccount {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$secret_id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$secret_name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('PCloudAccount', 'ProvisionerUser')]
        [string]$secret_type,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$account_domain,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$safe,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$account_name,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$username,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [securestring]$password,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$certFileName,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [bool]$enable_bulk_elevation,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [hashtable]$ephemeral_domain_user_data

    )

    BEGIN { }#begin

    PROCESS {

        $StrongAccount = [ordered]@{
            'is_active'      = $true
            'secret_name'    = $secret_name
            'secret_type'    = $secret_type
            'secret_details' = [ordered]@{
                'certFileName'               = "$certFileName"
                'domain'                     = ''
                'domains'                    = @()
                'account_domain'             = $account_domain
                'enable_bulk_elevation'      = [bool]$enable_bulk_elevation
                'ephemeral_domain_user_data' = if ($PSBoundParameters.ContainsKey('ephemeral_domain_user_data')) { $ephemeral_domain_user_data } else { @{} }
            }
        }

        #Only include the secret object when a credential field is supplied
        if (($PSBoundParameters.ContainsKey('safe')) -or ($PSBoundParameters.ContainsKey('account_name')) -or
            ($PSBoundParameters.ContainsKey('username')) -or ($PSBoundParameters.ContainsKey('password'))) {

            $secretData = [ordered]@{
                'safe'         = if ($PSBoundParameters.ContainsKey('safe')) { $safe } else { '' }
                'account_name' = if ($PSBoundParameters.ContainsKey('account_name')) { $account_name } else { '' }
                'username'     = if ($PSBoundParameters.ContainsKey('username')) { $username } else { '' }
                'password'     = if ($PSBoundParameters.ContainsKey('password')) { $(ConvertTo-InsecureString -SecureString $password) } else { '' }
            }

            $StrongAccount.Insert(1, 'secret', [ordered]@{ 'tenant_encrypted' = $false; 'secret_data' = $secretData })

        }

        $URI = "$($ISPSSSession.tenant_url)/api/secrets/$secret_id"

        #Create Request Body
        $body = $StrongAccount | ConvertTo-Json -Depth 5

        #Windows PowerShell ConvertTo-Json serialises an empty array (secret_details.domains) as "" - restore it to []
        $body = $body -replace '("domains"\s*:\s*)""', '$1[]'

        if ($PSCmdlet.ShouldProcess($secret_id, 'Update SIA Strong Account')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method PUT -Body $body

            if ($null -ne $result) {

                $result

            }
        }
    }#process

    END { }#end

}
