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

Describe 'Set-SIAStrongAccount' {

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

        $Script:pw = ConvertTo-SecureString 'SomePassword' -AsPlainText -Force
        $Script:response = Set-SIAStrongAccount -secret_id '1234-abcd' -secret_name 'MyAccount' -username 'svc' -password $Script:pw -account_domain 'ad.example.com'
    }

    Context 'Request' {

        It 'sends request to the public v1 by-id endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/secrets/public/v1/1234-abcd'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $Method -eq 'PUT' } -Times 1 -Exactly -Scope It
        }

        It 'sends request with expected body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.secret_name -eq 'MyAccount') -and
                ($request.secret.secret_data.username -eq 'svc') -and
                ($request.secret_details.account_domain -eq 'ad.example.com')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Vaulted in Privilege Cloud' {

        It 'sends the PCloudAccount secret type' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.dpa.cyberark.cloud' }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            }
            Set-SIAStrongAccount -secret_id '1234-abcd' -safe 'MySafe' -account_name 'admin' -secret_name 'MyAccount' -account_domain 'ad.example.com'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($Body | ConvertFrom-Json).secret_type -eq 'PCloudAccount'
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }
    }
}
