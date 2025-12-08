$fileName = $args[0]; # get file name
$dir = $args[1];

$p = $dir.ToString();
$path = $p.Substring(0, $p.Length - 1);

Set-Location "$path";

Write-Host "Starting. Console:" -ForegroundColor Green;
$sw = [Diagnostics.Stopwatch]::StartNew();

python -u $fileName

$sw.Stop();
$ms = $sw.ElapsedMilliseconds;

Write-Host"";
if ($ms -gt 1000) {
    $sec = $ms / 1000;
    Write-Host "End program! Time: ${sec} second" -ForegroundColor Green;
}
else {
    Write-Host "End program! Time: ${ms} ms" -ForegroundColor Green;
}
