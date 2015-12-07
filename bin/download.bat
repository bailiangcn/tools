@echo off

REM
REM 本脚本负责把云盘的自选股、日记下载到通达信软件
REM

rem 设定要替换的文件名
set srcFile1=blocknew
set srcFile2=diary

rem 设定要通达信数据目录
set srcDir=C:\new_haitong\T0002
rem 设定网盘的目录
set netDir=C:\云U盘\kp_bailiangcn@gmail.com\stock

    
REM 拷贝网盘内的文件
echo ******************** 
echo 从云盘覆盖本地自选股
echo ********************

xcopy /I /E /Y "%netDir%\%srcFile1%" "%srcDir%\%srcFile1%"
xcopy /I /E /Y "%netDir%\%srcFile2%" "%srcDir%\%srcFile2%"

@echo on 
