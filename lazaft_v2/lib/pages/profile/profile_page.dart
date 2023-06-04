import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/global/adapt.dart';
import 'package:lazaft_v2/global/global_style.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';
import 'package:lazaft_v2/global_widgets/my_input.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String routeName = "/profile";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  late String avatarAddr = "";
  late String myEmail = "";
  late String myName = "";
  bool isButtonLoading = false;

  Future _pickImage() async {
    print("trigger the _pickImage");
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    setState(() {
      image = File(img.path);
    });
    print("成功");
    print(image);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 获取路由参数
      // courseId, title, coverAddr
      final route = ModalRoute.of(context);
      if (route != null) {
        final args = route.settings.arguments as Map<String, dynamic>;
        setState(() {
          myEmail = args['email'];
          avatarAddr = args['myAvatarAddr'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
      // backgroundColor: GlobalStyle.MY_TAB_COLOR,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    Container(
                      height: GlobalStyle.MY_TAB_APP_BAR_HEIGHT,
                      color: GlobalStyle.MY_TAB_COLOR,
                    ),
                    Container(
                      height: 80,
                      color: Colors.transparent,
                    ),
                  ],
                ),
                Positioned(
                  top: 170 - 120 / 2,
                  child: Stack(
                    children: [
                      Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(100)),
                          padding: const EdgeInsets.all(6),
                          child: GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: image == null
                                    ? Image.network(
                                        avatarAddr,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, err, stackTrace) =>
                                            Image.asset(
                                                'assets/place_user.png'),
                                      )
                                    : Image.file(image!, fit: BoxFit.cover)),
                          )),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                width: 38,
                                height: 38,
                                color: Color(0xffABB3FE),
                                child: SvgPicture.asset(
                                  'assets/choose.svg',
                                  fit: BoxFit.scaleDown,
                                ),
                              )))
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adapt.pt(32)),
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff636D77)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("邮箱"),
                    const SizedBox(height: 10),
                    MyInput.email(enable: false, hintText: "1067079973@qq.com"),
                    const SizedBox(height: 10),
                    Text("呢称"),
                    const SizedBox(height: 10),
                    MyInput.nickName(
                      onChange: (value) {
                        myName = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: MyButton.large(
                        isLoading: isButtonLoading,
                        title: "确认修改",
                        onPress: () async {
                          if (myName == "" && image == null) {
                            UiTools.showCustomDialog(
                                context, "警告", "没有要修改的内容哦~", "");
                            return;
                          }
                          print("发送请求");
                          try {
                            setState(() {
                              isButtonLoading = true;
                            });
                            late String imagePath;
                            if (image == null) {
                              imagePath = '';
                            } else {
                              imagePath = image!.path;
                            }
                            final resp = await ApiRequest.updateProfile(
                                myEmail, myName, imagePath);
                            print(resp.statusCode);
                            if (resp.statusCode == 200) {
                              UiTools.showCustomDialog(
                                  context, "提示", "修改成功", "");
                            } else {
                              UiTools.showCustomDialog(
                                  context, "警告", "修改失败", "");
                            }
                          } catch (err) {
                            UiTools.showCustomDialog(context, "警告", "网络错误", "");
                          } finally {
                            setState(() {
                              isButtonLoading = false;
                            });
                          }

                          // 解析响应内容并输出
                          // if (response.statusCode == 200) {
                          //   print('Upload successful!');
                          //   print(await response.stream.bytesToString());
                          // } else {
                          //   print('Upload failed with status ${response
                          //       .statusCode}');
                          // }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
