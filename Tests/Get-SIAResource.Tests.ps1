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
                [pscustomobject]@{
                    'organizations' = 'value'
                    'subscriptions' = 'value'
                    'items'         = 'value'
                    'config'        = $(@{'config' = 'somevalue' } | ConvertTo-Json)
                }
            }

            $response = Get-SIAResource -AWS

        }

        Context 'Input' {

            It 'sends request' {

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint: AWS' {

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/discovery/organizations/'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint: Azure' {
                Get-SIAResource -Azure
                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/discovery/subscriptions/'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint: OnPrem' {
                Mock Invoke-IDRestMethod -MockWith {

                    $(@{'config' = 'somevalue' } | ConvertTo-Json)

                }
                Get-SIAResource -OnPrem
                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/discovery/onprem/'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint: GCP' {
                Get-SIAResource -GCP
                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/discovery/gcp/organizations/'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint: Databases' {
                Get-SIAResource -Database
                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/adb/resources/'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint when workspaceId specified' {

                Get-SIAResource -AWS -workspaceId SomeID

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/discovery/organizations/SomeID'

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

            }

        }

    }

}