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
        [ValidateSet('PostgreSQL', 'MySQL', 'MariaDB', 'MSSql', 'Oracle', 'MongoDB', 'DB2UnixSSH', 'WinDomain', 'AWSAccessKeys')]
        [string]$platform,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [string]$username,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [securestring]$password,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Managed'
        )]
        [securestring]$secret_access_key,

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
        [hashtable]$account_properties
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

                $props = @{
                    'platform' = $platform
                    'username' = $username
                }

                #Add named optional account properties if provided
                foreach ($key in @('address', 'port', 'database')) {
                    if ($PSBoundParameters.ContainsKey($key)) {
                        $props[$key] = $PSBoundParameters[$key]
                    }
                }

                #Merge any additional platform-specific properties (keys as expected by the API, e.g. auth_database, replica_set, aws_account_id)
                if ($PSBoundParameters.ContainsKey('account_properties')) {
                    $account_properties.GetEnumerator() | ForEach-Object { $props[$PSItem.Key] = $PSItem.Value }
                }

                $requestBody = @{
                    'store_type'         = 'managed'
                    'name'               = $name
                    'account_properties' = $props
                }

                if ($PSBoundParameters.ContainsKey('secret_access_key')) {
                    $requestBody['password_secret_object'] = @{'secret_access_key' = $(ConvertTo-InsecureString -SecureString $secret_access_key) }
                } elseif ($PSBoundParameters.ContainsKey('password')) {
                    $requestBody['password_secret_object'] = @{'password' = $(ConvertTo-InsecureString -SecureString $password) }
                }
                break

            }

        }

        #Create Request Body
        $body = $requestBody | ConvertTo-Json -Depth 5

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
