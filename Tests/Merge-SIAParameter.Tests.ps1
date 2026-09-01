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

Describe 'Merge-SIAParameter' {

    It 'takes the bound value when supplied' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $template = [ordered]@{ a = 'default-a'; b = 'default-b' }
            $result = Merge-SIAParameter -Template $template -BoundParameter @{ a = 'bound-a' }
            $result['a'] | Should -Be 'bound-a'
        }
    }

    It 'falls back to the template default when no fallback is supplied' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $template = [ordered]@{ a = 'default-a'; b = 'default-b' }
            $result = Merge-SIAParameter -Template $template -BoundParameter @{ a = 'bound-a' }
            $result['b'] | Should -Be 'default-b'
        }
    }

    It 'falls back to the -Fallback object property for unbound keys' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $template = [ordered]@{ a = 'default-a'; b = 'default-b' }
            $existing = [pscustomobject]@{ a = 'existing-a'; b = 'existing-b' }
            $result = Merge-SIAParameter -Template $template -BoundParameter @{ a = 'bound-a' } -Fallback $existing
            $result['a'] | Should -Be 'bound-a'
            $result['b'] | Should -Be 'existing-b'
        }
    }

    It 'uses $null from -Fallback rather than the template default when the property is missing' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $template = [ordered]@{ a = 'default-a'; b = 'default-b' }
            $existing = [pscustomobject]@{ a = 'existing-a' }
            $result = Merge-SIAParameter -Template $template -BoundParameter @{ } -Fallback $existing
            $result['b'] | Should -BeNullOrEmpty
        }
    }

    It 'preserves template key order' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $template = [ordered]@{ z = 1; m = 2; a = 3 }
            $result = Merge-SIAParameter -Template $template -BoundParameter @{ m = 99 }
            @($result.Keys) | Should -Be @('z', 'm', 'a')
        }
    }

    It 'returns an ordered dictionary' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $result = Merge-SIAParameter -Template ([ordered]@{ a = 1 }) -BoundParameter @{ }
            $result -is [System.Collections.Specialized.OrderedDictionary] | Should -BeTrue
        }
    }
}
