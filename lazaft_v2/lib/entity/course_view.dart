import 'package:lazaft_v2/entity/summaries/lesson_summary.dart';

class CourseView {
  int courseId;
  String title;
  int totalDurationMinutes;
  int totalLessons;
  bool isSubscribed;
  int price;

  List<LessonSummary> lessons;

  CourseView.noParm({
    this.courseId = -1,
    this.title = '',
    this.totalDurationMinutes = -1,
    this.totalLessons = -1,
    this.isSubscribed = false,
    this.price = -1,
    this.lessons = const [],
  });

  CourseView({
    required this.courseId,
    required this.title,
    required this.totalDurationMinutes,
    required this.totalLessons,
    required this.isSubscribed,
    required this.price,
    required this.lessons,
  });

  factory CourseView.fromJson(Map<String, dynamic> json) {
    return CourseView(
      courseId: json['courseId'],
      title: json['title'],
      totalDurationMinutes: json['totalDurationMinutes'],
      totalLessons: json['totalLessons'],
      isSubscribed: json['isSubscribed'],
      price: json['price'],

      // 当 lessons 为空时，返回空数组
      lessons: json['lessons'] == null
          ? []
          : json['lessons']
              .map<LessonSummary>((lesson) => LessonSummary.fromJson(lesson))
              .toList(),
    );
  }

  @override
  String toString() {
    return 'CourseView{courseId: $courseId, title: $title, totalDurationMinutes: $totalDurationMinutes, totalLessons: $totalLessons, isSubscribed: $isSubscribed, price: $price, lessons: $lessons}';
  }
}
