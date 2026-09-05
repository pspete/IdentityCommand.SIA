function Resolve-SIAServiceUrl {
    <#
    .SYNOPSIS
    Resolves SIA and CyberArk Identity URLs from platform discovery.

    .DESCRIPTION
    Given an ISPSS shared services subdomain, or a SIA tenant URL, queries CyberArk platform
    discovery (via IdentityCommand's Find-SharedServicesURL helper) once and returns the URLs
    Connect-SIATenant needs:

      - SIAUrl      - the 'jit' service api URL with any trailing /api removed (the SIA tenant URL).
      - IdentityUrl - the 'identity_user_portal' service api URL (the CyberArk Identity tenant URL
                      that New-IDSession / New-IDPlatformToken authenticate against).

    When a URL is supplied, Find-SharedServicesURL derives the shared services subdomain from the
    first label of the host name - correct for the standard https://<subdomain>.dpa.cyberark.cloud
    SIA URL form.

    .PARAMETER Subdomain
    The ISPSS shared services subdomain.

    .PARAMETER Url
    A SIA tenant URL to derive the shared services subdomain from.

    .EXAMPLE
    Resolve-SIAServiceUrl -Subdomain sometenant

    .EXAMPLE
    Resolve-SIAServiceUrl -Url https://sometenant.dpa.cyberark.cloud
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding(DefaultParameterSetName = 'Subdomain')]
    param(
        [parameter(Mandatory = $true, ParameterSetName = 'Subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$Subdomain,

        [parameter(Mandatory = $true, ParameterSetName = 'URL')]
        [ValidateNotNullOrEmpty()]
        [string]$Url
    )

    $Reference = if ($PSCmdlet.ParameterSetName -eq 'Subdomain') { $Subdomain } else { $Url }

    try {

        $Discovery = if ($PSCmdlet.ParameterSetName -eq 'Subdomain') {
            Find-SharedServicesURL -subdomain $Subdomain
        } else {
            Find-SharedServicesURL -url $Url
        }

    } catch {

        throw "Unable to resolve CyberArk shared services URLs from '$Reference': $($PSItem.Exception.Message)"

    }

    $IdentityUrl = $Discovery.identity_user_portal.api -replace '/$', ''

    if ([string]::IsNullOrEmpty($IdentityUrl)) {
        throw "CyberArk Identity URL (identity_user_portal) not found in platform discovery response for '$Reference'"
    }

    [pscustomobject]@{
        SIAUrl      = $Discovery.jit.api -replace '/api/?$', ''
        IdentityUrl = $IdentityUrl
    }

}
