package model

type UserLikeCourse struct {
	UserAccount string `gorm:"primaryKey"`
	CourseId    int    `gorm:"primaryKey"`
}

func (UserLikeCourse) TableName() string {
	return "user_like_course_tb"
}

func InsertLikeCourse(userLikeCourse *UserLikeCourse) error {
	err := Db.Create(&userLikeCourse).Error
	if err != nil {
		return err
	}
	return nil
}

func DeleteLikeItem() {}

func QueryLikesCountByCourseId(courseId int) int {
	var count int64
	Db.Model(&UserLikeCourse{}).Where("course_id = ?", courseId).Count(&count)
	return int(count)
}
