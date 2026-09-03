Describe $($PSCommandPath -Replace '.Tests.ps1') {

    BeforeAll {
        #Get Current Directory
        $Here = Split-Path -Parent $PSCommandPath

        #Module Name
        $ModuleName = 'IdentityCommand.SIA'

        #Resolve Path to Module Directory
        $ModulePath = Resolve-Path "$Here\..\$ModuleName"

        #Define Path to Module Manifest
        $ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

        if ( -not (Get-Module -Name $ModuleName -All)) {

            Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

        }

    }

    InModuleScope 'IdentityCommand.SIA' {

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
                [pscustomobject]@{'items' = 'value' }
            }

            Mock Invoke-IDRestMethod -MockWith {
                return 'value'
            } -ParameterFilter { $Uri.Contains('SomeConnector') }

            $response = Get-SIAConnector

        }

        Context 'Input' {

            It 'sends request' {

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/connectors/'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint when connector_id specified' {

                Get-SIAConnector -connector_id SomeConnector

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/connectors/SomeConnector'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter { $Method -match 'GET' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with no body' {

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter { $Body -eq $null } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

                $response | Should -Be 'value'

            }

            It 'provides expected output when connector_id is specified' {
                $response = Get-SIAConnector -connector_id SomeConnector
                $response | Should -Not -BeNullOrEmpty

                $response | Should -Be 'value'

            }

        }

    }

}