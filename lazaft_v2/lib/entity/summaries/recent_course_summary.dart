class RecentCourseSummary {
  final int courseId;
  final String coverAddr;
  final String title;
  final String teacherEmail;
  final String teacherName;
  final int learnedCount;
  final int lessonsCount;

  RecentCourseSummary(this.courseId, this.coverAddr, this.title,
      this.teacherName, this.learnedCount, this.lessonsCount, this.teacherEmail);

  RecentCourseSummary.noParm({
    this.courseId = 0,
    this.coverAddr = '',
    this.title = '',
    this.teacherName = '',
    this.learnedCount = 0,
    this.lessonsCount = 0,
    this.teacherEmail = '',
  });

  @override
  String toString() {
    return 'RecentCourseSummary: {courseId: $courseId, coverAddr: $coverAddr, title: $title, teacherName: $teacherName, learnedCount: $learnedCount, lessonsCount: $lessonsCount, teacherEmail: $teacherEmail}';
  }

  factory RecentCourseSummary.fromJson(Map<String, dynamic> json) {
    return RecentCourseSummary(
      json['courseId'],
      json['coverAddr'],
      json['title'],
      json['teacherName'],
      json['learnedCount'],
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
      'learnedCount': learnedCount,
      'lessonsCount': lessonsCount,
    };
  }
}





