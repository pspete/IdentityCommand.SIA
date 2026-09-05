# .ExternalHelp IdentityCommand.SIA-help.xml
function Get-SIAModuleData {

    [CmdletBinding()]
    param()

    begin { }#begin

    process {

        #Calculate the time elapsed since the start of the session and include in return data
        if ($null -ne $ISPSSSession.StartTime) {
            $ISPSSSession.ElapsedTime = '{0:HH:mm:ss}' -f ([datetime]$($(Get-Date) - $($ISPSSSession.StartTime)).Ticks)
        } else { $ISPSSSession.ElapsedTime = $null }

        #Deep Copy the $ISPSSSession session object and return as IdCmd Session type.
        Get-SessionClone -InputObject $ISPSSSession | Add-CustomType -Type IdCmd.Session

    }#process

    end { }#end

}