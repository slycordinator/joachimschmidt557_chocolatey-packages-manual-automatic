import-module au

$releases = 'https://api.github.com/repos/qpdf/qpdf/releases'

function global:au_BeforeUpdate() {
    #Download $Latest.URL32 / $Latest.URL64 in tools directory and remove any older installers.
    Get-RemoteFiles -Purge
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64
}

function global:au_SearchReplace {
    @{
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(\s+32-bit:).*"             = "`${1} $($Latest.URL32)"
            "(?i)(\s+64-bit:).*"             = "`${1} $($Latest.URL64)"
            "(?i)(checksum32:).*"           = "`${1} $($Latest.Checksum32)"
            "(?i)(checksum64:).*"           = "`${1} $($Latest.Checksum64)"
          }
     }
}

function global:au_GetLatest {
    $response = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $json = $response | ConvertFrom-Json

    # qpdf-11.1.1-mingw32.zip
    $re_32  = "qpdf-.+-mingw32.zip"
    $re_64  = "qpdf-.+-mingw64.zip"

    foreach ($release in $json) {
        $asset32 = $release.assets | ? name -match $re_32
        $asset64 = $release.assets | ? name -match $re_64

        if ($asset32 -eq $null) { continue }
        if ($asset64 -eq $null) { continue }

        $url32 = $asset32.browser_download_url
        $url64 = $asset64.browser_download_url

        $version = $release.tag_name -Replace 'v',''

        $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
        return $Latest
    }

    throw "No release with suitable binaries found."
}

update -ChecksumFor none
