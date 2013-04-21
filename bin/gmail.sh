#!/bin/bash
#===============================================================================
#
#          FILE:  gmail.sh
# 
#         USAGE:  ./gmail.sh 
# 
#   DESCRIPTION:  检查gmail,输出到xmobar
#                 a script that show how many new mails you got
#                 to use it in xmobar add this
#                 Run Com "sh" ["/path/to/mail.sh"] "mail" 300
# 
#        AUTHOR:  BaiLiang , bailiangcn@gmail.com
#       COMPANY:  DQYTV
#       VERSION:  1.0
#       CREATED:  2011-03-12 09:31:27
#   Last Change:  2011年03月17日 12时33分33秒
#      REVISION:  ---
#===============================================================================

gmail_login="##MAIL_USER##"
gmail_password="##MAIL_PASSWORD##"


dane="$(wget --secure-protocol=auto --timeout=10 -t 3 -q -O - \
       --user=${gmail_login} --password=${gmail_password} \
   https://mail.google.com/mail/feed/atom --no-check-certificate   \
   | grep 'fullcount' \
   | sed -e 's/.*<fullcount>//;s/<\/fullcount>.*//' 2>/dev/null)"

if [ -z "${dane}" ]; then
    echo "";
else
    if [ "${dane}" -gt  "0" ]; then
        echo " ${dane}封新邮件 ";
    else
        echo "";
    fi
fi
