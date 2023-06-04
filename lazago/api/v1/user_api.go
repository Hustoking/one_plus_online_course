package v1

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"lazago/global"
	"lazago/model"
	"net/http"
	"strconv"
)

// QueryUserList 查询用户列表
func QueryUserList(context *gin.Context) {
	pageSize, err := strconv.Atoi(context.Query("pageSize"))
	pageNum, err := strconv.Atoi(context.Query("pageNum"))
	// 检查参数是否正确
	if err != nil {
		fmt.Print(err)
		context.JSON(http.StatusUnprocessableEntity, gin.H{
			"code": global.FORMAT_ERROR,
			"msg":  global.GetCodeMsg(global.FORMAT_ERROR),
		})
	} else {
		users := model.GetUsers(pageNum, pageSize)
		context.JSON(http.StatusOK, gin.H{
			"data": users,
			"code": global.SUCCESS,
			"msg":  global.GetCodeMsg(global.SUCCESS),
		})
	}
}

// 添加用户
func AddUser(context *gin.Context) {
	var userInfo model.UserInfo
	// 将请求的数据绑定到结构体
	err := context.ShouldBindJSON(&userInfo)
	if err != nil {
		context.JSON(http.StatusUnprocessableEntity, gin.H{
			"code": global.FORMAT_ERROR,
			"msg":  global.GetCodeMsg(global.FORMAT_ERROR),
		})
	}
	// 检查用户是否存在
	isUserExist, err := model.CheckUserExist(userInfo.UserAccount)
	if err != nil {
		fmt.Println("===ERROR===")
		fmt.Print(err)
		context.JSON(http.StatusInternalServerError, gin.H{
			"code": global.SQL_INTERNAL_ERROR,
			"msg":  global.GetCodeMsg(global.SQL_INTERNAL_ERROR),
		})
	}
	// 用户账号不存在则创建用户
	if isUserExist == false {
		model.CreateUser(&userInfo)
		context.JSON(http.StatusOK, gin.H{
			"code": global.SUCCESS,
			"msg":  global.GetCodeMsg(global.SUCCESS),
		})
	} else {
		// 用户账号已存在，向前端返回错误信息
		context.JSON(http.StatusOK, gin.H{
			"code": global.USER_ACCOUNT_EXIST,
			"msg":  global.GetCodeMsg(global.USER_ACCOUNT_EXIST),
		})
	}
}

// Login 用户登录
func Login(context *gin.Context) {
	userAccount := context.PostForm("user_account")
	userPswdMd5 := context.PostForm("user_pswd_md5")
	isUserExist, err := model.CheckUserExist(userAccount)
	// 用户账号是否存在
	if isUserExist == false {
		context.JSON(http.StatusNotFound, gin.H{
			"code": global.USER_ACCOUNT_NOT_EXIST,
			"msg":  global.GetCodeMsg(global.USER_ACCOUNT_NOT_EXIST),
		})
		return
	}
	// 检查用户账号是否可用
	userIsAvailable, err := model.GetUserAvailableByUserAccount(userAccount)
	if userIsAvailable == false {
		context.JSON(http.StatusForbidden, gin.H{
			"code": global.USER_ACCOUNT_NOT_AVAILABLE,
			"msg":  global.GetCodeMsg(global.USER_ACCOUNT_NOT_AVAILABLE),
		})
		return
	}

	// 检查密码是否正确
	actualPswdMd5, err := model.GetPswdByUserAccount(userAccount)
	if err != nil {
		fmt.Print("===ERROR===")
		fmt.Print(err)
		context.JSON(http.StatusInternalServerError, gin.H{
			"code": global.SQL_INTERNAL_ERROR,
			"msg":  global.GetCodeMsg(global.SQL_INTERNAL_ERROR),
		})
		return
	}

	if userPswdMd5 != actualPswdMd5 {
		fmt.Println("---密码错误---")
		context.JSON(http.StatusUnauthorized, gin.H{
			"code": global.PSWD_WRONG,
			"msg":  global.GetCodeMsg(global.PSWD_WRONG),
		})
		return
	}

	// 登录成功
	context.JSON(http.StatusOK, gin.H{
		"code": global.SUCCESS,
		"msg":  global.GetCodeMsg(global.SUCCESS),
	})

}

// 用户账号验重
func CheckUserAccountExist(context *gin.Context) {
	userAccount := context.Query("user_account")
	isExist, err := model.CheckUserExist(userAccount)
	if err != nil {
		fmt.Println("===ERROR===")
		fmt.Print(err)
		context.JSON(http.StatusInternalServerError, gin.H{
			"code": global.SQL_INTERNAL_ERROR,
			"msg":  global.GetCodeMsg(global.SQL_INTERNAL_ERROR),
		})
	}
	if isExist == true {
		context.JSON(http.StatusConflict, gin.H{
			"code": global.USER_ACCOUNT_EXIST,
			"msg":  global.GetCodeMsg(global.USER_ACCOUNT_EXIST),
		})
	} else {
		context.JSON(http.StatusOK, gin.H{
			"code": global.SUCCESS,
			"msg":  global.GetCodeMsg(global.SUCCESS),
		})
	}
}

// 用户注册
func Register(context *gin.Context) {
	userAccount := context.PostForm("user_account")
	userPswdMd5 := context.PostForm("user_pswd_md5")
	userEmail := context.PostForm("user_email")

	// 用户账号验重
	isExist, err := model.CheckUserExist(userAccount)
	if err != nil {
		fmt.Println("===ERROR===")
		fmt.Print(err)
		context.JSON(http.StatusInternalServerError, gin.H{
			"code": global.SQL_INTERNAL_ERROR,
			"msg":  global.GetCodeMsg(global.SQL_INTERNAL_ERROR),
		})
		return
	}
	if isExist == true {
		context.JSON(http.StatusConflict, gin.H{
			"code": global.USER_ACCOUNT_EXIST,
			"msg":  global.GetCodeMsg(global.USER_ACCOUNT_EXIST),
		})
		return
	}

	var userInfo model.UserInfo
	{
		userInfo.UserAccount = userAccount
		userInfo.UserPswdMd5 = userPswdMd5
		userInfo.UserEmail = userEmail
	}
	// 将用户信息写入数据库
	model.CreateUser(&userInfo)
	context.JSON(http.StatusOK, gin.H{
		"code": global.SUCCESS,
		"msg":  global.GetCodeMsg(global.SUCCESS),
	})

	// 生成验证码
	verifyCode := global.GenVerifyCode()
	// 在 Redis 中储存邮箱对应的验证码
	model.WriteInRedis(userEmail, verifyCode)
	// 发送邮件
	global.SendMail(userEmail, "这是一封来自[ xxx ]的测试邮件", "欢迎您注册[ xxx ]，您的验证码为："+verifyCode)
}

// 用户注册认证
func RegisterAuth(context *gin.Context) {
	//model.InitDb()
	userAccount := context.PostForm("user_account")
	verifyCode := context.PostForm("verify_code")

	// 根据用户名称获取用户邮箱
	userEmail, err := model.GetEmailByUserAccount(userAccount)
	if err != nil && err != gorm.ErrRecordNotFound {
		fmt.Println("===ERROR===")
		fmt.Print(err)
		context.JSON(http.StatusInternalServerError, gin.H{
			"code": global.SQL_INTERNAL_ERROR,
			"msg":  global.GetCodeMsg(global.SQL_INTERNAL_ERROR),
		})
		return
	}
	if err == gorm.ErrRecordNotFound {
		context.JSON(404, gin.H{
			"code": global.USER_ACCOUNT_NOT_EXIST,
			"msg":  global.GetCodeMsg(global.USER_ACCOUNT_NOT_EXIST),
		})
		return
	}
	// 根据用户邮箱获取 Redis 中的验证码
	actualVerifyCode, err := model.ReadInRedis(userEmail)
	fmt.Println("===actualVerifyCode===")
	fmt.Println(actualVerifyCode)
	if verifyCode != actualVerifyCode {
		context.JSON(http.StatusUnauthorized, gin.H{
			"code": global.VERIFY_CODE_WRONG,
			"msg":  global.GetCodeMsg(global.VERIFY_CODE_WRONG),
		})
		return
	}
	// 将用户账号设置为可用
	err = model.SetUserAvailableByUserAccount(userAccount)
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
