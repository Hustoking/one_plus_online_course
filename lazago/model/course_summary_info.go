package model

type CourseSummaryInfo struct {
	CourseId         int     `gorm:"column:course_id;primaryKey;autoIncrement" json:"courseId"`
	CourseName       string  `gorm:"column:course_name;size:20;not null" json:"courseName"`
	CourseAvatarAddr string  `gorm:"column:course_avatar_addr" json:"courseAvatarAddr"`
	CoursePrice      float64 `gorm:"type:decimal(10,2);column:course_price;not null" json:"coursePrice"`
	Tags             string  `gorm:"type:json;column:tags" json:"tags"`
}

func QueryAllCourseSummary() ([]CourseSummaryInfo, error) {
	var courseSummaryInfos []CourseSummaryInfo
	err := Db.Table("course_tb").Select("course_id, course_name, course_price, tags, course_avatar_addr").Scan(&courseSummaryInfos).Error
	if err != nil {
		return nil, err
	}
	return courseSummaryInfos, nil
}
