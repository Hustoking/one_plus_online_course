package config

import "gorm.io/gorm/logger"

const HttpPort = ":8082"
const AppMode = "debug"

const Db = "mysql"
const DbHost = "43.138.47.188"
const DbPort = ":8039"
const DbUser = "root"
const DbPswd = "123456"
const DbName = "gradu"

var MySqlLogger = logger.Default.LogMode(logger.Info) // 打印所有日志

const SqlDsn = DbUser + ":" + DbPswd + "@tcp(" + DbHost + DbPort + ")/" + DbName + "?charset=utf8mb4&parseTime=True&loc=Local"

const MAIL_HOST = "smtp.163.com"
const HOST_MAIL_ADDR = "18443347444@163.com"
const HOST_MAIL_PSWD = "KHMTPWZQAPWVSIOP"

const REDIS_HOST_ADDR = "43.138.47.188:8079"
const REDIS_PSWD = ""
const REDIS_DB = 0
