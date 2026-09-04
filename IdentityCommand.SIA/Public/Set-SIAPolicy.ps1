# .ExternalHelp IdentityCommand.SIA-help.xml
function Set-SIAPolicy {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'False Positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$policyid,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 200)]
        [String]$policyName,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('Enabled', 'Disabled', 'Draft', 'Expired')]
        [String]$status,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 200)]
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

    begin {
        $OrderedProperties = [ordered]@{
            'policyid'        = $null
            'policyName'      = $null
            'status'          = $null
            'description'     = ''
            'providersData'   = @{}
            'startDate'       = $null
            'endDate'         = $null
            'userAccessRules' = @()
        }
    }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/access-policies/$policyid"

        #Get existing policy settings
        $PolicySettings = Get-SIAPolicy -policyid $policyid

        #Get request parameters
        $boundParameters = $PSBoundParameters | Get-Parameter

        #The API expects date-only strings
        foreach ($dateParam in 'startDate', 'endDate') {
            if ($PSBoundParameters.ContainsKey($dateParam)) {
                $boundParameters[$dateParam] = (Get-Date $PSBoundParameters[$dateParam] -Format 'yyyy-MM-dd').ToString()
            }
        }

        #Project supplied parameters onto the request template, falling back to the existing policy
        $Properties = Merge-SIAParameter -Template $OrderedProperties -BoundParameter $boundParameters -Fallback $PolicySettings

        #Create Request Body
        $body = $Properties | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($policyid, 'Update SIA Policy')) {
            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method PUT -Body $body

            if ($null -ne $result) {

                $result

            }
        }
    }#process

    end { }#end

}