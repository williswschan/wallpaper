### Set individual monitor's wallpaper. The function makes use of .Net IDesktopWallper COM object which capable of setting wallpaper for each monitor separately.

Key files are "Function.ps1" & "Wallpaper.dll", recommended to place in same directory.
"Wallpaper.cs" & "Wallpaper.csproj" are optional, these are source code and VS code config file for reference or compile DLL in case of necessary.

Run ". .\Functions.ps1" at powershell command prompt, required module will be import and following PS functions will be available.
Get-Monitors
Get-MonitorResolution
Set-Wallpaper

Detail usage may use "get-help Set-Wallpaper -Full" for detail.

PS - Module requires .net framework 4.8.1 or above.

### Sample usage, alternatively may refer to Set-Wallpapers.ps1;
```
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
```
