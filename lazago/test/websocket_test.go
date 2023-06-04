package test

import (
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"lazago/model"
	"log"
	"net/http"
	"testing"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  10240,
	WriteBufferSize: 10240,
	// 允许跨域
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func TestWebsocket(t *testing.T) {
	http.HandleFunc("/ws", handleWebSocket)
	err := http.ListenAndServe(":8082", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

// TODO: DELETE
var conns = make(map[string]*websocket.Conn)

func TestGinWebsocket(t *testing.T) {
	model.InitDb()
	r := gin.Default()
	r.GET("/ws", func(c *gin.Context) {
		handleWebSocket(c.Writer, c.Request)
	})
	err := r.Run(":8082")
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

func handleWebSocket(w http.ResponseWriter, r *http.Request) {
	// TODO: 将 id 换成 token 并存在 请求头中
	//authHeader := r.Header.Get("jwt")
	//// 解析 token
	//account, err := tools.ParseJwt2Account(authHeader)
	//if err != nil {
	//	fmt.Println("解析 token 失败: ", err)
	//	return
	//}
	//fmt.Println("===UserAccount===: ", account)

	// TODO: 暂时先用 id 代替
	account := r.URL.Query().Get("id")
	fmt.Println("===UserAccount===: ", account)

	fromConn, err := upgrader.Upgrade(w, r, nil)
	fmt.Println("fromConn: ", fromConn.RemoteAddr())

	if err != nil {
		log.Println("upgrade error: ", err)
		return
	}
	defer fromConn.Close()

	//TODO: DELTE
	// 添加到 conns 数组
	conns[account] = fromConn

	// 循环读取客户端发送的消息
	for {
		var messageInfo model.MessageInfo
		messageInfo.FromUserAccount = account
		err := fromConn.ReadJSON(&messageInfo)
		fmt.Println("messageInfo: ", messageInfo)
		if err != nil {
			log.Println("read error: ", err)
			break
		}
		toUser := messageInfo.ToUserAccount

		log.Printf("messageInfo: %v", messageInfo)

		// TODO: 回复给指定人
		toConn, ok := conns[toUser]
		if ok {
			data := map[string]string{
				"from":    account,
				"message": string(messageInfo.Message),
			}
			jsonData, err := json.Marshal(data)
			if err != nil {
				fmt.Println("json.Marshal error: ", err)
			}
			err = toConn.WriteMessage(websocket.TextMessage, jsonData)
			if err != nil {
				// TODO: handle error
				log.Println("write error: ", err)
				break
			} else {
				// TODO: 将消息写入数据库
				messageInfo.IsSent = 1
				err := model.Db.Create(&messageInfo).Error
				if err != nil {
					// TODO: handle error
					fmt.Println("写入数据库失败: ", err)
				}
			}
		} else {
			// 用户不在线
			fmt.Println("没有找到 toUser: ", toUser)
			// TODO: 写入数据库
			err := model.Db.Create(&messageInfo).Error
			if err != nil {
				// TODO: handle error
				fmt.Println("写入数据库失败: ", err)
			}
		}

		//for key, fromConn := range conns {
		//	fmt.Println("发送到 key: ", key)
		//	err = fromConn.WriteMessage(websocket.TextMessage, []byte("From GO Server: "+string(messageInfo.Message)))
		//	if err != nil {
		//		log.Println("write error: ", err)
		//		break
		//	}
		//}

	}
}

func TestSendToServe(t *testing.T) {
	// 连接到服务器
	conn, _, err := websocket.DefaultDialer.Dial("ws://localhost:8082/ws", nil)
	if err != nil {
		log.Fatal("dial error: ", err)
	}

	err = conn.WriteMessage(websocket.TextMessage, []byte("Hello, server!"))
	if err != nil {
		log.Println("write error: ", err)
		return
	}
}

func TestSendToClient(t *testing.T) {}
