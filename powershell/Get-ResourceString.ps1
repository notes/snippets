function Get-ResourceString {
    param($path)

    $code = @'
    [DllImport("user32.dll", EntryPoint="LoadStringW", CallingConvention = CallingConvention.Winapi, CharSet = CharSet.Unicode)]
    public static extern int LoadString(IntPtr hModule, int resourceID, StringBuilder resourceValue, int len);
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, ExactSpelling = true, EntryPoint = "LoadLibraryExW")]
    public static extern IntPtr LoadLibraryEx(string lpFileName, IntPtr hFile, uint dwFlags);
    [DllImport("kernel32.dll", ExactSpelling = true)]
    public static extern int FreeLibrary(IntPtr hModule);
'@

    $helper = Add-Type -MemberDefinition $code -Name ResourceStrings -Namespace Win32API -PassThru -UsingNamespace System.Text

    $info = $path -split ','
    $file = [System.Environment]::ExpandEnvironmentVariables(($info[0] -replace '@',''))
    $id = [Math]::Abs($info[1])

    [IntPtr]$hMod = $helper::LoadLibraryEx($file, [IntPtr]::Zero, 3)
    if($hMod -ne [IntPtr]::Zero) {
        $sb = New-Object System.Text.StringBuilder(1024)
        if($helper::LoadString($hMod, $id, $sb, $sb.Capacity) -ne 0) {
            $sb.ToString()
        }
        [void]$helper::FreeLibrary($hMod);
    }
}
