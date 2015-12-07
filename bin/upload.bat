@echo off

REM
REM 本脚本负责把海通通达信自选股和日记上传到云盘中
REM


rem 设定要替换的文件名
set srcFile1=blocknew
set srcFile2=diary


rem 设定要备份的目录
set srcDir=C:\new_haitong\T0002
rem 设定网盘的目录
set netDir=C:\云U盘\kp_bailiangcn@gmail.com\stock

echo ******************** 
echo 上传自选股
echo ********************
xcopy /I /E /Y "%srcDir%\%srcFile1%" "%netDir%\%srcFile1%"
xcopy /I /E /Y "%srcDir%\%srcFile2%" "%netDir%\%srcFile2%"

REM pause
@echo on 

