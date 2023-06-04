class PopularCourseSummary {
  final int courseId;
  final String coverAddr;
  final String title;
  final double rating;
  final int ratersCount;
  final String teacherEmail;
  final String teacherName;
  final String description;

  PopularCourseSummary.noParm({
    this.courseId = 0,
    this.coverAddr = '',
    this.title = 'XXX',
    this.rating = 0,
    this.ratersCount = 0,
    this.teacherEmail = '',
    this.teacherName = '',
    this.description = '',
  });

  PopularCourseSummary(
      {required this.coverAddr,
      required this.title,
      this.rating = 4,
      this.ratersCount = 30,
      required this.teacherEmail,
      required this.teacherName,
      required this.description,
      required this.courseId});

  @override
  String toString() {
    return "PopularCourseSummary: {courseId: $courseId, coverAddr: $coverAddr, title: $title, rating: $rating, ratersCount: $ratersCount, teacherName: $teacherName, description: $description}";
  }

  factory PopularCourseSummary.fromJson(Map<String, dynamic> json) {
    return PopularCourseSummary(
      courseId: json['courseId'],
      coverAddr: json['coverAddr'],
      title: json['title'],
      // rating: json['rating'],
      // ratersCount: json['ratersCount'],A
      teacherEmail: json['teacherEmail'],
      teacherName: json['teacherName'],
      description: json['description'],
    );
  }
}
