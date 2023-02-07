import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;

  Future<void> setVolume(double volume) async {
    await videoPlayerController.setVolume(volume);
  }


  VideoItems({
    @required this.videoPlayerController,
    @required this.looping , @required this.autoplay,
    Key key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

mixin SystemUiOverlay {
}

class _VideoItemsState extends State<VideoItems> {
   ChewieController _chewieController;

  @override
  void initState() {

    super.initState();

    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio:5/3,
      useRootNavigator: true,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, Internet_Issue) {
        return Center(
          child: Text(
            Internet_Issue,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }
  Color _favIconColor = Colors.white;
  Color _favIconColo = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(8.0) ,
      height: 250,width: 800,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

}