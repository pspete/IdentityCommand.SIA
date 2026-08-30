---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---


# Get-SIAStrongAccount

## SYNOPSIS
Get string account details from SIA

## SYNTAX

```
Get-SIAStrongAccount [-secret_type <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get details of configured string accounts for either virtual machines or databases

## EXAMPLES

### Example 1
```
Get-SIAStrongAccount
```

Get all virtual machine strong accounts

### Example 2
```
Get-SIAStrongAccount -secret_type PCloudAccount
```

Get all virtual machine strong accounts which are vaulted in Privilege Cloud

### Example 3
```
Get-SIAStrongAccount -databases
```

Get all database strong accounts

## PARAMETERS

### -secret_type
Specify to filter the type of virtual machine strong account to get details for.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: ProvisionerUser, PCloudAccount, IdentityUser, IdentityMgmtUser, TargetCertificate, General

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]
### System.Management.Automation.SwitchParameter
## OUTPUTS

### System.Object
## NOTES
Requires the DpaAdmin role.

## RELATED LINKS
