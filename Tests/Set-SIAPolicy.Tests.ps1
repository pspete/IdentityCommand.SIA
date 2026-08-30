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

Describe 'Set-SIAPolicy' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ 'policyId' = 'value' }
        }

        Mock -CommandName Get-SIAPolicy -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{
                'policyId'        = 'SomeID'
                'policyName'      = 'SomePolicy'
                'policyType'      = 'VM'
                'status'          = 'SomeStatus'
                'description'     = 'Some Description'
                'providersData'   = @{ 'provider' = 'data' }
                'startDate'       = '1925-10-08'
                'endDate'         = '2023-01-22'
                'userAccessRules' = @(@{ 'Access' = 'Rule' })
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

        $ConnectAs1 = New-SIAPolicyConnectAsDefinition -OnPrem -assignGroups Administrators
        $ConnectAs1 = New-SIAPolicyConnectAsDefinition -AWS -ssh 'ec2-user' -assignGroups Administrators, 'Remote Desktop Users' -connectAsDefinition $ConnectAs1
        $ConnectAs2 = New-SIAPolicyConnectAsDefinition -Azure -ssh 'azureuser' -connectAsDefinition $ConnectAs1
        $ConnectAs2 = New-SIAPolicyConnectAsDefinition -GCP -ssh 'root' -connectAsDefinition $ConnectAs2

        $UserData = New-SIAPolicyUserDataDefinition -Role -Name 'DEV_TEAM_ROLE'
        $UserData = New-SIAPolicyUserDataDefinition -Group -Name 'DEV_TEAM_GROUP' -UserDataDefinition $UserData

        $Script:AccessRules = @()
        $Script:AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName SomeAccessRule -userData $UserData -connectAs $ConnectAs1 -timeZone Europe/London
        $Script:AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName AnotherAccessRule -userData $UserData -connectAs $ConnectAs2 -timeZone America/Costa_Rica

        $FQDNrules = @()
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator EXACTLY -computernamePattern SomeHost -domain SomeDomain.com
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator WILDCARD -computernamePattern *-DEV-* -domain SomeDomain.com
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator SUFFIX -computernamePattern '-Prod' -domain SomeDomain.com
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator CONTAINS -computernamePattern SQL -domain SomeDomain.com
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator PREFIX -computernamePattern DC1 -domain SomeDomain.com

        $Script:Providers = New-SIAPolicyProviderDefinition -OnPrem -fqdnRulesConjunction OR -fqdnRules $FQDNrules
        $Script:Providers = New-SIAPolicyProviderDefinition -AWS -regions 'us-east-1', 'us-east-2' -tags @{ 'Key' = 'env'; 'Value' = @('prod') } -ProviderDefinition $Script:Providers
        $Script:Providers = New-SIAPolicyProviderDefinition -Azure -regions 'eastus2', 'eastus' -tags @{ 'Key' = 'env'; 'Value' = @('prod') } -ProviderDefinition $Script:Providers
        $Script:Providers = New-SIAPolicyProviderDefinition -GCP -regions 'asia-east1', 'us-east1' -labels @{ 'Key' = 'env'; 'Value' = @('prod') } -ProviderDefinition $Script:Providers
    }

    Context 'General' {

        BeforeEach {
            Set-SIAPolicy -policyId SomeID -status Enabled
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/access-policies/SomeID'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $Method -eq 'PUT' } -Times 1 -Exactly -Scope It
        }

        It 'gets the existing policy' {
            Should -Invoke -CommandName Get-SIAPolicy -ModuleName $Script:SIAModuleName -Times 1 -Exactly -Scope It
        }

        It 'merges existing values and sends the expected body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.policyName -eq 'SomePolicy') -and
                ($request.policyType -eq 'VM') -and
                ($request.status -eq 'Enabled') -and
                ($request.description -eq 'Some Description') -and
                ($request.startDate -eq '1925-10-08') -and
                ($request.endDate -eq '2023-01-22') -and
                ($request.providersData.provider -eq 'data') -and
                ($request.userAccessRules[0].Access -eq 'Rule')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Providers update' {

        It 'sends the supplied providersData' {
            Set-SIAPolicy -policyId 1234-abcd -providersData $Script:Providers
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                (($request.providersData.OnPrem.fqdnRules.computernamePattern).count -eq 5) -and
                ($request.providersData.AWS.tags.Key -eq 'env') -and
                ($request.providersData.Azure.tags.Key -eq 'env') -and
                ($request.providersData.GCP.labels.Key -eq 'env')
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'User access rule update' {

        It 'sends the supplied userAccessRules' {
            Set-SIAPolicy -policyId 1234-abcd -userAccessRules $Script:AccessRules
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.userAccessRules[0].ruleName -eq 'SomeAccessRule') -and
                ($request.userAccessRules[1].ruleName -eq 'AnotherAccessRule') -and
                ($request.userAccessRules[0].connectionInformation.connectAs.AWS.ssh -eq 'ec2-user') -and
                ($request.userAccessRules[1].connectionInformation.connectAs.AWS.rdp.localEphemeralUser.assignGroups -contains 'Remote Desktop Users')
            } -Times 1 -Exactly -Scope It
        }
    }
}
