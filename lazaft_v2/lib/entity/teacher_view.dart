import 'package:lazaft_v2/api/api_config.dart';

class TeacherView {
  String email;
  String teacherName;
  String avatarAddr;
  String description;
  int teachingDuration;
  int courseCount;
  int followerCount;
  bool isFollowed;

  TeacherView.noParm({
    this.email = '',
    this.teacherName = '',
    this.avatarAddr = '${ApiConfig.IMAGE_URL}place_user.png',
    this.description = '......',
    this.teachingDuration = -1,
    this.courseCount = -1,
    this.followerCount = -1,
    this.isFollowed = false,
  });

  TeacherView({
    required this.email,
    required this.teacherName,
    required this.avatarAddr,
    required this.description,
    required this.teachingDuration,
    required this.courseCount,
    required this.followerCount,
    required this.isFollowed,
  });

  factory TeacherView.fromJson(Map<String, dynamic> json) {
    return TeacherView(
      email: json['email'],
      teacherName: json['teacherName'],
      avatarAddr: json['avatarAddr'],
      description: json['description'],
      teachingDuration: json['teachingDuration'],
      courseCount: json['courseCount'],
      followerCount: json['followerCount'],
      isFollowed: json['isFollowed'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['teacherName'] = this.teacherName;
    data['avatarAddr'] = this.avatarAddr;
    data['description'] = this.description;
    data['teachingDuration'] = this.teachingDuration;
    data['courseCount'] = this.courseCount;
    data['followerCount'] = this.followerCount;
    data['isFollowed'] = this.isFollowed;
    return data;
  }
}
