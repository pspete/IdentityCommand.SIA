# .ExternalHelp IdentityCommand.SIA-help.xml
function New-SIAPolicyFQDNRuleDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function does not change state')]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'False Positive')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('EXACTLY', 'WILDCARD', 'PREFIX', 'SUFFIX', 'CONTAINS')]
        [string]$operator,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$computernamePattern,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$domain
    )

    begin { }#begin

    process {
        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove FQDNRuleDefinition

        $boundParameters.keys | ForEach-Object {
            $FQDNRuleDefinition = [pscustomobject]@{
                'operator'            = $null
                'computernamePattern' = $null
                'domain'              = $null
            }
        } {

            $FQDNRuleDefinition.$PSItem = $boundParameters[$PSItem]

        } {

            $FQDNRuleDefinition | Add-CustomType -Type IdCmd.SIA.Definition.Policy.Provider.FQDNRule

        }
    }#process

    end { }#end

}