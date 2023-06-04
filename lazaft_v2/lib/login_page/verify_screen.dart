import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';
import 'package:lazaft_v2/global_widgets/my_input.dart';
import 'package:lazaft_v2/login_page/login_screen.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';
import 'package:http/http.dart' as http;

import '../api/api_request.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);
  static const String routeName = '/verify_screen';

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {

  bool isLoading = false;
  String verifyCode = "";

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    return WillPopScope(
      onWillPop: () => UiTools.onBackPressed(context),
      child: Scaffold(
          body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/register_screen.svg',
            ),
            Text("验证码已发送至邮箱：",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff636D77).withOpacity(0.6))),
            const SizedBox(height: 8),
            Text(email,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff636D77).withOpacity(0.6))),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "验证码",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff636D77)),
              ),
            ),
            const SizedBox(height: 10),
            MyInput.email(
              hintText: '请输入验证码',
              onChange: (value) {
                verifyCode = value;
                debugPrint("verifyCode: $verifyCode");
              },
            ),
            const SizedBox(height: 20),
            MyButton.large(
              onPress: () async {
                if (verifyCode.isEmpty) {
                  UiTools.showCustomDialog(context, "提示", "验证码不能为空", "");
                  return;
                }
                if (verifyCode.length < 5) {
                  UiTools.showCustomDialog(context, "提示", "验证码错误", "");
                  return;
                }
                late http.StreamedResponse resp;
                try {
                  setState(() {
                    isLoading = true;
                  });
                  resp = await ApiRequest.verifyReq(email, verifyCode);
                } catch (err) {
                  debugPrint("err: $err");
                  UiTools.showCustomDialog(context, "提示", "网络错误", "");
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }

                if (resp.statusCode == 200) {
                  Navigator.pushNamed(context, LoginScreen.routeName, arguments: email);
                } else {
                  var resJson = json.decode(await resp.stream.bytesToString());
                  UiTools.showCustomDialog(context, "提示", "${resJson['msg']}", "");
                }
              },
              title: "确 定",
            )
          ],
        ),
      )),
    );
  }
}
