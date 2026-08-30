# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAPolicy {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ById'
        )]
        [String]$policyid,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [String]$filter,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [ValidateRange(1, 1000)]
        [int]$limit,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [int]$offset,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [String]$sort
    )

    BEGIN { }#begin

    PROCESS {

        switch ($PSCmdlet.ParameterSetName) {

            'ById' {
                $URI = "$($ISPSSSession.tenant_url)/api/access-policies/$policyid"
            }

            'List' {
                $URI = "$($ISPSSSession.tenant_url)/api/access-policies"

                $QueryString = $($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)

                If ($null -ne $QueryString) {
                    $URI = "$URI`?$QueryString"
                }
            }

        }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            switch ($PSCmdlet.ParameterSetName) {
                'ById' { $result }
                'List' { $result.items }
            }

        }

    }#process

    END { }#end

}
