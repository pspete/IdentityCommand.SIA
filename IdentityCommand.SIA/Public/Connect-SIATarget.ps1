# .ExternalHelp IdentityCommand.SIA-help.xml
function Connect-SIATarget {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'DPA-RDP'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-RDP'
        )]
        [switch]$RDP,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'DPA-SSH'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-SSH'
        )]
        [switch]$SSH,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'DPA-SSH'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-SSH'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'DPA-RDP'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-RDP'
        )]
        [String]$targetAddress,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-SSH'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-RDP'
        )]
        [String]$targetUser,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-SSH'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'DPA-RDP'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-RDP'
        )]
        [String]$targetDomain,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-SSH'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-RDP'
        )]
        [String]$logicalName,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Vaulted-RDP'
        )]
        [bool]$elevatedPrivileges

    )

    begin {
        $Properties = @{}
    }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/adb/sso/acquire"

        switch ($PSCmdlet.ParameterSetName) {
            { $PSItem -match 'RDP$' } {
                #Get request parameters
                $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove RDP

                #Create Request Object
                $Properties.Add('service', 'DPA-RDP')
                $Properties.Add('tokenResponseFormat', 'extended')
                $Properties.Add('tokenType', 'rdp_file')
                $Properties.Add('tokenParameters', $boundParameters)

                switch ($boundParameters.keys) {
                    #values for RDP filename
                    'targetAddress' {
                        $name_address = " _a $targetAddress"
                    }
                    'targetDomain' {
                        $name_domain = " _d $targetDomain"
                    }
                }

                #Create body
                $body = $Properties | ConvertTo-Json

                #Send request
                $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

                break
            }

            { $PSItem -match 'SSH$' } {
                #Get session data for username and url
                $SessionData = Get-SIAModuleData
                $URI = [System.Uri]$SessionData.tenant_url
                $UserName = $((Get-SIAModuleData).user)
                #get subdomain & SSH GW address from URI host
                $Subdomain = $($URI.Host.Split('.')[0])
                $SSHGateway = $($URI.Host.Replace('dpa', 'ssh'))

                #Build connection string elements if parameters provided
                switch ($PSBoundParameters) {
                    ( { $PSItem.ContainsKey('targetUser') }) {
                        $ConnectAsUser = "@$targetUser"
                    }
                    ( { $PSItem.ContainsKey('targetDomain') }) {
                        $ConnectAsDomain = "`#$targetDomain"
                    }
                    ( { $PSItem.ContainsKey('logicalName') }) {
                        $logicalNetwork = "`#$logicalName"
                    }
                }

                #build connection string for ZSP & vaulted credential ssh access
                $ConnectionString = "$UserName`#$Subdomain$ConnectAsUser$ConnectAsDomain@$targetAddress$logicalNetwork@$SSHGateway"

                Write-Debug $ConnectionString

                $result = $ConnectionString
                break
            }

        }

        if ($null -ne $result) {
            switch ($PSCmdlet.ParameterSetName) {
                { $PSItem -match 'RDP$' } {
                    #invoke an rdp connection using rdp file saved to temp directory
                    $Path = [System.IO.Path]::GetTempPath()
                    $FileName = "dpa$name_address$name_domain.rdp"
                    $FilePath = Join-Path $Path $FileName
                    $RDPFileContents = $result.token.text
                    try {
                        Set-Content -Value $RDPFileContents -Path $FilePath -Force -ErrorAction Stop
                        Get-Item -Path $FilePath -ErrorAction Stop | Invoke-Item
                    } catch {
                        throw $PSItem
                    }
                    break
                }

                { $PSItem -match 'SSH$' } {
                    #invoke ssh session using constructed connection string
                    ssh $result
                    break
                }
            }

        }

    }#process

    end { }#end

}