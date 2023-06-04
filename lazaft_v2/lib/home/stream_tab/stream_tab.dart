import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazaft_v2/api/api_config.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/entity/summaries/stream_summary.dart';
import 'package:lazaft_v2/pages/stream/stream_page.dart';

class StreamTab extends StatefulWidget {
  const StreamTab({Key? key}) : super(key: key);

  @override
  State<StreamTab> createState() => StreamTabState();
}

class StreamTabState extends State<StreamTab> {
  late List<StreamSummary> streamSummaries = [];

  final scrollController = ScrollController();

  _getSteams() async {
    final resp = await ApiRequest.getStreams();
    // TODO: handle error
    if (resp.statusCode == 200) {
      final res = jsonDecode(resp.body);
      print(" === STREAM TAB === ");
      print("resData: ${res['data']}");
      final data = res['data'];
      setState(() {
        streamSummaries = List<StreamSummary>.from(
          data.map((json) => StreamSummary.fromJson(json)),
        );
      });
      print("streamSummaries: ${streamSummaries}");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getSteams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      '${ApiConfig.IMAGE_URL}stream_header.png',
                      errorBuilder: (ctx, err, stackTrace) =>
                          Image.asset('assets/placeholder.png', height: 140),
                    )),
                const SizedBox(height: 24),
                const Text("正在直播",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff120D26))),
                const SizedBox(height: 10),
              ])),
              streamSummaries.isEmpty
                  ? SliverToBoxAdapter(child: Center(child: Text("还没有直播哟~")))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                      return StreamCard(streamSummary: streamSummaries[index]);
                    }, childCount: streamSummaries.length)),
            ],
          ),
        ),
      ),
    );
  }
}

class StreamCard extends StatelessWidget {
  const StreamCard({
    super.key,
    required this.streamSummary,
  });

  final StreamSummary streamSummary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: Add onTap
      onTap: () {
        debugPrint('You tap StreamCard');
        Navigator.pushNamed(context, StreamPage.routeName, arguments: {
          'streamId': streamSummary.streamId,
          'coverAddr': streamSummary.coverAddr,
          'title': streamSummary.title,
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ClipRRect(
            // 不能直接给 Container 加圆角，否则内部的 Image 不会被裁剪
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              height: 246,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    streamSummary.coverAddr,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stackTrace) => Center(
                        child:
                            Image.asset('assets/placeholder.png', height: 150)),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(streamSummary.title,
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color(0xff474747))),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xffFFF5C0),
                              ),
                              child: Text(streamSummary.teacherName,
                                  style: TextStyle(
                                      color: Color(0xff033773),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              padding: const EdgeInsets.fromLTRB(7, 6, 6, 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: Color(0xff225A9A),
                              ),
                              child: SvgPicture.asset('assets/right_arrow.svg'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
