---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIAResource

## SYNOPSIS
Get details of configured SIA resources

## SYNTAX

### discovery/organizations
```
Get-SIAResource [-AWS] [-workspaceId <String>] [<CommonParameters>]
```

### discovery/subscriptions
```
Get-SIAResource [-Azure] [-workspaceId <String>] [<CommonParameters>]
```

### discovery/onprem
```
Get-SIAResource [-OnPrem] [<CommonParameters>]
```

### discovery/gcp/organizations
```
Get-SIAResource [-GCP] [-workspaceId <String>] [<CommonParameters>]
```

### adb/resources
```
Get-SIAResource [-Database] [<CommonParameters>]
```

## DESCRIPTION
Return data on configured SIA resources for either AWS, Azure, GCP, Databases Or-Prem.

Alternatively specify a specific AWS, Azure or GCP workspaceID to get resource details for.

## EXAMPLES

### Example 1
```
Get-SIAResource -Azure
```

Return details of all configured Azure subscription resources

### Example 2
```
Get-SIAResource -Azure -workspaceId d00dWh3r-35My-C4rc-8215-e32ea94649b1
```

Return details of specific Azure workspace.

### Example 3
```
Get-SIAResource -AWS
```

Return details of all configured AWS organization resources

## PARAMETERS

### -AWS
Specify to return AWS Organization resource details

```yaml
Type: SwitchParameter
Parameter Sets: discovery/organizations
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Azure
Specify to return Azure Subscription resource details

```yaml
Type: SwitchParameter
Parameter Sets: discovery/subscriptions
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OnPrem
Specify to return On-Premise resource details

```yaml
Type: SwitchParameter
Parameter Sets: discovery/onprem
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GCP
Specify to return GCP Organization resource details

```yaml
Type: SwitchParameter
Parameter Sets: discovery/gcp/organizations
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Database
Specify to return Database resource details

```yaml
Type: SwitchParameter
Parameter Sets: adb/resources
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -workspaceId
Specify to return resource details for a specific workspace

```yaml
Type: String
Parameter Sets: discovery/organizations, discovery/subscriptions, discovery/gcp/organizations
Aliases: subscription_id

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
