package model

import (
	"time"
)

type CourseInfo struct {
	CourseId          int       `gorm:"column:course_id;primaryKey;autoIncrement" json:"courseId"`
	CourseName        string    `gorm:"column:course_name;size:20;not null" json:"courseName"`
	CourseAvatarAddr  string    `gorm:"column:course_avatar_addr" json:"courseAvatarAddr"`
	CoursePrice       float64   `gorm:"type:decimal(10,2);column:course_price;not null" json:"coursePrice"`
	CourseDescription string    `gorm:"column:course_description;size:500" json:"courseDescription"`
	Tags              string    `gorm:"type:json;column:tags" json:"tags"`
	CreatedAt         time.Time `gorm:"column:created_at;not null" json:"createdAt"`
	UpdatedAt         time.Time `gorm:"column:updated_at;autoUpdateTime" json:"updatedAt"`

	// 一对多
	Badges []BadgeInfo `gorm:"foreignKey:BelongToCourseId" json:"badges"`

	// 多对一 外键
	TeacherAccount string `gorm:"column:teacher_account;size:10;not null" json:"teacherAccount"`
}

func (CourseInfo) TableName() string {
	return "course_tb"
}

func InsertCourse(courseInfo *CourseInfo) error {
	err := Db.Create(&courseInfo).Error
	if err != nil {
		return err
	}
	return nil
}

func QueryAllCourse() ([]CourseInfo, error) {
	var courseInfos []CourseInfo
	err := Db.Find(&courseInfos).Error
	if err != nil {
		return nil, err
	}
	return courseInfos, nil
}

func QueryDescByCourseId(courseId int) (string, error) {
	var courseInfo CourseInfo
	err = Db.Select("course_description").Where("course_id = ?", courseId).First(&courseInfo).Error
	if err != nil {
		return "", err
	}
	return courseInfo.CourseDescription, nil
}

func QueryTeacherAccountByCourseId(courseId int) (string, error) {
	var courseInfo CourseInfo
	err = Db.Table("course_tb").Select("teacher_account").Where("course_id = ?", courseId).First(&courseInfo).Error
	if err != nil {
		return "", err
	}
	return courseInfo.TeacherAccount, nil
}

func QueryCourseNameByCourseId(courseId int) (string, error) {
	var courseInfo CourseInfo
	err = Db.Table("course_tb").Select("course_name").Where("course_id = ?", courseId).First(&courseInfo).Error
	if err != nil {
		return "", err
	}
	return courseInfo.CourseName, nil
}
