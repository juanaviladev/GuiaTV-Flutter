import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String url;

  const VideoPage({Key key, this.url}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  ChewieController _controller;
  VideoPlayerController _lowLevelController;

  @override
  void initState() {
    super.initState();
    _lowLevelController = VideoPlayerController.network(widget.url);
    _controller = ChewieController(
      videoPlayerController: _lowLevelController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      isLive: true,
      fullScreenByDefault: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Chewie(
        controller: _controller,
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _lowLevelController.dispose();
    _controller.dispose();
  }
}
