#!/bin/bash
#===============================================================================
#
#          FILE:  rtx.sh
# 
#         USAGE:  ./rtx.sh 
# 
#   DESCRIPTION:  运行腾讯通
# 
#                 启动腾讯通
#                 ./rtx.sh &
#
#        AUTHOR:  BaiLiang , bailiangcn@gmail.com
#       COMPANY:  DQYTV
#       VERSION:  1.0
#       CREATED:  2011-03-14 14:14:41
#   Last Change:  2011年03月17日 12时40分03秒
#===============================================================================

export LANG=zh_CN.UTF-8 
export WINEPREFIX="##HOME##/.wine" 
cd '##HOME##/.wine/drive_c/Program Files/Tencent/RTXC/'
wine ##HOME##/.wine/drive_c/Program\ Files/Tencent/RTXC/RTX.exe 2>/dev/null 
#/usr/local/bin/wine  C:\\windows\\command\start.exe /Unix ##HOME##/.wine/dosdevices/c:/users/bl/Start\ Menu/Programs/腾讯通/腾讯通RTX.lnk 2>/dev/null 
