package v1

import (
	"github.com/gin-gonic/gin"
	"lazago/global"
	"lazago/model"
	"net/http"
)

func UserLikeCourse(context *gin.Context) {
	var userLikeCourse model.UserLikeCourse
	err := context.ShouldBindJSON(&userLikeCourse)
	if err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{
			"code": global.SQL_INTERNAL_ERROR,
			"msg":  global.GetCodeMsg(global.SQL_INTERNAL_ERROR),
		})
		return
	}
	err = model.InsertLikeCourse(&userLikeCourse)
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

func UserDislikeCourse(context *gin.Context) {}
