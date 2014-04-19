#!/bin/bash - 
#===============================================================================
#
#          FILE: changpomo.sh
# 
#         USAGE: ./changpomo.sh 
#                可选参数： 时间长度
# 
#   DESCRIPTION: 为解决pomodairo调整时间不方便，所以制作了一个脚本外壳 
# 
#       CREATED: 2013年11月06日 21时23分28秒 CST
#===============================================================================

set -o nounset                              # Treat unset variables as an error
if [ $# -gt 0 ]; then
    echo $1
    sqlite3 /home/bl/pomodairo-1.1.db  <<EOS
    update config set  value=$1 where name="pomodoroLength";

EOS
else
    value=`zenity --list \
      --title="选择番茄时间长度" \
      --column="时长--分钟"  5 10 15 20 25 30 35 40`
    case $value in
        5 | 10 | 15 | 20 | 25 | 30 | 35 | 40 )
            sqlite3 /home/bl/pomodairo-1.1.db  <<EOS
            update config set  value=$value where name="pomodoroLength";

EOS
            ;;
        *)
            sqlite3 /home/bl/pomodairo-1.1.db  'update config set  value=25 where name="pomodoroLength";'
    esac
fi
    pkill pomodairo
    /opt/pomodairo/bin/pomodairo &
