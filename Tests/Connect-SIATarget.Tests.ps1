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
                    'token' = [pscustomobject]@{'text' = 'value' }
                }
            }

            Mock ssh -MockWith {}
            Mock Get-Item -MockWith {}
            Mock Invoke-Item -MockWith {}
            Mock Get-SIAModuleData -MockWith {
                [ordered]@{
                    'tenant_url' = 'https://sometenant.dpa.cyberark.cloud'
                    'user'       = 'someuser@somedomain.com'
                }
            }

        }

        AfterAll {
            Remove-Item -Path $(Join-Path $([System.IO.Path]::GetTempPath()) 'dpa _a SomeCPU.rdp') -Force -ErrorAction SilentlyContinue
            Remove-Item -Path $(Join-Path $([System.IO.Path]::GetTempPath()) 'dpa _a SomeCPU _d SomeDomain.rdp') -Force -ErrorAction SilentlyContinue
        }

        Context 'Input - RDP - Vaulted Creds' {
            BeforeEach {
                $response = Connect-SIATarget -RDP -targetUser SomeUser -targetAddress SomeCPU -targetDomain SomeDomain -logicalName SomeNet -elevatedPrivileges $true
            }
            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/adb/sso/acquire'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.service -eq 'DPA-RDP'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenResponseFormat -eq 'extended'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenType -eq 'rdp_file'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenParameters.targetUser -eq 'SomeUser'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenParameters.targetAddress -eq 'SomeCPU'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenParameters.targetDomain -eq 'SomeDomain'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenParameters.logicalName -eq 'SomeNet'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenParameters.elevatedPrivileges -eq $true

                } -Times 1 -Exactly -Scope It

            }

            It 'outputs expected rdp file' {
                Test-Path -Path $(Join-Path $([System.IO.Path]::GetTempPath()) 'dpa _a SomeCPU _d SomeDomain.rdp') | Should -BeTrue
            }

        }

        Context 'Input - RDP - ZSP' {
            BeforeEach {
                $response = Connect-SIATarget -RDP -targetAddress SomeCPU
            }
            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/adb/sso/acquire'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.service -eq 'DPA-RDP'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenResponseFormat -eq 'extended'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenType -eq 'rdp_file'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Request = $Body | ConvertFrom-Json
                    $Request.tokenParameters.targetAddress -eq 'SomeCPU'

                } -Times 1 -Exactly -Scope It

            }

            It 'outputs expected rdp file' {
                Test-Path -Path $(Join-Path $([System.IO.Path]::GetTempPath()) 'dpa _a SomeCPU.rdp') | Should -BeTrue
            }

        }

        Context 'Input - SSH - Vaulted Creds' {

            It 'does not send a request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 0 -Exactly -Scope It

            }

            It 'Invokes expected SSH command - all parameters' {
                Connect-SIATarget -SSH -targetUser SomeUser -targetAddress SomeCPU -targetDomain SomeDomain -logicalName SomeNet
                Assert-MockCalled ssh -ParameterFilter {

                    $args[0] -eq 'someuser@somedomain.com#sometenant@SomeUser#SomeDomain@SomeCPU#SomeNet@sometenant.ssh.cyberark.cloud'

                } -Times 1 -Exactly -Scope It

            }

            It 'Invokes expected SSH command - mandatory parameters' {
                Connect-SIATarget -SSH -targetUser SomeUser -targetAddress SomeCPU
                Assert-MockCalled ssh -ParameterFilter {

                    $args[0] -eq 'someuser@somedomain.com#sometenant@SomeUser@SomeCPU@sometenant.ssh.cyberark.cloud'

                } -Times 1 -Exactly -Scope It

            }

            It 'Invokes expected SSH command - optional domain' {
                Connect-SIATarget -SSH -targetUser SomeUser -targetAddress SomeCPU -targetDomain SomeDomain
                Assert-MockCalled ssh -ParameterFilter {

                    $args[0] -eq 'someuser@somedomain.com#sometenant@SomeUser#SomeDomain@SomeCPU@sometenant.ssh.cyberark.cloud'

                } -Times 1 -Exactly -Scope It

            }

            It 'Invokes expected SSH command - optional logicalName' {
                Connect-SIATarget -SSH -targetUser SomeUser -targetAddress SomeCPU -logicalName SomeNet
                Assert-MockCalled ssh -ParameterFilter {

                    $args[0] -eq 'someuser@somedomain.com#sometenant@SomeUser@SomeCPU#SomeNet@sometenant.ssh.cyberark.cloud'

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Input - SSH - ZSP' {
            BeforeEach {
                Connect-SIATarget -SSH -targetAddress SomeCPU
            }
            It 'does not send a request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 0 -Exactly -Scope It

            }

            It 'Invokes expected SSH command' {

                Assert-MockCalled ssh -ParameterFilter {

                    $args[0] -eq 'someuser@somedomain.com#sometenant@SomeCPU@sometenant.ssh.cyberark.cloud'

                } -Times 1 -Exactly -Scope It

            }

        }

    }

}