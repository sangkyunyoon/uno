$ErrorActionPreference = 'Stop'

function Assert-ExitCodeIsZero()
{
    if ($LASTEXITCODE -ne 0)
    {
        throw "Exit code must be zero."
	}
}

function Get-TemplateConfiguration(
    [bool]$uwp = $false,
    [bool]$android = $false,
    [bool]$iOS = $false,
    [bool]$macOS = $false,
    [bool]$wasm = $false,
    [bool]$skiaGtk = $false,
    [bool]$skiaWpf = $false,
    [bool]$skiaTizen = $false,
    [bool]$wasmVsCode = $false)
{
    $uwpFlag = '-uwp'
    $androidFlag = '-android'
    $iOSFlag = '-ios'
    $macOSFlag = '-macos'
    $wasmFlag = '-wasm'
    $wasmVsCodeFlag = '--vscodeWasm'
    $skiaWpfFlag = '--skia-wpf'
    $skiaGtkFlag = '--skia-gtk'
    $skiaTizenFlag = '--skia-tizen'

    $a = If ($uwp)        { $uwpFlag }        Else { $uwpFlag        + '=false' }
    $b = If ($android)    { $androidFlag }    Else { $androidFlag    + '=false' }
    $c = If ($iOS)        { $iOSFlag }        Else { $iOSFlag        + '=false' }
    $d = If ($macOS)      { $macOSFlag }      Else { $macOSFlag      + '=false' }
    $e = If ($wasm)       { $wasmFlag }       Else { $wasmFlag       + '=false' }
    $f = If ($wasmVsCode) { $wasmVsCodeFlag } Else { $wasmVsCodeFlag + '=false' }
    $g = If ($skiaWpf)    { $skiaWpfFlag    } Else { $skiaWpfFlag    + '=false' }
    $h = If ($skiaGtk)    { $skiaGtkFlag    } Else { $skiaGtkFlag    + '=false' }
    $i = If ($skiaTizen)  { $skiaTizenFlag  } Else { $skiaTizenFlag  + '=false' }

    @($a, $b, $c, $d, $e, $f, $g, $h, $i)
}

$default = @('-v', 'detailed', "-p:RestoreConfigFile=$env:NUGET_CI_CONFIG")

$debug = $default + '-c' + 'Debug'
$release = $default + '-c' + 'Release'

# UWP
dotnet new unoapp -n UnoApp (Get-TemplateConfiguration -uwp 1 -wasm 1 -wasmVsCode 1 -skiaGtk 1)

dotnet $debug UnoApp/UnoApp.Wasm/UnoApp.Wasm.csproj
Assert-ExitCodeIsZero

dotnet $release UnoApp/UnoApp.Wasm/UnoApp.Wasm.csproj
Assert-ExitCodeIsZero

dotnet $debug UnoApp/UnoApp.Skia.Gtk/UnoApp.Skia.Gtk.csproj
Assert-ExitCodeIsZero

dotnet $release UnoApp/UnoApp.Skia.Gtk/UnoApp.Skia.Gtk.csproj
Assert-ExitCodeIsZero

# WinUI
dotnet new unoapp-winui -n UnoAppWinUI (Get-TemplateConfiguration -uwp 1 -wasm 1 -wasmVsCode 1 -skiaGtk 1)

dotnet $debug UnoAppWinUI/UnoAppWinUI.Wasm/UnoAppWinUI.Wasm.csproj
Assert-ExitCodeIsZero

dotnet $release UnoAppWinUI/UnoAppWinUI.Wasm/UnoAppWinUI.Wasm.csproj
Assert-ExitCodeIsZero

dotnet $debug UnoAppWinUI/UnoAppWinUI.Skia.Gtk/UnoAppWinUI.Skia.Gtk.csproj
Assert-ExitCodeIsZero

dotnet $release UnoAppWinUI/UnoAppWinUI.Skia.Gtk/UnoAppWinUI.Skia.Gtk.csproj
Assert-ExitCodeIsZero
