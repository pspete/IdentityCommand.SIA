function Get-SIACompletionResult {
    <#
    .SYNOPSIS
    Turns objects returned by a Get-SIA* command into CompletionResult entries.

    .DESCRIPTION
    Shared formatting/filtering for the module's argument completers. Given the objects a
    Get-SIA* lookup returned, the word the user is completing, and the candidate property
    name(s) that hold the value to place on the command line (plus optional label
    property name(s) for the tooltip), it emits one [CompletionResult] per match.

    Matching is a prefix match, case-insensitive, against either the value or the label so a
    policy can be found by its id or its name. Values containing whitespace are single
    quoted so they bind as a single argument.

    .PARAMETER InputObject
    The objects returned by the Get-SIA* command. Accepts pipeline input.

    .PARAMETER WordToComplete
    The partial value the completion engine passed in.

    .PARAMETER ValueProperty
    Property name(s) holding the value to complete, tried in order; the first non-empty wins.

    .PARAMETER LabelProperty
    Optional property name(s) holding a friendly label for the tooltip, tried in order.

    .EXAMPLE
    $items | Get-SIACompletionResult -WordToComplete $wordToComplete -ValueProperty policyId -LabelProperty policyName
    #>
    [OutputType([System.Management.Automation.CompletionResult])]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [object[]]$InputObject,

        [parameter(Mandatory = $false)]
        [string]$WordToComplete,

        [parameter(Mandatory = $true)]
        [string[]]$ValueProperty,

        [parameter(Mandatory = $false)]
        [string[]]$LabelProperty
    )

    BEGIN {
        #Drop any opening quote the user has already typed.
        $Word = "$WordToComplete".Trim("'`"")
    }#begin

    PROCESS {

        foreach ($Item in $InputObject) {

            $Value = $ValueProperty | ForEach-Object { $Item.$_ } | Where-Object { $_ } | Select-Object -First 1
            if (-not $Value) { continue }

            $Label = $LabelProperty | ForEach-Object { $Item.$_ } | Where-Object { $_ } | Select-Object -First 1

            #Force scalar strings - an empty $Label from an absent property would otherwise make the
            #-notlike below evaluate to an empty array and break the -and.
            $Value = "$Value"
            $Label = "$Label"

            if (($Value -notlike "$Word*") -and ($Label -notlike "$Word*")) { continue }

            $CompletionText = if ($Value -match '\s') { "'$($Value -replace "'", "''")'" } else { "$Value" }
            $ToolTip = if ($Label -and ($Label -ne $Value)) { "$Label ($Value)" } else { "$Value" }

            [System.Management.Automation.CompletionResult]::new($CompletionText, $ToolTip, 'ParameterValue', $ToolTip)

        }

    }#process

    END { }#end

}

function Get-SIAArgumentCompleter {
    <#
    .SYNOPSIS
    Builds an argument-completer scriptblock backed by a Get-SIA* command.

    .DESCRIPTION
    Returns a scriptblock suitable for Register-ArgumentCompleter. When invoked by the completion
    engine it dispatches the lookup into the owning module (& $Module { ... }, the way psPAS does it),
    skips the call when there is no active session, and swallows any error so tab completion stays
    silent rather than noisy.

    .PARAMETER RetrievalCommand
    Name of the Get-SIA* command to call for candidate objects.

    .PARAMETER ValueProperty
    Property name(s) on the returned objects holding the value to complete, tried in order.

    .PARAMETER LabelProperty
    Optional property name(s) holding a friendly label for the tooltip, tried in order.

    .EXAMPLE
    Register-ArgumentCompleter -ParameterName policyId -CommandName Set-SIAPolicy -ScriptBlock (
        Get-SIAArgumentCompleter -RetrievalCommand Get-SIAPolicy -ValueProperty policyId -LabelProperty policyName
    )
    #>
    [OutputType([scriptblock])]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Captured by GetNewClosure and used inside the returned scriptblock')]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$RetrievalCommand,

        [parameter(Mandatory = $true)]
        [string[]]$ValueProperty,

        [parameter(Mandatory = $false)]
        [string[]]$LabelProperty
    )

    {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

        #Standard ArgumentCompleter parameters that are not otherwise referenced.
        $null = $parameterName, $commandAst, $fakeBoundParameters

        try {
            $Module = (Get-Command $commandName -ErrorAction Stop).Module

            & $Module {
                param($Retrieval, $ValueProperty, $LabelProperty, $Word)

                #No point calling the API before Connect-SIATenant has run.
                if ([string]::IsNullOrWhiteSpace($ISPSSSession.tenant_url)) { return }

                & $Retrieval -ErrorAction Stop |
                    Get-SIACompletionResult -WordToComplete $Word -ValueProperty $ValueProperty -LabelProperty $LabelProperty
            } $RetrievalCommand $ValueProperty $LabelProperty $wordToComplete

        } catch { return }

    }.GetNewClosure()

}

#region Registration

$SIAConnectorIdCompleter = Get-SIAArgumentCompleter -RetrievalCommand 'Get-SIAConnector' -ValueProperty 'id' -LabelProperty 'name'

Register-ArgumentCompleter -ParameterName 'connector_id' -ScriptBlock $SIAConnectorIdCompleter -CommandName @(
    'Get-SIAConnector'
    'Remove-SIAConnector'
    'Update-SIAConnector'
    'Test-SIAConnector'
    'Set-SIAConnectorMaintenanceMode'
    'Invoke-SIAConnectorCertificateRotation'
)

Register-ArgumentCompleter -ParameterName 'connectorId' -ScriptBlock $SIAConnectorIdCompleter -CommandName 'Add-SIAConnectorPoolMember'

$SIAPolicyIdCompleter = Get-SIAArgumentCompleter -RetrievalCommand 'Get-SIAPolicy' -ValueProperty 'policyId' -LabelProperty 'policyName'

#Get-SIAPolicy / Remove-SIAPolicy spell the parameter 'policyid', Set-SIAPolicy spells it 'policyId'.
foreach ($ParameterName in 'policyId', 'policyid') {
    Register-ArgumentCompleter -ParameterName $ParameterName -ScriptBlock $SIAPolicyIdCompleter -CommandName @(
        'Get-SIAPolicy'
        'Set-SIAPolicy'
        'Remove-SIAPolicy'
    )
}

Register-ArgumentCompleter -ParameterName 'policyName' -ScriptBlock (
    Get-SIAArgumentCompleter -RetrievalCommand 'Get-SIAPolicy' -ValueProperty 'policyName'
) -CommandName 'Set-SIAPolicy'

#endregion
