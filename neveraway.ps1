Add-Type -AssemblyName System.Windows.Forms
 
function Click-Mouse {
    # Save the current cursor position
    $currentPosition = [System.Windows.Forms.Cursor]::Position
 
    # Move the cursor to a specific location (adjust x, y as needed)
    [System.Windows.Forms.Cursor]::Position = [System.Drawing.Point]::new(200, 200)
    Start-Sleep -Milliseconds 100
 
    # Simulate mouse down and up (left click)
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Mouse {
        [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint cButtons, uint dwExtraInfo);
        private const int MOUSEEVENTF_LEFTDOWN = 0x02;
        private const int MOUSEEVENTF_LEFTUP = 0x04;
        public static void Click() {
            mouse_event(MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
        }
    }
"@
 
    [Mouse]::Click()
    Start-Sleep -Milliseconds 100
 
    # Return the cursor to its original position
    [System.Windows.Forms.Cursor]::Position = $currentPosition
}
 
while ($true) {
    Click-Mouse
    # This is the number of seconds in between mouse clicks, 
    #   adjusted as needed depending on your Teams "away" timer.  
    #   Mine is 5 minutes (300 seconds), so I put it to something lower than that, 250.
    Start-Sleep -Seconds 250  
}
