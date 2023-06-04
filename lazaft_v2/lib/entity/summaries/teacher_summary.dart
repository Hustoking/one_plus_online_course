class TeacherSummary {
  final String email;
  final String avatarAddr;
  final String teacherName;
  final String category;

  TeacherSummary(
      {required this.email,
      required this.avatarAddr,
      required this.teacherName,
      required this.category});

  @override
  String toString() {
    return "TeacherSummary: {email: $email, avatarAddr: $avatarAddr, teacherName: $teacherName, category: $category}";
  }

  factory TeacherSummary.fromJson(Map<String, dynamic> json) {
    return TeacherSummary(
      email: json['email'],
      avatarAddr: json['avatarAddr'],
      teacherName: json['teacherName'],
      category: json['category'],
    );
  }
}
