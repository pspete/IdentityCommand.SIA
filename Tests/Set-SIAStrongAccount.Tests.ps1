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

Describe 'Set-SIAStrongAccount' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ 'secret_id' = 'value' }
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

        $Script:pw = ConvertTo-SecureString 'SomePassword' -AsPlainText -Force
    }

    Context 'Request' {

        It 'PUTs to /api/secrets/{secret_id}' {
            Set-SIAStrongAccount -secret_id '1234-abcd' -secret_name 'n' -secret_type ProvisionerUser -account_domain local
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                ($URI -eq 'https://somedomain.dpa.cyberark.cloud/api/secrets/1234-abcd') -and ($Method -eq 'PUT')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Vaulted account update with no credential change' {

        It 'sends no secret object' {
            Set-SIAStrongAccount -secret_id '1234-abcd' -secret_name 'MyVaulted' -secret_type PCloudAccount -account_domain 'some.domain.co.uk'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                ($request.is_active -eq $true) -and
                ($request.secret_name -eq 'MyVaulted') -and
                ($request.secret_type -eq 'PCloudAccount') -and
                ($request.secret_details.account_domain -eq 'some.domain.co.uk') -and
                ($request.secret_details.PSObject.Properties.Name -contains 'ephemeral_domain_user_data') -and
                ($request.PSObject.Properties.Name -notcontains 'secret')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Ephemeral domain user data' {

        It 'sends the supplied nested ephemeral_domain_user_data structure' {
            $edu = @{
                ephemeral_domain_user_location = 'SomeOU'
                domain_controller              = @{ domain_controller_name = 'SomeDC'; domain_controller_use_ldaps = $true }
                winrm_info                     = @{ use_winrm_for_https = $true; winrm_certificate = '1761475228622917' }
            }
            Set-SIAStrongAccount -secret_id '1234-abcd' -secret_name 'MyVaulted' -secret_type PCloudAccount -account_domain 'some.domain.co.uk' -ephemeral_domain_user_data $edu
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                ($request.secret_details.ephemeral_domain_user_data.ephemeral_domain_user_location -eq 'SomeOU') -and
                ($request.secret_details.ephemeral_domain_user_data.domain_controller.domain_controller_name -eq 'SomeDC') -and
                ($request.secret_details.ephemeral_domain_user_data.winrm_info.winrm_certificate -eq '1761475228622917')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Stored-in-SIA account update with a new password' {

        It 'sends a secret object with all four secret_data keys' {
            Set-SIAStrongAccount -secret_id '1234-abcd' -secret_name 'teststrong' -secret_type ProvisionerUser -account_domain local -username 'stronglocal' -password $Script:pw
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                ($request.secret.tenant_encrypted -eq $false) -and
                ($request.secret.secret_data.username -eq 'stronglocal') -and
                ($request.secret.secret_data.password -eq 'SomePassword') -and
                ($request.secret.secret_data.PSObject.Properties.Name -contains 'safe') -and
                ($request.secret.secret_data.PSObject.Properties.Name -contains 'account_name')
            } -Times 1 -Exactly -Scope It
        }
    }
}
