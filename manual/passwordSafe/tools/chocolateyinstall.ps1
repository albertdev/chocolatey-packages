
$ErrorActionPreference = 'Stop';


$packageName= 'passwordSafe'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://sourceforge.net/projects/passwordsafe/files/Windows/3.47.2/pwsafe-3.47.2.msi'
$url64      = 'https://sourceforge.net/projects/passwordsafe/files/Windows/3.47.2/pwsafe64-3.47.2.msi'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64

  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)

  softwareName  = 'passwordSafe*'
  checksum      = '6546e3b1625aa95d56fdefbe79c4c1a2'
  checksumType  = 'md5'
  checksum64    = 'a6eef6c29d04e4654de3a0bd18331484'
  checksumType64= 'md5'
}

Install-ChocolateyPackage @packageArgs