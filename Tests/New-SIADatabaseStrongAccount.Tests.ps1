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

Describe 'New-SIADatabaseStrongAccount' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ 'id' = '3fa85f64-5717-4562-b3fc-2c963f66afa6'; 'createdAt' = '2026-08-30T16:36:54.365Z' }
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

        $Script:pw = ConvertTo-SecureString 'SomePassword' -AsPlainText -Force
        $Script:response = New-SIADatabaseStrongAccount -PAM -name 'MyPAMAccount' -safe 'MySafe' -account_name 'admin@example.com'
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/database-strong-accounts'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $Method -eq 'POST'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends a snake_case pam store type body for a PAM account' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.store_type -eq 'pam') -and
                ($request.account_properties.safe -eq 'MySafe') -and
                ($request.account_properties.account_name -eq 'admin@example.com')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Managed account' {

        BeforeEach {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.dpa.cyberark.cloud' }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            }
        }

        It 'sends a snake_case managed store type body with platform and password' {
            New-SIADatabaseStrongAccount -Managed -name 'PG' -platform PostgreSQL -username 'dbuser' -password $Script:pw -address 'db.example.com' -port 5432 -database 'mydb'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.store_type -eq 'managed') -and
                ($request.account_properties.platform -eq 'PostgreSQL') -and
                ($request.account_properties.port -eq 5432) -and
                ($request.password_secret_object.password -eq 'SomePassword')
            } -Times 1 -Exactly -Scope It
        }

        It 'uses secret_access_key for an AWSAccessKeys account' {
            New-SIADatabaseStrongAccount -Managed -name 'AWS' -platform AWSAccessKeys -username 'iam' -secret_access_key $Script:pw -account_properties @{ aws_account_id = '123456789012'; aws_access_key_id = 'AKIA...' }
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.account_properties.aws_account_id -eq '123456789012') -and
                ($request.password_secret_object.secret_access_key -eq 'SomePassword')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response.id | Should -Not -BeNullOrEmpty
        }
    }
}
