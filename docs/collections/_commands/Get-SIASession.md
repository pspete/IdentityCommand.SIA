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

```
Get-SIASession [[-minStartedTime] <DateTime>] [[-maxStartedTime] <DateTime>] [<CommonParameters>]
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

## PARAMETERS

### -minStartedTime
The start date/time of the events to fetch

If not specified will default to 1 day before the maxStartedTime

```yaml
Type: DateTime
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
