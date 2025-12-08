$fileName = $args[0]; # get file name
$dir = $args[1];
$option = ""
# $option = "-Ofast"
# $option = "-Ofast"
# $option2 = "-static"
$p = $dir.ToString();
$path = $p.Substring(0, $p.Length - 1);
$cpp_ver = "-std=c++14"

Set-Location "$path";
$isAbleToBuild = 1;

try {
    Remove-Item *.exe;
}
catch {
    Write-Error "Cannot remove *.exe file";
    $isAbleToBuild = 0;
}

if ($isAbleToBuild -eq 1) {
    $main = (Test-Path -Path main.cpp -PathType Leaf); # check main.cpp exist
    $num = (Get-ChildItem *.cpp | Measure-Object).Count; # count .cpp files
    $user = (Test-Path -Path user.cpp -PathType Leaf); # check user.cpp exist

    if ("$fileName" -eq "test.cpp") {
        # test
        Write-Output "Building test.cpp";
        g++ $cpp_ver $option $fileName -I "$path" -o run;
    }
    else {
        if ($main -and $num -gt 1) {
            # have main and more than 1 file
            if (-not("$fileName" -eq "main.cpp")) {
                # current file is not main
                Write-Output "Building main.cpp and $fileName";
                g++ $cpp_ver $option main.cpp $fileName -I "$path" $option2 -o run;
            }
            elseif ($user) {
                # current file is main and user exist
                Write-Output "Building main.cpp and user.cpp";
                g++ $cpp_ver $option main.cpp user.cpp -I "$path" -o run;
            }
            else {
                Write-Output "Building main.cpp";
                g++ $cpp_ver $option main.cpp .\*.cpp -I "$path" -o run;
            }
        }
        else {
            # only 1 cpp file in folder
            Write-Output "Building $fileName";
            g++ $cpp_ver $option $fileName -I "$path" -o run;
        }
    }

    $outFile = (Test-Path -Path run.exe -PathType Leaf) ;
    if ($outFile) {
        Write-Output "Build successfully!";
        Write-Output "Starting. Console:";
        $sw = [Diagnostics.Stopwatch]::StartNew();
        $ms0 = $sw.ElapsedMilliseconds;
        .\\run;
        #Write-Host "Done";
        $ms = $sw.ElapsedMilliseconds - $ms0;
        $sw.Stop();
        #$ms = $sw.ElapsedMilliseconds - 400;
        Write-Host "";
        if ($ms -gt 1000) {
            $sec = $ms / 1000;
            Write-Host "End program! Time: ${sec} second";
        }
        else {
            Write-Host "End program! Time: ${ms} ms";
        }
        Remove-Item *.exe
    }
    else {
        Write-Error "Build failed or no output file";
    }
}
