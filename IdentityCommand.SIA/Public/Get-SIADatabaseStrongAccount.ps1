# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIADatabaseStrongAccount {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ById'
        )]
        [Alias('id')]
        [String]$strong_account_id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [ValidateRange(1, 1000)]
        [int]$limit
    )

    begin { }#begin

    process {

        switch ($PSCmdlet.ParameterSetName) {

            'ById' {
                $URI = "$($ISPSSSession.tenant_url)/api/database-strong-accounts/$strong_account_id"
            }

            'List' {
                $URI = "$($ISPSSSession.tenant_url)/api/database-strong-accounts"

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

                'List' {
                    Get-SIAPagedResult -InitialResult $result -URI $URI -Style Cursor -ResultProperty 'items'
                }

                'ById' {
                    $result
                }

            }

        }

    }#process

    end { }#end

}
