. ".\build-config.ps1"

$filePath = $artifacts[$appName].path

$path = $filePath.Split("\")

$length = $path.Length

$fileName = $path[$length - 1]

$fileBin = [IO.File]::ReadAllBytes($filePath)

$enc = [System.Text.Encoding]::GetEncoding("iso-8859-1")

$fileEnc = $enc.GetString($fileBin)


$boundary = [System.Guid]::NewGuid().ToString()

$LF = "`r`n"

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

$headers.Add("X-HockeyAppToken", $hockeyAppToken)

$bodyLines = (
    "--$boundary",
    "Content-Disposition: form-data; name=`"ipa`"; filename=`"$fileName`"",
    "Content-Type: application/octet-stream$LF",
    $fileEnc,
    "--$boundary",
    "Content-Disposition: form-data: name=`"status`"$LF",
    $hockeyAppStatus,
    "--$boundary",
    "Content-Disposition: form-data: name=`"notify`"$LF",
    $hockeyAppNotify,
    "--$boundary",
    "Content-Disposition: form-data: name=`"notes`"$LF",
    $hockeyAppNotes,
    "--$boundary",
    "Content-Disposition: form-data: name=`"notes_type`"$LF",
    $hockeyAppNotesType,
    "--$boundary--$LF"
) -join $LF

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

$response = Invoke-RestMethod https://rink.hockeyapp.net/api/2/apps/$hockeyAppID/app_versions/new -Method Post -Body "bundle_version=$hockeyAppBundleVersion" -Headers $headers

$id = $response.id

Invoke-RestMethod https://rink.hockeyapp.net/api/2/apps/$hockeyAppID/app_versions/$id -Method Put -ContentType "multipart/form-data; boundary=`"$boundary`"" -Body $bodyLines -Headers $headers