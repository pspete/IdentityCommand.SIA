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

Describe 'Remove-SIATargetSet' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ 'results' = @([pscustomobject]@{ 'target_set_name' = 'abc12'; 'success' = $true }) }
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

        $InputObject = [pscustomobject]@{ 'name' = 'abc12' }
        $Script:response = $InputObject | Remove-SIATargetSet
    }

    Context 'Single target set' {

        It 'deletes by name at /api/targetsets/{name}' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/targetsets/abc12'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $Method -eq 'DELETE' } -Times 1 -Exactly -Scope It
        }

        It 'sends no body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $null -eq $Body } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Multiple target sets' {

        It 'bulk-deletes with a JSON array body at /api/targetsets/bulk' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.dpa.cyberark.cloud' }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            }
            Remove-SIATargetSet -name 'one', 'two'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($URI -eq 'https://somedomain.dpa.cyberark.cloud/api/targetsets/bulk') -and
                ($Body -eq '["one","two"]')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }
    }
}
