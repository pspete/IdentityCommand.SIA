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
            [pscustomobject]@{ 'target_set' = [pscustomobject]@{ 'name' = 'abc12' } }
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
            'name'                          = 'abc12'
            'enable_certificate_validation' = $true
            'secret_type'                   = 'ProvisionerUser'
            'secret_id'                     = '7e8a372f-c610-42a8-8f10-9c764d7a32ba'
            'type'                          = 'Suffix'
        }
        $Script:response = $InputObject | Add-SIATargetSet
    }

    Context 'Request' {

        It 'POSTs to /api/targetsets' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($URI -eq 'https://somedomain.dpa.cyberark.cloud/api/targetsets') -and ($Method -eq 'POST')
            } -Times 1 -Exactly -Scope It
        }

        It 'sends a single flat target set body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.name -eq 'abc12') -and
                ($request.secret_type -eq 'ProvisionerUser') -and
                ($request.secret_id -eq '7e8a372f-c610-42a8-8f10-9c764d7a32ba') -and
                ($request.type -eq 'Suffix') -and
                ($request.enable_certificate_validation -eq $true) -and
                ($request.PSObject.Properties.Name -notcontains 'target_sets_mapping')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'returns the target_set property' {
            $Script:response.name | Should -Be 'abc12'
        }
    }
}
