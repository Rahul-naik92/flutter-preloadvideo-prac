import 'package:flutter/material.dart';
import 'package:learn_riverpod/feed_controller.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  const PlayerController({super.key});
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
    return ChangeNotifierProvider(
      create: (_) => FeedController(),
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
  const FeedItem({super.key, required this.url});

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  // Player controller
  late VideoPlayerController _controller;

  bool initialized = false;

  @override
  void initState() {
    super.initState();
    initializePlayer(widget.url);
  }

  // Initialize Video Player
  void initializePlayer(String url) async {
    _controller = await context.read<FeedController>().addController(url);

    if (mounted) {
      setState(() {
        initialized = true;
        _controller.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized)
      return const Center(child: CircularProgressIndicator.adaptive());
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
