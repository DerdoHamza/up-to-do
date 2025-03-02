import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayers extends StatefulWidget {
  final String url;
  const VideoPlayers({
    super.key,
    required this.url,
  });

  @override
  State<VideoPlayers> createState() => _VideoPlayersState();
}

class _VideoPlayersState extends State<VideoPlayers> {
  late VideoPlayerController controller;
  @override
  void initState() {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : Container(),
      ),
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 1.25),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            });
          },
          child: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}
