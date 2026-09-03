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
                tenant_url         = $null
                User               = $null
                TenantId           = $null
                SessionId          = $null
                WebSession         = $null
                StartTime          = $null
                ElapsedTime        = $null
                LastCommand        = $null
                LastCommandTime    = $null
                LastCommandResults = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

            Mock Get-IDSession -MockWith {
                [ordered]@{
                    tenant_url = 'https://somedomain.dpa.cyberark.cloud'
                    User       = $null
                    TenantId   = 'SomeTenant'
                    SessionId  = 'SomeSession'
                }
            }


            Connect-SIATenant -tenant_url 'SomeURL'

        }

        Context 'Input' {

            It 'calls Get-IDSession' {

                Should -Invoke -CommandName Get-IDSession -Times 1 -Exactly -Scope It

            }

            It 'throws if Get-IDSesion does not return tenant_url' {

                Mock Get-IDSession -MockWith {
                    [ordered]@{
                        tenant_url = $null
                        User       = $null
                        TenantId   = 'SomeTenant'
                        SessionId  = 'SomeSession'
                    }
                }

                { Connect-SIATenant -tenant_url 'SomeURL' } | Should -Throw 'Authenticate with New-IDSession or New-IDPlatformToken and try again'

            }

        }

        Context 'Output' {

            It 'sets expected values' {



            }

            It 'provides output with expected values' {
                $ISPSSSession.tenant_url | Should -Not -BeNullOrEmpty
                $ISPSSSession.tenant_url | Should -Be 'SomeURL'
                $ISPSSSession.User | Should -BeNullOrEmpty
                $ISPSSSession.TenantId | Should -Be 'SomeTenant'
                $ISPSSSession.SessionId | Should -Be 'SomeSession'

            }

            It 'removes trailing space from provided tenant_url' {
                Connect-SIATenant -tenant_url 'SomeURL/'
                $ISPSSSession.tenant_url | Should -Be 'SomeURL'
            }

        }

    }

}