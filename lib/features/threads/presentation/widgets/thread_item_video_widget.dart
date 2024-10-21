import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_regular_video_widget.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ThreadItemVideoWidget extends StatefulWidget {

  final ThreadModel threadModel;
  const ThreadItemVideoWidget({Key? key, required this.threadModel}) : super(key: key);

  @override
  ThreadItemVideoWidgetController createState() => ThreadItemVideoWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadItemVideoWidgetView extends WidgetView<ThreadItemVideoWidget, ThreadItemVideoWidgetController> {

  const _ThreadItemVideoWidgetView(ThreadItemVideoWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {


    return CustomRegularVideoWidget(
      autoPlay: true, //state.videoIsPlaying,
      loop: true,
      mute: true,
      showDefaultControls: false,
      showCustomVolumeButton: true,
      onTap: () {
         context.push(context.generateRoutePath(subLocation: threadVideoPreviewPage), extra: widget.threadModel);
      },
      tag: widget.threadModel.videoUrl!,
      videoSource: VideoSource.mediaId,
      mediaId: widget.threadModel.videoUrl!, networkUrl: widget.threadModel.videoUrl!,
      fit: BoxFit.contain,
    );
    /// come back to this later
    // return VisibilityDetector(
    //   key: ValueKey('visibilityDetector-thread-${widget.threadModel.id}'),
    //   onVisibilityChanged: state.onVideoVisibilityChange,
    //   child: ,
    // );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadItemVideoWidgetController extends State<ThreadItemVideoWidget> {

  bool videoIsPlaying = false;

  @override
  Widget build(BuildContext context) => _ThreadItemVideoWidgetView(this);

  @override
  void initState() {
    super.initState();
  }

  void onVideoVisibilityChange(visibilityInfo) {
    var visiblePercentage = visibilityInfo.visibleFraction * 100;

    debugPrint('customLog: onVideoVisibilityChange -> Widget ${visibilityInfo.key} is $visiblePercentage% visible');

    if(visiblePercentage > 90.0) {
      if(!videoIsPlaying) {
        setState(() {videoIsPlaying = true;});
        debugPrint("customLog: video -thread-${widget.threadModel.id}: -> is playing now");
      }
    }else{
      if(videoIsPlaying) {
        setState(() {videoIsPlaying = false;});
        debugPrint("customLog: video -thread-${widget.threadModel.id}: ->  stopped playing");
      }
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

}