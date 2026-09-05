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

            $EndDate = Get-Date -Day 3 -Month 3 -Year 2024 -Hour 0 -Minute 0 -Second 0 -Millisecond 0 #'03/03/2024 00:00:00'
            $StartDate = Get-Date -Day 1 -Month 3 -Year 2024 -Hour 0 -Minute 0 -Second 0 -Millisecond 0 #03/01/2024 00:00:00


        }

        Context 'Input' {

            BeforeEach {
                $response = Get-SIASession
            }

            It 'sends request' {

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'https://somedomain.dpa.cyberark.cloud/api/monitoring/sessions?'


                } -Times 1 -Exactly -Scope It



                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'maxStartedTime='


                } -Times 1 -Exactly -Scope It

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'minStartedTime='


                } -Times 1 -Exactly -Scope It

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match '&'


                } -Times 1 -Exactly -Scope It
            }

            It 'sends request with expected url escaped minStartedTime format' {

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'minStartedTime=\d{4}(:?-\d{2}){2}T\d{2}(?:%3A)\d{2}(?:%3A)\d{2}.\d{3}Z'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected url escaped maxStartTime format' {

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'maxStartedTime=\d{4}(:?-\d{2}){2}T\d{2}(?:%3A)\d{2}(?:%3A)\d{2}.\d{3}Z'


                } -Times 1 -Exactly -Scope It

            }

            It 'sends expected maxStartedTime value when date object provided' {
                Get-SIASession -maxStartedTime $EndDate
                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'maxStartedTime=2024-03-03T00%3A00%3A00.000Z'


                } -Times 1 -Exactly -Scope It

            }

            It 'sends expected minStartedTime value when maxStartedTime date object provided' {
                Get-SIASession -maxStartedTime $EndDate
                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'minStartedTime=2024-03-02T00%3A00%3A00.000Z'


                } -Times 1 -Exactly -Scope It

            }

            It 'sends expected minStartedTime & maxStartedTime values when date objects provided' {
                Get-SIASession -maxStartedTime $EndDate -minStartedTime $StartDate
                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'minStartedTime=2024-03-01T00%3A00%3A00.000Z'


                } -Times 1 -Exactly -Scope It

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'maxStartedTime=2024-03-03T00%3A00%3A00.000Z'


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
            BeforeEach {
                $response = Get-SIASession
            }
            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'Pagination stall guard' {

            It 'stops instead of duplicating when the server ignores the offset parameter' {

                #Confirmed live: /api/monitoring/sessions ignores limit/offset/pageSize entirely and
                #always returns the same full page - this mock reproduces that by returning the same
                #items regardless of the offset requested, with a totalCount higher than the page size.
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{
                        'items'      = @(
                            [pscustomobject]@{ session_id = 'sess-1' }
                            [pscustomobject]@{ session_id = 'sess-2' }
                        )
                        'totalCount' = 5
                    }
                }

                $response = Get-SIASession

                $response.Count | Should -Be 2
                Should -Invoke -CommandName Invoke-IDRestMethod -Times 2 -Exactly -Scope It

            }

        }

    }

}