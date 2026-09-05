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

Describe 'Get-SIADatabaseTarget' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{
                'items'      = @(
                    [pscustomobject]@{ 'id' = 'd5fc1473'; 'name' = 'WideWorldImporters'; 'family' = 'MSSQL'; 'secretId' = 'b611be89' }
                    [pscustomobject]@{ 'id' = 'c2b799f4'; 'name' = 'northwind'; 'family' = 'Postgres'; 'secretId' = '910c7a20' }
                )
                'totalCount' = 2
                'nextCursor' = $null
            }
        }

        InModuleScope -ModuleName $Script:SIAModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.dpa.cyberark.cloud'
                User       = $null
                TenantId   = 'SomeTenant'
                SessionId  = 'SomeSession'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = Get-SIADatabaseTarget
    }

    Context 'Request' {

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/database-targets'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $Method -eq 'GET' } -Times 1 -Exactly -Scope It
        }

        It 'sends request with no body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $null -eq $Body } -Times 1 -Exactly -Scope It
        }

        It 'passes limit as a query parameter' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.dpa.cyberark.cloud' }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            }
            Get-SIADatabaseTarget -limit 1000
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -match 'limit=1000'
            } -Times 1 -Exactly -Scope It
        }

        It 'follows nextCursor to collect subsequent pages' {
            InModuleScope -ModuleName $Script:SIAModuleName {
                $ISPSSSession = [ordered]@{ tenant_url = 'https://somedomain.dpa.cyberark.cloud' }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            }

            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -notmatch 'cursor='
            } -MockWith {
                [pscustomobject]@{
                    'items'      = @([pscustomobject]@{ 'id' = 'd5fc1473'; 'name' = 'WideWorldImporters' })
                    'totalCount' = 2
                    'nextCursor' = 'page2token'
                }
            }

            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -match 'cursor=page2token'
            } -MockWith {
                [pscustomobject]@{
                    'items'      = @([pscustomobject]@{ 'id' = 'c2b799f4'; 'name' = 'northwind' })
                    'totalCount' = 2
                    'nextCursor' = $null
                }
            }

            $result = Get-SIADatabaseTarget

            $result.Count | Should -Be 2
            $result.name | Should -Contain 'northwind'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -match 'cursor=page2token'
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'returns the items collection' {
            $Script:response.name | Should -Contain 'WideWorldImporters'
            $Script:response.Count | Should -Be 2
        }
    }
}
