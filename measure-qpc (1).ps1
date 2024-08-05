Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Win32Interop {
    [DllImport("kernel32.dll")]
    public static extern bool QueryPerformanceFrequency(out long lpFrequency);

    [DllImport("kernel32.dll")]
    public static extern bool QueryPerformanceCounter(out long lpPerformanceCount);
}
"@

$frequency = 0
$counterStart = 0
$counterEnd = 0

Write-Host "You should see True three times, and then a time as seconds."
Write-Host "If you don't, your computer is failing to call QueryPerformanceCounter."

[Win32Interop]::QueryPerformanceFrequency([ref]$frequency)
[Win32Interop]::QueryPerformanceCounter([ref]$counterStart)
[Win32Interop]::QueryPerformanceCounter([ref]$counterEnd)

$elapsedTime = ($counterEnd - $counterStart) / $frequency
Write-Host "Elapsed time: $elapsedTime seconds"
