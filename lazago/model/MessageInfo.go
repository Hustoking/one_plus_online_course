package model

import "time"

type MessageInfo struct {
	FromUserAccount string    `gorm:"column:from_user_account;not null" json:"fromUserAccount"`
	ToUserAccount   string    `gorm:"column:to_user_account;not null" json:"toUserAccount"`
	Message         string    `gorm:"column:message;not null" json:"message"`
	CreatedAt       time.Time `gorm:"column:created_at;not null" json:"createdAt"`
	IsSent          int       `gorm:"type:tinyint(3);column:is_sent;default:0" json:"isSent"`
}

func (MessageInfo) TableName() string {
	return "message_tb"
}
