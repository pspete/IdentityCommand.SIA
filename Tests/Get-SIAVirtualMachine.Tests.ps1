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

Describe 'Get-SIAVirtualMachine' {

    BeforeEach {

        #A single page: the API reports the pagination token as cloud_N|onprem_M and never as an
        #empty value, so a mock which returns a token alongside items on every call would page forever
        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{
                'items'      = @([pscustomobject]@{ machineId = 'i-02bcf1723f4509c12' })
                'totalCount' = 1
                'nextToken'  = $null
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

        $InputObject = [pscustomobject]@{
            filter = "(locationType eq 'AWS')"
            source = 'CLOUD'
            sort   = 'name ASC'
            search = 'prod'
        }
        $Script:response = $InputObject | Get-SIAVirtualMachine
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint with query string' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($URI -like 'https://somedomain.dpa.cyberark.cloud/api/infrastructure/virtual-machines`?*') -and
                ($URI -match 'source=CLOUD') -and
                ($URI -match 'search=prod')
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $Method -eq 'GET'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends request with no body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $null -eq $Body
            } -Times 1 -Exactly -Scope It
        }

        It 'sends no request when no parameters are provided beyond the endpoint' {
            $null = Get-SIAVirtualMachine
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/infrastructure/virtual-machines'
            } -Times 1 -Exactly -Scope It
        }

        It 'stops paging at the first page which returns no items' {
            #The API reports a token unconditionally - cloud_0|onprem_0 once the set is exhausted - so
            #the empty page is what ends paging, after a single request carrying the token
            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
                [pscustomobject]@{ 'items' = @(); 'nextToken' = 'cloud_0|onprem_0' }
            }
            $null = Get-SIAVirtualMachine
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -match 'next_token'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the pagination token as next_token when following a page' {
            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
                [pscustomobject]@{ 'items' = @(); 'nextToken' = $null }
            } -ParameterFilter { $URI -match 'next_token' }
            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
                [pscustomobject]@{
                    'items'     = @([pscustomobject]@{ machineId = 'i-02bcf1723f4509c12' })
                    'nextToken' = 'cloud_100|onprem_0'
                }
            } -ParameterFilter { $URI -notmatch 'next_token' }

            $null = Get-SIAVirtualMachine

            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -match 'next_token=cloud_100%7Conprem_0|next_token=cloud_100\|onprem_0'
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }

        It 'outputs the items of the response' {
            $Script:response.machineId | Should -Be 'i-02bcf1723f4509c12'
        }
    }
}
