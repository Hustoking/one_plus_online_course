package test

import (
	"context"
	"crypto/tls"
	"fmt"
	"github.com/redis/go-redis/v9"
	"gopkg.in/mail.v2"
	"lazago/config"
	"math/rand"
	"testing"
	"time"
)

func TestMail(t *testing.T) {
	// Redis
	var ctx = context.Background()
	var client *redis.Client

	client = redis.NewClient(&redis.Options{
		Addr:     "43.138.47.188:8079",
		Password: "",
		DB:       0,
	})

	err := client.Set(ctx, "name", "golang-laza", 10*time.Minute).Err()
	if err != nil {
		t.Errorf("Failed to set key: %v", err)
	} else {
		t.Logf("Successfully set key: %s", "name")
	}
	// ======================================================

	// 生成随机数
	num := rand.Intn(90000) + 10000

	// 邮件相关
	message := mail.NewMessage()
	message.SetHeaders(map[string][]string{
		"From":    {config.HOST_MAIL_ADDR},
		"To":      {"1067079973@qq.com"},
		"Subject": {"这是一封测试邮件"},
	})
	message.SetBody("text/html", "这是一封测试邮件的内容，验证码: "+fmt.Sprintf("%d", num))
	// 创建邮件对象
	dialer := mail.NewDialer(config.MAIL_HOST, 25, config.HOST_MAIL_ADDR, config.HOST_MAIL_PSWD)
	// 跳过证书验证
	dialer.TLSConfig = &tls.Config{InsecureSkipVerify: true}
	// 发送邮件
	if err := dialer.DialAndSend(message); err != nil {
		fmt.Println("===ERROR===")
		fmt.Println(err)
		panic(err)
	}
	fmt.Println("===SUCCESS===")
}
