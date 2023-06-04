package v1

import (
	"github.com/gin-gonic/gin"
	"lazago/global"
	"lazago/model"
	"net/http"
)

func AddComment(context *gin.Context) {
	var commentInfo model.CommentInfo
	err := context.BindJSON(&commentInfo)
	if err != nil {
		context.JSON(http.StatusUnprocessableEntity, gin.H{
			"code": global.FORMAT_ERROR,
			"msg":  global.GetCodeMsg(global.FORMAT_ERROR),
		})
		return
	}

	err = model.InsertComment(&commentInfo)
	if err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{
			"code": global.SQL_INTERNAL_ERROR,
			"msg":  global.GetCodeMsg(global.SQL_INTERNAL_ERROR),
		})
		return
	}
	context.JSON(http.StatusOK, gin.H{
		"code": global.SUCCESS,
		"msg":  global.GetCodeMsg(global.SUCCESS),
	})
}
