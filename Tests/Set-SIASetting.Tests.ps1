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

Describe 'Set-SIASetting' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ 'SomeProperty' = 'Value' }
        }

        InModuleScope -ModuleName $Script:SIAModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.dpa.cyberark.cloud'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = Set-SIASetting -rdpRecording -enabled $true
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/settings/'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $Method -eq 'PATCH'
            } -Times 1 -Exactly -Scope It
        }

        It 'nests the supplied sub-setting under the feature name' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($Body | ConvertFrom-Json).rdpRecording.enabled -eq $true
            } -Times 1 -Exactly -Scope It
        }

        It 'sends only the target feature in the body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                @($Body | ConvertFrom-Json | ForEach-Object { $_.PSObject.Properties.Name }).Count -eq 1
            } -Times 1 -Exactly -Scope It
        }

        It 'does not read existing settings' {
            Mock -CommandName Get-SIASetting -ModuleName $Script:SIAModuleName -MockWith {}
            Set-SIASetting -rdpRecording -enabled $true
            Should -Invoke -CommandName Get-SIASetting -ModuleName $Script:SIAModuleName -Times 0 -Exactly -Scope It
        }

        It 'sends only supplied sub-settings for a multi-field feature' {
            Set-SIASetting -standingAccess -sessionIdleTime 20
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.standingAccess.sessionIdleTime -eq 20) -and
                (@($request.standingAccess.PSObject.Properties.Name).Count -eq 1)
            } -Times 1 -Exactly -Scope It
        }

        It 'maps -logonSequenceValue to the logonSequence API field' {
            Set-SIASetting -logonSequence -logonSequenceValue 'su - {Username}'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.logonSequence.logonSequence -eq 'su - {Username}') -and
                ($null -eq $request.logonSequence.logonSequenceValue)
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Validation' {

        It 'rejects <Parameter> value <Value>' -TestCases @(
            @{ Parameter = 'keyExpirationTimeSec'; Switch = 'sshMfaCaching'; Value = 60 }
            @{ Parameter = 'keyExpirationTimeSec'; Switch = 'sshMfaCaching'; Value = 50000 }
            @{ Parameter = 'sessionMaxDuration'; Switch = 'standingAccess'; Value = 30 }
            @{ Parameter = 'sessionMaxDuration'; Switch = 'standingAccess'; Value = 2000 }
            @{ Parameter = 'sessionIdleTime'; Switch = 'standingAccess'; Value = 0 }
            @{ Parameter = 'sessionIdleTime'; Switch = 'standingAccess'; Value = 121 }
        ) {
            $params = @{ $Switch = $true; $Parameter = $Value }
            { Set-SIASetting @params } | Should -Throw
        }

        It 'accepts <Parameter> value <Value>' -TestCases @(
            @{ Parameter = 'keyExpirationTimeSec'; Switch = 'sshMfaCaching'; Value = 7200 }
            @{ Parameter = 'sessionMaxDuration'; Switch = 'standingAccess'; Value = 120 }
            @{ Parameter = 'sessionIdleTime'; Switch = 'standingAccess'; Value = 20 }
        ) {
            $params = @{ $Switch = $true; $Parameter = $Value }
            { Set-SIASetting @params } | Should -Not -Throw
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }
    }
}
