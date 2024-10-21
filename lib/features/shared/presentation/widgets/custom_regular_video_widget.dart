import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_enums.dart';
import 'package:showwcase_v3/features/file_manager/data/models/video_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_circular_loader.dart';

class CustomRegularVideoWidget extends StatefulWidget {

  final bool autoPlay;
  final bool mute;
  final bool loop;
  final File? file;
  final bool showDefaultControls;
  final bool showCustomVolumeButton;
  final bool? enableProgressBar;
  final VideoSource videoSource;
  final String? networkUrl;
  final String? mediaId;
  final String? assetUrl;
  final Function()? onComplete;
  final Function(int value)? onChange;
  final double? aspectRatio;
  final BoxFit? fit;
  final Function()? onTap;
  final String tag;
  final double? maxWidth;
  final double? maxHeight;
  final bool? showControlsOnInitialize;
  final Function({required bool hidden})? controlsVisibilityChanged;

  const CustomRegularVideoWidget({Key? key,
    this.autoPlay = true,
    this.mute = true,
    this.loop = true,
    this.showDefaultControls = false,
    this.enableProgressBar,
    this.showCustomVolumeButton = true,
    this.showControlsOnInitialize,
    required this.videoSource,
    this.file,
    this.networkUrl,
    this.mediaId,
    this.assetUrl,
    this.onChange,
    this.onComplete,
    this.aspectRatio,
    this.fit,
    this.onTap,
    this.maxWidth,
    this.maxHeight,
    this.controlsVisibilityChanged,
    required this.tag,
  }) : super(key: key);

  @override
  CustomRegularVideoWidgetController createState() => CustomRegularVideoWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CustomRegularVideoWidgetView extends WidgetView<CustomRegularVideoWidget, CustomRegularVideoWidgetController> {

  const _CustomRegularVideoWidgetView(CustomRegularVideoWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
      },
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth : widget.maxWidth ?? media.size.width,
              maxHeight : widget.maxHeight ?? media.size.width
          ), child: DecoratedBox(
          decoration: const BoxDecoration(
            color: kAppBlack,
          ),

          child: Center(
            child: ValueListenableBuilder<VideoSrcStatus>(valueListenable: state.videoSourceStatus, builder: (_, videoSrcStatus, ch){
              if(videoSrcStatus == VideoSrcStatus.ready){
                return ValueListenableBuilder<bool>(valueListenable: state.videoPlayerInitialized, builder: (ctx, videoInitialized, _) {
                  if(videoInitialized) {
                    return Stack(
                      children: [
                        Positioned.fill(child: BetterPlayer(
                          controller: state._betterPlayerController,

                        )),
                        customOverlayControls()
                      ],
                    );
                  }
                  return  _videoPlaceholderWidget(ctx);
                });
              }

              if(videoSrcStatus == VideoSrcStatus.error) {
                _videoPlaceholderWidget(context, text: "Oops!. Unable to load video");
              }
              return _videoPlaceholderWidget(context);
            }),
          )

      ),),
    );

  }

  Widget _videoPlaceholderWidget(BuildContext context, {String? text}) {
    final theme = Theme.of(context);
    return Center(
      child: text != null ?   Text(text, style: TextStyle(color: theme.colorScheme.onBackground),) :
      const CustomCircularLoader(),
    );
  }

  Widget customOverlayControls() {
    return ValueListenableBuilder<bool>(valueListenable: state.volumeOff, builder: (_, volumeOff, __){
      return Stack(
        children: [
          if(widget.showCustomVolumeButton) ... {
            if(volumeOff) ... {
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: kAppBlack.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: IconButton(
                      onPressed: () {
                        // cont .setVolume(1.0);
                        state._betterPlayerController.setVolume(1.0);
                        state.volumeOff.value = false;
                      },
                      icon: const Icon(Icons.volume_off, size: 18, color: kAppWhite,),
                    ),
                  ))
            }else ... {
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: kAppBlack.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: IconButton(
                      onPressed: () {
                        // ctl.setVolume(0.0);
                        state._betterPlayerController.setVolume(0.0);
                        state.volumeOff.value = true;
                      },
                      icon: const Icon(Icons.volume_up, size: 18, color: kAppWhite,),
                    ),
                  ))
            }
          }

        ],
      );
    },);
  }


}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CustomRegularVideoWidgetController extends State<CustomRegularVideoWidget>{


  // late VideoPlayerController _videoController;
  late FileManagerCubit fileManagerCubit;
  late BetterPlayerController _betterPlayerController;
  final ValueNotifier<bool> videoPlayerInitialized = ValueNotifier(false);

  // this property is here because, sometimes the video link or file may not be readily available,
  // and we might have to load link/file from the server or from our asset folder
  late ValueNotifier<VideoSrcStatus> videoSourceStatus = ValueNotifier(VideoSrcStatus.ready);

  final ValueNotifier<BetterPlayerEventType?> betterPlayEventType = ValueNotifier(null);
  late ValueNotifier<bool> volumeOff;


  @override
  Widget build(BuildContext context) {
    return _CustomRegularVideoWidgetView(this);
  }

  @override
  void initState() {
    super.initState();
    fileManagerCubit = context.read<FileManagerCubit>();
    volumeOff = ValueNotifier(widget.mute);
    _initPlayer();

  }

  _initPlayer() async {

    late BetterPlayerDataSource betterPlayerDataSource;
    if (widget.videoSource == VideoSource.network) {

      videoSourceStatus.value = VideoSrcStatus.ready;
      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.networkUrl!,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
        ),

      );

    }if (widget.videoSource == VideoSource.mediaId) {

      videoSourceStatus.value = VideoSrcStatus.loading;
      // get video url from media Id and then use BetterPlayerDataSourceType.network to render video
     final either = await fileManagerCubit.fetchVideoFromMediaId(mediaId: widget.mediaId!);
     if(either.isLeft()){
       videoSourceStatus.value = VideoSrcStatus.error;
     }else{

       // sample -> https://customer-w1ye2rwu8qat1jce.cloudflarestream.com/bb34730b693fac04a22f5844891e88bd/manifest/video.m3u8
       videoSourceStatus.value = VideoSrcStatus.ready;
       final VideoModel videoSrc = either.asRight();
       final thumbnail = videoSrc.thumbnail;
       final preview = videoSrc.preview!;
       final hlsUrl = videoSrc.playback!.hls!;
       final dashUrl = videoSrc.playback!.dash!;

       betterPlayerDataSource = BetterPlayerDataSource(
         BetterPlayerDataSourceType.network,
         hlsUrl,
         videoFormat: BetterPlayerVideoFormat.hls,
         cacheConfiguration: const BetterPlayerCacheConfiguration(
           useCache: true,
         ),

       );
     }



    }
    else if (widget.videoSource == VideoSource.file) {

      videoSourceStatus.value = VideoSrcStatus.ready;
      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.file!.path,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
            useCache: true
        ),
      );

    }else if (widget.videoSource == VideoSource.asset && !widget.assetUrl.isNullOrEmpty()) {

      videoSourceStatus.value = VideoSrcStatus.loading;
      final file  = await getFileFromAssets(widget.assetUrl ?? '');
      videoSourceStatus.value = VideoSrcStatus.ready;

      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        file.path,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
            useCache: true
        ),
      );
    }

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
          autoPlay: widget.autoPlay,
          looping: widget.loop,
          eventListener: _playerEventListener,
          fit: widget.fit ?? BoxFit.fill,
          // videoFormat: BetterPlayerVideoFormat.hls,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: widget.showDefaultControls,
            enableMute: true,
            showControlsOnInitialize: widget.showControlsOnInitialize ?? false,
            enableFullscreen: false,
            enableAudioTracks: false,
            enableOverflowMenu: false,
            enablePlayPause: false,
            enableProgressBar: widget.enableProgressBar ?? false,
            enablePlaybackSpeed: true,
            enableSkips: false,
            enableProgressBarDrag: true,
            enableSubtitles: false,
            enableProgressText: false,
            enableQualities: false,
            loadingWidget: const CustomAdaptiveCircularIndicator()
          )),

      betterPlayerDataSource: betterPlayerDataSource,

    );

    if(widget.mute){
      _betterPlayerController.setVolume(0.0);
    }


  }

  void _playerEventListener(BetterPlayerEvent event) {
    debugPrint("event: ${event.betterPlayerEventType} , data: ${event.parameters}");
    if(event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      _betterPlayerController.setOverriddenAspectRatio(widget.aspectRatio ?? _betterPlayerController.videoPlayerController!.value.aspectRatio);
      // if(widget.fit != null){
      //   _betterPlayerController.setOverriddenFit(widget.fit!);
      // }
      videoPlayerInitialized.value = true;
    }

    if(event.betterPlayerEventType == BetterPlayerEventType.changedPlayerVisibility) {
    }

    if(event.betterPlayerEventType == BetterPlayerEventType.exception){
      videoSourceStatus.value = VideoSrcStatus.error;
    }

    if(event.betterPlayerEventType == BetterPlayerEventType.controlsVisible){
        widget.controlsVisibilityChanged?.call(hidden: false);
    }

    if(event.betterPlayerEventType == BetterPlayerEventType.controlsHiddenEnd){
      widget.controlsVisibilityChanged?.call(hidden: true);
    }

    if(event.betterPlayerEventType == BetterPlayerEventType.progress) {
      // debugPrint("event: ${event.betterPlayerEventType} , data: ${event.parameters}");
      final data = event.parameters;
      if(data == null) return;
      if(data.containsKey('progress') && data.containsKey('duration') && data["progress"] != null &&  data["duration"] != null) {
        // debugPrint("event: ${event.betterPlayerEventType} , data: ${event.parameters}");
        final now = DateTime.now();
        final pTime = data["progress"].toString();
        final dTime = data["duration"].toString();
        final fPTime = _formatTimeFromVid(pTime);
        final fDTime = _formatTimeFromVid(dTime);
        final pTimeString = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $fPTime';
        final dTimeString = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $fDTime';
        DateTime progressTime = DateTime.parse(pTimeString);
        DateTime durationTime= DateTime.parse(dTimeString);
        final differenceInSeconds = durationTime.difference(progressTime).inSeconds;
        widget.onChange?.call(differenceInSeconds);
        if(differenceInSeconds == 0){
          widget.onComplete?.call();
        }
        // debugPrint("time remaining: $differenceInSeconds");
      }
    }else {
      debugPrint("event: ${event.betterPlayerEventType} , data: ${event.parameters}");
    }
  }

  String _formatTimeFromVid(String rawTime) {
    final t0 = rawTime.replaceAll('-', '');
    final t1 = t0.split('.')[0];
    final t2 = t1.split(':');
    final i1 = t2[0].padLeft(2, '0');
    final i2 = t2[1].padLeft(2, '0');
    final i3 = t2[2].padLeft(2, '0');
    final formatted = "$i1:$i2:$i3";
    return formatted;
  }


  @override
  void dispose() {
    _betterPlayerController.pause();
    _betterPlayerController.dispose();
    super.dispose();
  }




}


