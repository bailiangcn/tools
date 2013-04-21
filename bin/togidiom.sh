#!/bin/bash
#激活成语接龙文档
#判断进程是否存在，如果不存在就启动它如果存在就显示它

PIDS=$(ps aux | grep 'evince.*成语接龙含义.pdf' | grep -v grep) 
if [ "$PIDS" != "" ]
then
    wmctrl -r 成语接龙含义.pdf -b remove,maximized_horz
    wmctrl -r 成语接龙含义.pdf -b remove,maximized_vert
    wmctrl -r 成语接龙含义.pdf -e 0,-1,-1,1920,1200
    wmctrl -r 成语接龙含义.pdf -b toggle,shaded
#运行进程
else
    sh -c "nohup evince /home/bl/Yunio/果果/成语接龙含义.pdf  >/dev/null 2>&1 &"
fi
