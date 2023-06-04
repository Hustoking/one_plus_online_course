import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/entity/summaries/popular_course_summary.dart';
import 'package:lazaft_v2/global/adapt.dart';
import 'package:lazaft_v2/global/global_style.dart';
import 'package:lazaft_v2/global_widgets/popular_course_card.dart';
import 'package:lazaft_v2/tools/always_bouncing_scroll_physics.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const routeName = '/search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var courses = <PopularCourseSummary>[];
  late String keyword = "";

  _getCoursesByKeyword() async {
    final resp = await ApiRequest.getCourseByKeyword(keyword);
    if (resp.statusCode == 200) {
      final respJson = jsonDecode(resp.body);
      if (respJson['code'] == 200) {
        for (var item in respJson['data']) {
          final course = PopularCourseSummary.fromJson(item);
          setState(() {
            courses.add(course);
          });
        }
      }
    } else {
      UiTools.showCustomDialog(context, "提示", "网络错误", "");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 传参规则：
      // keyword: String
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      keyword = args['keyword'];
      print("KEYWORD: ");
      print(keyword);
      _getCoursesByKeyword();
    });
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
      backgroundColor: GlobalStyle.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysBouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SizedBox(
                      child: Icon(Icons.arrow_back_ios,
                          color: const Color(0xff3D405B).withOpacity(0.5)))),
              centerTitle: true,
              title: Text("搜索课程",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3D405B).withOpacity(0.9),
                  )),
              backgroundColor: Colors.transparent,
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 10)),
            courses.length == 0
                ? SliverToBoxAdapter(child: Center(child: Text("空空如也")))
                : SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Adapt.pt(20)),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: courses.length,
                          (BuildContext context, int index) {
                        return Column(children: [
                          PopularCourseCard(courseSummary: courses[index]),
                          const SizedBox(height: 20),
                        ]);
                      })),
            )
          ],
        ),
      ),
    );
  }
}
