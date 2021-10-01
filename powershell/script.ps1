$File = "D:\Workplace\workato\powershell\test.txt";
$ftp = "ftp://ftpverint:ver17PDP@10.14.201.143/dat/pe/es/int/out/vta/test.txt";

Write-Host -Object "ftp url: $ftp";

$webclient = New-Object -TypeName System.Net.WebClient;
$uri = New-Object -TypeName System.Uri -ArgumentList $ftp;

Write-Host -Object "Uploading $File...";

$webclient.UploadFile($uri, $File);