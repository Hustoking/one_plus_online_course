import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';
import 'package:lazaft_v2/global_widgets/my_input.dart';
import 'package:lazaft_v2/login_page/verify_screen.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String routeName = '/register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  late String _nickName;
  late String _email;
  String _pswd = "(";

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    // 防止退出
    return WillPopScope(
      onWillPop: () => UiTools.onBackPressed(context),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: DefaultTextStyle(
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff636D77)),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/register_screen.svg',
                ),
                Form(
                  key: _registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("昵 称"),
                      const SizedBox(height: 10),
                      MyInput.nickName(
                        onSave: (value) {
                          _nickName = value;
                          debugPrint("_nickName: $_nickName");
                        },
                      ),
                      const SizedBox(height: 10),
                      Text("邮箱地址"),
                      SizedBox(height: 10),
                      MyInput.email(
                        onSave: (value) {
                          _email = value;
                          debugPrint("_email: $_email");
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text("密 码"),
                      const SizedBox(height: 10),
                      MyInput.pswd(
                        // 因为要进行两次密码的比较，所以要使用 onChange
                        onChange: (value) {
                          _pswd = value;
                          debugPrint("_pswd: $_pswd");
                        },
                      ),
                      const SizedBox(height: 10),
                      Text("确认密码"),
                      SizedBox(height: 10),
                      MyInput.checkPswd(
                        validator: (value) {
                          if (value != _pswd) {
                            return "两次密码不一致";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                MyButton.large(
                  isLoading: isLoading,
                  onPress: () async {
                    debugPrint('isLoading: $isLoading');
                    debugPrint("=== On Press ===");
                    if (_registerFormKey.currentState?.validate() == true) {
                      _registerFormKey.currentState?.save();
                      // TODO: 发送注册请求
                      // Navigator.pushNamed(context, '/register_screen');
                      late http.StreamedResponse resp;
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        resp = await ApiRequest.registerReq(
                            _nickName, _email, _pswd);
                      } catch (err) {
                        UiTools.showCustomDialog(context, "警告", "网络异常", "");
                        debugPrint(err.toString());
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }


                      if (resp.statusCode == 200) {
                        debugPrint("成功发送注册请求");
                        Navigator.pushNamed(context, VerifyScreen.routeName, arguments: _email);
                      } else {
                        var resJson = json.decode(await resp.stream.bytesToString());
                        UiTools.showCustomDialog(context, "提示", "${resJson['msg']}", "");
                      }
                    }
                  },
                  title: "注 册",
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login_screen', (route) => false);
                  },
                  child: const Text.rich(
                    TextSpan(
                        text: "已经有账号了？点击 ",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Color(0xff636D77)),
                        children: [
                          TextSpan(
                            text: "登录",
                            style: TextStyle(color: Color(0xff5667FD)),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
