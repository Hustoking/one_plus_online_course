class LessonSummary {
  final int lessonId;
  final String title;
  final int durationMinutes;

  LessonSummary({
    required this.lessonId,
    required this.title,
    required this.durationMinutes,
  });

  factory LessonSummary.fromJson(Map<String, dynamic> json) {
    return LessonSummary(
      lessonId: json['lessonId'],
      title: json['title'],
      durationMinutes: json['durationMinutes'],
    );
  }

  @override
  String toString() {
    return 'LessonSummary{lessonId: $lessonId, title: $title, durationMinutes: $durationMinutes}';
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lessonId'] = this.lessonId;
    data['title'] = this.title;
    data['durationMinutes'] = this.durationMinutes;
    return data;
  }

}
