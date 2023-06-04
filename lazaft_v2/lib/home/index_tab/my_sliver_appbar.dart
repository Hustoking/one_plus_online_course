import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySilverAppBar extends StatefulWidget {
  const MySilverAppBar({
    super.key,
  });

  @override
  State<MySilverAppBar> createState() => _MySilverAppBarState();
}

class _MySilverAppBarState extends State<MySilverAppBar> {
  late SharedPreferences _prefs;
  String _email = "";

  // 默认占位图
  // String myAvatarAddr = '${ApiConfig.IMAGE_URL}place_user.png';
  late String myAvatarAddr = "";
  String myNickName = "";

  Future<void> _loadEmail() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('_prefs.getString(email): ${_prefs.getString('email')}');
    setState(() {
      _email = _prefs.getString('email') ?? '';
    });
  }

  _getUserInfo() async {
    debugPrint(" === _getUserInfo === ");
    await _loadEmail();
    final resp = await ApiRequest.getMySummaryReq(_email);

    if (resp.statusCode == 200) {
      var res = jsonDecode(await resp.stream.bytesToString());
      var data = res['data'];
      debugPrint('res.data: $data');
      // TODO: 4-22 未解决
      // 出现 error
      // 异步错误
      // 数据未初始化
      // 不知道这个 mounted 有什么用，又不敢删
      // if (mounted) {
      await _prefs.setString("myAvatarAddr", data['avatarAddr']);
      await _prefs.setString("myNickName", data['nickName']);
      setState(() {
        myAvatarAddr = data['avatarAddr'];
        myNickName = data['nickName'];
      });
      // }
      debugPrint('res.data.avatarAddr: $myAvatarAddr');
      debugPrint('res.data.nickName: $myNickName');
      return data;
    } else {
      // TODO: error handle
      debugPrint('resp.statusCode: ${resp.statusCode}');
    }
    return "";
  }

  @override
  void initState() {
    debugPrint(' === MySilverAppBar initState === ');
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // ↓ 删除左上角的返回按钮
      leading: const SizedBox(),
      backgroundColor: Theme.of(context).colorScheme.background,
      stretch: true,
      expandedHeight: 142,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("晚上好！",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff364356))),
                  Text(myNickName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff636D77))),
                ],
              ),
              // 双圆角
              SizedBox(
                height: 62,
                width: 62,
                child: ClipRRect(
                  // 20% 圆角
                  borderRadius: BorderRadius.circular(62 * 2 / 10),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular((62 - 10) * 2 / 10),
                            child: Image.network(
                              myAvatarAddr,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stackTrace) =>
                                  Image.asset('assets/place_user.png'),
                            ))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
