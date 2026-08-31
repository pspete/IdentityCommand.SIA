# .ExternalHelp IdentityCommand.SIA-help.xml
function Add-SIAConnectorPoolMember {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$connector_pool_id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String[]]$connectorId
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/api/connectors/connector-pools/$connector_pool_id"

        #Create Request Body - build the connectors array explicitly so a single connector id still
        #serialises as a JSON array (Windows PowerShell ConvertTo-Json unwraps single-element arrays).
        $connectorItems = @($connectorId | ForEach-Object { @{'connectorId' = $PSItem } | ConvertTo-Json -Compress })
        $body = '{{ "connectors": [{0}] }}' -f ($connectorItems -join ', ')

        if ($PSCmdlet.ShouldProcess($connector_pool_id, 'Assign connectors to SIA Connector Pool')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    END { }#end

}
