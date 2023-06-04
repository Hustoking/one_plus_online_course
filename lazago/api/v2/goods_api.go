package v2

import (
	"github.com/gin-gonic/gin"
	"lazago/global"
	"lazago/model"
	"net/http"
)

func QueryGoodsList(context *gin.Context) {
	goods := model.QueryAllGoods()
	context.JSON(http.StatusOK, gin.H{
		"data": goods,
		"code": global.SUCCESS,
		"msg":  global.GetCodeMsg(global.SUCCESS),
	})
}

func AddGoods(context *gin.Context) {
	var goodsInfo model.GoodsInfo
	// 将请求的数据绑定到结构体
	err := context.ShouldBindJSON(&goodsInfo)
	if err != nil {
		context.JSON(http.StatusUnprocessableEntity, gin.H{
			"code": global.FORMAT_ERROR,
			"msg":  global.GetCodeMsg(global.FORMAT_ERROR),
		})
	}

	// 添加商品
	model.InsertGoods(&goodsInfo)
}
