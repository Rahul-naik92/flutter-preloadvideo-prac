import 'package:flutter/material.dart';
import 'package:learn_riverpod/page.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PreloadPageView Demo',
      home: VideoPlayerPage(videoUrls: ["urls1"]),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final List<String> videoUrls;

  const VideoPlayerPage({Key? key, required this.videoUrls}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late PreloadPageController _pageController;
  late List<VideoPlayerController> _videoControllers;

  @override
  void initState() {
    super.initState();
    _pageController = PreloadPageController();
    _videoControllers = widget.videoUrls
        .map((url) => VideoPlayerController.network(url))
        .toList();

    _videoControllers.forEach((controller) {
      controller.initialize().then((_) {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PreloadPageView.builder(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          itemCount: widget.videoUrls.length,
          preloadPagesCount: 2,
          itemBuilder: (context, index) {
            final controller = _videoControllers[index];
            return Center(
              child: controller.value.isInitialized
                  ? SizedBox.expand(
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                    )
                  : CircularProgressIndicator(),
            );
          },
          onPageChanged: (index) {
            // Pause all other video controllers except the one that is currently in view
            for (int i = 0; i < _videoControllers.length; i++) {
              if (i == index) {
                _videoControllers[i].play();
              } else {
                _videoControllers[i].pause();
              }
            }
          },
        ),
      ),
    );
  }
}
