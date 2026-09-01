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

Describe 'New-SIAPolicy' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -MockWith {
            [pscustomobject]@{ 'policyId' = 'value' }
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
        $UserData = New-SIAPolicyUserDataDefinition -Role -Name 'SOME_TEAM_ROLE' -UserDataDefinition $UserData
        $UserData = New-SIAPolicyUserDataDefinition -Group -Name 'DEV_TEAM_GROUP' -UserDataDefinition $UserData
        $UserData = New-SIAPolicyUserDataDefinition -Group -Name 'SOME_TEAM_GROUP' -UserDataDefinition $UserData
        $UserData = New-SIAPolicyUserDataDefinition -User -Name SomeUser -UserDataDefinition $UserData
        $UserData = New-SIAPolicyUserDataDefinition -User -Name SomeOtherUser -UserDataDefinition $UserData

        $AccessRules = @()
        $AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName SomeAccessRule -userData $UserData -connectAs $ConnectAs1 -timeZone Europe/London
        $AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName AnotherAccessRule -userData $UserData -connectAs $ConnectAs2 -timeZone America/Costa_Rica

        $FQDNrules = @()
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator EXACTLY -computernamePattern SomeHost -domain SomeDomain.com
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator WILDCARD -computernamePattern *-DEV-* -domain SomeDomain.com
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator SUFFIX -computernamePattern '-Prod' -domain SomeDomain.com
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator CONTAINS -computernamePattern SQL -domain SomeDomain.com
        $FQDNrules += New-SIAPolicyFQDNRuleDefinition -operator PREFIX -computernamePattern DC1 -domain SomeDomain.com

        $Providers = New-SIAPolicyProviderDefinition -OnPrem -fqdnRulesConjunction OR -fqdnRules $FQDNrules
        $Providers = New-SIAPolicyProviderDefinition -AWS -regions 'us-east-1', 'us-east-2' -tags @{'Key' = 'env'; 'Value' = @('prod') } -ProviderDefinition $Providers
        $Providers = New-SIAPolicyProviderDefinition -Azure -regions 'eastus2', 'eastus' -tags @{'Key' = 'env'; 'Value' = @('prod') } -ProviderDefinition $Providers
        $Providers = New-SIAPolicyProviderDefinition -GCP -regions 'asia-east1', 'us-east1' -labels @{'Key' = 'env'; 'Value' = @('prod') } -ProviderDefinition $Providers

        New-SIAPolicy -policyName SomePolicy -status Enabled -description 'Some Description' -providersData $Providers -userAccessRules $AccessRules -startDate (Get-Date -Year 1925 -Month 10 -Day 8) -EndDate (Get-Date -Year 2023 -Month 1 -Day 22)
    }

    Context 'Request' {

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.dpa.cyberark.cloud/api/access-policies'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter { $Method -eq 'POST' } -Times 1 -Exactly -Scope It
        }

        It 'sends request with expected policy body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.policyName -eq 'SomePolicy') -and
                ($request.status -eq 'Enabled') -and
                ($request.description -eq 'Some Description') -and
                ($request.startDate -eq '1925-10-08') -and
                ($request.endDate -eq '2023-01-22') -and
                ($null -ne $request.providersData) -and
                ($null -ne $request.userAccessRules)
            } -Times 1 -Exactly -Scope It
        }

        It 'sends request body with expected providersData' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                (($request.providersData.OnPrem.fqdnRules.computernamePattern).count -eq 5) -and
                ($request.providersData.OnPrem.fqdnRules.computernamePattern -contains 'SomeHost') -and
                ($request.providersData.OnPrem.fqdnRules.computernamePattern -contains '*-DEV-*') -and
                ($request.providersData.OnPrem.fqdnRules.computernamePattern -contains '-Prod') -and
                ($request.providersData.OnPrem.fqdnRules.computernamePattern -contains 'SQL') -and
                ($request.providersData.OnPrem.fqdnRules.computernamePattern -contains 'DC1') -and
                ($request.providersData.AWS.tags.Key -eq 'env') -and
                ($request.providersData.Azure.tags.Key -eq 'env') -and
                ($request.providersData.GCP.labels.Key -eq 'env')
            } -Times 1 -Exactly -Scope It
        }

        It 'sends request body with expected userAccessRules' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SIAModuleName -ParameterFilter {
                $request = $Body | ConvertFrom-Json
                ($request.userAccessRules[0].ruleName -eq 'SomeAccessRule') -and
                ($request.userAccessRules[1].ruleName -eq 'AnotherAccessRule') -and
                ($request.userAccessRules[0].connectionInformation.connectAs.OnPrem.rdp.localEphemeralUser.assignGroups -eq 'Administrators') -and
                ($request.userAccessRules[0].connectionInformation.connectAs.AWS.ssh -eq 'ec2-user') -and
                ($request.userAccessRules[1].connectionInformation.connectAs.AWS.rdp.localEphemeralUser.assignGroups -contains 'Administrators') -and
                ($request.userAccessRules[1].connectionInformation.connectAs.AWS.rdp.localEphemeralUser.assignGroups -contains 'Remote Desktop Users')
            } -Times 1 -Exactly -Scope It
        }
    }
}
