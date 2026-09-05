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

            Mock Resolve-SIAServiceUrl -MockWith {
                [pscustomobject]@{
                    SIAUrl      = 'https://SomeSubdomain.dpa.cyberark.cloud'
                    IdentityUrl = 'https://aao4818.id.cyberark.cloud'
                }
            }

            Mock New-IDSession -MockWith {}
            Mock New-IDPlatformToken -MockWith {}

            Connect-SIATenant -tenant_url 'SomeURL'

        }

        Context 'Input' {

            It 'calls Get-IDSession' {

                Should -Invoke -CommandName Get-IDSession -Times 1 -Exactly -Scope It

            }

            It 'does not attempt authentication when an active session is found' {

                Should -Invoke -CommandName New-IDSession -Times 0 -Exactly -Scope It
                Should -Invoke -CommandName New-IDPlatformToken -Times 0 -Exactly -Scope It

            }

            It 'throws if no active session and no authentication parameters are supplied' {

                Mock Get-IDSession -MockWith {
                    [ordered]@{
                        tenant_url = $null
                        User       = $null
                        TenantId   = 'SomeTenant'
                        SessionId  = 'SomeSession'
                    }
                }

                { Connect-SIATenant -tenant_url 'SomeURL' } |
                    Should -Throw 'Authenticate with New-IDSession or New-IDPlatformToken, or supply -Credential, and try again'

            }

        }

        Context 'Authentication' {

            BeforeEach {

                Mock Get-IDSession -MockWith {
                    [ordered]@{
                        tenant_url = $null
                        User       = $null
                        TenantId   = 'SomeTenant'
                        SessionId  = 'SomeSession'
                    }
                }

                $Credential = [pscredential]::new('SomeUser', ('SomeSecret' | ConvertTo-SecureString -AsPlainText -Force))

            }

            It 'resolves the CyberArk Identity URL from the supplied tenant_url' {

                Connect-SIATenant -tenant_url 'https://somedomain.dpa.cyberark.cloud' -Credential $Credential

                Should -Invoke -CommandName Resolve-SIAServiceUrl -ParameterFilter {
                    $Url -eq 'https://somedomain.dpa.cyberark.cloud'
                } -Times 1 -Exactly -Scope It

            }

            It 'authenticates with New-IDSession using the discovered Identity URL when a credential is supplied' {

                Connect-SIATenant -tenant_url 'https://somedomain.dpa.cyberark.cloud' -Credential $Credential

                Should -Invoke -CommandName New-IDSession -ParameterFilter {
                    $tenant_url -eq 'https://aao4818.id.cyberark.cloud' -and $Credential.UserName -eq 'SomeUser'
                } -Times 1 -Exactly -Scope It

            }

            It 'authenticates with New-IDPlatformToken when -PlatformToken is specified' {

                Connect-SIATenant -tenant_url 'https://somedomain.dpa.cyberark.cloud' -Credential $Credential -PlatformToken

                Should -Invoke -CommandName New-IDPlatformToken -ParameterFilter {
                    $tenant_url -eq 'https://aao4818.id.cyberark.cloud'
                } -Times 1 -Exactly -Scope It
                Should -Invoke -CommandName New-IDSession -Times 0 -Exactly -Scope It

            }

            It 'authenticates with New-IDSession using the SAML assertion when -SAMLResponse is supplied' {

                Connect-SIATenant -tenant_url 'https://somedomain.dpa.cyberark.cloud' -SAMLResponse 'SomeAssertion'

                Should -Invoke -CommandName New-IDSession -ParameterFilter {
                    $tenant_url -eq 'https://aao4818.id.cyberark.cloud' -and $SAMLResponse -eq 'SomeAssertion'
                } -Times 1 -Exactly -Scope It

            }

            It 'resolves both SIA and Identity URLs from a supplied subdomain' {

                Connect-SIATenant -tenant_subdomain 'SomeSubdomain' -Credential $Credential

                Should -Invoke -CommandName Resolve-SIAServiceUrl -ParameterFilter {
                    $Subdomain -eq 'SomeSubdomain'
                } -Times 1 -Exactly -Scope It

                $ISPSSSession.tenant_url | Should -Be 'https://SomeSubdomain.dpa.cyberark.cloud'

            }

        }

        Context 'Output' {

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

            It 'resolves tenant_url from shared services when tenant_subdomain is provided' {

                Connect-SIATenant -tenant_subdomain 'SomeSubdomain'

                Should -Invoke -CommandName Resolve-SIAServiceUrl -ParameterFilter {
                    $Subdomain -eq 'SomeSubdomain'
                } -Times 1 -Exactly -Scope It

                $ISPSSSession.tenant_url | Should -Be 'https://SomeSubdomain.dpa.cyberark.cloud'

            }

        }

    }

}
