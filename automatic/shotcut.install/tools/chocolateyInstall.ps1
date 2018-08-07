﻿
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://github.com/mltframework/shotcut/releases/download/v18.07/shotcut-win32-180702.exe'
$url64      = 'https://github.com/mltframework/shotcut/releases/download/v18.07/shotcut-win64-180702.exe'
$checksum32 = 'c009da27c89d07446d78370942719a779f499aecd9adb777458121468700e4aa'
$checksum64 = 'b4c7403ed11570273521b2ef6ceee0a6fd5dedc146f96da91d97205bf85b5278'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url32
  url64Bit      = $url64

  softwareName  = 'shotcut*'

  checksum      = $checksum32
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'

  silentArgs   = '/S'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs