import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class FeedController extends ChangeNotifier {
  final Map<String, VideoPlayerController> _controllers = {};

  String? _currentUrl;

  /// Adds a new [VideoPlayerController] for the given [url]
  Future<VideoPlayerController> addController(String url) async {
    if (_currentUrl != url) {
      final currentController = _controllers[_currentUrl];
      if (currentController != null) {
        await currentController.pause();
      }
      _currentUrl = url;
    }
    if (_controllers.containsKey(url)) {
      return _controllers[url]!;
    }
    final fileInfo = await checkCacheFor(url);
    VideoPlayerController controller;
    if (fileInfo == null) {
      controller = VideoPlayerController.networkUrl(Uri.parse(url));
    } else {
      controller = VideoPlayerController.file(fileInfo.file);
    }
    await controller.initialize();

    // make sure there's only 10 controllers in memory, otherwise delete the oldest one
    if (_controllers.length >= 10) {
      final oldestController = _controllers.values.first;
      await oldestController.dispose();
      _controllers.remove(_controllers.keys.first);
    }

    _controllers[url] = controller;

    return _controllers[url]!;
  }

  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
