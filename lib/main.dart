import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wikolo',
      home: PlayerController(),

      //  VideoReelsWidget(videoUrls: [
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/4_461f6b13fd.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/1_9afae56794.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/2_48617b2f56.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/3_e119eeccbd.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/5_e16b9681d8.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/6_a3b5dc8442.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/7_d3571f5ad7.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/8_a4d0e1df61.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/9_d92e917519.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/10_41581ba49f.mp4",
      //   "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/11_a08cdfd856.mp4",
      // ]),
    );
  }
}

class PlayerController extends StatefulWidget {
  const PlayerController({Key? key}) : super(key: key);
  @override
  State<PlayerController> createState() => _PlayerControllerState();
}

class _PlayerControllerState extends State<PlayerController> {
  //properties

  //to check which index is currently played
  int currentIndex = 0;

  //static content
  final List<String> urls = const [
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/4_461f6b13fd.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/1_9afae56794.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/2_48617b2f56.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/3_e119eeccbd.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/5_e16b9681d8.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/6_a3b5dc8442.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/7_d3571f5ad7.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/8_a4d0e1df61.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/9_d92e917519.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/10_41581ba49f.mp4",
    "https://livepin-admin-bucket.s3.ap-south-1.amazonaws.com/11_a08cdfd856.mp4",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: urls.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (ctx, index) {
          return FeedItem(url: urls[index]);
        },
      ),
    );
  }
}

class FeedItem extends StatefulWidget {
  // Url to play video
  final String url;
  const FeedItem({Key? key, required this.url}) : super(key: key);

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  // Player controller
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize player
    initializePlayer(widget.url);
  }

  // Initialize Video Player
  void initializePlayer(String url) async {
    final fileInfo = await checkCacheFor(url);
    if (fileInfo == null) {
      _controller = VideoPlayerController.network(url);
    } else {
      _controller = VideoPlayerController.file(fileInfo.file);
    }

    await _controller.initialize();
    if (mounted) {
      setState(() {
        _controller.play();
      });
    }
  }

  // Check for cache
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  // Dispose controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
