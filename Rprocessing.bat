@echo off
REM sets working directory
Pushd C:\Users\sspinetto\Downloads\News-Saturation-master\News-Saturation-master
REM finds newest file
for /f %%i in ('dir /b/a-d/od/t:c') do set LAST=%%i
REM ECHO in case PAUSE is uncommented (for use in testing)
echo The most recently created file is %LAST%
REM sets arg1 in R script to latest file
set arg1=%LAST%
shift
"C:\Program Files\R\R-3.3.3\bin\RScript.exe" "C:\Users\sspinetto\Downloads\News-Saturation-master\News-Saturation-master\News-Saturation\crawler_data_AUTOprocessing.R" %arg1% %*
REM 
REM pause