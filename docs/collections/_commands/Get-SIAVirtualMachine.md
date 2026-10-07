---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIAVirtualMachine

## SYNOPSIS
Get details of VM infrastructure targets from SIA

## SYNTAX

```
Get-SIAVirtualMachine [[-filter] <String>] [[-source] <String>] [[-sort] <String>] [[-search] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get details of the virtual machine infrastructure targets belonging to the tenant, optionally filtered, searched and sorted. Results are automatically paginated - all matching records are returned regardless of how many pages the API splits them across.

## EXAMPLES

### Example 1
```
Get-SIAVirtualMachine
```

Get all VM infrastructure targets from SIA

### Example 2
```
Get-SIAVirtualMachine -source CLOUD
```

Get all VM infrastructure targets which were found by cloud discovery

### Example 3
```
Get-SIAVirtualMachine -filter "((name contains 'prod') and (region eq 'us-east-1'))"
```

Get all VM infrastructure targets whose name contains prod, in the us-east-1 region

### Example 4
```
Get-SIAVirtualMachine -search 'prod' -sort 'region DESC,name ASC'
```

Search VM infrastructure targets for the keyword prod, returning results sorted by region descending then name ascending

## PARAMETERS

### -filter
Return only targets matching the criteria of the filter expression.

Each logical expression must be enclosed in parentheses, with parentheses nested for `and`/`or` combinations.

Supported comparison operators: `eq`, `ne`, `gt`, `ge`, `lt`, `le`, `contains`, `not contains`, `starts with`, `ends with`, `is null`, `is not null`.

Fields available to filter on: `machineId`, `workspaceId`, `rootId`, `name`, `region`, `networkName`, `resourceGroup`, `locationType`, `osType`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -source
Return only targets found by the specified discovery source.

`CLOUD` for cloud discovery, `MANUAL` for manually added targets, `USERDRIVEN` for user connected targets.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: CLOUD, MANUAL, USERDRIVEN

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sort
A comma separated list of fields to sort the results by, each optionally followed by `ASC` or `DESC`, for example `region DESC,name ASC`.

The API sorts by `scannedOn DESC` when not specified.

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

### -search
Search targets by keyword. The `machineId`, `name` and `ips` fields are searched.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
