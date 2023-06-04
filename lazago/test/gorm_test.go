package test

import (
	"context"
	"database/sql"
	"fmt"
	"github.com/jmoiron/sqlx"
	"lazago/model"
	"strconv"
	"testing"
)

func TestGorm1(t *testing.T) {
	model.InitDb()
	//println("===Ceshi===")
	//exist := model.CheckUserExist("123")
	//println(exist)

	//println("===Ceshi2===")
	//var userInfo model.UserInfo
	////err := model.Db.Where("user_account = ?", "1067079973").First(&userInfo).Error
	//model.Db.Take(&userInfo, "user_account = ?", "1067079973")
	//print("===UserName===")
	//print(userInfo.UserName)

	// Insert
	u1 := model.UserInfo{
		UserAccount: "1067079973",
		UserName:    "HuStoking",
		UserPswdMd5: "324j009j",
		UserEmail:   "18443347444@163.com",
	}
	model.Db.Create(&u1)

	// 查询单条记录
	println("===Select===")
	var userInfo model.UserInfo
	model.Db.Take(&userInfo)
	println("===UserAccount===")
	fmt.Println(userInfo.UserAccount)

}

func TestCheckUserExist(t *testing.T) {
	model.InitDb()
	isExist, err := model.CheckUserExist("123")
	if err != nil {
		fmt.Println("===ERROR===")
		fmt.Println(err)
	}
	fmt.Println(isExist)
}

func TestTake(t *testing.T) {
	model.InitDb()
	var userInfo model.UserInfo
	model.Db.Take(&userInfo)
	println("===UserAccount===")
	fmt.Println(userInfo)
}

func TestSqlx(t *testing.T) {
	const DSN = "root:123456@tcp(43.138.47.188)/fruttle"
	db, err := sqlx.Connect("mysql", DSN)
	if err != nil {
		fmt.Println("Failed to connect to database:", err)
	} else {
		fmt.Println("Connected to database")
	}
	defer db.Close()
}

func TestSql(t *testing.T) {
	connStr := "root:123456@tcp(43.138.47.188:8039)/fruttle"
	db, err := sql.Open("mysql", connStr)
	if err != nil {
		fmt.Println("Failed to connect to database:", err)
	} else {
		fmt.Println("Connected to database")
	}
	ctx := context.Background()

	err = db.PingContext(ctx)
	if err != nil {
		fmt.Printf("Ping failed: %v\n", err)
	}
	fmt.Println("Ping succeeded")
}

func TestPage(t *testing.T) {
	model.InitDb()
	users := model.GetUsers(0, 1)
	for _, user := range users {
		fmt.Println(user)
	}
}

func TestUserAvailable(t *testing.T) {
	model.InitDb()
	available, err := model.GetUserAvailableByUserAccount("1067079973")
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
	println(available)
}

func TestUserPswd(t *testing.T) {
	model.InitDb()
	pswd, err := model.GetPswdByUserAccount("1067079973")
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
	println(pswd)
}

func TestSelectSingleField(t *testing.T) {
	model.InitDb()
	var userInfo model.UserInfo
	err := model.Db.Select("user_name").Where("user_account = ?", "1067079973").First(&userInfo).Error
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
	fmt.Println(userInfo.UserName)
}

func TestSetUserAvailable(t *testing.T) {
	model.InitDb()
	err := model.Db.Model(&model.UserInfo{}).Where("user_account = ?", "1067079973").Update("is_verified", true).Error
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
}
func TestGetEmail(t *testing.T) {
	model.InitDb()
	email, err := model.GetEmailByUserAccount("1067079973")
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
	fmt.Println(email)
}

// ================================================================

func TestGenDatabase(t *testing.T) {
	model.InitDb()
	model.Db.AutoMigrate(&model.UserInfo{}, &model.CategoryInfo{}, &model.GoodsInfo{}, &model.OrderInfo{})
}

func TestAddUser(t *testing.T) {
	model.InitDb()
	// 添加用户
	u1 := model.UserInfo{
		UserAccount: "1067079973",
		UserName:    "HuStoking",
		UserPswdMd5: "324j009j",
		UserEmail:   "18443347444@163.com",
	}
	err := model.Db.Create(&u1).Error
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
}
func TestAddCategory(t *testing.T) {
	model.InitDb()
	// 添加分类
	c1 := model.CategoryInfo{
		CategoryName: "饮料",
	}
	err := model.Db.Create(&c1).Error
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
}
func TestAddGoods(t *testing.T) {
	model.InitDb()
	// 添加商品
	g1 := model.GoodsInfo{
		GoodsName:         "苹果",
		GoodsPrice:        5.5,
		GoodsDescription:  "红富士",
		GoodsStock:        100,
		GoodsAvatarAddr:   "",
		GoodsOwnerAccount: "1067079973",
		Categories:        []model.CategoryInfo{{CategoryName: "水果"}},
		Tags:              `["fruit", "healthy", "snack"]`,
	}
	err := model.Db.Create(&g1).Error
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
}

func TestAddOrder(t *testing.T) {
	model.InitDb()
	// 添加订单
	o1 := model.OrderInfo{
		PurchaseCount: 10,
		OrderStatus:   0,
		GoodsID:       1,
		UserAccount:   "1067079973",
	}
	err := model.Db.Create(&o1).Error
	if err != nil {
		fmt.Println("===Error===")
		fmt.Println(err)
	}
}

// ======================================== 查询 Goods 相关 =============================================
func TestGetGoodsSummary(t *testing.T) {
	model.InitDb()
	var goodsInfos []*model.GoodsInfo
	//model.Db.Select("goods_id, goods_name, goods_price, tags, is_free_shipping, goods_avatar_addr").Find(&goodsInfos)
	model.Db.Table("goods_tb").Select("goods_id, goods_name, goods_price, tags, is_free_shipping, goods_avatar_addr").Scan(&goodsInfos)

	for _, p := range goodsInfos {
		//tags, err := json.Marshal(p.Tags)
		//if err != nil {
		//	fmt.Println("===Error===")
		//	fmt.Println(err)
		//}
		price := fmt.Sprintf("%f", p.GoodsPrice)
		fmt.Println(strconv.Itoa(p.GoodsID) + "\t" + p.GoodsName + "\t" + p.Tags + "\t" + price + "\t" + strconv.FormatBool(p.IsFreeShipping) + p.GoodsDescription + "\t" + p.GoodsAvatarAddr)
	}
}

// ========================================Message Test=============================================
