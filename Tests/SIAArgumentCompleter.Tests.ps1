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

Describe 'Get-SIACompletionResult' {

    It 'returns a CompletionResult for a prefix match on the value' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $items = @(
                [pscustomobject]@{ connectorId = 'c-111'; name = 'EU-Connector' }
                [pscustomobject]@{ connectorId = 'c-222'; name = 'US-Connector' }
            )
            $result = $items | Get-SIACompletionResult -WordToComplete 'c-2' -ValueProperty 'connectorId', 'id' -LabelProperty 'name'
            $result | Should -HaveCount 1
            $result | Should -BeOfType ([System.Management.Automation.CompletionResult])
            $result.CompletionText | Should -Be 'c-222'
            $result.ToolTip | Should -Be 'US-Connector (c-222)'
        }
    }

    It 'also matches on the label' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $items = @([pscustomobject]@{ connectorId = 'c-111'; name = 'EU-Connector' })
            $result = $items | Get-SIACompletionResult -WordToComplete 'EU' -ValueProperty 'connectorId' -LabelProperty 'name'
            $result.CompletionText | Should -Be 'c-111'
        }
    }

    It 'falls back through the value property list' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $items = @([pscustomobject]@{ id = 'fallback-id'; name = 'X' })
            $result = $items | Get-SIACompletionResult -WordToComplete '' -ValueProperty 'connectorId', 'id' -LabelProperty 'name'
            $result.CompletionText | Should -Be 'fallback-id'
        }
    }

    It 'single quotes a value containing whitespace' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $items = @([pscustomobject]@{ name = 'target set one' })
            $result = $items | Get-SIACompletionResult -WordToComplete '' -ValueProperty 'name'
            $result.CompletionText | Should -Be "'target set one'"
        }
    }

    It 'returns nothing when no candidate property holds a value' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $items = @([pscustomobject]@{ other = 'x' })
            $items | Get-SIACompletionResult -WordToComplete '' -ValueProperty 'connectorId', 'id' | Should -BeNullOrEmpty
        }
    }
}

Describe 'connector_id / id alias' {

    It '<Command> accepts -id as an alias for -connector_id' -TestCases @(
        @{ Command = 'Get-SIAConnector' }
        @{ Command = 'Remove-SIAConnector' }
        @{ Command = 'Update-SIAConnector' }
        @{ Command = 'Test-SIAConnector' }
        @{ Command = 'Set-SIAConnectorMaintenanceMode' }
        @{ Command = 'Invoke-SIAConnectorCertificateRotation' }
    ) {
        param($Command)
        (Get-Command $Command).Parameters['connector_id'].Aliases | Should -Contain 'id'
    }

    It 'binds Get-SIAConnector output to Remove-SIAConnector by the id property' {
        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith { }
        InModuleScope -ModuleName $Script:SIAModuleName {
            New-Variable -Name ISPSSSession -Value ([ordered]@{ tenant_url = 'https://x.cyberark.cloud' }) -Scope Script -Force
        }

        [pscustomobject]@{ id = 'c-999'; name = 'X' } | Remove-SIAConnector -Confirm:$false

        Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
            $URI -match '/api/connectors/c-999'
        } -Times 1 -Exactly
    }
}

Describe 'connector_id argument completer' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ items = @(
                    [pscustomobject]@{ id = 'c-111'; name = 'EU-Connector' }
                    [pscustomobject]@{ id = 'c-222'; name = 'US-Connector' }
                ) }
        }

        InModuleScope -ModuleName $Script:SIAModuleName {
            $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.dpa.cyberark.cloud' }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }
    }

    It 'completes <Command> -<Parameter> from Get-SIAConnector' -TestCases @(
        @{ Command = 'Get-SIAConnector'; Parameter = 'connector_id' }
        @{ Command = 'Remove-SIAConnector'; Parameter = 'connector_id' }
        @{ Command = 'Update-SIAConnector'; Parameter = 'connector_id' }
        @{ Command = 'Test-SIAConnector'; Parameter = 'connector_id' }
        @{ Command = 'Set-SIAConnectorMaintenanceMode'; Parameter = 'connector_id' }
        @{ Command = 'Invoke-SIAConnectorCertificateRotation'; Parameter = 'connector_id' }
        @{ Command = 'Add-SIAConnectorPoolMember'; Parameter = 'connectorId' }
    ) {
        param($Command, $Parameter)
        $line = "$Command -$Parameter "
        $completions = (TabExpansion2 -inputScript $line -cursorColumn $line.Length).CompletionMatches
        $completions.CompletionText | Should -Contain 'c-111'
        $completions.CompletionText | Should -Contain 'c-222'
    }

    It 'filters by the word being completed' {
        $line = 'Remove-SIAConnector -connector_id c-2'
        $completions = (TabExpansion2 -inputScript $line -cursorColumn $line.Length).CompletionMatches
        $completions.CompletionText | Should -Be 'c-222'
    }

    It 'is silent when there is no active session' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            New-Variable -Name ISPSSSession -Value ([ordered]@{ tenant_url = $null }) -Scope Script -Force
        }
        $line = 'Remove-SIAConnector -connector_id '
        $completions = (TabExpansion2 -inputScript $line -cursorColumn $line.Length).CompletionMatches
        $completions.CompletionText | Should -Not -Contain 'c-111'
    }
}
