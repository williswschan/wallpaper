. $PSScriptRoot\Functions.ps1

For ($MonitorID = 0; $MonitorID -le $((Get-ConnectedMonitors) - 1); $MonitorID++) {

    $WallpaperDirectory = "C:\Windows\Web\4K\Wallpaper\Windows"
    $Width = (Get-Wallpaper -MonitorID $MonitorID).Width
    $Height = (Get-Wallpaper -MonitorID $MonitorID).Height
    $WallpaperFilePath = $WallpaperDirectory + "\img0_" + $Width + "x" + $Height + ".jpg"
#    $WallpaperFilePath = "C:\Windows\Web\4K\Wallpaper\Windows\img0_3840x2160.jpg"
    
    If ([System.IO.File]::Exists($WallpaperFilePath)) {
        Set-Wallpaper -MonitorID $MonitorID -WallpaperFilePath $WallpaperFilePath
    }
}