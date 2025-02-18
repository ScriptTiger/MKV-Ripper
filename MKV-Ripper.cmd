@echo off

rem =====
rem For more information on ScriptTiger and more ScriptTiger scripts visit the following URL:
rem https://scripttiger.github.io/
rem Or visit the following URL for the latest information on this ScriptTiger script:
rem https://github.com/ScriptTiger/MKV-Ripper
rem =====

setlocal ENABLEDELAYEDEXPANSION

rem Generic call to FFmpeg
set FFMPEG=call "%~dp0bin\ffmpeg.exe" -hide_banner -i %1

rem Base file name
set BASE=%~dpn1

rem Enumerate video and audio streams, and generate associated output arguments
set OUTPUT=
set i=0
for /f tokens^=4^,5^,6^ delims^=^:^,^_^(^)^  %%0 in ('%FFMPEG% -vn -an -dn -sn -f null "" 2^>^&1^| findstr Stream') do (
	if "%%0" == "und" (call :Output %%1 %%2
	) else if "%%0" == "eng" (call :Output %%1 %%2
	) else call :Output %%0 %%1
	if "!EXT!" == "" goto Exit
	set /a i=i+1
)

rem Output streams to files
%FFMPEG% %OUTPUT%

rem =========
rem Functions
rem =========

rem Pause and exit
:Exit
pause
exit /b

rem Generate output arguments
:Output
set EXT=
if "%1" neq "Video" if "%1" neq "Audio" (
	set EXT=null
	exit /b
)
if "%1" == "Video" set OUTPUT=!OUTPUT! -map 0:!i! -c:v copy -an -dn -sn 
if "%1" == "Audio" set OUTPUT=!OUTPUT! -map 0:!i! -c:a copy -vn -dn -sn 
if "%2" == "h264" set EXT=mp4
if "%2" == "hevc" set EXT=mp4
if "%2" == "av1" set EXT=mp4
if "%2" == "pcm" set EXT=wav
if "%2" == "aac" set EXT=m4a
if "%2" == "flac" set EXT=flac
if "!EXT!" == "" (
	echo The %2 %1 codec is currently unsupported. Please submit a PR or issue on GitHub to request support to be added.
	exit /b
)
set OUTPUT=!OUTPUT! "%BASE%-!i!.!EXT!"
exit /b