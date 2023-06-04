package routes

import (
	"github.com/gin-gonic/gin"
	v1 "lazago/api/v1"
	"lazago/config"
)

func InitRouter() {
	gin.SetMode(config.AppMode)

	routerEngine := gin.Default()

	v1RouterGroup := routerEngine.Group("/api/v1")
	{
		// 分页查询用户列表
		v1RouterGroup.GET("/user", v1.QueryUserList)
		// 添加用户
		v1RouterGroup.POST("/user_add", v1.AddUser)
		// 用户登录
		v1RouterGroup.POST("login", v1.Login)
		// 用户账号验重（用户账号表单失焦）
		v1RouterGroup.GET("/user_exist", v1.CheckUserAccountExist)
		// 用户注册
		v1RouterGroup.POST("/register", v1.Register)
		// 用户注册认证
		v1RouterGroup.POST("/register_auth", v1.RegisterAuth)

		// 课程相关
		v1RouterGroup.POST("/course_add", v1.AddCourse)
		// 查询全部课程列表
		v1RouterGroup.GET("/course", v1.GetCourseSummary)
		// 用户点赞课程
		v1RouterGroup.POST("/like_course", v1.UserLikeCourse)
		// 根据课程id获取Desc
		v1RouterGroup.GET("/course_desc", v1.GetDescByCourseId)
		// 为课程添加评论
		v1RouterGroup.POST("/comment_add", v1.AddComment)
		// 获取课程详情界面 view
		v1RouterGroup.GET("/course_detail", v1.GetCourseDetail)

		// 徽章相关
		v1RouterGroup.POST("/badge_add", v1.AddBadge)
	}

	routerEngine.Run(config.HttpPort)
}
