package test

import (
	"context"
	"fmt"
	"github.com/redis/go-redis/v9"
	"testing"
	"time"
)

func TestRedis(t *testing.T) {
	var ctx = context.Background()

	var client *redis.Client

	client = redis.NewClient(&redis.Options{
		Addr:     "43.138.47.188:8079",
		Password: "",
		DB:       0,
	})

	err := client.Set(ctx, "1067079973@qq.com", "123456", 10*time.Minute).Err()
	if err != nil {
		t.Errorf("Failed to set key: %v", err)
	} else {
		t.Logf("Successfully set key: %s", "name")
	}

	// 检查连接是否成功
	//pong, err := client.Ping(ctx).Result()
	//if err != nil {
	//	t.Errorf("Failed to ping Redis server: %v", err)
	//} else {
	//	t.Logf("Successfully connected to Redis server. Response: %s", pong)
	//}
}

func TestGetFromRedis(t *testing.T) {
	ctx := context.Background()

	var client *redis.Client
	client = redis.NewClient(&redis.Options{
		Addr:     "43.138.47.188:8079",
		Password: "",
		DB:       0,
	})

	val, err := client.Get(ctx, "123").Result()
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
	fmt.Println(val)
}
