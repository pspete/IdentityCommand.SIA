# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAResource {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'discovery/organizations'
        )]
        [switch]$AWS,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'discovery/subscriptions'
        )]
        [switch]$Azure,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'discovery/onprem'
        )]
        [switch]$OnPrem,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'discovery/gcp/organizations'
        )]
        [switch]$GCP,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'adb/resources'
        )]
        [switch]$Database,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'discovery/organizations'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'discovery/subscriptions'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'discovery/gcp/organizations'
        )]
        [Alias('subscription_id')]
        [String]$workspaceId
    )

    begin { }#begin

    process {

        #Paramterset name is the url path to send the query to.
        $URI = "$($ISPSSSession.tenant_url)/api/$($PSCmdlet.ParameterSetName)/$workspaceId"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            if ($PSBoundParameters.Keys -notcontains 'workspaceId') {
                #If specific workspace is not being queried - return property containing resource info

                switch ($PSCmdlet.ParameterSetName) {
                    { $PSItem -match '/organizations$' } {
                        $returnProp = 'organizations' #? Asumption for AWS/GCP
                    }
                    'discovery/onprem' {
                        $result = $result | ConvertFrom-Json
                        $returnProp = 'config' #* On-Prem - return is text/json so converting here for now
                    }
                    'discovery/subscriptions' {
                        $returnProp = 'subscriptions' #* Azure
                    }
                    'adb/resources' {
                        $returnProp = 'items'
                    }
                    default {
                        $result #TODO : catch all - delete if never needed
                    }
                }

                If ($null -ne $returnProp) {

                    #Return returnProp data if set
                    $result.$returnProp

                }

            } Else {
                #for specific workspace query, just return the result
                $result
            }
        }

    }#process

    end {

    }#end

}