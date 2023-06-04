package model

import (
	"fmt"
	"gorm.io/gorm"
	"lazago/global"
	"time"
)

type UserInfo struct {
	UserAccount    string    `gorm:"column:user_account;size:10;not null;primaryKey;unique;" json:"userAccount"`
	UserName       string    `gorm:"column:user_name;size:20;default:'USER'" json:"userName"`
	UserAvatarAddr *string   `gorm:"column:user_avatar_addr" json:"userAvatarAddr"`
	UserPswdMd5    string    `gorm:"column:user_pswd_md5;not null" json:"userPswdMd5"`
	UserEmail      string    `gorm:"column:user_email;size:20;not null" json:"userEmail"`
	UserStatus     int       `gorm:"type:tinyint(3);column:user_status;default:0" json:"userStatus"`
	CreatedAt      time.Time `gorm:"column:created_at;not null" json:"createdAt"`
	UpdatedAt      time.Time `gorm:"column:updated_at;autoUpdateTime" json:"updatedAt"`

	// 一对多
	Badges   []BadgeInfo   `gorm:"foreignKey:BelongToUserAccount" json:"badges"`
	Courses  []CourseInfo  `gorm:"foreignKey:TeacherAccount" json:"courses"`
	Comments []CommentInfo `gorm:"foreignKey:UserAccount" json:"comments"`

	// 多对多
	LikeCourses []CourseInfo `gorm:"many2many:user_like_course_tb;foreignKey:UserAccount;joinForeignKey:UserAccount;References:CourseId;JoinReferences:CourseId" json:"likeCourses"`
}

// TableName 自定义表名
func (UserInfo) TableName() string {
	return "user_tb"
}

// CreateUser 创建用户
func CreateUser(userInfo *UserInfo) int {
	err := Db.Create(&userInfo).Error
	if err != nil {
		return global.ERROR
	}
	return global.SUCCESS
}

/*
CheckUserExist CheckUserExist 检查用户是否存在
存在返回 true
不存在返回 false
错误返回 error
*/
func CheckUserExist(userAccount string) (result bool, err error) {
	var userInfo UserInfo
	err = Db.Where("user_account = ?", userAccount).First(&userInfo).Error
	// 如果查询出错，且不是因为没有找到记录
	if err != nil && err != gorm.ErrRecordNotFound {
		println("===ERROR===")
		fmt.Println(err)
		result = false
		return
	}
	// 如果没有下面这一行，err 会是 gorm.ErrRecordNotFound
	err = nil
	// 如果 UserAccount 不为空，说明找到了记录
	if userInfo.UserAccount != "" {
		result = true
		return
	}
	// 否则，没有找到记录
	result = false
	return
}

func GetUsers(pageNum int, pageSize int) (users []UserInfo) {
	err := Db.Limit(pageSize).Offset((pageNum - 1) * pageSize).Find(&users).Error
	if err != nil {
		return nil
	}
	return users
}

// GetUserByUserAccount 检查用户账号是否可用 -（不是检查是否存在）
func GetUserAvailableByUserAccount(userAccount string) (result bool, err error) {
	var userInfo UserInfo
	//err := Db.Model(&userInfo).Select("is_verified").Where("user_account = ?", userAccount).First(&userInfo).Error
	err = Db.Select("user_status").Where("user_account = ?", userAccount).First(&userInfo).Error
	if err != nil {
		fmt.Println("===ERROR===")
		fmt.Println(err)
		result = false
		return
	}
	result = userInfo.UserStatus != 0
	return
}

func GetPswdByUserAccount(userAccount string) (pswd_md5 string, err error) {
	var userInfo UserInfo
	err = Db.Select("user_pswd_md5").Where("user_account = ?", userAccount).First(&userInfo).Error
	if err != nil {
		fmt.Println("===ERROR===")
		fmt.Println(err)
		pswd_md5 = ""
		return
	}
	pswd_md5 = userInfo.UserPswdMd5
	return
}

func GetEmailByUserAccount(userAccount string) (email string, err error) {
	var userInfo UserInfo
	err = Db.Select("user_email").Where("user_account = ?", userAccount).First(&userInfo).Error
	if err != nil {
		fmt.Println("===ERROR===")
		fmt.Println(err)
		email = ""
		return
	}
	email = userInfo.UserEmail
	return
}

func SetUserAvailableByUserAccount(userAccount string) (err error) {
	err = Db.Model(&UserInfo{}).Where("user_account = ?", userAccount).Update("user_status", global.USER_STATUS_STUDENT).Error
	return
}

func QueryUserAvatarAddrByUserAccount(userAccount string) (userAvatarAddr string, err error) {
	var userInfo UserInfo
	err = Db.Select("user_avatar_addr").Where("user_account = ?", userAccount).First(&userInfo).Error
	if err != nil {
		fmt.Println("===ERROR===")
		fmt.Println(err)
		userAvatarAddr = ""
		return
	}
	userAvatarAddr = *userInfo.UserAvatarAddr
	return
}

func QueryUserNameByUserAccount(userAccount string) (userName string, err error) {
	var userInfo UserInfo
	err = Db.Select("user_name").Where("user_account = ?", userAccount).First(&userInfo).Error
	if err != nil {
		fmt.Println("===ERROR===")
		fmt.Println(err)
		userName = ""
		return
	}
	userName = userInfo.UserName
	return
}
