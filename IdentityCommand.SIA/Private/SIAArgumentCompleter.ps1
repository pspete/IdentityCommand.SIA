#The completer helper functions this file used to define now live in IdentityCommand's
#Private folder, which the psm1 loads into this module's scope.

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
