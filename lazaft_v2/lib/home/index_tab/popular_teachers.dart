import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazaft_v2/entity/summaries/teacher_summary.dart';
import 'package:lazaft_v2/pages/teacher/teacher_page.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';

import '../../api/api_request.dart';

class PopularTeachers extends StatefulWidget {
  PopularTeachers({Key? key}) : super(key: key);

  @override
  State<PopularTeachers> createState() => _PopularTeachersState();
}

class _PopularTeachersState extends State<PopularTeachers> {
  List<TeacherSummary> teachers = [];

  _getPopularTeachers() async {
    final resp = await ApiRequest.getPopularTeachers();
    if (resp.statusCode == 200) {
      // 将服务器的响应装载成 json
      final res = jsonDecode(resp.body);
      final teacherss = (res['data'] as List<dynamic>)
          .map((e) => TeacherSummary.fromJson(e))
          .toList();
      print('TeacherS: $teacherss');
      setState(() {
        teachers = teacherss;
      });
    } else {
      // TODO: 加载失败处理
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPopularTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("热门教师",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff364356))),
            GestureDetector(
                // TODO: 点击事件
                onTap: () {
                  UiTools.showCustomDialog(context, "提示", "该按钮正在建设", "");
                },
                child: SvgPicture.asset('assets/filter_icon.svg')),
          ],
        ),
        // Horizontal Scroll Teacher List
        SizedBox(
          height: 176 + 40,
          // color: Colors.blue,
          child: teachers.length == 0
              ? Center(child: Text("教师列表为空~"))
              : OverflowBox(
                  maxWidth: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    scrollDirection: Axis.horizontal,
                    itemCount: teachers.length,
                    // List Render Teacher
                    itemBuilder: (BuildContext context, int index) =>
                        TeacherCard(teacherSummary: teachers[index]),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 10);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class TeacherCard extends StatelessWidget {
  const TeacherCard({
    super.key,
    required this.teacherSummary,
  });

  final TeacherSummary teacherSummary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        // TODO: handle click event
        onTap: () {
          print(" === Teacher Card Clicked === ");
          print(" === Teacher Name: ${teacherSummary.teacherName} ===");
          Navigator.pushNamed(context, TeacherPage.routeName, arguments: {
            "email": teacherSummary.email,
            "teacherName": teacherSummary.teacherName,
            "teacherAvatarAddr": teacherSummary.avatarAddr,
          });
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(126 * 1 / 10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ]),
          width: 126,
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(110 * 1 / 10),
                        child: AspectRatio(
                          aspectRatio: 1/1.08,
                          child: Image.network(
                            teacherSummary.avatarAddr,
                            // width: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stackTrace) =>
                                Image.asset('assets/place_user.png'),
                          ),
                        )),
                  )),
              SizedBox(height: 10),
              Text(teacherSummary.teacherName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff364356))),
              Text(teacherSummary.category,
                  style: TextStyle(fontSize: 12, color: Color(0xff364356))),
            ],
          ),
        ),
      ),
    );
  }
}
