import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/global/adapt.dart';
import 'package:lazaft_v2/pages/lesson/mobile_video.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key? key}) : super(key: key);
  static const routeName = '/stream_detail';

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late String teacherEmail = '';
  late String coverAddr = '';
  late String title = '';
  late String teacherName = '';
  late String teacherAvatarAddr = '';
  late int lessonId;
  late String? vidoAddr = '';

  _getLessonView() async {
    final prefs = await SharedPreferences.getInstance();
    final myEmail = prefs.getString('email') ?? '';
    final resp = await ApiRequest.getLessonView(lessonId, myEmail);
    if (resp.statusCode == 200) {
      // 将服务器的响应装载成 json
      final res = jsonDecode(resp.body);
      print("resData: ${res['data']}");
      vidoAddr = res['data']['videoAddr'];
      teacherEmail = res['data']['teacherEmail'];
      setState(() {
        teacherName = res['data']['teacherName'];
        teacherAvatarAddr = res['data']['avatarAddr'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 传参规则：
      // lessonId
      // coverAddr 封面
      // title 标题
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      lessonId = arguments['lessonId'];
      setState(() {
        coverAddr = arguments['coverAddr'] ?? '';
        title = arguments['title'];
      });
      _getLessonView();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(" === BUILD LESSON PAGE === ");
    Adapt.initialize(context);
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_ios, size: 20)),
                  SizedBox(width: 7),
                  Text("详细",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            leadingWidth: 200,
            backgroundColor: Theme.of(context).colorScheme.background,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                coverAddr,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stackTrace) =>
                    Image.asset('assets/placeholder.png'),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.pt(22)),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xff5C5C5C),
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    height: 260,
                    // color: Colors.blue,
                    child: vidoAddr == ''
                        ? Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : MobileVideo(videoAddr: vidoAddr),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('讲师：$teacherName',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff5C5C5C),
                              fontWeight: FontWeight.w400)),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: Adapt.pt(35),
                        height: Adapt.pt(35),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              teacherAvatarAddr,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stackTrace) =>
                                  Image.asset('assets/place_user.png'),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
