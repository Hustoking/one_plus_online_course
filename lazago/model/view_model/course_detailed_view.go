package view_model

import "lazago/model"

type CourseDetailedView struct {
	CourseId          int    `json:"courseId"`
	CourseName        string `json:"courseName"`
	CourseDescription string `json:"courseDescription"`

	TeacherAccount    string `json:"teacherAccount"`
	TeacherAvatarAddr string `json:"teacherAvatarAddr"`
	TeacherName       string `json:"teacherName"`

	CommentsCount int `json:"commentsCount"`
	LikesCount    int `json:"likesCount"`
	BadgesCount   int `json:"badgesCount"`
}

func QueryCourseDetailedView(courseId int) (CourseDetailedView, error) {
	var courseDetailedView CourseDetailedView
	err := model.Db.Table("course_tb").Select("course_tb.course_id, course_tb.course_name, course_tb.course_description, teacher_tb.teacher_account, teacher_tb.teacher_avatar_addr, teacher_tb.teacher_name").
		Joins("left join teacher_tb on course_tb.teacher_account = teacher_tb.teacher_account").
		Where("course_id = ?", courseId).First(&courseDetailedView).Error
	if err != nil {
		return courseDetailedView, err
	}
	return courseDetailedView, nil
}
