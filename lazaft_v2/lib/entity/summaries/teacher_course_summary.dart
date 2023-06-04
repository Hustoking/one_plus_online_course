class TeacherCourseSummary {
  final int courseId;
  final String coverAddr;
  final String title;
  final double rating;
  final int ratersCount;
  final String description;

  TeacherCourseSummary(
      {required this.courseId,
      required this.coverAddr,
      required this.title,
      this.rating = 4,
      this.ratersCount = 30,
      required this.description});

  @override
  String toString() {
    return "CourseSummary: {coverAddr: $coverAddr, title: $title, rating: $rating, ratersCount: $ratersCount, description: $description}";
  }

  factory TeacherCourseSummary.fromJson(Map<String, dynamic> json) {
    return TeacherCourseSummary(
      courseId: json['courseId'],
      coverAddr: json['coverAddr'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['verticalCoverAddr'] = this.coverAddr;
    data['title'] = this.title;
    data['rating'] = this.rating;
    data['ratersCount'] = this.ratersCount;
    data['description'] = this.description;
    return data;
  }
}
