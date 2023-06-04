import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/entity/stream_view.dart';
import 'package:lazaft_v2/global/adapt.dart';

import '../lesson/mobile_video.dart';

class StreamPage extends StatefulWidget {
  const StreamPage({Key? key}) : super(key: key);
  static const routeName = '/stream_page';

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  StreamView streamView = StreamView.noParm();
  late String title = '';
  late String coverAddr = '';

  _getStreamView(int streamId) async {
    final resp = await ApiRequest.getStreamView(streamId);
    // TODO: handle error
    if (resp.statusCode == 200) {
      // 将服务器的响应装载成 json
      final res = jsonDecode(resp.body);
      print("resData: ${res['data']}");
      final _streamView = StreamView.fromJson(res['data']);
      setState(() {
        streamView = _streamView;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 传参规则：
      // streamId: 课程id
      // coverAddr: 封面
      // title: 直播标题
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      setState(() {
        streamView.streamId = args['streamId'];
        coverAddr = args['coverAddr'];
        title = args['title'];
      });

      _getStreamView(streamView.streamId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(" === BUILD STREAM PAGE === ");
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
                  Text("直播",
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
                    child: streamView.streamAddr == ''
                        ? Center(
                      child: CupertinoActivityIndicator(),
                    )
                    // TODO: change
                        : MobileVideo(videoAddr: streamView.streamAddr),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('讲师：${streamView.teacherName}',
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
                              streamView.avatarAddr,
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
