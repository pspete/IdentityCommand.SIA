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

Describe 'ConvertTo-SIASecretBody' {

    It 'returns a UTF8 byte array' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $result = @{ 'password' = 'SomeSecret' } | ConvertTo-SIASecretBody
            $result -is [byte[]] | Should -BeTrue
        }
    }

    It 'round-trips the object through JSON' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $body = [ordered]@{ 'name' = 'acct'; 'secret' = @{ 'password' = 'p' } } | ConvertTo-SIASecretBody
            $request = [System.Text.Encoding]::UTF8.GetString($body) | ConvertFrom-Json
            $request.name | Should -Be 'acct'
            $request.secret.password | Should -Be 'p'
        }
    }

    It 'restores an -EmptyArrayProperty to []' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $body = [ordered]@{ 'domains' = @() } | ConvertTo-SIASecretBody -EmptyArrayProperty domains
            $json = [System.Text.Encoding]::UTF8.GetString($body)
            $json | Should -Match '"domains"\s*:\s*\[\]'
        }
    }

    It 'leaves other empty-string values untouched' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $body = [ordered]@{ 'domains' = @(); 'domain' = '' } | ConvertTo-SIASecretBody -EmptyArrayProperty domains
            $json = [System.Text.Encoding]::UTF8.GetString($body)
            $json | Should -Match '"domain"\s*:\s*""'
        }
    }

    It 'honours -Depth for nested structures' {
        InModuleScope -ModuleName $Script:SIAModuleName {
            $deep = [ordered]@{ l1 = [ordered]@{ l2 = [ordered]@{ l3 = [ordered]@{ l4 = 'value' } } } }
            $request = [System.Text.Encoding]::UTF8.GetString(($deep | ConvertTo-SIASecretBody -Depth 8)) | ConvertFrom-Json
            $request.l1.l2.l3.l4 | Should -Be 'value'
        }
    }
}
