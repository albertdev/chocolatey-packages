$ErrorActionPreference = 'Stop';

$packageName= 'passwordSafe'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/pwsafe/pwsafe/releases/download/3.49.1/pwsafe-3.49.1.msi'
$url64      = 'https://github.com/pwsafe/pwsafe/releases/download/3.49.1/pwsafe64-3.49.1.msi'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64

  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)

  checksum      = 'c10f3c646521771ce9095705a030ed2dadaba3fa22db256f6117b4b8ca8c5a0e'
  checksumType  = 'sha256'
  checksum64    = '13c3d4fa7444d7354503c59720103bf52803936b4ad022a31b24fb885a99cd05'
  checksumType64= 'sha256'
}

Install-ChocolateyPackage @packageArgs
