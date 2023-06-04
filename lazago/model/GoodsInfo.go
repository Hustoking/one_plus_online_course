package model

import (
	"lazago/global"
	"time"
)

type GoodsInfo struct {
	GoodsID          int       `gorm:"column:goods_id;primaryKey;autoIncrement" json:"goodsId"`
	GoodsName        string    `gorm:"column:goods_name;size:20;not null" json:"goodsName"`
	GoodsPrice       float64   `gorm:"type:decimal(10,2);column:goods_price;not null" json:"goodsPrice"`
	GoodsDescription string    `gorm:"column:goods_description;size:100" json:"goodsDescription"`
	GoodsStock       int       `gorm:"column:goods_stock;not null;default:0" json:"goodsStock"`
	GoodsAvatarAddr  string    `gorm:"column:goods_avatar_addr" json:"goodsAvatarAddr"`
	CreatedAt        time.Time `gorm:"column:created_at;not null" json:"createdAt"`
	UpdatedAt        time.Time `gorm:"column:updated_at;autoUpdateTime" json:"updatedAt"`
	Tags             string    `gorm:"type:json;column:tags" json:"tags"`
	IsFreeShipping   bool      `gorm:"type:tinyint(1);column:is_free_shipping;not null;default:false" json:"isFreeShipping"`

	// 外键
	//GoodsCategoryID   int    `gorm:"column:goods_category_id;not null" json:"goodsCategoryId"`
	GoodsOwnerAccount string `gorm:"column:goods_owner_account;not null" json:"goodsOwnerAccount"`

	// 一对多
	Orders []OrderInfo `gorm:"foreignKey:GoodsID" json:"order"`

	// 多对多
	Categories []CategoryInfo `gorm:"many2many:goods_category_tb;foreignKey:GoodsID;joinForeignKey:GoodsID;References:CategoryID;JoinReferences:CategoryID" json:"categories"`
}

func (GoodsInfo) TableName() string {
	return "goods_tb"
}

type GoodsSummaryInfo struct {
	GoodsID         int     `json:"goodsId"`
	GoodsName       string  `json:"goodsName"`
	GoodsPrice      float64 `json:"goodsPrice"`
	GoodsAvatarAddr string  `json:"goodsAvatarAddr"`
	Tags            string  `json:"tags"`
	IsFreeShipping  bool    `json:"isFreeShipping"`
}

func QueryAllGoods() []GoodsSummaryInfo {
	var goodsSummaryInfos []GoodsSummaryInfo
	Db.Table("goods_tb").Select("goods_id, goods_name, goods_price, tags, is_free_shipping, goods_avatar_addr").Scan(&goodsSummaryInfos)
	// TODO: no handle error
	return goodsSummaryInfos

}

func InsertGoods(goodsInfo *GoodsInfo) int {
	err := Db.Create(&goodsInfo).Error
	if err != nil {
		return global.SQL_INTERNAL_ERROR
	}
	return global.SUCCESS
}

// ============================================== Category =================================================

type CategoryInfo struct {
	CategoryID   int    `gorm:"column:category_id;primaryKey;autoIncrement" json:"categoryId"`
	CategoryName string `gorm:"column:category_name;size:20;not null" json:"categoryName"`

	// 一对多
	//Goods []GoodsInfo `gorm:"foreignKey:GoodsCategoryID" json:"goods"`

	// 多对多
	Goods []GoodsInfo `gorm:"many2many:goods_category_tb;foreignKey:CategoryID;joinForeignKey:CategoryID;References:GoodsID;JoinReferences:GoodsID" json:"goods"`
}

func (CategoryInfo) TableName() string {
	return "category_tb"
}
