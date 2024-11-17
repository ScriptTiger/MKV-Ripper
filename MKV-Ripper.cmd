@echo off

rem =====
rem For more information on ScriptTiger and more ScriptTiger scripts visit the following URL:
rem https://scripttiger.github.io/
rem Or visit the following URL for the latest information on this ScriptTiger script:
rem https://github.com/ScriptTiger/MKV-Ripper
rem =====

setlocal ENABLEDELAYEDEXPANSION

set FFMPEG=call "%~dp0bin\ffmpeg.exe" -hide_banner -i %1

set OUTPUT=
set i=0
for /f tokens^=4^,5^ delims^=^:^,^_^(^  %%0 in ('%FFMPEG% -vn -an -dn -sn -f null "" 2^>^&1^| findstr Stream') do (
	if "%%0" == "Video" set OUTPUT=!OUTPUT! -map 0:!i! -c:v copy -an -dn -sn 
	if "%%0" == "Audio" set OUTPUT=!OUTPUT! -map 0:!i! -c:a copy -vn -dn -sn 
	if "%%1" == "h264" set OUTPUT=!OUTPUT! "%~dpn1-!i!.mp4"
	if "%%1" == "hevc" set OUTPUT=!OUTPUT! "%~dpn1-!i!.mp4"
	if "%%1" == "pcm" set OUTPUT=!OUTPUT! "%~dpn1-!i!.wav"
	if "%%1" == "aac" set OUTPUT=!OUTPUT! "%~dpn1-!i!.m4a"
	set /a i=i+1
)

%FFMPEG% %OUTPUT%
pause