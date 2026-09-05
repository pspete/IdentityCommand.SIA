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

        Context 'General Operation' {

            It 'outputs expected object - OnPrem' {
                $FQDNRule = New-SIAPolicyFQDNRuleDefinition -operator 'EXACTLY' -computernamePattern SomeName -domain SomeDomain
                $Object = New-SIAPolicyProviderDefinition -OnPrem -fqdnRulesConjunction OR -fqdnRules $FQDNrule
                $Object.OnPrem | Should -Not -BeNullOrEmpty
                $Object.OnPrem.fqdnRulesConjunction | Should -Be 'OR'
                $Object.OnPrem.fqdnRules | Should -Be $FQDNRule
                ($Object | Get-Member).TypeName | Select-Object -Unique | Should -Be 'IdCmd.SIA.Definition.Policy.Provider'
            }

            It 'outputs expected object - AWS' {
                $Object = New-SIAPolicyProviderDefinition -AWS -regions 'us-east-1', 'us-east-2' -tags @{'Key' = 'env'; 'Value' = @('prod') }
                $Object.AWS | Should -Not -BeNullOrEmpty
                $Object.AWS.regions | Should -HaveCount 2
                $Object.AWS.tags | Should -BeOfType '[hashtable]'
                ($Object | Get-Member).TypeName | Select-Object -Unique | Should -Be 'IdCmd.SIA.Definition.Policy.Provider'
            }

            It 'outputs expected object - Azure' {
                $Object = New-SIAPolicyProviderDefinition -Azure -regions 'eastus2', 'eastus' -tags @{'Key' = 'env'; 'Value' = @('prod') }
                $Object.Azure | Should -Not -BeNullOrEmpty
                $Object.Azure.regions | Should -HaveCount 2
                $Object.Azure.tags | Should -BeOfType '[hashtable]'
                ($Object | Get-Member).TypeName | Select-Object -Unique | Should -Be 'IdCmd.SIA.Definition.Policy.Provider'
            }

            It 'outputs expected object - GCP' {
                $Object = New-SIAPolicyProviderDefinition -GCP -regions 'asia-east1', 'us-east1' -labels @{'Key' = 'env'; 'Value' = @('prod') }
                $Object.GCP | Should -Not -BeNullOrEmpty
                $Object.GCP.regions | Should -HaveCount 2
                $Object.GCP.labels | Should -BeOfType '[hashtable]'
                ($Object | Get-Member).TypeName | Select-Object -Unique | Should -Be 'IdCmd.SIA.Definition.Policy.Provider'
            }

            It 'outputs expected object - Multiple Providers' {
                $FQDNRule = New-SIAPolicyFQDNRuleDefinition -operator 'EXACTLY' -computernamePattern SomeName -domain SomeDomain
                $Object = New-SIAPolicyProviderDefinition -OnPrem -fqdnRulesConjunction OR -fqdnRules $FQDNrule
                $Object = New-SIAPolicyProviderDefinition -AWS -regions 'us-east-1', 'us-east-2' -tags @{'Key' = 'env'; 'Value' = @('prod') } -ProviderDefinition $Object
                $Object = New-SIAPolicyProviderDefinition -Azure -regions 'eastus2', 'eastus' -tags @{'Key' = 'env'; 'Value' = @('prod') } -ProviderDefinition $Object
                $Object = New-SIAPolicyProviderDefinition -GCP -regions 'asia-east1', 'us-east1' -labels @{'Key' = 'env'; 'Value' = @('prod') } -ProviderDefinition $Object

                $Object.OnPrem | Should -Not -BeNullOrEmpty
                $Object.OnPrem.fqdnRulesConjunction | Should -Be 'OR'
                $Object.OnPrem.fqdnRules | Should -Be $FQDNRule
                $Object.AWS | Should -Not -BeNullOrEmpty
                $Object.AWS.regions | Should -HaveCount 2
                $Object.AWS.tags | Should -BeOfType '[hashtable]'
                $Object.Azure | Should -Not -BeNullOrEmpty
                $Object.Azure.regions | Should -HaveCount 2
                $Object.Azure.tags | Should -BeOfType '[hashtable]'
                $Object.GCP | Should -Not -BeNullOrEmpty
                $Object.GCP.regions | Should -HaveCount 2
                $Object.GCP.labels | Should -BeOfType '[hashtable]'
                ($Object | Get-Member).TypeName | Select-Object -Unique | Should -Be 'IdCmd.SIA.Definition.Policy.Provider'
            }

        }

    }

}