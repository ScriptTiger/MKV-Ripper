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

rem Enumerate video and audio streams, and generate associated output arguments
set OUTPUT=
set i=0
for /f tokens^=4^,5^ delims^=^:^,^_^(^  %%0 in ('%FFMPEG% -vn -an -dn -sn -f null "" 2^>^&1^| findstr Stream') do (
	set EXT=
	if "%%0" == "Video" set OUTPUT=!OUTPUT! -map 0:!i! -c:v copy -an -dn -sn 
	if "%%0" == "Audio" set OUTPUT=!OUTPUT! -map 0:!i! -c:a copy -vn -dn -sn 
	if "%%1" == "h264" set EXT=mp4
	if "%%1" == "hevc" set EXT=mp4
	if "%%1" == "pcm" set EXT=wav
	if "%%1" == "aac" set EXT=m4a
	if "!EXT!" == "" (
		call :Unsupported %%0 %%1
		goto Exit
	)
	set OUTPUT=!OUTPUT! "%~dpn1-!i!.!EXT!"
	set /a i=i+1
)

rem Output streams to files
%FFMPEG% %OUTPUT%

rem Pause and exit
:Exit
pause
exit /b

rem Display error message on unsupported codec
:Unsupported
echo The %2 %1 codec is currently unsupported. Please submit a PR or issue on GitHub to request support to be added.
exit /b