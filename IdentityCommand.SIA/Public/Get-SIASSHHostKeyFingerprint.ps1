# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIASSHHostKeyFingerprint {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 255)]
        [String]$target_id
    )

    begin { }#begin

    process {

        $URI = "$(Resolve-RequestUrl)/api/ssh-fingerprints/$target_id"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result

        }

    }#process

    end { }#end

}
