import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_regular_video_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_state.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_video_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_feed_action_bar_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_more_menu_action.dart';

class ThreadVideoPreviewPage extends StatefulWidget {

  final ThreadModel thread;
  const ThreadVideoPreviewPage({Key? key, required this.thread}) : super(key: key);

  @override
  ThreadVideoPreviewPageController createState() => ThreadVideoPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadVideoPreviewPageView extends WidgetView<ThreadVideoPreviewPage, ThreadVideoPreviewPageController> {

  const _ThreadVideoPreviewPageView(ThreadVideoPreviewPageController state) : super(state);

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
                              networkImage: widget.thread.user?.profilePictureKey, username: widget.thread.user?.username,
                              borderSize: 0,
                              borderColor: kAppBlack,
                              size: 30,
                            ),
                            const SizedBox(width: 10,),
                            Text(widget.thread.user?.displayName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium?.copyWith(color: kAppWhite),)

                          ],
                        ),
                      ),
                      actions: [
                        Opacity(
                          opacity: state.animation.value,
                          child: ThreadMoreMenuAction(
                            thread: widget.thread,
                            iconColor: kAppWhite,
                            paddingRight: 20,
                          ),
                        ),

                      ],
                    );
                  },
                )),
                body: GestureDetector(
                  onTap: () {
                    if(state.inFullScreen){
                      // disable full screen
                      disableFullScreen();
                    }else{
                      // enable full screen
                      enableFullScreen();
                    }
                    state.inFullScreen = !state.inFullScreen;

                  },
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [

                      /// Videos here --------------

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
                            key:  ValueKey("video-preview-${widget.thread.id}"),
                            child: ch!
                        );

                      }, child: SafeArea(
                        child: CustomRegularVideoWidget(
                          key: state._customRegularVideoKey,
                          autoPlay: true,
                          loop: true,
                          mute: false,
                          showDefaultControls: true,
                          showCustomVolumeButton: false,
                          enableProgressBar: true,
                          maxWidth: media.size.width,
                          maxHeight: media.size.height - kToolbarHeight,
                          tag: widget.thread.videoUrl!,
                          videoSource: VideoSource.mediaId, mediaId: widget.thread.videoUrl!,
                          controlsVisibilityChanged: ({required bool hidden}) {
                            if(hidden) {
                              state.hideThreadInfo.value = false;
                              return;
                            }

                            // if video controls are visible, hide thread info, else show it
                            state.hideThreadInfo.value = true;


                          },
                          fit: BoxFit.contain,),
                      ),),

                      /// Thread data  -----------------
                      ValueListenableBuilder<bool>(valueListenable: state.hideThreadInfo, builder: (c, hideThreadInfo, __) {
                        if(hideThreadInfo) {
                          return const SizedBox.shrink();
                        }
                        return FadeIn(child: SafeArea(child: Align(
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
                              child: BlocSelector<ThreadPreviewVideoCubit, ThreadPreviewState, ThreadModel>(
                                selector: (state){
                                  return state.threadPreviews.firstWhere((element) => element.id == widget.thread.id);
                                },
                                builder: (context, reactiveThread) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if(!reactiveThread.message.isNullOrEmpty())...{
                                          ThreadMessageWidget(threadModel: reactiveThread, textColor: kAppWhite, maxLines: 2,),
                                          const SizedBox(height: 10,),
                                        },
                                        ThreadFeedActionBarWidget(thread: reactiveThread, iconColor: kAppWhite, separatorColor: kAppFaintBlack,),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )));
                      }),
                    ],
                  ),
                )

            );
          }
      ),
    );

  }

  void _showVideoOptions(BuildContext context){
    final ch = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.copy, size: 20,),
          minLeadingWidth: 0,
          title: const Text('Copy thread'),
          onTap: (){

          },
        ),
        const CustomBorderWidget(),
        ListTile(
          leading: const Icon(Icons.flag_outlined, size: 20,),
          minLeadingWidth: 0,
          title: const Text('Report thread'),
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

class ThreadVideoPreviewPageController extends State<ThreadVideoPreviewPage>  with SingleTickerProviderStateMixin {

  late ValueNotifier<bool> enableSwipe;
  // late ValueNotifier<bool> enableDragToDismiss;
  bool inFullScreen = false;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  late Animation<double> animation;
  late AnimationController animationController;
  final ValueNotifier<double> pageDismissProgress = ValueNotifier(1.0);
  late ThreadPreviewVideoCubit threadPreviewVideoCubit;
  late Brightness originalThemeBrightness;
  final GlobalKey<CustomRegularVideoWidgetController> _customRegularVideoKey = GlobalKey<CustomRegularVideoWidgetController>();
  final ValueNotifier<bool> hideThreadInfo = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => _ThreadVideoPreviewPageView(this);

  @override
  void initState() {

    threadPreviewVideoCubit = context.read<ThreadPreviewVideoCubit>();
    threadPreviewVideoCubit.setThreadPreview(thread: widget.thread);
    enableSwipe = ValueNotifier(true);
    // enableDragToDismiss = ValueNotifier(true);

    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds:  200), value: 1);
    final tween = Tween<double>(begin: 0.0, end: 1.0);
    animation = tween.animate(animationController);
    // enableFullScreen();
    setSystemUIOverlays(Brightness.dark);
    onWidgetBindingComplete(onComplete: () {
      originalThemeBrightness = Theme.of(context).brightness;
    });
    // _customRegularVideoKey.currentState?.
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