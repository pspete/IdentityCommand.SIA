function Connect-SIATenant {

    [CmdletBinding(DefaultParameterSetName = 'Subdomain')]
    param(

        #subdomain
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Subdomain'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('subdomain')]
        [String]$tenant_subdomain,

        #tenant_url
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'URL'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('sia_url')]
        [String]$tenant_url

    )

    begin {

        $IDSession = Get-IDSession
        if ($null -eq $IDSession.tenant_url) {
            throw 'Authenticate with New-IDSession or New-IDPlatformToken and try again'
        }

    }#begin

    process {

        switch ($PSCmdlet.ParameterSetName) {

            'URL' {

                #Ensure URL is in expected format
                #Remove trailing slash if provided in Url
                $tenant_url = $tenant_url -replace '/$', ''
                break

            }

            'Subdomain' {

                #Resolve the SIA API URL from the shared services subdomain
                $Service = Find-SharedServicesURL -subdomain $tenant_subdomain -service jit
                #Use the API URL with the trailing /api removed
                $tenant_url = $Service.api -replace '/api/?$', ''
                break

            }

        }

        #Make the CyberArk Identity Session available in the IndentityCommand.SIA scope
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
