# .ExternalHelp IdentityCommand.SIA-help.xml
function Set-SIADatabaseStrongAccount {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('id')]
        [string]$strong_account_id,

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

        $URI = "$($ISPSSSession.tenant_url)/api/database-strong-accounts/$strong_account_id"

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

                foreach ($key in @('address', 'port', 'database')) {
                    if ($PSBoundParameters.ContainsKey($key)) {
                        $props[$key] = $PSBoundParameters[$key]
                    }
                }

                if ($PSBoundParameters.ContainsKey('accountProperties')) {
                    $accountProperties.GetEnumerator() | ForEach-Object { $props[$PSItem.Key] = $PSItem.Value }
                }

                $requestBody = @{
                    'storeType'         = 'managed'
                    'name'              = $name
                    'accountProperties' = $props
                }
                break

            }

        }

        #Create Request Body
        $body = $requestBody | ConvertTo-Json -Depth 5

        if ($PSCmdlet.ShouldProcess($strong_account_id, 'Update SIA Database Strong Account')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method PUT -Body $body

            if ($null -ne $result) {

                $result

            }
        }

    }#process

    END { }#end

}
