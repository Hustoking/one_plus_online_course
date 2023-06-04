package main

import (
	"lazago/model"
	"lazago/routes"
)

func main() {
	model.InitDb()
	routes.InitRouter()
}
