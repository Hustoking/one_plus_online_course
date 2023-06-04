package test

import (
	"fmt"
	"lazago/model"
	"strconv"
	"testing"
)

func TestQueryTeacherAccount(t *testing.T) {
	model.InitDb()
	teacherAccount, err := model.QueryTeacherAccountByCourseId(3)
	if err != nil {
		t.Error(err)
	}
	fmt.Println("teacherAccount: ", teacherAccount)

}

func TestQueryCommentsAccountByCourseId(t *testing.T) {
	model.InitDb()
	courseId := 2
	count := model.QueryCommentsCountByCourseId(courseId)
	fmt.Println("Course ID "+strconv.Itoa(courseId)+" count: ", count)
}

func TestQueryLikesCountByCourseId(t *testing.T) {
	model.InitDb()
	courseId := 3
	count := model.QueryLikesCountByCourseId(courseId)
	fmt.Println("Course ID "+strconv.Itoa(courseId)+" likes count: ", count)
}

func TestQueryBadgesCountByCourseId(t *testing.T) {
	model.InitDb()
	courseId := 4
	count := model.QueryBadgesCountByCourseId(courseId)
	fmt.Println("Course ID "+strconv.Itoa(courseId)+" badges count: ", count)
}

func TestQueryUserAvatarAddrByUserAccount(t *testing.T) {
	model.InitDb()
	userAccount := "1067079973"
	userAvatarAddr, err := model.QueryUserAvatarAddrByUserAccount(userAccount)
	if err != nil {
		t.Error(err)
	}
	fmt.Println("User Account "+userAccount+" avatar addr: ", userAvatarAddr)
}

func TestQueryUserNameAddrByUserAccount(t *testing.T) {
	model.InitDb()
	userAccount := "1067079973"
	userName, err := model.QueryUserNameByUserAccount(userAccount)
	if err != nil {
		t.Error(err)
	}
	fmt.Println("User Account "+userAccount+"'s Name: ", userName)
}
