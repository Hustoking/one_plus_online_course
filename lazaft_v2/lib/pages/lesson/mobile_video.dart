import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MobileVideo extends StatefulWidget {
  const MobileVideo({Key? key, required this.videoAddr}) : super(key: key);

  final String? videoAddr;

  @override
  State<MobileVideo> createState() => _MobileVideoState();
}

class _MobileVideoState extends State<MobileVideo> {
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(Uri.parse(
          // 'https://live.bilibili.com/6?hotRank=0&session_id=e21b44736d4101badf8c53e6b4ff07f5_017319D8-053B-4B97-98E0-C68B15E768DA&launch_id=1000268&live_from=78002&visit_id=2k1of443nbq0'))
          // 'https://player.bilibili.com/player.html?aid=414992811&bvid=BV1wV411y7jF&cid=244481480&page=1'))
          '${widget.videoAddr}'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..goBack()
      ..goForward();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    debugPrint(
        '======================= DidChangeDependencies MY_TAB =======================');
  }

  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    // if (Platform.isAndroid || Platform.isIOS) {
    return SafeArea(
      child: WebViewWidget(controller: controller),
    );
  }
}
