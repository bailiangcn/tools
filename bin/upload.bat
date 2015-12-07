@echo off

REM
REM 本脚本负责把海通通达信自选股和日记上传到云盘中
REM

set homename=BL-STOCK
set officename=bailiang-stock

rem 设定要替换的文件名
set srcFile1=blocknew
set srcFile2=diary

set srcDir=

if "%computername%"=="%homename%" (
    echo your computer is at home.
    ) 
if "%computername%"=="%officename%" (
    echo your computer is at office.
    )

rem 设定要备份的目录
set srcDir=C:\new_haitong\T0002
rem 设定网盘的目录
set netDir=C:\云U盘\kp_bailiangcn@gmail.com\stock

if "%srcDir%"=="" (
    echo Where are you?
) else (
    echo ******************** 
    echo 上传自选股
    echo ********************
    xcopy /I /E /Y "%srcDir%\%srcFile1%" "%netDir%\%srcFile1%"
    xcopy /I /E /Y "%srcDir%\%srcFile2%" "%netDir%\%srcFile2%"
)

REM pause
@echo on 

