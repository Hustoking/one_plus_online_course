import 'package:flutter/cupertino.dart';
import 'package:lazaft_v2/entity/summaries/end_course_summary.dart';

import '../entity/summaries/recent_course_summary.dart';

class MyInfoProvider with ChangeNotifier {

  String _nickName = "";
  String get nickName => _nickName;

  String _myAvatarAddr = "";
  String get myAvatarAddr => _myAvatarAddr;

  String _myEmail = "";
  String get myEmail => _myEmail;

  int _coursesCount = -1;
  int get coursesCount => _coursesCount;

  int _likeTeachersCount = -1;
  int get likeTeachersCount => _likeTeachersCount;

  int _coinsCount = -1;
  int get coinsCount => _coinsCount;

  List<RecentCourseSummary> recentCourses = [];
  List<EndCourseSummary> endCourses = [];


  void setCoinsCount(int coinsCount) {
    _coinsCount = coinsCount;
    notifyListeners();
  }

  void setCoursesCount(int coursesCount) {
    _coursesCount = coursesCount;
    notifyListeners();
  }

  void setLikeTeachersCount(int likeTeachersCount) {
    _likeTeachersCount = likeTeachersCount;
    notifyListeners();
  }

  void setStatistics({required int coursesCount, required int likeTeachersCount, required int coinsCount}) {
    _coursesCount = coursesCount;
    _likeTeachersCount = likeTeachersCount;
    _coinsCount = coinsCount;
    notifyListeners();
  }

  // void pullMyInfo()

}