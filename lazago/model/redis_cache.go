package model

import (
	"context"
	"fmt"
	"github.com/redis/go-redis/v9"
	"lazago/config"
	"time"
)

func getRedisConn() *redis.Client {
	var client *redis.Client
	client = redis.NewClient(&redis.Options{
		Addr:     config.REDIS_HOST_ADDR,
		Password: config.REDIS_PSWD,
		DB:       config.REDIS_DB,
	})
	return client
}

// 写入 redis
func WriteInRedis(redis_key string, redis_value string) error {

	var ctx = context.Background()

	client := getRedisConn()

	// 10 分钟有效期
	err := client.Set(ctx, redis_key, redis_value, 10*time.Minute).Err()
	if err != nil {
		// TODO: error handling
		fmt.Println("Failed to set key: %v", err)
		return err
	}
	return nil
}

func ReadInRedis(redis_key string) (string, error) {
	ctx := context.Background()

	client := getRedisConn()

	val, err := client.Get(ctx, redis_key).Result()
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
		return "", err
	}
	return val, nil
}
