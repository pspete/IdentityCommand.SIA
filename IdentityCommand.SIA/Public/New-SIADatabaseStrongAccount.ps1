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
        [string]$accountName,

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
        [securestring]$secretAccessKey,

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
        [hashtable]$accountProperties
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/database-strong-accounts"

        switch ($PSCmdlet.ParameterSetName) {

            'PAM' {

                $requestBody = @{
                    'storeType'         = 'pam'
                    'name'              = $name
                    'accountProperties' = @{
                        'safe'        = $safe
                        'accountName' = $accountName
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

                #Merge any additional platform-specific properties
                if ($PSBoundParameters.ContainsKey('accountProperties')) {
                    $accountProperties.GetEnumerator() | ForEach-Object { $props[$PSItem.Key] = $PSItem.Value }
                }

                $requestBody = @{
                    'storeType'         = 'managed'
                    'name'              = $name
                    'accountProperties' = $props
                }

                if ($PSBoundParameters.ContainsKey('secretAccessKey')) {
                    $requestBody['passwordSecretObject'] = @{'secretAccessKey' = $(ConvertTo-InsecureString -SecureString $secretAccessKey) }
                } elseif ($PSBoundParameters.ContainsKey('password')) {
                    $requestBody['passwordSecretObject'] = @{'password' = $(ConvertTo-InsecureString -SecureString $password) }
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
