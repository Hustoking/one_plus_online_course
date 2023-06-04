import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazaft_v2/home/index_tab/my_sliver_appbar.dart';
import 'package:lazaft_v2/home/index_tab/popular_courses.dart';
import 'package:lazaft_v2/home/index_tab/popular_teachers.dart';
import 'package:lazaft_v2/pages/search/search_page.dart';
import 'package:lazaft_v2/tools/always_bouncing_scroll_physics.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';

class IndexTab extends StatefulWidget {
  const IndexTab({Key? key}) : super(key: key);

  @override
  State<IndexTab> createState() => IndexTabState();
}

class IndexTabState extends State<IndexTab> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    debugPrint(' === IndexTab InitState ===');
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  final scrollController = ScrollController();

  String keyword = "";

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      // 加上手势处理，在点击空白处时 input 失焦
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: CustomScrollView(
            controller: scrollController,
            physics: const AlwaysBouncingScrollPhysics(),
            slivers: [
              MySilverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  // 在这里设置 padding，是为了让 TextFiled 的阴影遮住圆角
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 0),
                  child: Column(
                    children: [
                      // Search Row
                      Row(
                        children: [
                          // Input Box
                          Expanded(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular((42 + 12) * 2 / 10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              // 使左边的字距输入框更远点
                              padding: EdgeInsets.fromLTRB(16, 6, 10, 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onChanged: (value) {
                                        keyword = value;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "查找老师/课程",
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff636D77)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10), // 添加一个间隔
                                  Container(
                                    height: 42,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              42 * 2 / 10),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            // TODO:
                                            Navigator.pushNamed(context, SearchPage.routeName, arguments: {
                                              'keyword': keyword,
                                            });
                                          },
                                          child: Icon(Icons.search,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 18),
                          // Option Button
                          GestureDetector(
                              onTap: () {
                                UiTools.showCustomDialog(
                                    context, "提示", "该按钮正在建设中", "");
                              },
                              child:
                                  SvgPicture.asset('assets/option_button.svg')),
                        ],
                      ),
                      SizedBox(height: 30),
                      PopularTeachers(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("热门课程",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff364356))),
                          GestureDetector(
                              // TODO: 点击事件
                              onTap: () {
                                UiTools.showCustomDialog(
                                    context, "提示", "该按钮正在建设中", "");
                              },
                              child:
                                  SvgPicture.asset('assets/filter_icon.svg')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  sliver: PopularCourses()),
            ],
          ),
        ),
      ),
    );
  }
}

