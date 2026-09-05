# .ExternalHelp IdentityCommand.SIA-help.xml
function Connect-SIATenant {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Subdomain')]
    param(

        #subdomain
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'Subdomain')]
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'SubdomainCredential')]
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'SubdomainSAML')]
        [ValidateNotNullOrEmpty()]
        [Alias('subdomain')]
        [String]$tenant_subdomain,

        #tenant_url
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'URL')]
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'URLCredential')]
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'URLSAML')]
        [ValidateNotNullOrEmpty()]
        [Alias('sia_url')]
        [String]$tenant_url,

        #Credential used to authenticate to CyberArk Identity when no active IdentityCommand session is found
        [parameter(Mandatory = $true, ParameterSetName = 'SubdomainCredential')]
        [parameter(Mandatory = $true, ParameterSetName = 'URLCredential')]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential,

        #Authenticate as a service user via New-IDPlatformToken (OAuth client_credentials) instead of the interactive New-IDSession
        [parameter(ParameterSetName = 'SubdomainCredential')]
        [parameter(ParameterSetName = 'URLCredential')]
        [Switch]$PlatformToken,

        #SAML assertion used to authenticate to CyberArk Identity when no active IdentityCommand session is found
        [parameter(Mandatory = $true, ParameterSetName = 'SubdomainSAML')]
        [parameter(Mandatory = $true, ParameterSetName = 'URLSAML')]
        [ValidateNotNullOrEmpty()]
        [String]$SAMLResponse

    )

    begin {

        $IDSession = Get-IDSession
        $HaveSession = $null -ne $IDSession.tenant_url
        $AuthRequested = $PSBoundParameters.ContainsKey('Credential') -or $PSBoundParameters.ContainsKey('SAMLResponse')

        if ($HaveSession -and $AuthRequested) {
            Write-Verbose 'An active IdentityCommand session was found; ignoring supplied authentication parameters and using the existing session'
        }

    }#begin

    process {

        $UsingSubdomain = $PSCmdlet.ParameterSetName -like 'Subdomain*'

        #Resolve service URLs from platform discovery when a subdomain was supplied, or when
        #authentication is required and the CyberArk Identity URL must be discovered.
        $ServiceUrl = $null

        if ($UsingSubdomain) {

            $ServiceUrl = Resolve-SIAServiceUrl -Subdomain $tenant_subdomain
            $tenant_url = $ServiceUrl.SIAUrl

        } else {

            #Ensure URL is in expected format - remove trailing slash if provided in Url
            $tenant_url = $tenant_url -replace '/$', ''

            if (-not $HaveSession -and $AuthRequested) {
                $ServiceUrl = Resolve-SIAServiceUrl -Url $tenant_url
            }

        }

        if (-not $HaveSession) {

            if (-not $AuthRequested) {
                throw 'Authenticate with New-IDSession or New-IDPlatformToken, or supply -Credential, and try again'
            }

            $IdentityUrl = $ServiceUrl.IdentityUrl

            if ($PSCmdlet.ShouldProcess($IdentityUrl, 'Authenticate to CyberArk Identity')) {

                if ($PSCmdlet.ParameterSetName -like '*SAML') {
                    $null = New-IDSession -tenant_url $IdentityUrl -SAMLResponse $SAMLResponse
                } elseif ($PlatformToken) {
                    $null = New-IDPlatformToken -tenant_url $IdentityUrl -Credential $Credential
                } else {
                    $null = New-IDSession -tenant_url $IdentityUrl -Credential $Credential
                }

                $IDSession = Get-IDSession

            }

        }

        #Make the CyberArk Identity Session available in the IdentityCommand.SIA scope
        foreach ($key in $IDSession.keys) {
            if ($null -ne $IDSession[$key]) {
                $ISPSSSession[$key] = $IDSession[$key]
            }
        }

        #Set the SIA URL in the session data
        $ISPSSSession.tenant_url = $tenant_url

    }#process

    end { }#end

}
