@echo off
chcp 936 && cls
setlocal enabledelayedexpansion
echo ��ǰĿ¼: %~dp0

echo ��ѡ��������ѡ��:
echo 1. CPU������� (ffmpegĬ��)
echo 2. IntelӲ������ (����h264)
echo 3. NVIDIAӲ������ (����h264)
echo 4. AMDӲ������ (����h264)
set /p codec="������ѡ�� (Ĭ��Ϊ1): "

if "%codec%"=="" set codec=1

if "%codec%"=="1" (
    set "codec_param="
) else if "%codec%"=="2" (
    set "codec_param=-c:v h264_qsv"
) else if "%codec%"=="3" (
    set "codec_param=-c:v h264_nvenc"
) else if "%codec%"=="4" (
    set "codec_param=-c:v h264_amf"
) else (
    echo ��Ч����,��Ĭ��ʹ��CPU�������
    set "codec_param="
)

echo.
echo ��ѡ���ļ���ʽ��
echo 1. mkv
echo 2. mp4
echo 3. webm
set /p format="ѡ��(Ĭ��mp4):"
if "%format%"=="" set format=2

if "%format%"=="1" (
    set "input_ext=mkv"
    set "output_ext=mp4"
) else if "%format%"=="2" (
    set "input_ext=mp4"
    set "output_ext=mp4"
) else if "%format%"=="3" (
    set "input_ext=webm"
    set "output_ext=mp4"
) else (
    echo ��Ч����,Ĭ��ʹ��mp4!
    set "input_ext=mp4"
    set "output_ext=mp4"
)

set /p bitrate="��������Ƶ���ʣ���λ:M��K,����:3M��1500K���� "
if "%bitrate%"=="" (
    echo δ��������,ʹ��Ĭ��2M!
    set "bitrate=2M"
)

set /p maxrate="������������ʣ���λ:M��K,����:4M��3500K���� "
if "%maxrate%"=="" (
    echo δ�����������,ʹ��Ĭ��4M!
    set "maxrate=4M"
)

set /p bufsize="�����뻺������С����λ:M��K,����:1M��500K���� "
if "%bufsize%"=="" (
    echo δ���뻺������С,ʹ��Ĭ��2M!
    set "bufsize=2M"
)

if not exist "%~dp0output" mkdir "%~dp0output"

for %%a in ("%~dp0*.%input_ext%") do (
    ffmpeg -i "%%a" %codec_param% -map 0:v -preset:v fast -b:v %bitrate% -maxrate %maxrate% -bufsize %bufsize% -profile:v high -pix_fmt yuv420p -map 0:a -c:a copy -map_metadata 0 "%~dp0output\%%~na.%output_ext%"
)

echo.
echo ת����ɣ����� output �ļ��С�
pause
endlocal
