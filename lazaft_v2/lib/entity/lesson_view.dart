class LessonView {
  int lessonId;
  String videoAddr;
  String teacherEmail;
  String coverAddr;
  String title;
  String teacherName;
  String teacherAvatarAddr;

  LessonView({
    required this.lessonId,
    required this.videoAddr,
    required this.teacherEmail,
    required this.coverAddr,
    required this.title,
    required this.teacherName,
    required this.teacherAvatarAddr,
  });

  factory LessonView.fromJson(Map<String, dynamic> json) {
    return LessonView(
      lessonId: json['lessonId'],
      videoAddr: json['videoAddr'],
      teacherEmail: json['teacherEmail'],
      coverAddr: json['coverAddr'],
      title: json['title'],
      teacherName: json['teacherName'],
      teacherAvatarAddr: json['teacherAvatarAddr'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lessonId'] = this.lessonId;
    data['videoAddr'] = this.videoAddr;
    data['teacherEmail'] = this.teacherEmail;
    data['coverAddr'] = this.coverAddr;
    data['title'] = this.title;
    data['teacherName'] = this.teacherName;
    data['teacherAvatarAddr'] = this.teacherAvatarAddr;
    return data;
  }

}