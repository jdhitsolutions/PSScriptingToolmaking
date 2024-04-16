Function Get-CriticalEventLogEntry {
    [CmdletBinding()]
    [alias('gcel')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Specify a Windows event log name like System.'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$LogName,

        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Computername =$env:COMPUTERNAME,

        [int]$Count = 20
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }
    Process {
        Write-Verbose "Getting $LogName entries from $Computername"
        Get-WinEvent -FilterHashtable @{LogName = $LogName; Level = 2,3 } -MaxEvents $Count -ComputerName $Computername |
        Select-Object -property @{Name="Computername";Expression = {$_.MachineName}},
        TimeCreated,ID,ProviderName,Message,LevelDisplayName,
        @{Name="LogName";Expression={$_.ContainerLog}}
    }
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
} #close Get-CriticalEventLogEntry