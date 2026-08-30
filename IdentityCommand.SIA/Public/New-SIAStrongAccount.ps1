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
        [bool]$enable_bulk_elevation

    )

    BEGIN { }#begin

    PROCESS {

        $StrongAccount = [ordered]@{
            'is_active'      = $true
            'secret'         = [ordered]@{
                'tenant_encrypted' = $false
                'secret_data'      = [ordered]@{
                    'safe'         = ''
                    'account_name' = ''
                    'username'     = ''
                    'password'     = ''
                }
            }
            'secret_name'    = $secret_name
            'secret_type'    = $null
            'secret_details' = [ordered]@{
                'certFileName'               = "$certFileName"
                'domain'                     = ''
                'domains'                    = @()
                'account_domain'             = $account_domain
                'enable_bulk_elevation'      = [bool]$enable_bulk_elevation
                'ephemeral_domain_user_data' = @{}
            }
        }

        $URI = "$($ISPSSSession.tenant_url)/api/secrets"

        switch ($PSCmdlet.ParameterSetName) {

            'VaultedInPrivilegeCloud' {

                $StrongAccount.secret_type = 'PCloudAccount'
                $StrongAccount.secret.secret_data.safe = $safe
                $StrongAccount.secret.secret_data.account_name = $account_name
                break

            }

            'StoredInSIA' {

                $StrongAccount.secret_type = 'ProvisionerUser'
                $StrongAccount.secret.secret_data.username = $username
                $StrongAccount.secret.secret_data.password = $(ConvertTo-InsecureString -SecureString $password)
                break

            }

        }

        #Create Request Body
        $body = $StrongAccount | ConvertTo-Json -Depth 5

        if ($PSCmdlet.ShouldProcess($secret_name, 'Create New SIA Strong Account')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }
        }
    }#process

    END { }#end

}
