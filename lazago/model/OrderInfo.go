package model

import "time"

type OrderInfo struct {
	OrderID       int       `gorm:"column:order_id;primaryKey;autoIncrement" json:"orderId"`
	PurchaseCount int       `gorm:"column:purchase_count;not null" json:"purchaseCount"`
	OrderStatus   int       `gorm:"type:tinyint(3);column:order_status;not null;default:0" json:"orderStatus"`
	CreatedAt     time.Time `gorm:"column:created_at;not null" json:"createdAt"`
	UpdatedAt     time.Time `gorm:"column:updated_at;autoUpdateTime" json:"updatedAt"`

	// 外键
	GoodsID     int    `gorm:"column:goods_id;not null" json:"goodsId"`
	UserAccount string `gorm:"column:user_account;not null" json:"userAccount"`
}

func (OrderInfo) TableName() string {
	return "order_tb"
}
