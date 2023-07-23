using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Management.Automation;
using System.Collections.Generic;

namespace NOM
{
    public class DesktopWallpaper
    {
        public enum DesktopWallpaperPosition
        {
            Center = 0, // may see the screen border
            Tile = 1,   // can set for individual monitor, this repeats the same image across the background like tile along a bathroom wall
            Stretch = 2,    // no perspectives(not maintain the aspect ratio)
            Fit = 3,    //  this option shrinks or enlarges your photo to fit your screen’s height
            Fill = 4,   // will enlarge or shrink the image according to your screen’s width to get a proper fit
            Span = 5    // wallpaper will span on all screen
        }

        [ComImport, Guid("B92B56A9-8B55-4E14-9A89-0199BBB6F93B"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        public interface IDesktopWallpaper  // interface class, members of an interface are abstract and public.
        {
            void SetWallpaper([MarshalAs(UnmanagedType.LPWStr)] string monitorID, [MarshalAs(UnmanagedType.LPWStr)] string wallpaper);
            [return: MarshalAs(UnmanagedType.LPWStr)]
            string GetWallpaper([MarshalAs(UnmanagedType.LPWStr)] string monitorID);  // reference by get wallpaper file path
            [return: MarshalAs(UnmanagedType.LPWStr)]
            string GetMonitorDevicePathAt(uint monitorIndex);
            [return: MarshalAs(UnmanagedType.U4)]
            uint GetMonitorDevicePathCount();
            void SetBackgroundColor([MarshalAs(UnmanagedType.U4)] uint color);
            void SetPosition([MarshalAs(UnmanagedType.I4)] DesktopWallpaperPosition position);
            [return: MarshalAs(UnmanagedType.I4)]
            DesktopWallpaperPosition GetPosition();
        }

        public class WallpaperWrapper   // subclass of DesktopWallpaper
        {
            static readonly Guid CLSID_DesktopWallpaper = new Guid("{C2CF3110-460E-4fc1-B9D0-8A1C0C9CC4BD}");   // Create a GUID
            public static IDesktopWallpaper CreateInstance()
            {
                Type typeDesktopWallpaper = Type.GetTypeFromCLSID(CLSID_DesktopWallpaper);
                return (IDesktopWallpaper)Activator.CreateInstance(typeDesktopWallpaper);
            }
        }
    }

    public class Wallpaper  // main class
    {
        public static void SetWallpaper(uint monitorID, string path, string position = "Stretch" )   // method to setwallpaper
        {
            DesktopWallpaper.IDesktopWallpaper wallpaper = DesktopWallpaper.WallpaperWrapper.CreateInstance();
            DesktopWallpaper.DesktopWallpaperPosition wallpaperPosition;
            Enum.TryParse(position, out wallpaperPosition);
            if (monitorID <= wallpaper.GetMonitorDevicePathCount())
            {
                string monitor = wallpaper.GetMonitorDevicePathAt(monitorID);
                wallpaper.SetWallpaper(monitor, path);
                wallpaper.SetPosition(wallpaperPosition);   // wallpaper.SetPosition(DesktopWallpaper.DesktopWallpaperPosition.Fill);
            }
            Marshal.ReleaseComObject(wallpaper);
        }

        public static List<int> GetMonitorResolution(uint monitorID)    // method to getwallpaper
        {
            DesktopWallpaper.IDesktopWallpaper wallpaper = DesktopWallpaper.WallpaperWrapper.CreateInstance();
            var screen = Screen.AllScreens[monitorID];
            List<int> screenBounds = new List<int>();  
            screenBounds.Add(screen.Bounds.Width);  
            screenBounds.Add(screen.Bounds.Height);  
            Marshal.ReleaseComObject(wallpaper);    // release the mapped COM object
            return screenBounds;  
        }

        public static int GetConnectedMonitors()    // method to getmonitors
        {
            return Screen.AllScreens.Length;
        }
    }  
}