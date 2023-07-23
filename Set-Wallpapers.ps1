. $PSScriptRoot\Functions.ps1

For ($MonitorID = 0; $MonitorID -le $((Get-ConnectedMonitors) - 1); $MonitorID++) {

    $WallpaperDirectory = "C:\Windows\Web\4K\Wallpaper\Windows"
    $Width = (Get-MonitorResolution -MonitorID $MonitorID).Width
    $Height = (Get-MonitorResolution -MonitorID $MonitorID).Height
    $WallpaperFilePath = $WallpaperDirectory + "\img0_" + $Width + "x" + $Height + ".jpg"
    
    If ([System.IO.File]::Exists($WallpaperFilePath)) {
        Set-Wallpaper -MonitorID $MonitorID -WallpaperFilePath $WallpaperFilePath
    }
}