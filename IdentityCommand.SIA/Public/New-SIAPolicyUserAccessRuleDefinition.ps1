Function New-SIAPolicyUserAccessRuleDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function does not change state')]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'False Positive')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$ruleName,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SIAPolicyUserDataDefinition.'
        )]
        [PSTypeName('IdCmd.SIA.Definition.Policy.UserAccessRule.UserData')]
        [psobject]$userData,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SIAPolicyConnectAsDefinition.'
        )]
        [PSTypeName('IdCmd.SIA.Definition.Policy.UserAccessRule.ConnectAs')]
        [psobject]$connectAs,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [PSDefaultValue(Value = 2)]
        [ValidateRange(0, 24)]
        [int]$grantAccess,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [PSDefaultValue(Value = 10)]
        [ValidateRange(0, 120)]
        [int]$idleTime,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [AllowEmptyCollection()]
        [ValidateSet('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')]
        [String[]]$daysOfWeek,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [bool]$fullDays,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidatePattern('^([01]\d|2[0-3]):([0-5]\d)$')]
        [string]$hoursFrom,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidatePattern('^([01]\d|2[0-3]):([0-5]\d)$')]
        [string]$hoursTo,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$timeZone
    )

    Begin {
        $userAccessRuleDefinition = [ordered]@{
            ruleName              = $null
            userData              = New-SIAPolicyUserDataDefinition
            connectionInformation = $null
        }
    }

    Process {

        $userAccessRuleDefinition.ruleName = $ruleName

        $userAccessRuleDefinition.userData = $userData

        $ConnectionParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove userData, ruleName

        $ConnectionParameters.Keys | ForEach-Object {

            $ConnectionDefinition = [ordered]@{
                connectAs   = $null
                grantAccess = $null
                idleTime    = $null
                daysOfWeek  = @('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')
                fullDays    = $true
                hoursFrom   = $null
                hoursTo     = $null
                timeZone    = $null
            }

        } {
            $ConnectionDefinition["$PSItem"] = $ConnectionParameters["$PSItem"]
        } {
            $userAccessRuleDefinition.connectionInformation = $ConnectionDefinition
        }

        $userAccessRuleDefinition | Add-CustomType -Type IdCmd.SIA.Definition.Policy.UserAccessRule

    }

    End { }

}