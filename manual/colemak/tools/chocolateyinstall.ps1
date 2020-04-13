$ErrorActionPreference = 'Stop';

$packageName = 'colemak'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$fileLocation   = Join-Path $toolsDir "Colemak_i386.msi"
$fileLocation64 = Join-Path $toolsDir "Colemak_amd64.msi"


$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'colemak*'
  fileType      = 'msi'
  file          = $fileLocation
  file64        = $fileLocation64
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`" ALLUSERS=1"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
