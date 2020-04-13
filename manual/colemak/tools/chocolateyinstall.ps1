$ErrorActionPreference = 'Stop';

$packageName = 'colemak'
$url         = 'https://skozl.com/s/colemak-caps.zip'
$urlChecksum = "babdb6461663932a11480da384e5ef41024470d1dc0cc8792c0b2955398d29ac"

# Installer distribution has a folder structure for different locales, but there's only EN now
$locale = 'EN'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$distributionDownload = Join-Path $toolsDir "colemak-caps.zip"

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

$downloadArgs = @{
    packageName = $packageName
    url = $url
    fileFullPath = $distributionDownload
    checksumType = "sha256"
    checksum = $urlChecksum
}

Get-ChocolateyWebFile @downloadArgs

Get-ChocolateyUnzip -FileFullPath $distributionDownload -Destination $distributionDir

$distributionDir = Join-Path $toolsDir "colemak-caps-install"

$arch = 'i386'
if (Get-ProcessorBits 64) {
    $arch = 'amd64'
}
$msiFileLocation = Join-Path $distributionDir "colemak ($locale)/Colemak_$arch.msi"


$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  file          = $msiFileLocation
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`" ALLUSERS=1"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'colemak*'
}

#Install-ChocolateyZipPackage @packageArgs
#
#Get-ChildItem -recurse $toolsDir -filter setup.exe | foreach {
#    $ignoreFile = $_.FullName + '.ignore'
#    Set-Content -Path $ignoreFile -Value ($null)
#}

Install-ChocolateyInstallPackage @packageArgs
