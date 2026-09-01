# .ExternalHelp IdentityCommand.SIA-help.xml
function New-SIADatabaseStrongAccount {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'PAM'
        )]
        [switch]$PAM,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'PAM'
        )]
        [string]$safe,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'PAM'
        )]
        [string]$account_name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [switch]$Managed,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [ValidateSet('PostgreSQL', 'MySQL', 'MariaDB', 'MSSql', 'Oracle', 'MongoDB', 'DB2UnixSSH', 'WinDomain')]
        [string]$platform,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [string]$username,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [securestring]$password,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [string]$address,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [ValidateRange(1, 65535)]
        [int]$port,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [string]$database,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [string]$dsn,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [hashtable]$account_properties,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [switch]$AWS,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [string]$aws_account_id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [string]$aws_access_key_id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [securestring]$secret_access_key,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [string]$aws_account_alias_name,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [ValidateSet('us-east-1', 'us-west-1', 'us-west-2', 'eu-west-1', 'eu-central-1', 'ap-northeast-1', 'ap-southeast-1', 'ap-southeast-2', 'sa-east-1', 'us-gov-west-1')]
        [string]$region
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/database-strong-accounts"

        switch ($PSCmdlet.ParameterSetName) {

            'PAM' {

                $requestBody = @{
                    'store_type'         = 'pam'
                    'name'               = $name
                    'account_properties' = @{
                        'safe'         = $safe
                        'account_name' = $account_name
                    }
                }
                break

            }

            'Managed' {

                #Platform-specific required properties
                if (($platform -in 'MongoDB', 'DB2UnixSSH', 'WinDomain') -and ( -not $PSBoundParameters.ContainsKey('address'))) {
                    throw "The $platform platform requires -address."
                }
                if (($platform -eq 'MongoDB') -and ( -not $PSBoundParameters.ContainsKey('database'))) {
                    throw 'The MongoDB platform requires -database.'
                }

                $props = @{
                    'platform' = $platform
                    'username' = $username
                }

                foreach ($key in @('address', 'port', 'database', 'dsn')) {
                    if ($PSBoundParameters.ContainsKey($key)) {
                        $props[$key] = $PSBoundParameters[$key]
                    }
                }

                #Merge any additional platform-specific properties (snake_case keys, e.g. auth_database, replica_set, use_ssl, log_on_to, user_dn, reconcile_is_win_account)
                if ($PSBoundParameters.ContainsKey('account_properties')) {
                    $account_properties.GetEnumerator() | ForEach-Object { $props[$PSItem.Key] = $PSItem.Value }
                }

                $requestBody = @{
                    'store_type'            = 'managed'
                    'name'                  = $name
                    'account_properties'    = $props
                    'password_secret_object' = @{'password' = $(ConvertTo-InsecureString -SecureString $password) }
                }
                break

            }

            'AWS' {

                $props = @{
                    'platform'          = 'AWSAccessKeys'
                    'username'          = $username
                    'aws_account_id'    = $aws_account_id
                    'aws_access_key_id' = $aws_access_key_id
                }

                foreach ($key in @('aws_account_alias_name', 'region')) {
                    if ($PSBoundParameters.ContainsKey($key)) {
                        $props[$key] = $PSBoundParameters[$key]
                    }
                }

                $requestBody = @{
                    'store_type'            = 'managed'
                    'name'                  = $name
                    'account_properties'    = $props
                    'password_secret_object' = @{'secret_access_key' = $(ConvertTo-InsecureString -SecureString $secret_access_key) }
                }
                break

            }

        }

        #Create Request Body (serialised to UTF8 bytes so the plaintext secret can't be captured - see helper)
        $body = $requestBody | ConvertTo-SIASecretBody

        if ($PSCmdlet.ShouldProcess($name, 'Create SIA Database Strong Account')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }
        }

    }#process

    END { }#end

}
