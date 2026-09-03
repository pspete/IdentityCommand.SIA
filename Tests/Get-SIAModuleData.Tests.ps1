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
                LastError          = $null
                LastErrorTime      = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

            $response = Get-SIAModuleData

        }

        Context 'General' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'has output with expected number of properties' {

                $response.Keys.Count | Should -Be 12

            }

            It 'outputs object with expected typename' {

                $response | Get-Member | Select-Object -ExpandProperty typename -Unique | Should -Be IdCmd.Session

            }

        }

    }

}