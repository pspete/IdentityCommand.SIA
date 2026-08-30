# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAStrongAccount {
    [CmdletBinding(DefaultParameterSetName = 'VirtualMachines')]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'VirtualMachines'
        )]
        [ValidateSet('ProvisionerUser', 'PCloudAccount', 'IdentityUser', 'IdentityMgmtUser', 'TargetCertificate', 'General')]
        [String[]]$secret_type,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Databases'
        )]
        [switch]$databases
    )

    BEGIN { }#begin

    PROCESS {

        switch ($PSCmdlet.ParameterSetName) {
            'VirtualMachines' {
                $URI = "$($ISPSSSession.tenant_url)/api/secrets"

                $QueryString = $($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)

                If ($null -ne $QueryString) {
                    $URI = "$URI`?$QueryString"
                }
            }

            'Databases' {
                $URI = "$($ISPSSSession.tenant_url)/api/adb/secretsmgmt/secrets"
            }
        }


        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            switch ($PSCmdlet.ParameterSetName) {
                'Databases' {
                    $result = $result.secrets
                }
            }
            $result

        }

    }#process

    END {

    }#end

}