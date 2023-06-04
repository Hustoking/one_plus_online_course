package v1

import (
	"github.com/gin-gonic/gin"
	"lazago/global"
	"lazago/model"
	"lazago/model/view_model"
	"net/http"
	"strconv"
)

func AddCourse(context *gin.Context) {
	var courseInfo model.CourseInfo
	err := context.ShouldBindJSON(&courseInfo)
	if err != nil {
		context.JSON(http.StatusUnprocessableEntity, gin.H{
			"code": global.FORMAT_ERROR,
			"msg":  global.GetCodeMsg(global.FORMAT_ERROR),
		})
		return
	}
	err = model.InsertCourse(&courseInfo)
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

func GetAllCourse(context *gin.Context) {
	courseList, err := model.QueryAllCourse()
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
		"data": courseList,
	})
}

func GetCourseSummary(context *gin.Context) {
	courseSummaryList, err := model.QueryAllCourseSummary()
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
		"data": courseSummaryList,
	})
}

func GetDescByCourseId(context *gin.Context) {
	courseId := context.Query("courseId")
	num, err := strconv.Atoi(courseId)
	if err != nil {
		context.JSON(http.StatusUnprocessableEntity, gin.H{
			"code": global.FORMAT_ERROR,
			"msg":  global.GetCodeMsg(global.FORMAT_ERROR),
		})
	}
	courseDesc, err := model.QueryDescByCourseId(num)
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
		"data": courseDesc,
	})
}

// 课程详情界面 view
func GetCourseDetail(context *gin.Context) {
	var courseDetail view_model.CourseDetailedView
	_courseId := context.Query("courseId")
	courseId, err := strconv.Atoi(_courseId)

	courseDetail.CourseId = courseId

	if err != nil {
		context.JSON(http.StatusUnprocessableEntity, gin.H{
			"code": global.FORMAT_ERROR,
			"msg":  global.GetCodeMsg(global.FORMAT_ERROR),
		})
		return
	}
	courseDetail.CourseDescription, err = model.QueryDescByCourseId(courseId)
	courseDetail.TeacherAccount, err = model.QueryTeacherAccountByCourseId(courseId)
	courseDetail.CourseName, err = model.QueryCourseNameByCourseId(courseId)

	courseDetail.CommentsCount = model.QueryCommentsCountByCourseId(courseId)
	courseDetail.LikesCount = model.QueryLikesCountByCourseId(courseId)
	courseDetail.BadgesCount = model.QueryBadgesCountByCourseId(courseId)

	courseDetail.TeacherAvatarAddr, err = model.QueryUserAvatarAddrByUserAccount(courseDetail.TeacherAccount)
	courseDetail.TeacherName, err = model.QueryUserNameByUserAccount(courseDetail.TeacherAccount)
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
		"data": courseDetail,
	})
}
