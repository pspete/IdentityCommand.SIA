# .ExternalHelp IdentityCommand.SIA-help.xml
function New-SIAPolicyProviderDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function does not change state')]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'False Positive')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [switch]$AWS,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Azure'
        )]
        [switch]$Azure,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'OnPrem'
        )]
        [switch]$OnPrem,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GCP'
        )]
        [switch]$GCP,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Azure'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GCP'
        )]
        [string[]]$regions,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Azure'
        )]
        [psobject[]]$tags,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GCP'
        )]
        [string[]]$vpcIds,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [string[]]$accountIds,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Azure'
        )]
        [string[]]$resourceGroups,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Azure'
        )]
        [string[]]$vnetIds,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Azure'
        )]
        [string[]]$subscriptions,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'OnPrem'
        )]
        [ValidateSet('AND', 'OR')]
        [string]$fqdnRulesConjunction,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'OnPrem',
            HelpMessage = 'Accepts output from New-SIAPolicyFQDNRuleDefinition.'
        )]
        [PSTypeName('IdCmd.SIA.Definition.Policy.Provider.FQDNRule')]
        [psobject[]]$fqdnRules,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GCP'
        )]
        [psobject[]]$labels,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GCP'
        )]
        [string[]]$projects,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Add additional data to previous output from New-SIAPolicyProviderDefinition.'
        )]
        [PSTypeName('IdCmd.SIA.Definition.Policy.Provider')]
        [psobject]$ProviderDefinition
    )

    begin { }#begin

    process {
        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove AWS, Azure, OnPrem, GCP, ProviderDefinition

        $boundParameters.keys | ForEach-Object {

            switch ($PSCmdlet.ParameterSetName) {
                'AWS' {
                    $ProviderValues = [pscustomobject]@{
                        'regions'    = @()
                        'tags'       = @()
                        'vpcIds'     = @()
                        'accountIds' = @()
                    }
                }
                'Azure' {
                    $ProviderValues = [pscustomobject]@{
                        'regions'        = @()
                        'tags'           = @()
                        'resourceGroups' = @()
                        'vnetIds'        = @()
                        'subscriptions'  = @()
                    }
                }
                'GCP' {
                    $ProviderValues = [pscustomobject]@{
                        'regions'  = @()
                        'labels'   = @()
                        'vpcIds'   = @()
                        'projects' = @()
                    }
                }
                'OnPrem' {
                    $ProviderValues = [pscustomobject]@{
                        'fqdnRulesConjunction' = 'OR'
                        'fqdnRules'            = @()
                    }
                }
            }

        } {

            switch ($PSItem) {

                default {
                    $ProviderValues.$PSItem = $boundParameters[$PSItem]
                }

            }

        } {

            If ($null -ne $ProviderDefinition) {
                $ProviderDefinition | Add-Member -MemberType NoteProperty -Name $PSCmdlet.ParameterSetName -Value $ProviderValues -PassThru
            } else {
                [pscustomobject]@{$PSCmdlet.ParameterSetName = $ProviderValues } | Add-CustomType -Type IdCmd.SIA.Definition.Policy.Provider
            }
        }
    }#process

    end { }#end

}