Function Connect-SIATenant {

    [CmdletBinding()]
    param(

        #tenant_url
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$tenant_url

    )

    BEGIN {

        $IDSession = Get-IDSession
        if ($null -eq $IDSession.tenant_url) {
            throw 'Authenticate with New-IDSession or New-IDPlatformToken and try again'
        }

    }#begin

    PROCESS {

        #Ensure URL is in expected format
        #Remove trailing space if provided in Url
        $tenant_url = $tenant_url -replace '/$', ''
        #$tenant_url = Find-SharedServicesURL -url $tenant_url -service jit

        #Make the CyberArk Identity Session available in the IndentityCommand.SIA scope
        foreach ($key in $IDSession.keys) {
            if ($null -ne $IDSession[$key]) {
                $ISPSSSession[$key] = $IDSession[$key]
            }
        }

        #Set the SIA URL in the session data
        $ISPSSSession.tenant_url = $tenant_url

    }#process

    END { }#end


}