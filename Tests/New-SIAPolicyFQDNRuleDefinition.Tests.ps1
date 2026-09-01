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

        Context 'General Operation' {

            It 'outputs expected object' {
                $Object = New-SIAPolicyFQDNRuleDefinition -operator 'EXACTLY' -computernamePattern SomeName -domain SomeDomain
                $Object | Should -Not -BeNullOrEmpty
                $Object.operator | Should -Be 'EXACTLY'
                $Object.computernamePattern | Should -Be 'SomeName'
                $Object.domain | Should -Be 'SomeDomain'
                ($Object | Get-Member).TypeName | Select-Object -Unique | Should -Be 'IdCmd.SIA.Definition.Policy.Provider.FQDNRule'
            }

        }

    }

}