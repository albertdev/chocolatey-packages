$ErrorActionPreference = 'Stop';

$packageName= 'passwordSafe'
$installedSoftwareFilter = "Password Safe*"
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/pwsafe/pwsafe/releases/download/3.50.0/pwsafe-3.50.0.msi'
$url64      = 'https://github.com/pwsafe/pwsafe/releases/download/3.50.0/pwsafe64-3.50.0.msi'

$sha256Checksum32Bit = '746b3dc0f0b9cd4d0e8c96b42faed42bbd3c798c8d814a5bb1a694985c523a88'
$sha256Checksum64Bit = '55cba7febccb1a6972b57aa572234e587107f3e423827d8aec9577fc3d56ae34'

# Check if a previous version is still installed.  The MSI install at the end of this script
# complains when it detects previous installs, so uninstall first.
# Note: This helper method requires a chocolatey version newer than 0.9.10.

[array] $uninstallInfo = Get-UninstallRegistryKey -SoftwareName $installedSoftwareFilter

if ($uninstallInfo.Count -eq 1) {
    Write-Output "Found previous install, running uninstall first"
    $silentArgs = '/qn /norestart'
    $validExitCodes = @(0, 3010, 1605, 1614, 1641)
    if ($installerType -ne 'MSI') {
        $validExitCodes = @(0)
    }
    $uninstallInfo | % {
        $file = "$($_.UninstallString)"

        # Prepend MSI identifier
        $silentArgs = "$($_.PSChildName) $silentArgs"

        Uninstall-ChocolateyPackage -PackageName $packageName `
                                    -FileType 'MSI' `
                                    -SilentArgs "$silentArgs" `
                                    -ValidExitCodes $validExitCodes `
    }
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
