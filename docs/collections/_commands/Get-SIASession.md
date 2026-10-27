---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# Get-SIASession

## SYNOPSIS
Get SIA Session data

## SYNTAX

### List (Default)
```
Get-SIASession [[-minStartedTime] <DateTime>] [[-maxStartedTime] <DateTime>] [<CommonParameters>]
```

### ById
```
Get-SIASession -session_id <String> [<CommonParameters>]
```

## DESCRIPTION
Gets SIA session diagnostic data

## EXAMPLES

### Example 1
```
Get-SIASession
```

Gets session diagnostic data for the previous 24 hours

### Example 2
```
Get-SIASession -maxStartedTime (Get-Date 03-03-2024)
```

Gets session diagnostic data for 24 hours preceding the specified date

### Example 3
```
Get-SIASession -maxStartedTime (Get-Date 03-03-2024) -minStartedTime (Get-Date 01-03-2024)
```

Gets session diagnostic data between the specified dates

### Example 4
```
Get-SIASession -minStartedTime (Get-Date 01-03-2024)
```

Gets session diagnostic data from the specified dates until now

### Example 5
```
Get-SIASession -session_id a93281d8-6109-dcc4-b537-67e45b41f732
```

Gets the specified session

### Example 6
```
$session = Get-SIASession -session_id a93281d8-6109-dcc4-b537-67e45b41f732
$session.extra_info
($session.extra_info | Where-Object key -eq cms).details | Format-Table
```

Lists the connection steps of the session, then shows the tunnel details for each connector as a table.

Step details holding JSON are returned as objects; other details are returned as text.

## PARAMETERS

### -minStartedTime
The start date/time of the events to fetch

If not specified will default to 1 day before the maxStartedTime

```yaml
Type: DateTime
Parameter Sets: List
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -maxStartedTime
The end date/time of the events to fetch

If not specified, will default to now

```yaml
Type: DateTime
Parameter Sets: List
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -session_id
The id of the session to get

```yaml
Type: String
Parameter Sets: ById
Aliases:

Required: True
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
