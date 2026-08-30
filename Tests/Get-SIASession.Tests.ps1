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

            Mock Invoke-IDRestMethod -MockWith {
                [pscustomobject]@{'items' = 'value' }
            }

            $EndDate = Get-Date -Day 3 -Month 3 -Year 2024 -Hour 0 -Minute 0 -Second 0 -Millisecond 0 #'03/03/2024 00:00:00'
            $StartDate = Get-Date -Day 1 -Month 3 -Year 2024 -Hour 0 -Minute 0 -Second 0 -Millisecond 0 #03/01/2024 00:00:00


        }

        Context 'Input' {

            BeforeEach {
                $response = Get-SIASession
            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'https://somedomain.dpa.cyberark.cloud/api/monitoring/sessions?'


                } -Times 1 -Exactly -Scope It



                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'maxStartedTime='


                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'minStartedTime='


                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match '&'


                } -Times 1 -Exactly -Scope It
            }

            It 'sends request with expected url escaped minStartedTime format' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'minStartedTime=\d{4}(:?-\d{2}){2}T\d{2}(?:%3A)\d{2}(?:%3A)\d{2}.\d{3}Z'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected url escaped maxStartTime format' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'maxStartedTime=\d{4}(:?-\d{2}){2}T\d{2}(?:%3A)\d{2}(?:%3A)\d{2}.\d{3}Z'


                } -Times 1 -Exactly -Scope It

            }

            It 'sends expected maxStartedTime value when date object provided' {
                Get-SIASession -maxStartedTime $EndDate
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'maxStartedTime=2024-03-03T00%3A00%3A00.000Z'


                } -Times 1 -Exactly -Scope It

            }

            It 'sends expected minStartedTime value when maxStartedTime date object provided' {
                Get-SIASession -maxStartedTime $EndDate
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'minStartedTime=2024-03-02T00%3A00%3A00.000Z'


                } -Times 1 -Exactly -Scope It

            }

            It 'sends expected minStartedTime & maxStartedTime values when date objects provided' {
                Get-SIASession -maxStartedTime $EndDate -minStartedTime $StartDate
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'minStartedTime=2024-03-01T00%3A00%3A00.000Z'


                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'maxStartedTime=2024-03-03T00%3A00%3A00.000Z'


                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'GET' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with no body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -eq $null } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {
            BeforeEach {
                $response = Get-SIASession
            }
            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

    }

}