@echo
Pushd C:\Users\sspinetto\Downloads\News-Saturation-master\News-Saturation-master
@echo off
echo Time format = %time%
echo hh = %time:~0,2%
echo mm = %time:~3,2%
echo ss = %time:~6,2%
echo Timestamp = %time:~0,2%_%time:~3,2%
set CURRENT_DATE=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%_%time:~3,2%
echo %CURRENT_DATE%
REM the pauses can be uncommented when not runnining automatically
REM pause
call scrapy runspider news_crawler.py -o news_%CURRENT_DATE%.csv
REM pause