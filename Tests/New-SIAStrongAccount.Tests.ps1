Describe $($PSCommandPath -Replace '.Tests.ps1') {

    BeforeAll {
        #Get Current Directory
        $Here = Split-Path -Parent $PSCommandPath

        #Assume ModuleName from Repository Root folder
        $ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

        #Resolve Path to Module Directory
        $ModulePath = Resolve-Path "$Here\..\$ModuleName"

        #Define Path to Module Manifest
        $ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

        if ( -not (Get-Module -Name $ModuleName -All)) {

            Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

        }

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        BeforeEach {

            $ISPSSSession = [ordered]@{
                tenant_url         = 'https://somedomain.dpa.cyberark.cloud'
                User               = $null
                TenantId           = 'SomeTenant'
                SessionId          = 'SomeSession'
                WebSession         = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                StartTime          = $null
                ElapsedTime        = $null
                LastCommand        = $null
                LastCommandTime    = $null
                LastCommandResults = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

            Mock Invoke-IDRestMethod -MockWith {
                [pscustomobject]@{'target_set' = 'value' }
            }

            $SecureString = $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force)

        }

        Context 'Input - StoredInDPA-VM' {
            BeforeEach {
                $response = New-SIAStrongAccount -username SomeUser -password $SecureString -secret_name SomeName -account_domain SomeDomain.com
            }
            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/secrets/public/v1'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.is_active -eq $true

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_name -eq 'SomeName'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_type -eq 'ProvisionerUser'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_details.account_domain -eq 'SomeDomain.com'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret.secret_data.username -eq 'SomeUser'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret.secret_data.password -eq 'SomePassword'

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Input - VaultedInPrivilegeCloud-VM' {
            BeforeEach {
                $response = New-SIAStrongAccount -safe StrongAccounts -account_name OS-WinDomain-pspete.dev-someuser -secret_name SomeUser -account_domain pspete.dev
            }
            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/secrets/public/v1'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.is_active -eq $true

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_name -eq 'SomeUser'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_type -eq 'PCloudAccount'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_details.account_domain -eq 'pspete.dev'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret.secret_data.safe -eq 'StrongAccounts'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret.secret_data.account_name -eq 'OS-WinDomain-pspete.dev-someuser'

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Input - StoredInDPA-DB' {
            BeforeEach {
                $response = New-SIAStrongAccount -username dbuser -password $SecureString -secret_name SomeName -database
            }
            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/adb/secretsmgmt/secrets'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_name -eq 'SomeName'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_type -eq 'username_password'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_store.store_type -eq 'managed'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_data.username -eq 'dbuser'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_data.password -eq 'SomePassword'

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Input - VaultedInPrivilegeCloud-DB' {
            BeforeEach {
                $response = New-SIAStrongAccount -safe DBAccts -account_name Database-DBHost-somedomain-dbuser -secret_name SomeName -database
            }
            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/adb/secretsmgmt/secrets'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_name -eq 'SomeName'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_type -eq 'cyberark_pam'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_store.store_type -eq 'pam'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_link.safe -eq 'DBAccts'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.secret_link.account_name -eq 'Database-DBHost-somedomain-dbuser'

                } -Times 1 -Exactly -Scope It

            }

        }

    }

}