import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_circular_loader.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_images_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_feed_action_bar_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_more_menu_action.dart';

import '../../data/bloc/thread_preview_state.dart';

class ThreadImagesPreviewPage extends StatefulWidget {

  final ThreadModel thread;
  final List<String> galleryItems;
  final int initialPageIndex;
  const ThreadImagesPreviewPage({Key? key, required this.thread, required this.galleryItems,
    this.initialPageIndex = 0}) : super(key: const ValueKey('ThreadImagesPreviewPage'));

  @override
  ThreadImagesPreviewPageController createState() => ThreadImagesPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadImagesPreviewPageView extends WidgetView<ThreadImagesPreviewPage, ThreadImagesPreviewPageController> {

  const _ThreadImagesPreviewPageView(ThreadImagesPreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    // setAppSystemOverlay(theme: theme, strictlyUseDarkModeOverlays: true, useThemeOverlays: false);

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
                        )

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
                          key:  ValueKey("image-preview-${widget.galleryItems[0]}"),
                          child: ch!
                      );

                    }, child: SafeArea(
                      child: _pageView(context),
                    ),),

                    /// Thread data  -----------------
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
                          child: BlocSelector<ThreadPreviewImagesCubit, ThreadPreviewState, ThreadModel>(
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
                    )),
                  ],
                )

            );
          }
      ),
    );

  }

  Widget _pageView(BuildContext context) {
    return ValueListenableBuilder<bool>(valueListenable: state.enableSwipe, builder: (_, bool enableSwipeValue, __) {
      return PhotoViewGallery.builder(
        scrollPhysics: enableSwipeValue ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        scaleStateChangedCallback: (scale) {
          debugPrint("photoview: scale state changed: $scale");
          state.enableSwipe.value = scale == PhotoViewScaleState.initial;
        },

        builder: (BuildContext context, int index) {

          final imageUrl = widget.galleryItems[index];

          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              imageUrl,
              cacheKey: imageUrl,
              // maxWidth: size.width.toInt(),
            ),

            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
            onTapDown: (_, TapDownDetails details, ctrl){
              if(state.inFullScreen){
                // disable full screen
                disableFullScreen();
              }else{
                // enable full screen
                enableFullScreen();
              }
              state.inFullScreen = !state.inFullScreen;
            }
          );
        },
        itemCount: widget.galleryItems.length,
        loadingBuilder: (context, event) => const Center(child: CustomCircularLoader(),),
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
        pageController: state._pageController,
        onPageChanged: state._onPageChanged,
      );
    });
  }

  void _showImageOptions(BuildContext context){
    final ch = SafeArea(
      top: false,
      bottom: true,
      child: Column(
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
              title: const Text('Copy thread link'),
              onTap: () {
                final copyUrl = "${ApiConfig.websiteUrl}/thread/${widget.thread.id}";
                copyTextToClipBoard(context, copyUrl);
              },
            ),
         ],
      ),
    );

    showCustomBottomSheet(context, child: ch);
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadImagesPreviewPageController extends State<ThreadImagesPreviewPage> with SingleTickerProviderStateMixin {

  late ValueNotifier<int> currentIndex;
  late ValueNotifier<bool> enableSwipe;
  // late ValueNotifier<bool> enableDragToDismiss;
  late PageController _pageController;
  bool inFullScreen = false;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  late Animation<double> animation;
  late AnimationController animationController;
  final ValueNotifier<double> pageDismissProgress = ValueNotifier(1.0);
  late ThreadPreviewImagesCubit threadPreviewImagesCubit;
  late Brightness originalThemeBrightness;

  @override
  Widget build(BuildContext context) => _ThreadImagesPreviewPageView(this);

  @override
  void initState() {

    threadPreviewImagesCubit = context.read<ThreadPreviewImagesCubit>();
    threadPreviewImagesCubit.setThreadPreview(thread: widget.thread);
    currentIndex = ValueNotifier(widget.initialPageIndex);
    enableSwipe = ValueNotifier(true);
    // enableDragToDismiss = ValueNotifier(true);
    _pageController = PageController(initialPage: widget.initialPageIndex);
    // _pageController.
    
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds:  200), value: 1);
    final tween = Tween<double>(begin: 0.0, end: 1.0);
    animation = tween.animate(animationController);
    onWidgetBindingComplete(onComplete: () {
      originalThemeBrightness = Theme.of(context).brightness;
    });

    setSystemUIOverlays(Brightness.dark);
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




  void _onPageChanged(int index){
    currentIndex.value = index;
  }

  void _changeImage(int index){
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }


  @override
  void dispose() {
    setSystemUIOverlays(originalThemeBrightness);
    _pageController.dispose();
    animationController.dispose();
    super.dispose();
  }

}