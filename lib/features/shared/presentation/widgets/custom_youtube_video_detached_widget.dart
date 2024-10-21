import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomYoutubeVideoDetachedWidget extends StatefulWidget {

  final String url;
  final String? videoId;
  final Function()? onClose;
  final Function()? onOpenExternalLinkTapped;
  const CustomYoutubeVideoDetachedWidget({Key? key, required this.url, this.videoId, this.onClose, this.onOpenExternalLinkTapped}) : super(key: key);

  @override
  CustomYoutubeVideoDetachedWidgetController createState() => CustomYoutubeVideoDetachedWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CustomYoutubeVideoDetachedWidgetView extends WidgetView<CustomYoutubeVideoDetachedWidget, CustomYoutubeVideoDetachedWidgetController> {

  const _CustomYoutubeVideoDetachedWidgetView(CustomYoutubeVideoDetachedWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    if(state._youtubePlayerController == null) {
      return const SizedBox.shrink();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Hero(tag: widget.url,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: state._youtubePlayerController!,
                    showVideoProgressIndicator: false,
                    aspectRatio: 16 / 9,
                    // thumbnail: widget.thumbNailImageUrl != null ? _thumbnailImage(widget.thumbNailImageUrl, VideoType.youtube) : null,
                    actionsPadding: EdgeInsets.zero,
                    bufferIndicator: const Center(
                      child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 2, color: kAppBlue,)),
                    ),
                    bottomActions: const [],
                    topActions: [
                      // const Padding(padding: EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 80),
                      //   child: Icon(FeatherIcons.move, color: kAppWhite, size: 20,),
                      // ),
                      GestureDetector(
                        onTap: () {
                          widget.onClose?.call();
                          widget.onOpenExternalLinkTapped?.call();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: const Padding(padding: EdgeInsets.only(left: 10, top: 10, right: 20),
                          child: Icon(FeatherIcons.externalLink, color: kAppWhite, size: 20,),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          widget.onClose?.call();
                        },
                        child: const Padding(padding: EdgeInsets.only(left: 10, top: 10, right: 20),
                          child: Icon(Icons.close, color: kAppWhite, size: 20,),
                        ),
                      ),
                      // IconButton(onPressed: () {}, icon: ),

                    ],

                    onReady: () {
                      state.youtubeVideoReady.value = true;

                    },
                    onEnded: (data) {
                      // state.youtubeVideoReady.value = false;
                      state._youtubePlayerController?.pause();
                    },
                  ),
                  builder: (ctx, player) {
                    return player;
                  },

                ),
                // ValueListenableBuilder<bool>(valueListenable: state.youtubeVideoEnded, builder: (_, ended, __) {
                //   // if(!ready) return const Center(child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 2, color: kAppBlue,),),);
                //   // if(ready) return const SizedBox.shrink();
                //   if(state.youtubeVideoReady.value && ended){
                //     return const SizedBox.shrink();
                //   }
                //
                //
                // })
              ],
            ),
          )
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CustomYoutubeVideoDetachedWidgetController extends State<CustomYoutubeVideoDetachedWidget> {

  late YoutubePlayerController? _youtubePlayerController;
  final ValueNotifier<bool> youtubeVideoReady = ValueNotifier(false);
  final ValueNotifier<bool> youtubeVideoEnded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => _CustomYoutubeVideoDetachedWidgetView(this);

  @override
  void initState() {
    super.initState();

    final videoId = widget.videoId ?? YoutubePlayer.convertUrlToId(widget.url);

    //for youtube videos
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags:  const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: false,
        enableCaption: false,
        showLiveFullscreenButton: true,
        controlsVisibleAtStart: false,
        loop: false,
        // showLiveFullscreenButton: true,
      ),

    );

  }


  @override
  void dispose() {
    super.dispose();
    _youtubePlayerController?.dispose();
  }

}