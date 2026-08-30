# .ExternalHelp IdentityCommand.SIA-help.xml
function New-SIAPolicy {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 200)]
        [String]$policyName,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('Irrelevant', 'Enabled', 'Disabled', 'Draft', 'Expired')]
        [String]$status,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(0, 200)]
        [String]$description,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SIAPolicyProviderDefinition.'
        )]

        [PSTypeName('IdCmd.SIA.Definition.Policy.Provider')]
        [psobject]$providersData,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [datetime]$startDate,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [datetime]$endDate,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SIAPolicyUserAccessRuleDefinition.'
        )]
        [PSTypeName('IdCmd.SIA.Definition.Policy.UserAccessRule')]
        [psobject[]]$userAccessRules
    )

    BEGIN {
        $OrderedProperties = [ordered]@{
            'policyName'      = $null
            'policyType'      = 'VM'
            'status'          = 'Draft'
            'description'     = ''
            'providersData'   = @{}
            'startDate'       = $null
            'endDate'         = $null
            'userAccessRules' = @()
        }
    }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/access-policies"

        #Get request parameters
        $boundParameters = $PSBoundParameters | Get-Parameter

        If ($PSBoundParameters.ContainsKey('startDate')) {

            #Convert ExpiryDate to string in Required format
            $Date = (Get-Date $startDate -Format yyyy-MM-dd).ToString()

            #Include date string in request
            $boundParameters['startDate'] = $Date

        }

        If ($PSBoundParameters.ContainsKey('endDate')) {

            #Convert ExpiryDate to string in Required format
            $Date = (Get-Date $endDate -Format yyyy-MM-dd).ToString()

            #Include date string in request
            $boundParameters['endDate'] = $Date

        }

        $OrderedProperties.keys | ForEach-Object {

            $Properties = [ordered]@{ }

        } {

            #Parameter match
            If ($boundParameters.ContainsKey($PSItem)) {

                #Add to hash table in key/value pair
                $Properties.Add($PSItem, $boundParameters[$PSItem])

            } Else {
                $Properties.Add($PSItem, $OrderedProperties.$PSItem)
            }

        } {
            #Create Request Body
            $body = $Properties | ConvertTo-Json -Depth 8
        }
        if ($PSCmdlet.ShouldProcess($policyName, 'Create New SIA Policy')) {
            #Send Request

            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }
        }
    }#process

    END { }#end

}