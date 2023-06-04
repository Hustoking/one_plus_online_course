package global

import (
	"crypto/tls"
	"fmt"
	"gopkg.in/mail.v2"
	"lazago/config"
	"math/rand"
)

// SendMail TODO: 待测试
func SendMail(to string, title string, body string) {
	message := mail.NewMessage()
	message.SetHeaders(map[string][]string{
		"From":    {config.HOST_MAIL_ADDR},
		"To":      {to},
		"Subject": {title},
	})
	message.SetBody("text/html", body)
	// 创建邮件对象
	dialer := mail.NewDialer(config.MAIL_HOST, 25, config.HOST_MAIL_ADDR, config.HOST_MAIL_PSWD)
	// 跳过证书验证
	dialer.TLSConfig = &tls.Config{InsecureSkipVerify: true}
	// 发送邮件
	if err := dialer.DialAndSend(message); err != nil {
		fmt.Println("===ERROR===")
		fmt.Println(err)
		// TODO: error handling
		panic(err)
	}
	fmt.Println("===SUCCESS===")
}

// GenVerifyCode TODO: 待测试
func GenVerifyCode() string {
	// 生成随机数
	num := rand.Intn(900000) + 100000
	return fmt.Sprintf("%d", num)
}
