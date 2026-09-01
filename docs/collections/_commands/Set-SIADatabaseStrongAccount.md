---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---


# Set-SIADatabaseStrongAccount

## SYNOPSIS
Update a SIA database strong account

## SYNTAX

### PAM
```
Set-SIADatabaseStrongAccount -strong_account_id <String> -name <String> [-PAM] -safe <String>
 -account_name <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Managed
```
Set-SIADatabaseStrongAccount -strong_account_id <String> -name <String> [-Managed] -platform <String>
 -username <String> [-password <SecureString>] [-address <String>] [-port <Int32>] [-database <String>]
 [-dsn <String>] [-account_properties <Hashtable>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### AWS
```
Set-SIADatabaseStrongAccount -strong_account_id <String> -name <String> -username <String> [-AWS]
 -aws_account_id <String> -aws_access_key_id <String> [-secret_access_key <SecureString>]
 [-aws_account_alias_name <String>] [-region <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates an existing database strong account (PAM or managed) in SIA.

## EXAMPLES

### Example 1
```
Set-SIADatabaseStrongAccount -strong_account_id 550e8400 -PAM -name UpdatedAccount -safe UpdatedSafe -accountName admin@newdomain.com
```

Updates the specified PAM database strong account.

## PARAMETERS

### -account_name
The CyberArk Privilege Cloud account name (PAM accounts).

```yaml
Type: String
Parameter Sets: PAM
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -account_properties
A hashtable of additional platform-specific account properties, with keys as expected by the API (for example dsn, auth_database, replica_set, use_ssl, log_on_to, user_dn, region, aws_account_id, aws_access_key_id, reconcile_is_win_account).

```yaml
Type: Hashtable
Parameter Sets: Managed
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -address
The address of the database server.

```yaml
Type: String
Parameter Sets: Managed
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AWS
Create/update a managed AWS Access Keys database strong account.

```yaml
Type: SwitchParameter
Parameter Sets: AWS
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_access_key_id
The AWS access key ID.

```yaml
Type: String
Parameter Sets: AWS
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_account_alias_name
The AWS account alias name. Optional.

```yaml
Type: String
Parameter Sets: AWS
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -aws_account_id
The AWS account ID number.

```yaml
Type: String
Parameter Sets: AWS
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -database
The database name.

```yaml
Type: String
Parameter Sets: Managed
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -dsn
The data source name. Optional.

```yaml
Type: String
Parameter Sets: Managed
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Managed
Create or update a managed database strong account, where SIA stores the credential.

```yaml
Type: SwitchParameter
Parameter Sets: Managed
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name
The name of the database strong account.

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

### -PAM
Create or update a PAM (Privilege Cloud vaulted) database strong account.

```yaml
Type: SwitchParameter
Parameter Sets: PAM
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -password
A new account password, as a SecureString (non-AWS platforms).
Omit to leave the password unchanged.

```yaml
Type: SecureString
Parameter Sets: Managed
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -platform
The account platform - one of PostgreSQL, MySQL, MariaDB, MSSql, Oracle, MongoDB, DB2UnixSSH, WinDomain or AWSAccessKeys.

```yaml
Type: String
Parameter Sets: Managed
Aliases:
Accepted values: PostgreSQL, MySQL, MariaDB, MSSql, Oracle, MongoDB, DB2UnixSSH, WinDomain, AWSAccessKeys

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -port
The port of the database server (1-65535).

```yaml
Type: Int32
Parameter Sets: Managed
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -region
The AWS region. Optional.

```yaml
Type: String
Parameter Sets: AWS
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -safe
The name of the CyberArk Privilege Cloud safe where the account is vaulted.

```yaml
Type: String
Parameter Sets: PAM
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -secret_access_key
A new AWS secret access key, as a SecureString (AWSAccessKeys platform).
Omit to leave it unchanged.

```yaml
Type: SecureString
Parameter Sets: AWS
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -strong_account_id
The unique identifier of the database strong account.

```yaml
Type: String
Parameter Sets: (All)
Aliases: id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -username
The username of the strong account credential.

```yaml
Type: String
Parameter Sets: Managed, AWS
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
### System.Management.Automation.SwitchParameter
### System.Int32
### System.Collections.Hashtable
## OUTPUTS

### System.Object
## NOTES
Requires the DpaAdmin role.

## RELATED LINKS
