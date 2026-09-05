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

Describe 'Resolve-SIAServiceUrl' {

    BeforeEach {

        Mock -CommandName Find-SharedServicesURL -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{
                jit                  = [pscustomobject]@{ api = 'https://sometenant.dpa.cyberark.cloud/api' }
                identity_user_portal = [pscustomobject]@{ api = 'https://sometenant.id.cyberark.cloud/' }
            }
        }
    }

    Context 'Subdomain parameter set' {

        It 'queries platform discovery by subdomain' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $null = Resolve-SIAServiceUrl -Subdomain 'sometenant'
            }
            Should -Invoke -CommandName Find-SharedServicesURL -ModuleName $Script:SIAModuleName -ParameterFilter {
                $subdomain -eq 'sometenant'
            } -Times 1 -Exactly
        }

        It 'returns the SIA tenant URL with any trailing /api removed' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                (Resolve-SIAServiceUrl -Subdomain 'sometenant').SIAUrl |
                    Should -Be 'https://sometenant.dpa.cyberark.cloud'
            }
        }

        It 'returns the CyberArk Identity URL with any trailing slash removed' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                (Resolve-SIAServiceUrl -Subdomain 'sometenant').IdentityUrl |
                    Should -Be 'https://sometenant.id.cyberark.cloud'
            }
        }
    }

    Context 'URL parameter set' {

        It 'queries platform discovery by url' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $null = Resolve-SIAServiceUrl -Url 'https://sometenant.dpa.cyberark.cloud'
            }
            Should -Invoke -CommandName Find-SharedServicesURL -ModuleName $Script:SIAModuleName -ParameterFilter {
                $url -eq 'https://sometenant.dpa.cyberark.cloud'
            } -Times 1 -Exactly
        }

        It 'resolves both URLs from a supplied url' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $result = Resolve-SIAServiceUrl -Url 'https://sometenant.dpa.cyberark.cloud'
                $result.SIAUrl | Should -Be 'https://sometenant.dpa.cyberark.cloud'
                $result.IdentityUrl | Should -Be 'https://sometenant.id.cyberark.cloud'
            }
        }
    }

    Context 'Error handling' {

        It 'wraps a discovery failure in a descriptive error' {
            Mock -CommandName Find-SharedServicesURL -ModuleName $Script:SIAModuleName -MockWith {
                throw 'boom'
            }
            InModuleScope -ModuleName $Script:SIAModuleName {
                { Resolve-SIAServiceUrl -Subdomain 'sometenant' } |
                    Should -Throw "*Unable to resolve CyberArk shared services URLs from 'sometenant'*boom*"
            }
        }

        It 'throws when the discovery response has no identity_user_portal URL' {
            Mock -CommandName Find-SharedServicesURL -ModuleName $Script:SIAModuleName -MockWith {
                [pscustomobject]@{
                    jit                  = [pscustomobject]@{ api = 'https://sometenant.dpa.cyberark.cloud/api' }
                    identity_user_portal = [pscustomobject]@{ api = '' }
                }
            }
            InModuleScope -ModuleName $Script:SIAModuleName {
                { Resolve-SIAServiceUrl -Url 'https://sometenant.dpa.cyberark.cloud' } |
                    Should -Throw "*identity_user_portal*not found*"
            }
        }
    }
}
