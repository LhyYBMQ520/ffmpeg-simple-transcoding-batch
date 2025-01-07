@echo off
chcp 65001 && cls
setlocal enabledelayedexpansion
echo 当前目录: %~dp0

echo 请选择编解码器选项：
echo 1. CPU编解码器 (ffmpeg默认)
echo 2. Intel硬件加速 (仅限h264)
echo 3. NVIDIA硬件加速 (仅限h264)
echo 4. AMD硬件加速 (仅限h264)
set /p codec="请输入选项 (默认为1): "

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
    echo 无效输入,将默认使用CPU编解码器
    set "codec_param="
)

echo.
echo 请选择文件格式：
echo 1. mkv
echo 2. mp4
echo 3. webm
set /p format="选择(默认mp4):"
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
    echo 无效输入,默认使用mp4!
    set "input_ext=mp4"
    set "output_ext=mp4"
)

set /p bitrate="请输入视频码率(单位:M或K,例如:3M或1500K,一定要大写单位!): "
if "%bitrate%"=="" (
    echo 未输入码率,使用默认2M!
    set "bitrate=2M"
)

set /p maxrate="请输入最大码率(单位:M或K,例如:4M或3500K,一定要大写单位!): "
if "%maxrate%"=="" (
    echo 未输入最大码率,使用默认4M!
    set "maxrate=4M"
)

set /p bufsize="请输入缓冲区大小(单位:M或K,例如:1M或500K,一定要大写单位!): "
if "%bufsize%"=="" (
    echo 未输入缓冲区大小,使用默认2M!
    set "bufsize=2M"
)

if not exist "%~dp0output" mkdir "%~dp0output"

for %%a in ("%~dp0*.%input_ext%") do (
    ffmpeg -i "%%a" %codec_param% -map 0:v -preset:v fast -b:v %bitrate% -maxrate %maxrate% -bufsize %bufsize% -profile:v high -pix_fmt yuv420p -map 0:a -c:a copy -map_metadata 0 "%~dp0output\%%~na.%output_ext%"
)

echo.
echo 转换完成！请检查 output 文件夹。
pause
endlocal
