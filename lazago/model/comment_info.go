package model

import "time"

type CommentInfo struct {
	CommentId      int       `gorm:"column:comment_id;primaryKey;autoIncrement" json:"commentId"`
	CommentContent string    `gorm:"column:comment_content;size:500;not null" json:"commentContent"`
	CreatedAt      time.Time `gorm:"column:created_at;not null" json:"createdAt"`

	// 外键
	CourseId    int    `gorm:"column:course_id;not null" json:"courseId"`
	UserAccount string `gorm:"column:user_account;size:10;not null" json:"userAccount"`
}

func (CommentInfo) TableName() string {
	return "comment_tb"
}

func InsertComment(commentInfo *CommentInfo) error {
	err := Db.Create(&commentInfo).Error
	if err != nil {
		return err
	}
	return nil
}

func QueryCommentsCountByCourseId(courseId int) int {
	var count int64
	Db.Model(&CommentInfo{}).Where("course_id = ?", courseId).Count(&count)
	return int(count)
}
