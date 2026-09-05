# .ExternalHelp IdentityCommand.SIA-help.xml
function New-SIAPolicyUserDataDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function does not change state')]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'False Positive')]
    [CmdletBinding(DefaultParameterSetName = 'roles')]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'roles'
        )]
        [switch]$Role,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'groups'
        )]
        [switch]$Group,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'users'
        )]
        [switch]$User,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$name,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$source,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Add additional data to previous output from New-SIAPolicyUserDataDefinition.'
        )]
        [PSTypeName('IdCmd.SIA.Definition.Policy.UserAccessRule.UserData')]
        [psobject]$UserDataDefinition
    )

    begin { }#begin

    process {
        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove Role, Group, User, UserDataDefinition

        $boundParameters.keys | ForEach-Object {

            $UserDataValues = [pscustomobject]@{}

            If ($null -ne $UserDataDefinition) {
                $UserData = $UserDataDefinition
            } else {
                $UserData = [pscustomobject]@{
                    'roles'  = @()
                    'groups' = @()
                    'users'  = @()
                } | Add-CustomType -Type IdCmd.SIA.Definition.Policy.UserAccessRule.UserData
            }

        } {
            switch ($PSItem) {
                default {

                    $UserDataValues | Add-Member -MemberType NoteProperty -Name $PSItem -Value $boundParameters[$PSItem]

                }
            }
        } {
            If ($null -ne $UserDataValues.name) {

                If ($UserDataValues.PSObject.Properties.Name -notcontains 'source') {
                    $UserDataValues | Add-Member -MemberType NoteProperty -Name 'source' -Value $null
                }

                $UserData.$($PSCmdlet.ParameterSetName) += $UserDataValues

            }
        }
    }#process

    end { $UserData }#end

}