import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';

class ShowScreenPage extends StatelessWidget {
  const ShowScreenPage({Key? key}) : super(key: key);
  static const String routeName = '/show_screen';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => UiTools.onBackPressed(context),
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                SvgPicture.asset(
                  'assets/show_screen.svg',
                ),
                SizedBox(height: 20),
                Text(
                  "来和我们一起成为 A+",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "登录以查看更多个性化推荐",
                  style: TextStyle(fontSize: 16, color: Color(0xff636D77)),
                ),
                SizedBox(height: 150),
                MyButton.large(
                  onPress: () {
                    Navigator.pushNamed(context, '/login_screen');
                  },
                  title: "登 录",
                ),
                SizedBox(height: 40),
                GestureDetector(
                  // TODO: Navigator Jump
                  onTap: () {},
                  child: Text("随便看看",
                      style: TextStyle(fontSize: 13, color: Color(0xff5667FD))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

