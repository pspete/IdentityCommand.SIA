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
    }

    Context 'PAM' {

        BeforeEach {
            $Script:response = New-SIADatabaseStrongAccount -PAM -name 'MyPAMAccount' -safe 'MySafe' -account_name 'admin@example.com'
        }

        It 'sends request to expected endpoint with POST' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($URI -eq 'https://somedomain.dpa.cyberark.cloud/api/database-strong-accounts') -and ($Method -eq 'POST')
            } -Times 1 -Exactly -Scope It
        }

        It 'sends a snake_case pam store type body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.store_type -eq 'pam') -and
                ($request.account_properties.safe -eq 'MySafe') -and
                ($request.account_properties.account_name -eq 'admin@example.com')
            } -Times 1 -Exactly -Scope It
        }

        It 'provides output' {
            $Script:response.id | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Managed' {

        It 'sends a managed body with platform, username, optional properties and password' {
            New-SIADatabaseStrongAccount -Managed -name 'PG' -platform PostgreSQL -username 'dbuser' -password $Script:pw -address 'db.example.com' -port 5432 -database 'mydb' -dsn 'SomeDSN'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.store_type -eq 'managed') -and
                ($request.account_properties.platform -eq 'PostgreSQL') -and
                ($request.account_properties.username -eq 'dbuser') -and
                ($request.account_properties.port -eq 5432) -and
                ($request.account_properties.dsn -eq 'SomeDSN') -and
                ($request.password_secret_object.password -eq 'SomePassword')
            } -Times 1 -Exactly -Scope It
        }

        It 'merges extra account_properties' {
            New-SIADatabaseStrongAccount -Managed -name 'Mongo' -platform MongoDB -username 'u' -password $Script:pw -address 'a' -database 'd' -account_properties @{ replica_set = 'rs0'; use_ssl = 'true' }
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($Body | ConvertFrom-Json).account_properties.replica_set -eq 'rs0'
            } -Times 1 -Exactly -Scope It
        }

        It 'requires -address for MongoDB' {
            { New-SIADatabaseStrongAccount -Managed -name 'M' -platform MongoDB -username 'u' -password $Script:pw -database 'd' } |
                Should -Throw '*requires -address*'
        }

        It 'requires -database for MongoDB' {
            { New-SIADatabaseStrongAccount -Managed -name 'M' -platform MongoDB -username 'u' -password $Script:pw -address 'a' } |
                Should -Throw '*requires -database*'
        }

        It 'requires -address for DB2UnixSSH' {
            { New-SIADatabaseStrongAccount -Managed -name 'D' -platform DB2UnixSSH -username 'u' -password $Script:pw } |
                Should -Throw '*requires -address*'
        }
    }

    Context 'AWS' {

        It 'sends an AWSAccessKeys body with first-class aws fields and secret_access_key' {
            New-SIADatabaseStrongAccount -AWS -name 'AWSScrt' -username 'AWSAcct' -aws_account_id '123456789012' -aws_access_key_id 'AKIA123' -secret_access_key $Script:pw -aws_account_alias_name 'alias' -region 'eu-west-1'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.store_type -eq 'managed') -and
                ($request.account_properties.platform -eq 'AWSAccessKeys') -and
                ($request.account_properties.aws_account_id -eq '123456789012') -and
                ($request.account_properties.aws_access_key_id -eq 'AKIA123') -and
                ($request.account_properties.aws_account_alias_name -eq 'alias') -and
                ($request.account_properties.region -eq 'eu-west-1') -and
                ($request.password_secret_object.secret_access_key -eq 'SomePassword')
            } -Times 1 -Exactly -Scope It
        }
    }
}
