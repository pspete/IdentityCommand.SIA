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
                    'base64_cmd' = $([System.Convert]::ToBase64String($([System.Text.Encoding]::UTF8.GetBytes('SomeValue'))))
                }
            } -ParameterFilter {
                $Uri.Contains('api/public-keys/scripts?')
            }

            Mock Invoke-IDRestMethod -MockWith {
                [pscustomobject]@{'target_set' = 'value' }
            }

            $InputObject = [pscustomobject]@{
                'AWS'         = $true
                'workspaceId' = 'SomeID'
            }
            $response = $InputObject | Get-SIASSHPublicKey

        }

        Context 'Input' {

            It 'sends request' {

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -contains 'https://somedomain.dpa.cyberark.cloud/api/public-keys?'
                    $URI -contains 'workspaceId=SomeID'
                    $URI -contains 'workspaceType=AWS'
                    $URI -contains '&'


                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint when deploymentScript is specified' {
                $InputObject | Get-SIASSHPublicKey -deploymentScript
                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $($URI -eq 'https://somedomain.dpa.cyberark.cloud/api/public-keys/scripts?workspaceId=SomeID&workspaceType=AWS' -or
                        $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/public-keys/scripts?workspaceType=AWS&workspaceId=SomeID')

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

            It 'provides expected base64 decoded output when deploymentscript is specified' {
                $response = $InputObject | Get-SIASSHPublicKey -deploymentScript
                $response | Should -Be 'SomeValue'

            }

        }

    }

}