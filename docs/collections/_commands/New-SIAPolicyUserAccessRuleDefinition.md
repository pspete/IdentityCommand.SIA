---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# New-SIAPolicyUserAccessRuleDefinition

## SYNOPSIS
Define User Access Rules for a SIA Policy

## SYNTAX

```
New-SIAPolicyUserAccessRuleDefinition [-ruleName] <String> [[-userData] <PSObject>] [-connectAs] <PSObject>
 [[-grantAccess] <Int32>] [[-idleTime] <Int32>] [[-daysOfWeek] <String[]>] [[-fullDays] <Boolean>]
 [[-hoursFrom] <String>] [[-hoursTo] <String>] [-timeZone] <String> [<CommonParameters>]
```

## DESCRIPTION
Creates user access rule definitions to provide as input when creating a new SIA policy with \`New-SIAPolicy\`

## EXAMPLES

### Example 1
```
$AccessRules = New-SIAPolicyUserAccessRuleDefinition -ruleName SomeRuleName -userData $UserData -connectAs $ConnectAs -grantAccess 1 -idleTime 5 -timeZone Europe/London
```

Defines a new user access rule according to the specified parameters.

\`$UserData\` object is created using the \`New-SIAPolicyUserDataDefinition\` command

\`$ConnectAs\` object is created using the \`New-SIAPolicyConnectAsDefinition\` command

### Example 2
```
$AccessRules = @()

$AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName SomeAccessRule -userData $UserData1 `
-connectAs $ConnectAs1 -grantAccess 1 -idleTime 10 -timeZone Europe/London -daysOfWeek Mon,Tue,Wed,Thu,Fri

$AccessRules += New-SIAPolicyUserAccessRuleDefinition -ruleName AnotherAccessRule -userData $UserData2 `
-connectAs $ConnectAs2 -grantAccess 1 -idleTime 10 -timeZone America/Costa_Rica -fullDays $false `
-hoursFrom 09:00 -hoursTo 18:00
```

Defines a set of user access rules according to the specified parameters.

\`$UserData\` object is created using the \`New-SIAPolicyUserDataDefinition\` command

\`$ConnectAs\` object is created using the \`New-SIAPolicyConnectAsDefinition\` command

## PARAMETERS

### -connectAs
Accepts object output from New-SIAPolicyConnectAsDefinition.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -daysOfWeek
Days of the week during which the policy will allow access.

Leave empty for all days.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Mon, Tue, Wed, Thu, Fri, Sat, Sun

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -fullDays
Whether the policy will give access during the entire day.

If this is set to false, a timeframe is required in the hoursFrom and hoursTo parameters.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -grantAccess
The maximum time of the session in hours.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -hoursFrom
The time of day from which the policy will allow access.

Time format: hh:mm.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -hoursTo
The time of day until which the policy will allow access.

Time format: hh:mm.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -idleTime
The maximum idle time before the session ends, in minutes.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ruleName
The access rule name.

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

### -timeZone
The timezone that is taken into account when calculating the hoursFrom and hoursTo parameters.

Represented by zone name such as "America/Los_Angeles" or "Australia/Sydney".

These names are defined by TZ database name.

Full list can be found in the following links: - https://www.iana.org/time-zones

- https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -userData
Accepts object output from New-SIAPolicyUserDataDefinition.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### System.Management.Automation.PSObject
### System.Int32
### System.String[]
### System.Boolean
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
