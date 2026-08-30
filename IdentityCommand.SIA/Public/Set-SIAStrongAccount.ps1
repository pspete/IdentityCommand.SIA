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
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VaultedInPrivilegeCloud-VM'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VaultedInPrivilegeCloud-DB'
        )]
        [string]$safe,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VaultedInPrivilegeCloud-VM'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VaultedInPrivilegeCloud-DB'
        )]
        [string]$account_name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'StoredInDPA-VM'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'StoredInDPA-DB'
        )]
        [string]$username,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'StoredInDPA-VM'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'StoredInDPA-DB'
        )]
        [securestring]$password,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$secret_name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VaultedInPrivilegeCloud-VM'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'StoredInDPA-VM'
        )]
        [string]$account_domain,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VaultedInPrivilegeCloud-VM'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'StoredInDPA-VM'
        )]
        [string]$certFileName,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'StoredInDPA-DB'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VaultedInPrivilegeCloud-DB'
        )]
        [switch]$database

    )

    BEGIN { }#begin

    PROCESS {

        switch ($PSCmdlet.ParameterSetName) {

            { $PSItem -match '-VM$' } {
                $StrongAccount = [ordered]@{
                    'is_active'      = $true
                    'secret'         = @{'tenant_encrypted' = $false; 'secret_data' = @{} }
                    'secret_name'    = $null
                    'secret_type'    = $null
                    'secret_details' = @{'certFileName' = $null; 'account_domain' = $null }
                }

                $URI = "$($ISPSSSession.tenant_url)/api/secrets/public/v1/$secret_id"
                $StrongAccount.secret_details.account_domain = $account_domain
                $StrongAccount.secret_details.certFileName = $certFileName

            }

            { $PSItem -match '-DB$' } {
                $StrongAccount = [ordered]@{
                    'secret_name'  = $null
                    'secret_type'  = $null
                    'secret_store' = $null
                    'tags'         = @()
                }

                $URI = "$($ISPSSSession.tenant_url)/api/adb/secretsmgmt/secrets/$secret_id"

            }

            'VaultedInPrivilegeCloud-VM' {

                $StrongAccount.secret_type = 'PCloudAccount'
                $StrongAccount.secret.secret_data.add('safe', $safe)
                $StrongAccount.secret.secret_data.add('account_name', $account_name)
                break

            }

            'VaultedInPrivilegeCloud-DB' {

                $StrongAccount.Insert(2, 'description', '')
                $StrongAccount.Insert(3, 'purpose', '')
                $StrongAccount.Insert(4, 'secret_link', @{'safe' = $safe ; 'account_name' = $account_name })
                $StrongAccount.secret_store = @{'store_type' = 'pam' }
                $StrongAccount.secret_type = 'cyberark_pam'
                break

            }

            'StoredInDPA-VM' {

                $StrongAccount.secret_type = 'ProvisionerUser'
                $StrongAccount.secret.secret_data.add('username', $username)
                $StrongAccount.secret.secret_data.add('password', $(ConvertTo-InsecureString -SecureString $password))
                break

            }

            'StoredInDPA-DB' {

                $StrongAccount.secret_type = 'username_password'
                $StrongAccount.Insert(2, 'secret_data', @{'username' = $username; 'password' = $(ConvertTo-InsecureString -SecureString $password) })
                $StrongAccount.secret_store = @{'store_type' = 'managed' }
                break

            }

        }

        $StrongAccount.secret_name = $secret_name

        #Create Request Body
        $body = $StrongAccount | ConvertTo-Json

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
