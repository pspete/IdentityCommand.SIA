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
                [pscustomobject]@{
                    'SomeProperty' = 'Value'
                }
            }

            Mock Get-SIASetting -MockWith {
                [pscustomobject]@{
                    'mfaCaching'            = 'Existing'
                    'sshMfaCaching'         = $null
                    'rdpMfaCaching'         = $null
                    'adbMfaCaching'         = $null
                    'k8sMfaCaching'         = $null
                    'sshCommandAudit'       = $null
                    'standingAccess'        = $null
                    'rdpFileTransfer'       = $null
                    'certificateValidation' = $null
                    'rdpKeyboardLayout'     = $null
                    'rdpRecording'          = [pscustomobject]@{'enabled' = $false }
                }
            }

            $response = Set-SIASetting -rdpRecording -enabled $true

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/settings/'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'PATCH' } -Times 1 -Exactly -Scope It

            }

            It 'Gets existing setting values' {
                Assert-MockCalled Get-SIASetting -Times 1 -Exactly -Scope It
            }

            It 'sends request with body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -ne $null } -Times 1 -Exactly -Scope It

            }

            It 'sends expected updated setting in body' {
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $($Body | ConvertFrom-Json).rdpRecording.enabled -eq $true
                } -Times 1 -Exactly -Scope It
            }

            It 'sends expected existing setting in body' {
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $($Body | ConvertFrom-Json).mfaCaching -eq 'Existing'
                } -Times 1 -Exactly -Scope It
            }

        }

        Context 'Output' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

    }

}