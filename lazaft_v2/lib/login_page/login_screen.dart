import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';
import 'package:lazaft_v2/global_widgets/my_input.dart';
import 'package:lazaft_v2/home/home_page.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginFormKey = GlobalKey<FormState>();
  String email = "";
  String pswdMd5 = "";
  bool isLoading = false;

  late SharedPreferences _prefs;

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _saveUserEmail(String email) async {
    await _prefs.setString('email', email);
    debugPrint(_prefs.containsKey('email').toString());
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 注册完成后自动填充邮箱
    // 可选传参 email
    // email = ModalRoute.of(context)!.settings.arguments == null
    //     ? ''
    //     : ModalRoute.of(context)!.settings.arguments as String;

    return WillPopScope(
      onWillPop: () => UiTools.onBackPressed(context),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                SizedBox(height: 70),
                SvgPicture.asset(
                  'assets/login_screen.svg',
                ),
                SizedBox(height: 40),
                Form(
                  key: _loginFormKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("邮箱地址",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff636D77))),
                        SizedBox(height: 10),
                        MyInput.email(
                          onChange: (value) {
                            email = value;
                            debugPrint("email: $email");
                          },
                        ),
                        SizedBox(height: 16),
                        Text("密 码",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff636D77))),
                        SizedBox(height: 10),
                        MyInput.pswd(
                          onChange: (value) {
                            pswdMd5 = value;
                            debugPrint("pswdMd5: $pswdMd5");
                          },
                        ),
                      ]),
                ),
                SizedBox(height: 40),
                MyButton.large(
                  isLoading: isLoading,
                  onPress: () async {
                    await _saveUserEmail(email);
                    debugPrint('_prefs.getString(email): ${_prefs.getString('email')}');
                    debugPrint("=== On Press ===");
                    if (_loginFormKey.currentState?.validate() == true) {
                      _loginFormKey.currentState?.save();
                      // TODO: 发送登录请求
                      // late http.StreamedResponse resp = http.StreamedResponse as http.StreamedResponse;
                      http.StreamedResponse? resp;
                      print('email: $email, pswdMd5: $pswdMd5');
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        print('resp 前');
                        resp = await ApiRequest.loginReq(email, pswdMd5);
                        print('resp后: $resp');
                      } catch (err) {
                        print('err: $err');
                        UiTools.showCustomDialog(context, "提示", "网络错误", "");

                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }

                      if (resp!.statusCode == 200) {
                        // TODO: 保存登录状态
                        await _prefs.setBool('isLoggedIn', true);
                        debugPrint('isLoggedIn: ${_prefs.getBool('isLoggedIn')}');
                        print('登录成功');
                        Navigator.pushNamed(context, HomePage.routeName);
                      } else {
                        var resJson = json.decode(await resp.stream.bytesToString());
                        UiTools.showCustomDialog(context, "提示", "${resJson['msg']}", "");
                      }
                    }
                  },
                  title: "登 录",
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/register_screen', (route) => false);
                  },
                  child: Text.rich(
                    TextSpan(
                        text: "还没有账号？点击 ",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff636D77)),
                        children: [
                          TextSpan(
                            text: "注册",
                            style: TextStyle(color: Color(0xff5667FD)),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
