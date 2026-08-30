---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Set-SIAStrongAccount

## SYNOPSIS
Update a strong account in SIA

## SYNTAX

### VaultedInPrivilegeCloud-DB
```
Set-SIAStrongAccount -secret_id <String> -safe <String> -account_name <String> -secret_name <String>
 [-database] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### VaultedInPrivilegeCloud-VM
```
Set-SIAStrongAccount -secret_id <String> -safe <String> -account_name <String> -secret_name <String>
 -account_domain <String> [-certFileName <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### StoredInDPA-DB
```
Set-SIAStrongAccount -secret_id <String> -username <String> -password <SecureString> -secret_name <String>
 [-database] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### StoredInDPA-VM
```
Set-SIAStrongAccount -secret_id <String> -username <String> -password <SecureString> -secret_name <String>
 -account_domain <String> [-certFileName <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates a configured strong account for either virtual machines or databases, using credentials vaulted in CyberArk Privilege Cloud or stored directly in SIA.

## EXAMPLES

### Example 1
```powershell
Set-SIAStrongAccount -secret_id 1234-abcd -secret_name MyAccount -username svc_sia -password $pwd -account_domain ad.example.com
```

Updates the specified strong account with credentials stored in SIA.

## PARAMETERS

### -account_domain
The domain of the strong account.

```yaml
Type: String
Parameter Sets: VaultedInPrivilegeCloud-VM, StoredInDPA-VM
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -account_name
The name of the vaulted CyberArk Privilege Cloud account.

```yaml
Type: String
Parameter Sets: VaultedInPrivilegeCloud-DB, VaultedInPrivilegeCloud-VM
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -certFileName
The filename of the certificate to use for authentication.

```yaml
Type: String
Parameter Sets: VaultedInPrivilegeCloud-VM, StoredInDPA-VM
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -database
Specifies that the strong account relates to a database rather than a virtual machine.

```yaml
Type: SwitchParameter
Parameter Sets: VaultedInPrivilegeCloud-DB, StoredInDPA-DB
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -password
The password of the strong account credential stored in SIA, as a SecureString.

```yaml
Type: SecureString
Parameter Sets: StoredInDPA-DB, StoredInDPA-VM
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -safe
The name of the CyberArk Privilege Cloud safe where the account is vaulted.

```yaml
Type: String
Parameter Sets: VaultedInPrivilegeCloud-DB, VaultedInPrivilegeCloud-VM
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -secret_id
The unique identifier of the strong account to update.

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

### -secret_name
A friendly name for the strong account.

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
The username of the strong account credential stored in SIA.

```yaml
Type: String
Parameter Sets: StoredInDPA-DB, StoredInDPA-VM
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
Default value: None
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
Default value: None
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

## RELATED LINKS
