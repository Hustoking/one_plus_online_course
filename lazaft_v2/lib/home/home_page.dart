import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazaft_v2/global/global_style.dart';
import 'package:lazaft_v2/home/index_tab/index_tab.dart';
import 'package:lazaft_v2/home/my_tab/my_tab.dart';
import 'package:lazaft_v2/home/stream_tab/stream_tab.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'tabs';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<IndexTabState> indexTabScrollKey = GlobalKey();
  GlobalKey<MyTabState> myTabScrollKey = GlobalKey();
  GlobalKey<StreamTabState> streamTabScrollKey = GlobalKey();
  late List<Widget> tabs;

  _HomePageState() {
    tabs = [
      IndexTab(key: indexTabScrollKey),
      StreamTab(key: streamTabScrollKey),
      MyTab(key: myTabScrollKey),
    ];
  }

  int currentIndex = 0;

  onBottomNavTap(int index) {
    print("=== Change Navi: $index ===");
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    } else {
      print("=== 重建页面 ===");
      switch (index) {
        case 0:
          // 向上滚动
          indexTabScrollKey.currentState?.scrollController.animateTo(
            -20,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
          Future.delayed(const Duration(milliseconds: 280), () {
            indexTabScrollKey = GlobalKey();
            setState(() {
              tabs[0] = IndexTab(key: indexTabScrollKey);
            });
          });
          break;
        case 1:
          streamTabScrollKey.currentState?.scrollController.animateTo(
            -20,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
          Future.delayed(const Duration(milliseconds: 280), () {
            streamTabScrollKey = GlobalKey();

            setState(() {
              tabs[1] = StreamTab(key: streamTabScrollKey);
            });
          });

          break;
        case 2:
          myTabScrollKey.currentState?.scrollController.animateTo(
            -20,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
          Future.delayed(const Duration(milliseconds: 230), () {
            myTabScrollKey = GlobalKey();
            setState(() {
              tabs[2] = MyTab(key: myTabScrollKey);
            });
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => UiTools.onBackPressed(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        // body: tabs[currentIndex],
        // ↓ 使用这个会避免反复调用 initState
        body: IndexedStack(
          index: currentIndex,
          children: tabs,
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: currentIndex,
          onChangePage: onBottomNavTap,
        ),
      ),
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar(
      {Key? key, required this.currentIndex, required this.onChangePage})
      : super(key: key);

  final int currentIndex;
  final Function onChangePage;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Color(0xff5667FD);

    final Color unSelectedColor = Color(0xff364356);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      // 使用 Theme 去除水波纹效果
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        // 使 BottomNavigationBar 变高一点，Default: 56
        child: SizedBox(
          height: 60,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: currentIndex,
            onTap: (int index) => onChangePage(index),
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                // 设置颜色
                icon: SvgPicture.asset(
                  'assets/tab1_icon.svg',
                  colorFilter: ColorFilter.mode(
                      currentIndex == 0 ? selectedColor : unSelectedColor,
                      BlendMode.srcIn),
                ),
                label: '课程',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/tab2_icon.svg',
                  colorFilter: ColorFilter.mode(
                      currentIndex == 1 ? selectedColor : unSelectedColor,
                      BlendMode.srcIn),
                ),
                label: '直播',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/tab3_icon.svg',
                  colorFilter: ColorFilter.mode(
                      currentIndex == 2 ? selectedColor : unSelectedColor,
                      BlendMode.srcIn),
                ),
                label: '我的',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
