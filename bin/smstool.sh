#接口类型：互亿无线触发短信接口，支持发送验证码短信、订单通知短信等。
#账户注册：请通过该地址开通账户http://sms.ihuyi.com/register.html
#注意事项：
#（1）调试期间，请用默认的模板进行测试，默认模板详见接口文档；
#（2）请使用 用户名 及 APIkey来调用接口，APIkey在会员中心可以获取；
#（3）该代码仅供接入互亿无线短信接口参考使用，客户可根据实际需要自行编写；
 
#!/bin/sh
#用户名是登录ihuyi.com账号名（例如：cf_demo123）
account="c66251041"
#密码 查看密码请登录用户中心->验证码、通知短信->帐户及签名设置->APIKEY
password="75d3c4d93b9325e833f58a6a4ec3e971"
#修改为您要发送的手机号
mobile="13339505100"
#内容里的1234是变量。可以修改成任意4-8位数字
content="您的验证码是：123456。请不要把验证码泄露给其他人。"
echo "send sms:"
curl --data "account=$account&password=$password&mobile=$mobile&content=$content&rd=1" "http://106.ihuyi.com/webservice/sms.php?method=Submit"
echo  -e "\n query balance:"
curl --data "account=$account&password=$password" "http://106.ihuyi.com/webservice/sms.php?method=GetNum"
