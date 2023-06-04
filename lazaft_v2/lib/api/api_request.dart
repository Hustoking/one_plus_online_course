import 'dart:async';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiRequest {
  // 注册
  static Future<http.StreamedResponse> registerReq(
      nickName, email, pswdMd5) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiConfig.BASE_URL}api/register'));
    request.fields['nickName'] = nickName;
    request.fields['email'] = email;
    request.fields['pswdMd5'] = pswdMd5;
    final response = await request.send();

    return response;
  }

  static Future<http.StreamedResponse> verifyReq(
      String email, String verifyCode) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiConfig.BASE_URL}api/register_auth'));
    request.fields['email'] = email;
    request.fields['verifyCode'] = verifyCode;

    final response = await request.send();
    return response;
  }

  static Future<http.StreamedResponse> loginReq(
      String email, String pswdMd5) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiConfig.BASE_URL}api/login'));
    request.fields['email'] = email;
    request.fields['pswdMd5'] = pswdMd5;

    final response = await request.send();
    return response;
  }

  static Future<http.StreamedResponse> getMySummaryReq(String email) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiConfig.BASE_URL}api/get_my_summary'));
    request.fields['email'] = email;

    final response = await request.send();
    return response;
  }

  static Future<http.Response> getPopularTeachers() async {
    var request =
        http.post(Uri.parse('${ApiConfig.BASE_URL}api/get_popular_teachers'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getPopularCourses() async {
    var request =
        http.post(Uri.parse('${ApiConfig.BASE_URL}api/get_popular_courses'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getTeacherView(String userEmail, String teacherEmail) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/get_teacher_view' + '?user_email=$userEmail' + '&teacher_email=$teacherEmail'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getTeacherCourses(String email) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/get_teacher_courses' + '?email=$email'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getCourseInfo(String email, int courseId) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/get_course_info' +
            '?email=$email' +
            '&course_id=$courseId'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getLessonView(
      int lessonId, String userEmail) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/get_lesson_view?lesson_id=$lessonId' +
            '&user_email=$userEmail'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getMyTabView(String email) async {
    var request = http.post(
        Uri.parse('${ApiConfig.BASE_URL}api/get_my_tab_view?email=$email'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getStreams() async {
    var request = http.post(Uri.parse('${ApiConfig.BASE_URL}api/get_streams'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getStreamView(int streamId) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/get_stream_view?stream_id=$streamId'));

    final response = await request;
    return response;
  }

  static Future<http.Response> buyCourse(int streamId, String email) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/buy_course?course_id=$streamId' +
            '&email=$email'));

    final response = await request;
    return response;
  }

  static Future<http.StreamedResponse> updateProfile(
      String email, String userName, String filePath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiConfig.BASE_URL}api/update_profile'));
    request.fields['userEmail'] = email;
    request.fields['userName'] = userName;
    if (filePath != '') {
      var file = await http.MultipartFile.fromPath('file', filePath);
      request.files.add(file);
    }

    final response = await request.send();
    return response;
  }

  static Future<http.Response> getMyCourses(String email) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/get_my_courses?email=$email'));

    final response = await request;
    return response;
  }

  static Future<http.Response> likeTeacher(String userEmail, String teacherEmail) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/like_teacher' +
            '?user_email=$userEmail' +
            '&teacher_email=$teacherEmail'));

    final response = await request;
    return response;
  }

  static Future<http.Response> dislikeTeacher(String userEmail, String teacherEmail) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/dislike_teacher' +
            '?user_email=$userEmail' +
            '&teacher_email=$teacherEmail'));

    final response = await request;
    return response;
  }

  static Future<http.Response> unsubscribeCourse(String userEmail, int courseId) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/unsubscribe_course' +
            '?user_email=$userEmail' +
            '&course_id=$courseId'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getLikeTeachers(String userEmail) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/get_like_teachers?user_email=$userEmail'));

    final response = await request;
    return response;
  }

  static Future<http.Response> getCourseByKeyword(String keyword) async {
    var request = http.post(Uri.parse(
        '${ApiConfig.BASE_URL}api/get_course_by_keyword?keyword=$keyword'));

    final response = await request;
    return response;
  }
}
