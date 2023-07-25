if ([System.IO.File]::Exists("$($PSScriptRoot)\bin\Debug\net481\Wallpaper.dll")) {
    Import-Module -Name "$($PSScriptRoot)\bin\Debug\net481\Wallpaper.dll"
} else {
    Import-Module -Name $PSScriptRoot   # Import all moduel in the desired directory.
}

Function Get-ConnectedMonitors {
<#
.SYNOPSIS
    Return number of connected monitor(s).

.DESCRIPTION
    Return number of connected monitor(s), please notice that this value stars from 1 while monitorID start from 0, you may want to minus 1 when using together with pipeline .

.EXAMPLE
     Get-ConnectedMonitors

.OUTPUTS
    Int

.NOTES
    Author:  Willis Chan
    Website: https://github.com/williswschan/wallpaper
#>

    [NOM.Wallpaper]::GetConnectedMonitors()

}

Function Get-Wallpaper {
<#
.SYNOPSIS
    Return monitor's properties such as width, height and aspect ratio...etc information.

.DESCRIPTION
    Return monitor's properties such as width, height and aspect ratio...etc information, please notice that value of "MonitorID" should stars from 0.

.EXAMPLE
    Get-Wallpaper -MonitorID 0

.EXAMPLE
    (Get-ConnectedMonitors) - 1 | Get-Wallpaper

.EXAMPLE
    (Get-Wallpaper -MonitorID 0).Width

.OUTPUTS
    PSCustomObject

.NOTES
    Author:  Willis Chan
    Website: https://github.com/williswschan/wallpaper
#>    

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage="Enter the monitor id, please notice it starts from 0.")]
        [Alias("ID")]
        [int]$MonitorID
    )

    $Name = ([NOM.Wallpaper]::GetWallpaper($MonitorID)[0]).ToString() + "x" + ([NOM.Wallpaper]::GetWallpaper($MonitorID)[1]).ToString()
    [int] $Width = [NOM.Wallpaper]::GetWallpaper($MonitorID)[0]
    [int] $Height = [NOM.Wallpaper]::GetWallpaper($MonitorID)[1]
    $AspectRatio = [math]::Round([NOM.Wallpaper]::GetWallpaper($MonitorID)[0] / [NOM.Wallpaper]::GetWallpaper($MonitorID)[1],2)
    $Wallpaper = [NOM.Wallpaper]::GetWallpaper($MonitorID)[2]
    $Position = [NOM.Wallpaper]::GetWallpaper($MonitorID)[3]
    $MonitorDevicePathCount = [NOM.Wallpaper]::GetWallpaper($MonitorID)[4]

    $AspectRatio = $AspectRatio.ToString()
    
    $AspectRatio = switch ($AspectRatio) {
        "1.78"  {"16:9"; break}
        "1.6"  {"16:10"; break}        
        "1.33"   {"4:3"; break}
        "1.5"   {"3:2"; break}
        "2.33" {"21:9"; break}
        "3.56"  {"32:9"; break}
        default {"Unknown"; break}
    }

    $MonitorResolution = [PSCustomObject]@{
        Name = $Name
        Width = $Width
        Height = $Height
        AspectRatio = $AspectRatio
        Wallpaper = $Wallpaper
        Position = $Position
        MonitorDevicePathCount = $MonitorDevicePathCount
    }

    $MonitorResolution
}

Function Set-Wallpaper {
<#
.SYNOPSIS
    Set individual monitor's wallpaper.

.DESCRIPTION
    Set individual monitor's wallpaper. The function makes use of .Net IDesktopWallper COM object which capable of setting wallpaper for each monitor separately.  

.EXAMPLE
    Set-Wallpaper -MonitorID 0 -WallpaperFilePath "C:\Windows\Web\4K\Wallpaper\Windows\img0_3840x2160.jpg" -Position Center

.NOTES
    Author:  Willis Chan
    Website: https://github.com/williswschan/wallpaper
#> 

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage="Enter the monitor id, please notice it starts from 0.")]
        [Alias("ID")]
        [int]$MonitorID,
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage="Enter the wallpaper file path.")]
        [Alias("Wallpaper", "File", "Path")]
        [string]$WallpaperFilePath,
        [Parameter(ValueFromPipeline, HelpMessage="Enter the desired postion. Available values are Center, Tile, Stretch(Default if omitted), Fit, Fill, Span.")]
        [string]$Position = "Stretch" 
    )

    If ($MonitorID -le $(Get-ConnectedMonitors) - 1) {
        try {
            [NOM.Wallpaper]::SetWallpaper($MonitorID, $WallpaperFilePath, $Position) | Out-Null
        }
        catch {
            Write-Error $Error[0]
        }            
    } else {
        Write-Host -ForegroundColor Red "MonitorID greater than connected monitor(s)."
    }

<#
    try {
        [NOM.Wallpaper]::SetWallpaper($MonitorID, $WallpaperFilePath, $Position) | Out-Null
    }
    catch {
        Write-Error $Error[0]
    }     
#>  

}

Function Reset-Wallpaper {
    <#
    .SYNOPSIS
        Reset wallpaper setting saved in roaming profile.
    
    .DESCRIPTION
        Reset wallpaper setting saved in roaming profile. This will ensure wallpaper change will be effective immediately.
    
    .EXAMPLE
         Reset-Wallpaper
    
    .NOTES
        Author:  Willis Chan
        Website: https://github.com/williswschan/wallpaper
    #>
    
        [NOM.Wallpaper]::ResetWallpaper("")
    
    }