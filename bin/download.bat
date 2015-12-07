@echo off

REM
REM 本脚本负责把云盘的自选股、日记下载到通达信软件
REM 需要安装 winrar
REM

set homename=BL-STOCK
set officename=bailiang-stock

REM 备份原有自选股
rem 格式化日期
rem date出来的日期是"2006-02-22 星期三"，不能直接拿来使用，所以应该先格式化一下
rem 变成我们想要的。date:~0,4的意思是从0开始截取4个字符
set d=%date:~0,4%%date:~5,2%%date:~8,2%
rem 设定压缩程序路径，这里用的是WINRAR的rar.exe进行打包的
set path=C:\Program Files\WinRAR;c:\windows\system32


rem 设定要替换的文件名
set srcFile=自选股*.BLK
rem
rem 设定备份文件所在目录
set dstDir=C:\temp
rem 设定备份文件名称前缀
set dstFile=backup_自选_
rem 设定备份文件的前缀,目前为temp,前缀为backup
set webPrefix=

set srcDir=

if "%computername%"=="%homename%" (
    echo your computer is at home.
        rem 设定要备份的目录
        rem set srcDir=C:\Program Files\dzh2\USERDATA
	set srcDir=C:\dzh365\USERDATA
        rem 设定网盘的目录
        set netDir=Z:\stock
    ) 
if "%computername%"=="%officename%" (
    echo your computer is at office.
    rem 设定要备份的目录
    rem set srcDir=C:\dzh365\USERDATA
    set srcDir=C:\Program Files\dzh2\USERDATA
    rem 设定网盘的目录
    set netDir=Y:
    )

if "%srcDir%"=="" (
    echo Where are you?
) else (
    rem 如果备份文件夹不存在就建立文件夹
    if not exist %dstDir% start mkdir %dstDir%
    rem 如果文件不存在,开始备份
    if not exist %dstDir%\%dstFile%%webPrefix%%d%.rar start Rar a %dstDir%\%dstFile%%webPrefix%%d%.rar %srcDir%\block\%srcFile%
    
    REM 拷贝网盘内的文件
    echo ******************** 
    echo 从云盘覆盖本地自选股
    echo ********************
    xcopy  /Y "%netDir%\%srcFile%" "%srcDir%\block\"

    xcopy  /Y  "%netDir%\MEMO.DAT" "%srcDir%\MEMO.DAT"
    xcopy /E /Y "%netDir%\NOTE\*.*" "%srcDir%\NOTE\"
)

REM pause
@echo on 
