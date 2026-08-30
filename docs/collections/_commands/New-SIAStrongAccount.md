---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---


# New-SIAStrongAccount

## SYNOPSIS
Create a new strong account configuration in SIA

## SYNTAX

### VaultedInPrivilegeCloud
```
New-SIAStrongAccount -safe <String> -account_name <String> -secret_name <String> -account_domain <String>
 [-certFileName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### StoredInSIA
```
New-SIAStrongAccount -username <String> -password <SecureString> -secret_name <String> -account_domain <String>
 [-certFileName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Configures a new strong account in SIA for use against either a virtual machine or database.
Strong account can be an account already vaulted in Privilege Cloud, or can be stored locally in the SIA service.

## EXAMPLES

### Example 1
```
New-SIAStrongAccount -username SomeUser -password $SecureString -secret_name SomeName -account_domain SomeDomain.com
```

Creates a virtual machine strong account which is stored in the SIA service

### Example 2
```
New-SIAStrongAccount -username dbuser -password $SecureString -secret_name SomeName -database
```

Creates a database strong account which is stored in the SIA service

### Example 3
```
New-SIAStrongAccount -safe StrongAccounts -account_name OS-WinDomain-pspete.dev-someuser -secret_name SomeUser -account_domain pspete.dev
```

Creates a virtual machine strong account which is vaulted in Privilege Cloud

### Example 4
```
New-SIAStrongAccount -safe DBAccts -account_name Database-DBHost-somedomain-dbuser -secret_name SomeName -database
```

Creates a database strong account which is vaulted in Privilege Cloud

## PARAMETERS

### -account_domain
The domain of the strong account

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -account_name
The object name of the strong account from Privilege Cloud

```yaml
Type: String
Parameter Sets: VaultedInPrivilegeCloud
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -certFileName
A certificate filename for the account

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -password
The password of the strong account as a secure string

```yaml
Type: SecureString
Parameter Sets: StoredInSIA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -safe
The Privilege Cloud safe that the string account is vaulted in

```yaml
Type: String
Parameter Sets: VaultedInPrivilegeCloud
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -secret_name
A name to configure for the strong account in SIA

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -username
The user name of the string account

```yaml
Type: String
Parameter Sets: StoredInSIA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### System.Security.SecureString
### System.Management.Automation.SwitchParameter
## OUTPUTS

### System.Object
## NOTES
Requires the DpaAdmin role.

## RELATED LINKS
