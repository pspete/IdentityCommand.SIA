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

Describe 'Add-SIATargetSet' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ 'results' = @([pscustomobject]@{ 'target_set_name' = 'somename'; 'success' = $true }) }
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
            'strong_account_id'             = 'StrongID'
            'name'                          = 'somename'
            'enable_certificate_validation' = $true
            'secret_type'                   = 'ProvisionerUser'
            'secret_id'                     = 'SomeID'
            'type'                          = 'Domain'
        }
        $Script:response = $InputObject | Add-SIATargetSet
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to the bulk endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/discovery/targetsets/bulk'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $Method -eq 'POST'
            } -Times 1 -Exactly -Scope It
        }

        It 'maps the target set to the strong account id in the request body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.target_sets_mapping[0].strong_account_id -eq 'StrongID') -and
                ($request.target_sets_mapping[0].target_sets[0].name -eq 'somename') -and
                ($request.target_sets_mapping[0].target_sets[0].provision_format -eq '<user>-<session-guid>')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }
    }
}
