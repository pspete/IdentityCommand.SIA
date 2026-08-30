Describe $($PSCommandPath -Replace '.Tests.ps1') {

    BeforeAll {
        #Get Current Directory
        $Here = Split-Path -Parent $PSCommandPath

        #Assume ModuleName from Repository Root folder
        $ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

        #Resolve Path to Module Directory
        $ModulePath = Resolve-Path "$Here\..\$ModuleName"

        #Define Path to Module Manifest
        $ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

        if ( -not (Get-Module -Name $ModuleName -All)) {

            Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

        }

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

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

            $InputObject = [pscustomobject]@{
                'name' = 'SomeID'
            }

            Mock Invoke-IDRestMethod -MockWith {
                [pscustomobject]@{'target_sets' = 'value' }
            }


            $response = $InputObject | Remove-SIATargetSet

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -contains 'https://somedomain.dpa.cyberark.cloud/api/discovery/targetsets/SomeID'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint for bulk target sets' {
                Remove-SIATargetSet -Name somename, someothername
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -contains 'https://somedomain.dpa.cyberark.cloud/api/discovery/targetsets/bulk'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'DELETE' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with no body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -eq $null } -Times 1 -Exactly -Scope It

            }

            It 'sends request with body if multiple names are specified' {
                Remove-SIATargetSet -Name somename, someothername

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -ne $null } -Times 1 -Exactly -Scope It

            }

        }

    }

}