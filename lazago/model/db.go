package model

import (
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"lazago/config"
)

// todo: to lowerCase
var Db *gorm.DB
var err error

func InitDb() {
	Db, err = gorm.Open(mysql.Open(config.SqlDsn), &gorm.Config{
		Logger: config.MySqlLogger,
	})
	if err != nil {
		panic(err)
	}

	// 生成数据库
	// TODO: 取消自动生成 - Test
	Db.AutoMigrate(&UserInfo{}, &CourseInfo{}, &BadgeInfo{}, &CommentInfo{})
}
