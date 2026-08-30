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
        [string]$certFileName

    )

    BEGIN { }#begin

    PROCESS {

        $StrongAccount = [ordered]@{
            'is_active'      = $true
            'secret'         = @{'tenant_encrypted' = $false; 'secret_data' = @{} }
            'secret_name'    = $null
            'secret_type'    = $null
            'secret_details' = @{'certFileName' = $certFileName; 'account_domain' = $account_domain }
        }

        $URI = "$($ISPSSSession.tenant_url)/api/secrets/public/v1/$secret_id"

        switch ($PSCmdlet.ParameterSetName) {

            'VaultedInPrivilegeCloud' {

                $StrongAccount.secret_type = 'PCloudAccount'
                $StrongAccount.secret.secret_data.add('safe', $safe)
                $StrongAccount.secret.secret_data.add('account_name', $account_name)
                break

            }

            'StoredInSIA' {

                $StrongAccount.secret_type = 'ProvisionerUser'
                $StrongAccount.secret.secret_data.add('username', $username)
                $StrongAccount.secret.secret_data.add('password', $(ConvertTo-InsecureString -SecureString $password))
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
