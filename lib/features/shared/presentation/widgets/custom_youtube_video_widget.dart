import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_play_icon.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_youtube_video_detached_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomYoutubeVideoWidget extends StatefulWidget {

  final String url;
  final bool autoplay;
  final bool detachOnClick;
  final bool playDetachedVideo;
  final Function()? onTap;
  final bool mute;
  final bool pauseVideoOnTap;
  final Function()? onDetachedVideoExternalLinkTapped;
  const CustomYoutubeVideoWidget({Key? key, required this.url, this.pauseVideoOnTap = false, this.playDetachedVideo = false, this.autoplay = true, this.mute = true, this.detachOnClick = true, this.onTap, this.onDetachedVideoExternalLinkTapped}) : super(key: key);

  @override
  CustomYoutubeVideoWidgetController createState() => CustomYoutubeVideoWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CustomYoutubeVideoWidgetView extends WidgetView<CustomYoutubeVideoWidget, CustomYoutubeVideoWidgetController> {

  const _CustomYoutubeVideoWidgetView(CustomYoutubeVideoWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    if(state._youtubePlayerController == null) {
      return const SizedBox.shrink();
    }
    return Hero(tag: widget.url, child:
    GestureDetector(
      onTap: () {
        if(state.youtubeVideoReady.value && widget.detachOnClick && state.entry == null) {
          state._youtubePlayerController?.pause();
          state._showLoadingOverlay();
          return;
        }

        if(widget.pauseVideoOnTap) {
          state._youtubePlayerController?.pause();
        }
        widget.onTap?.call();
        // changeScreenWithConstructor(context, VideoPreviewPage(
        //       videoUrl: videoUrl,
        //       videoType: VideoType.youtube,
        //       ), rootNavigator: true);
        // state.launchBrowser(videoUrl, context);
      },
      child: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: state._youtubePlayerController!,
                  showVideoProgressIndicator: true,
                  aspectRatio: 16 / 9,
                  // thumbnail: widget.thumbNailImageUrl != null ? _thumbnailImage(widget.thumbNailImageUrl, VideoType.youtube) : null,
                  actionsPadding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  bottomActions: const [],
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
              ValueListenableBuilder<bool>(valueListenable: state.youtubeVideoReady, builder: (_, ready, __) {
                if(widget.autoplay && !ready) return const Center(child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 2, color: kAppBlue,),),);
                if(ready && widget.autoplay) return const SizedBox.shrink();
                return const CustomPlayIcon();
              })
            ],
          ),
        ),
      ),
    ));
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CustomYoutubeVideoWidgetController extends State<CustomYoutubeVideoWidget> {

  late YoutubePlayerController? _youtubePlayerController;
  final ValueNotifier<bool> youtubeVideoReady = ValueNotifier(false);

  // detach on click properties
  OverlayEntry? entry;
  late Offset offset;
  late String? videoId;

  @override
  Widget build(BuildContext context) => _CustomYoutubeVideoWidgetView(this);

  @override
  void initState() {
    super.initState();

    videoId = YoutubePlayer.convertUrlToId(widget.url);

    //for youtube videos
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags:  YoutubePlayerFlags(
        autoPlay: widget.autoplay,
        mute: widget.mute,
        hideControls: true,
        // showLiveFullscreenButton: true,
      ),

    );

    // initialize detached video
    onWidgetBindingComplete(onComplete: () {
      if(mounted) {
        final size = MediaQuery.of(context).size;
        final videoHeight = (9 * (size.width) / 16);
        // offset = Offset(size.width * 0.28, (size.height - videoHeight - (size.height * 0.145)));
        offset = const Offset(0.0, 0.0);

        if(widget.playDetachedVideo) {
          _youtubePlayerController?.pause();
          _showLoadingOverlay();
        }
      }
    });

  }


  _showLoadingOverlay() {
    entry = OverlayEntry(builder: (ctx) {

      final theme = Theme.of(ctx);
      final size = MediaQuery.of(ctx).size;

      return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            offset += details.delta;
            entry!.markNeedsBuild();
          },
          child: SizedBox(
            width: size.width * 1.0,
            // height: 50,
            child:  SafeArea(
                child: CustomYoutubeVideoDetachedWidget(url: widget.url, videoId: videoId, onClose: () {
                  _hideOverlayWidget();
                }, onOpenExternalLinkTapped: () {
                  widget.onDetachedVideoExternalLinkTapped?.call();
                },)),
          )
          // child:,
        ),
      );
    });

    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }
  _hideOverlayWidget() {
    entry?.remove();
    entry = null;
  }


  @override
  void dispose() {
    super.dispose();
    _youtubePlayerController?.dispose();
  }

}