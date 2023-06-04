package global

// 返回的结果码
const (
	SUCCESS = 200
	ERROR   = 500

	// 用户相关
	USER_ACCOUNT_EXIST         = 1001
	USER_ACCOUNT_NOT_EXIST     = 1002
	PSWD_WRONG                 = 1003
	USER_ACCOUNT_NOT_AVAILABLE = 1004

	// Others
	FORMAT_ERROR       = 7001
	SQL_INTERNAL_ERROR = 7002
	VERIFY_CODE_WRONG  = 7003
)

var codeMsg = map[int]string{
	SUCCESS:                    "ok",
	ERROR:                      "fail",
	USER_ACCOUNT_EXIST:         "用户账号存在",
	USER_ACCOUNT_NOT_EXIST:     "用户账号不存在",
	PSWD_WRONG:                 "密码错误",
	FORMAT_ERROR:               "格式错误",
	SQL_INTERNAL_ERROR:         "SQL 内部错误，请联系管理员",
	USER_ACCOUNT_NOT_AVAILABLE: "用户账号未激活",
	VERIFY_CODE_WRONG:          "验证码错误",
}

func GetCodeMsg(code int) string {
	msg, ok := codeMsg[code]
	if ok {
		return msg
	}
	return "-无效的错误码-"
}

// 用户状态
// UserStatus
const (
	USER_STATUS_DISABLE = 0 // 禁用
	USER_STATUS_STUDENT = 1 // 学生
	USER_STATUS_TEACHER = 2 // 教师
	USER_STATUS_MANAGE  = 3 // 管理员
)
