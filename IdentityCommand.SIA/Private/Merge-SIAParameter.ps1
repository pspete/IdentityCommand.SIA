function Merge-SIAParameter {
    <#
    .SYNOPSIS
    Projects supplied parameters onto an ordered request template.

    .DESCRIPTION
    Several SIA commands build a request body by walking a fixed [ordered] template of expected
    properties and, for each key, taking the caller's bound value when supplied, otherwise falling
    back to either the corresponding property of a prior/existing object (e.g. the current policy for
    an update) or the template's own default value.

    This helper centralises that walk. The returned [ordered] hashtable preserves the template's key
    order and is ready to pipe to ConvertTo-Json.

    .PARAMETER Template
    An [ordered] hashtable whose keys define the expected properties (and their order) and whose
    values are the defaults to use when a key is neither bound nor present in -Fallback.

    .PARAMETER BoundParameter
    The projected bound parameters (typically $PSBoundParameters | Get-Parameter). A key present here
    always wins.

    .PARAMETER Fallback
    Optional object (e.g. the existing policy from Get-SIAPolicy). When supplied, an unbound key takes
    its value from this object's matching property instead of the template default.

    .EXAMPLE
    $body = Merge-SIAParameter -Template $OrderedProperties -BoundParameter ($PSBoundParameters | Get-Parameter)

    .EXAMPLE
    $body = Merge-SIAParameter -Template $OrderedProperties -BoundParameter $boundParameters -Fallback $PolicySettings
    #>
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [System.Collections.Specialized.OrderedDictionary]$Template,

        [parameter(Mandatory = $true)]
        [hashtable]$BoundParameter,

        [parameter(Mandatory = $false)]
        [object]$Fallback
    )

    $merged = [ordered]@{ }

    foreach ($key in $Template.Keys) {

        if ($BoundParameter.ContainsKey($key)) {

            $merged[$key] = $BoundParameter[$key]

        } elseif ($PSBoundParameters.ContainsKey('Fallback')) {

            $merged[$key] = $Fallback.$key

        } else {

            $merged[$key] = $Template[$key]

        }

    }

    $merged

}
