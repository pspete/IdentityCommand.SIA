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
    connector can be found by its id or its name. Values containing whitespace are single
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
    $items | Get-SIACompletionResult -WordToComplete $wordToComplete -ValueProperty connectorId, id -LabelProperty name
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

            if (($Value -notlike "$Word*") -and ($Label -notlike "$Word*")) { continue }

            $CompletionText = if ($Value -match '\s') { "'$($Value -replace "'", "''")'" } else { "$Value" }
            $ToolTip = if ($Label -and ($Label -ne $Value)) { "$Label ($Value)" } else { "$Value" }

            [System.Management.Automation.CompletionResult]::new($CompletionText, $ToolTip, 'ParameterValue', $ToolTip)

        }

    }#process

    END { }#end

}

#region Registration

#Each completer runs in the caller's session state, so the Get-SIA* lookup is dispatched into the
#module (& $Module { ... }) the way psPAS does it. Anything that goes wrong - no active session, an
#API error - is swallowed so tab completion stays silent rather than noisy.

$SIAConnectorIdCompleter = {

    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    #Standard ArgumentCompleter parameters that are not otherwise referenced.
    $null = $parameterName, $commandAst, $fakeBoundParameters

    try {
        $Module = (Get-Command $commandName -ErrorAction Stop).Module

        & $Module {
            param($Word)
            #No point calling the API before Connect-SIATenant has run.
            if ([string]::IsNullOrWhiteSpace($ISPSSSession.tenant_url)) { return }
            Get-SIAConnector -ErrorAction Stop |
                Get-SIACompletionResult -WordToComplete $Word -ValueProperty 'id' -LabelProperty 'name'
        } $wordToComplete

    } catch { return }

}

Register-ArgumentCompleter -ParameterName 'connector_id' -ScriptBlock $SIAConnectorIdCompleter -CommandName @(
    'Get-SIAConnector'
    'Remove-SIAConnector'
    'Update-SIAConnector'
    'Test-SIAConnector'
    'Set-SIAConnectorMaintenanceMode'
    'Invoke-SIAConnectorCertificateRotation'
)

Register-ArgumentCompleter -ParameterName 'connectorId' -ScriptBlock $SIAConnectorIdCompleter -CommandName 'Add-SIAConnectorPoolMember'

#endregion
