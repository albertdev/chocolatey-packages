$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition

# Distribution zip uses Linux convention of putting everything in a folder
# rather than root dir of zip. Extract it into 'tools'
$extractDir = $toolsDir

$distZipFileName = 'rsgain-3.6-win64.zip'
$distZipFilePath = Join-Path -Path $toolsDir -ChildPath $distZipFileName
$distFolder  = 'rsgain-3.6-win64'

$packageArgs = @{
    packageName     = 'rsgain'
    fileFullPath64  = $distZipFilePath
    destination     = $extractDir
}

Get-ChocolateyUnzip @packageArgs

# Rename folder which was included in zip so it's version-agnostic
Rename-Item -Path (Join-Path -Path $extractDir -ChildPath $distFolder) 'content'

Remove-Item -Path $distZipFilePath -Force
