#region Loader
<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.INPUTS

.OUTPUTS
#>
[CmdletBinding()]
param(

    [bool]$DotSourceModule = $false

)

#Get function files
Get-ChildItem $PSScriptRoot\ -Recurse -Include '*.ps1' -Exclude '*.ps1xml' |

    ForEach-Object {

        if ($DotSourceModule) {
            . $_.FullName
        } else {
            $ExecutionContext.InvokeCommand.InvokeScript(
                $false,
                (
                    [scriptblock]::Create(
                        [io.file]::ReadAllText(
                            $_.FullName,
                            [Text.Encoding]::UTF8
                        )
                    )
                ),
                $null,
                $null
            )

        }

    }

#endregion Loader

#Copy IdentityCommand's private helpers into this module: this module's functions call them, and
#the argument completer registrations below do so at import time.
#Each copy is created from the function definition, so it runs in this module's scope and uses this
#module's $ISPSSSession, whether IdentityCommand loaded from source or from its combined psm1.
#Resolve a single IdentityCommand module: with more than one version loaded, Get-Module returns
#an array.
$Module = Get-Module -Name IdentityCommand | Sort-Object Version -Descending | Select-Object -First 1

if ($null -eq $Module) {
    throw 'The IdentityCommand module is not loaded. Import IdentityCommand and try again.'
}

& $Module { Get-ChildItem -Path Function: } |

    Where-Object { $_.ModuleName -eq $Module.Name -and -not $Module.ExportedFunctions.ContainsKey($_.Name) } |

    ForEach-Object {

        . ([scriptblock]::Create("function $($_.Name) {$($_.Definition)}"))

    }

#region Registration

$SIAConnectorIdCompleter = Get-ArgumentCompleter -RetrievalCommand 'Get-SIAConnector' -ValueProperty 'id' -LabelProperty 'name'

Register-ArgumentCompleter -ParameterName 'connector_id' -ScriptBlock $SIAConnectorIdCompleter -CommandName @(
    'Get-SIAConnector'
    'Remove-SIAConnector'
    'Update-SIAConnector'
    'Test-SIAConnector'
    'Set-SIAConnectorMaintenanceMode'
    'Invoke-SIAConnectorCertificateRotation'
)

Register-ArgumentCompleter -ParameterName 'connectorId' -ScriptBlock $SIAConnectorIdCompleter -CommandName 'Add-SIAConnectorPoolMember'

$SIAPolicyIdCompleter = Get-ArgumentCompleter -RetrievalCommand 'Get-SIAPolicy' -ValueProperty 'policyId' -LabelProperty 'policyName'

#Get-SIAPolicy / Remove-SIAPolicy / Set-SIAPolicy.
foreach ($ParameterName in 'policyid') {
    Register-ArgumentCompleter -ParameterName $ParameterName -ScriptBlock $SIAPolicyIdCompleter -CommandName @(
        'Get-SIAPolicy'
        'Set-SIAPolicy'
        'Remove-SIAPolicy'
    )
}

Register-ArgumentCompleter -ParameterName 'policyName' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SIAPolicy' -ValueProperty 'policyName'
) -CommandName 'Set-SIAPolicy'

Register-ArgumentCompleter -ParameterName 'strong_account_id' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SIADatabaseStrongAccount' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName @(
    'Get-SIADatabaseStrongAccount'
    'Set-SIADatabaseStrongAccount'
    'Remove-SIADatabaseStrongAccount'
)

$SIASecretIdCompleter = Get-ArgumentCompleter -RetrievalCommand 'Get-SIAStrongAccount' -ValueProperty 'secret_id' -LabelProperty 'secret_name'

Register-ArgumentCompleter -ParameterName 'secret_id' -ScriptBlock $SIASecretIdCompleter -CommandName @(
    'Remove-SIAStrongAccount'
    'Set-SIAStrongAccount'
    'Add-SIATargetSet'
)

#Get-SIATargetSet takes the strong account's secret_id under a differently-cased parameter name.
Register-ArgumentCompleter -ParameterName 'strongAccountId' -ScriptBlock $SIASecretIdCompleter -CommandName 'Get-SIATargetSet'

Register-ArgumentCompleter -ParameterName 'name' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SIATargetSet' -ValueProperty 'name' -LabelProperty 'type'
) -CommandName @(
    'Get-SIATargetSet'
    'Remove-SIATargetSet'
)

#Get-SIAHttpsRelay's item id field is unconfirmed against a live response - assumed 'id' by analogy
#with every other SIA list endpoint. No label property, for the same reason.
Register-ArgumentCompleter -ParameterName 'https_relay_id' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SIAHttpsRelay' -ValueProperty 'id'
) -CommandName @(
    'Remove-SIAHttpsRelay'
    'Update-SIAHttpsRelay'
    'Invoke-SIAHttpsRelayCertificateRotation'
)

#endregion

# Script scope session object for session data
$ISPSSSession = [ordered]@{
    tenant_url         = $null
    User               = $null
    TenantId           = $null
    SessionId          = $null
    WebSession         = $null
    StartTime          = $null
    ElapsedTime        = $null
    LastCommand        = $null
    LastCommandTime    = $null
    LastCommandResults = $null
    LastError          = $null
    LastErrorTime      = $null
} | Add-CustomType -Type IdCmd.Session

New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force