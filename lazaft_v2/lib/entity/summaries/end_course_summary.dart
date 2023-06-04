class EndCourseSummary {
  final int courseId;
  final String coverAddr;
  final String title;
  final String teacherEmail;
  final String teacherName;
  final int lessonsCount;

  EndCourseSummary(this.courseId, this.coverAddr, this.title, this.teacherName,
      this.lessonsCount, this.teacherEmail);

  EndCourseSummary.noParm({
    this.courseId = 0,
    this.coverAddr = '',
    this.title = '',
    this.teacherName = '',
    this.lessonsCount = 0,
    this.teacherEmail = '',
  });

  @override
  String toString() {
    return 'EndCourseSummary: {courseId: $courseId, coverAddr: $coverAddr, title: $title, teacherName: $teacherName, lessonsCount: $lessonsCount, teacherEmail: $teacherEmail}';
  }

  factory EndCourseSummary.fromJson(Map<String, dynamic> json) {
    return EndCourseSummary(
      json['courseId'],
      json['coverAddr'],
      json['title'],
      json['teacherName'],
      json['lessonsCount'],
      json['teacherEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'coverAddr': coverAddr,
      'title': title,
      'teacherEmail': teacherEmail,
      'teacherName': teacherName,
      'lessonsCount': lessonsCount,
    };
  }
}
