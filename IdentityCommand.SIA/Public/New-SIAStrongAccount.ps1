# .ExternalHelp IdentityCommand.SIA-help.xml
function New-SIAStrongAccount {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VaultedInPrivilegeCloud'
        )]
        [string]$safe,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VaultedInPrivilegeCloud'
        )]
        [string]$account_name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'StoredInSIA'
        )]
        [string]$username,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'StoredInSIA'
        )]
        [securestring]$password,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$secret_name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$account_domain,

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

    begin { }#begin

    process {

        $StrongAccount = [ordered]@{
            'is_active'      = $true
            'secret'         = [ordered]@{
                'tenant_encrypted' = $false
                'secret_data'      = [ordered]@{ }
            }
            'secret_name'    = $secret_name
            'secret_type'    = $null
            'secret_details' = [ordered]@{
                'certFileName'               = "$certFileName"
                'account_domain'             = $account_domain
                'enable_bulk_elevation'      = [bool]$enable_bulk_elevation
                'ephemeral_domain_user_data' = if ($PSBoundParameters.ContainsKey('ephemeral_domain_user_data')) { $ephemeral_domain_user_data } else { @{} }
            }
        }

        $URI = "$($ISPSSSession.tenant_url)/api/secrets"

        switch ($PSCmdlet.ParameterSetName) {

            'VaultedInPrivilegeCloud' {

                $StrongAccount.secret_type = 'PCloudAccount'
                $StrongAccount.secret.secret_data.Add('safe', $safe)
                $StrongAccount.secret.secret_data.Add('account_name', $account_name)
                break

            }

            'StoredInSIA' {

                $StrongAccount.secret_type = 'ProvisionerUser'
                $StrongAccount.secret.secret_data.Add('username', $username)
                $StrongAccount.secret.secret_data.Add('password', $(ConvertTo-InsecureString -SecureString $password))
                break

            }

        }

        #Create Request Body (serialised to UTF8 bytes so the plaintext secret can't be captured - see helper)
        $body = $StrongAccount | ConvertTo-SIASecretBody

        if ($PSCmdlet.ShouldProcess($secret_name, 'Create New SIA Strong Account')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }
        }
    }#process

    end { }#end

}
