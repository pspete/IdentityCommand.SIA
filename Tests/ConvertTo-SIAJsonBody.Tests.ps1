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

Describe 'ConvertTo-SIAJsonBody' {

    It 'returns a JSON string that round-trips' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $json = ConvertTo-SIAJsonBody -Body @{ name = 'acct'; enabled = $true }
            $json | Should -BeOfType [string]
            $request = $json | ConvertFrom-Json
            $request.name | Should -Be 'acct'
            $request.enabled | Should -BeTrue
        }
    }

    It 'keeps a single-element collection property as a JSON array' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $json = ConvertTo-SIAJsonBody -Body @{ connectors = @(@{ connectorId = 'solo' }) }
            $request = $json | ConvertFrom-Json
            @($request.connectors).Count | Should -Be 1
            $request.connectors[0].connectorId | Should -Be 'solo'
        }
    }

    It 'keeps a multi-element collection property as a JSON array' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $json = ConvertTo-SIAJsonBody -Body @{ connectors = @(@{ connectorId = 'a' }, @{ connectorId = 'b' }) }
            $request = $json | ConvertFrom-Json
            $request.connectors.Count | Should -Be 2
        }
    }

    It 'serialises a bool as a lowercase JSON literal' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $json = ConvertTo-SIAJsonBody -Body @{ checkBackendEndpoints = [bool]$false } -Compress
            $json | Should -Be '{"checkBackendEndpoints":false}'
        }
    }

    It 'honours -Depth' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $deep = @{ l1 = @{ l2 = @{ l3 = @{ l4 = 'value' } } } }
            $request = ConvertTo-SIAJsonBody -Body $deep -Depth 8 | ConvertFrom-Json
            $request.l1.l2.l3.l4 | Should -Be 'value'
        }
    }
}
