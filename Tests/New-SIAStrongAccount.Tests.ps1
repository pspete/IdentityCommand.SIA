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

Describe 'New-SIAStrongAccount' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ 'secret_id' = 'value' }
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

        $Script:SecureString = ConvertTo-SecureString 'SomePassword' -AsPlainText -Force
    }

    Context 'StoredInSIA' {

        BeforeEach {
            $Script:response = New-SIAStrongAccount -username SomeUser -password $Script:SecureString -secret_name SomeName -account_domain SomeDomain.com
        }

        It 'sends request to the public v1 endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/secrets/public/v1'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $Method -eq 'POST' } -Times 1 -Exactly -Scope It
        }

        It 'sends request with expected body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.is_active -eq $true) -and
                ($request.secret_name -eq 'SomeName') -and
                ($request.secret_type -eq 'ProvisionerUser') -and
                ($request.secret_details.account_domain -eq 'SomeDomain.com') -and
                ($request.secret.secret_data.username -eq 'SomeUser') -and
                ($request.secret.secret_data.password -eq 'SomePassword')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'VaultedInPrivilegeCloud' {

        BeforeEach {
            $Script:response = New-SIAStrongAccount -safe StrongAccounts -account_name OS-WinDomain-pspete.dev-someuser -secret_name SomeUser -account_domain pspete.dev
        }

        It 'sends request to the public v1 endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/secrets/public/v1'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends request with expected body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.secret_type -eq 'PCloudAccount') -and
                ($request.secret_details.account_domain -eq 'pspete.dev') -and
                ($request.secret.secret_data.safe -eq 'StrongAccounts') -and
                ($request.secret.secret_data.account_name -eq 'OS-WinDomain-pspete.dev-someuser')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            New-SIAStrongAccount -username u -password $Script:SecureString -secret_name n -account_domain d | Should -Not -BeNullOrEmpty
        }
    }
}
