import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_play_icon.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePreviewPage extends StatefulWidget {

  final String url;
  const YoutubePreviewPage({Key? key,  required this.url}) : super(key: key);

  @override
  YoutubePreviewPageController createState() => YoutubePreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _YoutubePreviewPageView extends WidgetView<YoutubePreviewPage, YoutubePreviewPageController> {

  const _YoutubePreviewPageView(YoutubePreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        state._youtubePlayerController?.toggleFullScreenMode();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: kAppWhite),
          ),
          extendBodyBehindAppBar: true,
          body: OrientationBuilder(
            builder: (ctx, Orientation orientation) {

              final screen = MediaQuery.of(ctx);
              final screenHeight = screen.size.height;
              final screenWidth = screen.size.width;

              return AspectRatio(
                aspectRatio: screenWidth > screenHeight ? screen.size.width / screen.size.height : screen.size.height / screen.size.width,
                child: YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: state._youtubePlayerController!,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      RemainingDuration(),
                      const SizedBox(width: 20,),
                      ProgressBar(isExpanded: true),
                      const SizedBox(width: 20,),
                      CurrentPosition(),
                      const SizedBox(width: 20,),
                      const PlaybackSpeedButton(),
                      const SizedBox(width: 20,),
                      // PlayPauseButton()
                    ],
                    aspectRatio: screenWidth > screenHeight ? screen.size.width / screen.size.height : screen.size.height / screen.size.width,
                    // thumbnail: widget.thumbNailImageUrl != null ? _thumbnailImage(widget.thumbNailImageUrl, VideoType.youtube) : null,
                    actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                    onReady: () {
                      state.youtubeVideoReady.value = true;
                    },
                    onEnded: (data) {
                      state.youtubeVideoReady.value = false;
                    },
                  ),
                  builder: (ctx, player) {
                    return player;
                  },
                ),
              );
            }
          )
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class YoutubePreviewPageController extends State<YoutubePreviewPage> {

  late String? videoId;
  late YoutubePlayerController? _youtubePlayerController;
  final ValueNotifier<bool> youtubeVideoReady = ValueNotifier(false);
  late Brightness originalThemeBrightness;

  @override
  Widget build(BuildContext context) => _YoutubePreviewPageView(this);

  @override
  void initState() {
    super.initState();

    videoId = YoutubePlayer.convertUrlToId(widget.url);

    //for youtube videos
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId ?? "",

      flags:  const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: false,
        showLiveFullscreenButton: false,
        // showLiveFullscreenButton: true,
      ),

    );

    onWidgetBindingComplete(onComplete: () {
      originalThemeBrightness = Theme.of(context).brightness;
    });

    enableFullScreen();
    _youtubePlayerController?.toggleFullScreenMode();


  }

  initialize() async {

  }


  @override
  void dispose() {
    disableFullScreen();
    setSystemUIOverlays(originalThemeBrightness);
    super.dispose();
  }

}