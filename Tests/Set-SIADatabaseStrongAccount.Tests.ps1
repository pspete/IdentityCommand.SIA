BeforeAll {
    $Script:SIAModuleName = 'IdentityCommand.SIA'

    #Get Current Directory
    $Here = Split-Path -Parent $PSCommandPath

    #Resolve Path to Module Directory
    $ModulePath = Resolve-Path "$Here\..\$Script:SIAModuleName"

    #Define Path to Module Manifest
    $ManifestPath = Join-Path "$ModulePath" "$Script:SIAModuleName.psd1"

    if ( -not (Get-Module -Name $Script:SIAModuleName -All)) {

        Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

    }
}

Describe 'Set-SIADatabaseStrongAccount' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ 'id' = '550e8400'; 'name' = 'Updated'; 'storeType' = 'pam' }
        }

        InModuleScope -ModuleName $Script:SIAModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.dpa.cyberark.cloud'
                User       = $null
                TenantId   = 'SomeTenant'
                SessionId  = 'SomeSession'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:pw = ConvertTo-SecureString 'NewPassword' -AsPlainText -Force
    }

    Context 'PAM' {

        BeforeEach {
            $Script:response = Set-SIADatabaseStrongAccount -strong_account_id '550e8400' -PAM -name 'UpdatedPAMAccount' -safe 'UpdatedSafe' -account_name 'admin@newdomain.com'
        }

        It 'PUTs to the by-id endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($URI -eq 'https://somedomain.dpa.cyberark.cloud/api/database-strong-accounts/550e8400') -and ($Method -eq 'PUT')
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the updated pam account properties' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                ($request.store_type -eq 'pam') -and
                ($request.account_properties.safe -eq 'UpdatedSafe') -and
                ($request.account_properties.account_name -eq 'admin@newdomain.com')
            } -Times 1 -Exactly -Scope It
        }

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Managed' {

        It 'omits password_secret_object when no new password is supplied' {
            Set-SIADatabaseStrongAccount -strong_account_id '550e8400' -Managed -name 'TestScrt' -platform MySQL -username 'TestString' -address 'testaddress'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                ($request.account_properties.address -eq 'testaddress') -and
                ($null -eq $request.password_secret_object)
            } -Times 1 -Exactly -Scope It
        }

        It 'includes password_secret_object when a new password is supplied' {
            Set-SIADatabaseStrongAccount -strong_account_id '550e8400' -Managed -name 'TestScrt' -platform MySQL -username 'TestString' -address 'testaddress' -password $Script:pw
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).password_secret_object.password -eq 'NewPassword'
            } -Times 1 -Exactly -Scope It
        }

        It 'requires -address for MongoDB' {
            { Set-SIADatabaseStrongAccount -strong_account_id '550e8400' -Managed -name 'M' -platform MongoDB -username 'u' -database 'd' } |
                Should -Throw '*requires -address*'
        }
    }

    Context 'AWS' {

        It 'sends aws account properties and only includes secret_access_key when supplied' {
            Set-SIADatabaseStrongAccount -strong_account_id '550e8400' -AWS -name 'AWSScrt' -username 'AWSAcct' -aws_account_id '123456789012' -aws_access_key_id 'AKIA123'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                ($request.account_properties.aws_account_id -eq '123456789012') -and
                ($null -eq $request.password_secret_object)
            } -Times 1 -Exactly -Scope It
        }
    }
}
