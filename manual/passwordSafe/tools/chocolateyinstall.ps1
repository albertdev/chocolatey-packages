$ErrorActionPreference = 'Stop';

$packageName= 'passwordSafe'
$installedSoftwareFilter = "Password Safe*"
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/pwsafe/pwsafe/releases/download/3.52.0/pwsafe-3.52.0.msi'
$url64      = 'https://github.com/pwsafe/pwsafe/releases/download/3.52.0/pwsafe64-3.52.0.msi'

$sha256Checksum32Bit = '55d92f4c2bafd9f899cbef44c6cc48c13ff6335db88bc607a8bab82bfad78529'
$sha256Checksum64Bit = '3dfc053a36e47298d29a0e3391bd0675fb5730d244cefbde6b973b6c20f95ea2'

# Check if a previous version is still installed.  The MSI install at the end of this script
# complains when it detects previous installs, so uninstall first.
# Note: This helper method requires a chocolatey version newer than 0.9.10.

[array] $uninstallInfo = Get-UninstallRegistryKey -SoftwareName $installedSoftwareFilter

if ($uninstallInfo.Count -eq 1) {
    $packageArgs = @{
        packageName = $packageName
        validExitCodes= @(0, 3010, 1605, 1614, 1641) # https://msdn.microsoft.com/en-us/library/aa376931(v=vs.85).aspx
    }
    if ($uninstallInfo.UninstallString -like "*msiex*") {
        $packageArgs['fileType'] = 'MSI'
        # The Product Code GUID is the most important thing that should be passed for MSI, and very
        # FIRST, because it comes directly after /x, which is already set in the
        # Uninstall-ChocolateyPackage msiargs.
        $packageArgs['silentArgs'] = "$($uninstallInfo.PSChildName) /qn /norestart"
        $packageArgs['file'] = ''
    } else {
        $packageArgs['fileType'] = 'EXE'
        # Run NSIS uninstal exe in silent mode
        $packageArgs['silentArgs'] = "/S"
        $uninstallCmd = $uninstallInfo.UninstallString
        # Uninstall string might contain something like '"C:\Progam Files\X\uninstall.exe" /s'
        # Only the part in quotes needs to be kept
        if ($uninstallCmd.Contains('"')) {
            $start = $uninstallCmd.IndexOf('"')
            $end = $uninstallCmd.IndexOf('"', $start + 1)
            $packageArgs['file'] = $uninstallCmd.Substring($start + 1, $end - $start - 1)
        }
    }
    Write-Output "Found previous install, running uninstall first"
    Uninstall-ChocolateyPackage @packageArgs `

} elseif ($uninstallInfo.Count -gt 1) {
    Write-Warning "$($uninstallInfo.Count) previous installations found!"
    Write-Warning "To prevent accidental data loss, no installations will be altered."
    Write-Warning "The following installations were matched:"
    $uninstallInfo | % {Write-Warning "- $($_.DisplayName)"}
    Write-Warning "Please uninstall these old versions manually by using"
    Write-Warning "Windows' Apps & Features / Programs and Features screen."
    throw "Multiple previous installations found, stopping passwordSafe install."
}

# Actual installation

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64

  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)

  checksum      = $sha256Checksum32Bit
  checksumType  = 'sha256'
  checksum64    = $sha256Checksum64Bit
  checksumType64= 'sha256'
}

Install-ChocolateyPackage @packageArgs
