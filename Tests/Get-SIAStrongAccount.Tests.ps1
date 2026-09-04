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

Describe 'Get-SIAStrongAccount' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
            $URI -match '/api/secrets/count'
        } -MockWith {
            [pscustomobject]@{ 'count' = 1 }
        }

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
            $URI -notmatch '/api/secrets/count'
        } -MockWith {
            #The API returns a bare array, not an envelope object
            @([pscustomobject]@{ 'secret_id' = '111ad1ca'; 'secret_name' = 'SomeValue' })
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

        $Script:response = Get-SIAStrongAccount
    }

    Context 'Request' {

        It 'sends a list request and a count request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -Times 2 -Exactly -Scope It
        }

        It 'sends the list request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/secrets'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the count request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/secrets/count'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $Method -eq 'GET' } -Times 2 -Exactly -Scope It
        }

        It 'sends requests with no body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $null -eq $Body } -Times 2 -Exactly -Scope It
        }

        It 'passes secret_type (comma-joined) and count as query parameters on the list request' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.dpa.cyberark.cloud' }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            }
            Get-SIAStrongAccount -secret_type ProvisionerUser, PCloudAccount -count 100
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($URI -match '/api/secrets\?') -and
                ($URI -match 'secret_type=ProvisionerUser(%2C|,)PCloudAccount') -and
                ($URI -match 'count=100')
            } -Times 1 -Exactly -Scope It
        }

        It 'passes secret_type as a query parameter on the count request' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.dpa.cyberark.cloud' }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            }
            Get-SIAStrongAccount -secret_type ProvisionerUser
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($URI -match '/api/secrets/count\?') -and ($URI -match 'secret_type=ProvisionerUser')
            } -Times 1 -Exactly -Scope It
        }

        It 'requests additional pages when the count endpoint reports more records than were returned' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.dpa.cyberark.cloud' }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            }

            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -match '/api/secrets/count'
            } -MockWith {
                [pscustomobject]@{ 'count' = 2 }
            }

            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($URI -notmatch '/api/secrets/count') -and ($URI -notmatch 'offset=')
            } -MockWith {
                @([pscustomobject]@{ 'secret_id' = '111ad1ca' })
            }

            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -match 'offset=1'
            } -MockWith {
                @([pscustomobject]@{ 'secret_id' = '1cfb8e37' })
            }

            $result = Get-SIAStrongAccount

            $result.Count | Should -Be 2
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -match 'offset=1'
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }
    }
}
