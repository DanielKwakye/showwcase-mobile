import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_regular_video_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_state.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_video_cubit.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/shows_action_bar_widget.dart';

class ShowVideoPreviewPage extends StatefulWidget {

  final ShowModel show;
  final String videoUrl;
  const ShowVideoPreviewPage({Key? key, required this.show,required this.videoUrl}) : super(key: key);

  @override
  ShowVideoPreviewPageController createState() => ShowVideoPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ShowVideoPreviewPageView extends WidgetView<ShowVideoPreviewPage, ShowVideoPreviewPageController> {

  const _ShowVideoPreviewPageView(ShowVideoPreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () {
        return state.dismissPage(context, theme);
      },
      child: ValueListenableBuilder<double>(
          valueListenable: state.pageDismissProgress,
          builder: (_, pageDismissProgress, __) {
            return Scaffold(
                backgroundColor: kAppBlack.withOpacity(pageDismissProgress),
                appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: AnimatedBuilder(
                  animation: state.animation,
                  builder: (_, ch) {
                    return AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: Opacity(opacity: state.animation.value, child: const BackButton(),),
                      iconTheme: const IconThemeData(color: kAppWhite),
                      centerTitle: false,
                      title: Opacity(
                        opacity: state.animation.value,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomUserAvatarWidget(
                              networkImage: widget.show.user?.profilePictureKey, username: widget.show.user?.username,
                              borderSize: 0,
                              borderColor: kAppBlack,
                              size: 30,
                            ),
                            const SizedBox(width: 10,),
                            Text(widget.show.user?.displayName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium?.copyWith(color: kAppWhite),)

                          ],
                        ),
                      ),
                      actions: [
                        Opacity(
                          opacity: state.animation.value,
                          child: IconButton(onPressed: (){
                            // share
                            showVideoOptions(context);
                          }, icon: const Icon(Icons.more_horiz, color: kAppWhite,)),
                        ),

                      ],
                    );
                  },
                )),
                body: Stack(
                  children: [

                    /// Images here --------------

                    ValueListenableBuilder<bool>(valueListenable: state.enableSwipe, builder: (_, enableDragToDismissValue, ch) {
                      return Dismissible(
                          direction: enableDragToDismissValue ? DismissDirection.vertical : DismissDirection.none,
                          onDismissed: (_) {
                            state.dismissPage(context, theme);
                          },
                          onUpdate: (DismissUpdateDetails update) {
                            // update is between 0 and 1. update 1.0 means fully dismissed, 0.0 fully visible
                            // final progress = update.progress < 0.5 ? 0.5 : 0.0;


                            state.pageDismissProgress.value = 1 - update.progress;

                            // debugPrint("update: ${update.progress}");
                            if(update.progress == 0.0){
                              state.animationController.forward();
                              disableFullScreen();

                            }else{
                              if(!state.animationController.isAnimating) {
                                state.animationController.reverse();
                              }
                            }


                          },
                          behavior: HitTestBehavior.opaque,
                          key:  ValueKey("video-preview-${widget.show.id}"),
                          child: ch!
                      );

                    }, child: SafeArea(
                      child: CustomRegularVideoWidget(
                        autoPlay: true,
                        loop: true,
                        mute: false,
                        showDefaultControls: false,
                        showCustomVolumeButton: false,
                        maxWidth: media.size.width,
                        maxHeight: media.size.height - kToolbarHeight,
                        tag: widget.videoUrl,
                        videoSource: VideoSource.mediaId, mediaId: widget.videoUrl,
                        fit: BoxFit.contain,),
                    ),),

                    /// Show data  -----------------
                    SafeArea(child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedBuilder(
                        animation: state.animation,
                        builder: (_, ch) {
                          return Opacity(
                            opacity: state.animation.value,
                            child: ch,
                          );
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: kAppBlack.withOpacity(0.8),
                          ),
                          child: BlocSelector<ShowPreviewVideoCubit, ShowPreviewState, ShowModel>(
                            selector: (state){
                              return state.showPreviews.firstWhere((element) => element.id == widget.show.id);
                            },
                            builder: (context, reactiveShow) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    if(widget.show.title != null) ... {
                                      Text(widget.show.title!, style: theme.textTheme.titleMedium?.copyWith(fontSize: defaultFontSize, fontWeight: FontWeight.w700, color: kAppWhite),),
                                      const SizedBox(height: 10,),
                                    },

                                    ShowsActionBarWidget(showModel: reactiveShow, iconColor: kAppWhite, separatorColor: kAppFaintBlack,),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )),
                  ],
                )

            );
          }
      ),
    );

  }

  void showVideoOptions(BuildContext context){
    final ch = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.download, size: 20,),
          minLeadingWidth: 0,
          title: const Text('Save to gallery'),
          onTap: (){

          },
        ),
        const CustomBorderWidget(),
        ListTile(
          leading: const Icon(Icons.copy, size: 20,),
          minLeadingWidth: 0,
          title: const Text('Copy image link'),
          onTap: () {

          },
        ),
      ],
    );

    showCustomBottomSheet(context, child: ch);
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ShowVideoPreviewPageController extends State<ShowVideoPreviewPage>  with SingleTickerProviderStateMixin {

  late ValueNotifier<bool> enableSwipe;
  // late ValueNotifier<bool> enableDragToDismiss;
  bool inFullScreen = false;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  late Animation<double> animation;
  late AnimationController animationController;
  final ValueNotifier<double> pageDismissProgress = ValueNotifier(1.0);
  late ShowPreviewVideoCubit showPreviewVideoCubit;
  late Brightness originalThemeBrightness;

  @override
  Widget build(BuildContext context) => _ShowVideoPreviewPageView(this);

  @override
  void initState() {

    showPreviewVideoCubit = context.read<ShowPreviewVideoCubit>();
    showPreviewVideoCubit.setShowPreview(show: widget.show);
    enableSwipe = ValueNotifier(true);
    // enableDragToDismiss = ValueNotifier(true);

    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds:  200), value: 1);
    final tween = Tween<double>(begin: 0.0, end: 1.0);
    animation = tween.animate(animationController);
    // setSystemUIOverlays(context, forcedBrightness: Brightness.dark);
    setSystemUIOverlays(Brightness.dark);
    onWidgetBindingComplete(onComplete: () {
      originalThemeBrightness = Theme.of(context).brightness;
    });
    super.initState();
  }

  Future<bool> dismissPage(BuildContext context, ThemeData theme) async {
    await disableFullScreen();
    // setAppSystemOverlay(theme: theme, useThemeOverlays: true, strictlyUseDarkModeOverlays: false, strictlyUseLightModeOverlays: false);
    if(mounted){
      pop(context);
    }
    return true;
  }

  @override
  void dispose() {
    setSystemUIOverlays(originalThemeBrightness);
    animationController.dispose();
    super.dispose();
  }

}