---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Add-SIATargetSet

## SYNOPSIS
Add a new target set in SIA

## SYNTAX

```
Add-SIATargetSet [-name] <String> [[-provision_format] <String>] [[-description] <String>]
 [-enable_certificate_validation] <Boolean> [-secret_type] <String> [-secret_id] <String> [-type] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Configure a new target in SIA

## EXAMPLES

### Example 1
```
Add-SIATargetSet -name somedomain.com -description "Some Description" -secret_type PCloudAccount -secret_id 1234-abcd -type Domain
```

Adds a target set for a strong account vaulted in Privilege Cloud

### Example 1
```
Add-SIATargetSet -name host.somedomain.com -description "Some Description" -secret_type ProvisionerUser -secret_id 1234-abcd -type Target
```

Adds a target set for SIA stored strong account

## PARAMETERS

### -description
Descriptive text for the target set

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -enable_certificate_validation
Whether certificate validation is enabled or not

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name
The name of the target set

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -provision_format
A naming format for any accounts provisioned by the target set

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -secret_id
The ID of the associated strong account

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -secret_type
The type of the associated strong account

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: ProvisionerUser, PCloudAccount, IdentityUser, IdentityMgmtUser, TargetCertificate, General

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -type
The type of the target set

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Domain, Suffix, Target

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### System.Boolean
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
