---
external help file: PSTools-help.xml
Module Name: PSTools
online version:
schema: 2.0.0
---

# Get-LastBoot

## SYNOPSIS

Get computer last boot time

## SYNTAX

```yaml
Get-LastBoot [-Computername <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION

Get information about a server's last boot time and uptime.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-LastBoot

   Computername: THINKX1-JH [Microsoft Windows 11 Pro]

LastBoot                                   Uptime
--------                                   ------
4/13/2024 10:22:50 AM          2.05:35:37.1966781
```

### Example 2

```powershell
PS C:\> Get-LastBoot dom1

   Computername: DOM1 [Microsoft Windows Server 2019 Standard]

LastBoot                                   Uptime
--------                                   ------
4/15/2024 3:35:35 PM             00:22:08.6067023
```

## PARAMETERS

### -Computername

The name of a remote computer to query. If not specified, the local computer is queried.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
