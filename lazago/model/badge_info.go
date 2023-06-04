package model

import "time"

type BadgeInfo struct {
	BadgeId   int       `gorm:"column:badge_id;primaryKey;autoIncrement" json:"badgeId"`
	CreatedAt time.Time `gorm:"column:created_at;not null" json:"createdAt"`
	UpdatedAt time.Time `gorm:"column:updated_at;autoUpdateTime" json:"updatedAt"`

	// 多对一 外键
	BelongToUserAccount string `gorm:"column:belong_to_user_account;size:10;not null" json:"belongToUserAccount"`
	BelongToCourseId    int    `gorm:"column:belong_to_course_id;not null" json:"belongToCourseId"`
}

func (BadgeInfo) TableName() string {
	return "badge_tb"
}

func InsertBadge(badgeInfo *BadgeInfo) error {
	err := Db.Create(&badgeInfo).Error
	if err != nil {
		return err
	}
	return nil
}

func QueryBadgesCountByCourseId(courseId int) int {
	var count int64
	Db.Model(&BadgeInfo{}).Where("belong_to_course_id = ?", courseId).Count(&count)
	return int(count)
}
