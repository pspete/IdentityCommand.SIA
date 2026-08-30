---
external help file: IdentityCommand.SIA-help.xml
Module Name: IdentityCommand.SIA
online version:
schema: 2.0.0
---

# New-SIAPolicyUserDataDefinition

## SYNOPSIS
Defines user data for the User Access Rule of a SIA policy.

## SYNTAX

### roles (Default)
```
New-SIAPolicyUserDataDefinition [-Role] [-name <String>] [-source <String>] [-UserDataDefinition <PSObject>]
 [<CommonParameters>]
```

### groups
```
New-SIAPolicyUserDataDefinition [-Group] [-name <String>] [-source <String>] [-UserDataDefinition <PSObject>]
 [<CommonParameters>]
```

### users
```
New-SIAPolicyUserDataDefinition [-User] [-name <String>] [-source <String>] [-UserDataDefinition <PSObject>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates an object for inclusion as a user access rule of a SIA Policy.

This function is used to provide the object for the \`userData\` parameter when defining a User Access Rules using the  \`New-SIAPolicyUserAccessRuleDefinition\` function.

## EXAMPLES

### Example 1
```
$UserData = New-SIAPolicyUserDataDefinition -Role -name "DEV_TEAM_ROLE"
```

Creates a user data definition for the "DEV_TEAM_ROLE" Identity Role.

The \`$UserData\` variable in the above example is used as input for the \`userData\` parameter of the \`New-SIAPolicyUserAccessRuleDefinition\` function.

### Example 2
```
$UserData = New-SIAPolicyUserDataDefinition -Role -name "DEV_TEAM_ROLE"
$UserData = New-SIAPolicyUserDataDefinition -Role -name "SOME_TEAM_ROLE" -UserDataDefinition $UserData
$UserData = New-SIAPolicyUserDataDefinition -Group -name "DEV_TEAM_GROUP" -UserDataDefinition $UserData
$UserData = New-SIAPolicyUserDataDefinition -Group -name "SOME_TEAM_GROUP" -UserDataDefinition $UserData
$UserData = New-SIAPolicyUserDataDefinition -User -name SomeUser -UserDataDefinition $UserData
$UserData = New-SIAPolicyUserDataDefinition -User -name SomeOtherUser -UserDataDefinition $UserData
```

Creates a user data definition for the Roles groups and users specified.

The \`$UserData\` variable in the above example is used as input for the \`userData\` parameter of the \`New-SIAPolicyUserAccessRuleDefinition\` function.

## PARAMETERS

### -Group
The name of a group to include in the user data definition.

The specified groups define which users can access the assets defined in a SIA policy.

```yaml
Type: SwitchParameter
Parameter Sets: groups
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Role
The name of a role to include in the user data definition.

The roles specified define which users can access the assets defined in a SIA policy.

```yaml
Type: SwitchParameter
Parameter Sets: roles
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The name of a user to include in the user data definition.

The users specifed can access the assets defined in a SIA policy.

A user's login name should be specified as it appears in CyberArk Identity Cloud Directory (login_name@suffix).

```yaml
Type: SwitchParameter
Parameter Sets: users
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UserDataDefinition
Adds additional data to previous output from \`New-SIAPolicyUserDataDefinition\`.

This is used when multiple users, groups and/or roles are required to be specified in an access rule.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name
The name of the user, group or role to include in the definition.

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

### -source
The source of the object to include in the rule.

If left blank, the source will be determined from the Identity Cloud Directory.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.SwitchParameter
### System.String
### System.Management.Automation.PSObject
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
