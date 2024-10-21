import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_any_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_view_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_gif_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_images_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_regular_video_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_youtube_video_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_boosted_list_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_comment_item_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_feed_action_bar_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_more_menu_action.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_poll_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

class ThreadPreviewPage extends StatefulWidget {

  final ThreadModel thread;
  const ThreadPreviewPage({Key? key, required this.thread}) : super(key: key);

  @override
  ThreadPreviewPageController createState() => ThreadPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadPreviewPageView extends WidgetView<ThreadPreviewPage, ThreadPreviewPageController> {

  const _ThreadPreviewPageView(ThreadPreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final currentUser = AppStorage.currentUserSession!;
    final media = MediaQuery.of(context);

    // onWillPop: () {
    //   state.threadPreviewCubit.removeThreadFromPreviews(thread: widget.thread);
    //   return Future.value(true);
    // },

    return Scaffold(
      /// Bottom bar to reply a preview
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: theme.colorScheme.primary,
          height: kToolbarHeight,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CustomBorderWidget(),
              Padding(
                // padding: EdgeInsets.zero,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pushToProfile(context, user: currentUser);
                      },
                      child: CustomUserAvatarWidget(networkImage: currentUser.profilePictureKey,),
                    ),
                    const SizedBox(width: 8,),
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CupertinoTextField(
                        readOnly: true,
                        padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        placeholder: 'Reply to Thread...',
                        onTap: () {
                          context.push(threadEditorPage,extra: {
                            'threadToReply': widget.thread,
                            'community': widget.thread.community
                          });
                        },
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.light
                              ? kAppLightGray
                              : kDarkOutlineColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100),
                        ),

                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      body: SafeArea(
        bottom: true,
        child: BlocSelector<ThreadPreviewCubit, ThreadPreviewState, ThreadModel>(

          selector: (threadPreviewState){
            return threadPreviewState.threadPreviews.firstWhere((element) => element.id == widget.thread.id);
          },

          builder: (context, ThreadModel reactiveThread) {
            return CustomScrollView(
              slivers: [
                const CustomInnerPageSliverAppBar(pageTitle: "Thread",),
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// thread content here -------------------
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SeparatedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          separatorBuilder: (BuildContext context, int index) {

                            /// Spacing between each component (this creates an even spaces)
                            return const SizedBox(height: 8,);

                          },
                          children: [
                            if(reactiveThread.isPinned != null) ... {
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/svg/pin.svg',
                                        colorFilter: const ColorFilter.mode(kAppGold, BlendMode.srcIn),
                                        height: 13),
                                    const SizedBox(width: 10,),
                                    const Text('Pinned Thread',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),)
                                  ],
                                ),
                              )
                            },
                            if((reactiveThread.boostedBy ?? []).isNotEmpty) ... {
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
                                child: ThreadBoostedListWidget(thread: reactiveThread),
                              )
                            },
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
                              child: GestureDetector(
                                  onTap: () {
                                    pushToProfile(context, user: reactiveThread.user!);
                                  },

                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      UserProfileIconWidget(
                                        user: reactiveThread.user!,
                                        dimension: '100x',
                                        networkImage: (reactiveThread.isAnonymous ?? false) ? anonymousPostUserImage : null,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 8,),
                                      Expanded(child:
                                      /// Meta data about thread here  --------------
                                      ThreadUserMetaDataWidget(
                                        hideDisplayName: true,
                                        thread: reactiveThread,
                                        pageName: threadPreviewPage,
                                      ),
                                      ),
                                      /// thread feed actions
                                      ///
                                      ThreadMoreMenuAction(
                                        thread: reactiveThread,
                                        paddingRight: 0,
                                      ),
                                    ],
                                  )


                              ),
                            ),


                            /// Title section
                            if(!reactiveThread.title.isNullOrEmpty())...{
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
                                  child: Text(reactiveThread.title ?? '', style: TextStyle(
                                      height: defaultLineHeight,
                                      fontSize: defaultFontSize + 2,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).colorScheme.onBackground)
                                  )
                              )

                            },

                            /// Message Section
                            if(!reactiveThread.message.isNullOrEmpty())...{

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
                                child: ThreadMessageWidget(
                                  threadModel: reactiveThread,
                                  maxLines: 5,
                                ),
                              )

                              // if(isContainingAnyLink(thread.message) && thread.linkPreviewMeta == null)AnyLinkPreviewWidget(message:thread.message!,)

                            },

                            /// Link preview section
                            if(reactiveThread.linkPreviewMeta != null )...{
                              CustomLinkPreviewWidget(linkPreviewMeta: reactiveThread.linkPreviewMeta!, onTap: (url) {
                                context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {
                                  "url": url,
                                  "thread": reactiveThread
                                });
                              },),
                            }else if(!reactiveThread.message.isNullOrEmpty() && isContainingAnyLink(reactiveThread.message)) ...{
                              CustomAnyLinkPreviewWidget(message:reactiveThread.message!, onTap: (url) {
                                context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {
                                  "url": url,
                                  "thread": reactiveThread
                                });
                              },)
                            },

                            /// Images section
                            if((reactiveThread.images ?? []).isNotEmpty) ...{
                              CustomImagesWidget(
                                images: reactiveThread.images ?? [],
                                onTap: (index, images){
                                  context.push(context.generateRoutePath(subLocation: threadImagesPreviewPage), extra: {
                                    'thread': reactiveThread,
                                    'galleryItems': images,
                                    'initialPageIndex': index
                                  });
                                },
                              ),
                            },

                            /// Video section
                            if(!reactiveThread.videoUrl.isNullOrEmpty()) ...{
                              if(checkIfLinkIsYouTubeLink(reactiveThread.videoUrl!)) ...{
                                CustomYoutubeVideoWidget(url: reactiveThread.videoUrl!, detachOnClick: false, autoplay: true,)
                              }else ... {
                                // CustomRegularVideoWidget(
                                //   autoPlay: true,
                                //   loop: true,
                                //   mute: false,
                                //   showDefaultControls: false,
                                //   showCustomVolumeButton: false,
                                //   maxWidth: media.size.width,
                                //   maxHeight: media.size.height - kToolbarHeight,
                                //   tag: widget.thread.videoUrl!,
                                //   videoSource: VideoSource.mediaId,
                                //   mediaId: widget.thread.videoUrl!,
                                //   fit: BoxFit.contain,),
                                CustomRegularVideoWidget(
                                  autoPlay: true,
                                  loop: true,
                                  mute: true,
                                  showDefaultControls: false,
                                  showCustomVolumeButton: true,
                                  onTap: () {
                                    return context.push(context.generateRoutePath(subLocation: threadVideoPreviewPage), extra: reactiveThread);
                                  },
                                  tag: reactiveThread.videoUrl!,
                                  videoSource: VideoSource.mediaId, mediaId: reactiveThread.videoUrl!,
                                  fit: BoxFit.contain,),
                              }
                            },

                            /// Gif section
                            if(reactiveThread.gif != null) ...{
                              CustomGifWidget(url: reactiveThread.gif?.tiny?.url ?? '', onTap: () {
                                context.push(context.generateRoutePath(subLocation: threadImagesPreviewPage), extra: {
                                  'thread': reactiveThread,
                                  'galleryItems': [reactiveThread.gif?.tiny?.url ?? ''],
                                  'initialPageIndex': 0
                                });
                              },),
                            },


                            /// Code section
                            if(!reactiveThread.code.isNullOrEmpty()) ...{
                              CustomCodeViewWidget(tag: reactiveThread.id.toString(), code: reactiveThread.code ?? '',
                                codeLanguage: reactiveThread.codeLanguage,
                                onTap: (code, language) {
                                  context.push(context.generateRoutePath(subLocation: threadCodePreviewPage), extra: {
                                    'thread': reactiveThread,
                                    'code': reactiveThread.code,
                                    'tag': reactiveThread.id.toString()
                                  });
                                },
                              ),
                            },

                            /// Poll Section
                            if(reactiveThread.poll != null) ...{
                              Container(
                                color: theme.colorScheme.surface,
                                // padding: const EdgeInsets.only(left: threadSymmetricPadding, right: threadSymmetricPadding),
                                child: ThreadPollWidget(
                                  thread:  reactiveThread,),
                              ),
                            }

                          ],
                        ),
                      ),
                      /// End of thread content ---------------------------

                      const SizedBox(height: 10,),
                      /// Thread action bar -----
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
                        child: ThreadFeedActionBarWidget(thread: reactiveThread,),
                      )
                    ],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: CustomBorderWidget(bottom: 20,),
                ),

                BlocListener<ThreadPreviewCubit, ThreadPreviewState>(
                  listenWhen: (_, next){
                    return next.status == ThreadStatus.refreshThreadPreviewCommentsCompleted;
                  },
                  listener: (context, threadPreviewState) {
                    if(threadPreviewState.status  == ThreadStatus.refreshThreadPreviewCommentsCompleted){
                      state.pagingController.itemList = threadPreviewState.threadComments[widget.thread.id];
                    }
                  },
                  child:  PagedSliverList<int, ThreadModel>.separated(
                    pagingController: state.pagingController,
                    addAutomaticKeepAlives: true,
                    builderDelegate: PagedChildBuilderDelegate<ThreadModel>(
                      itemBuilder: (context, item, index) {
                        return BlocSelector<ThreadPreviewCubit, ThreadPreviewState, ThreadModel>(
                          key:  ValueKey(item.id),
                          selector: (threadPreviewState) {
                            return threadPreviewState.threadComments[widget.thread.id]!.firstWhere((element) => element.id == item.id);
                          },
                          builder: (context, reactiveReply) {
                            return Padding(
                              key: ValueKey(reactiveReply.id),
                              padding: const EdgeInsets.only(left: threadSymmetricPadding),
                              child: ThreadCommentItemWidget(
                                comment: reactiveReply,
                                key: ValueKey(reactiveReply.id),
                                hideViewAllCommentsButton: false,
                                thread: reactiveThread,),
                            );
                          },
                        );

                      },
                      firstPageProgressIndicatorBuilder: (_) => const Center(child: CustomAdaptiveCircularIndicator(),),
                      newPageProgressIndicatorBuilder: (_) => const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: SizedBox(
                            height: 50, width: double.maxFinite,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: CustomAdaptiveCircularIndicator(),
                            ),
                          )),
                      noItemsFoundIndicatorBuilder: (_) => const SizedBox.shrink(),
                      noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
                      firstPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
                      newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                  ),
                )


              ],
            );
          },
        )


      )

    // body: NestedScrollView(
    //   controller: state.scrollController,
    //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //     return [
    //       const CustomInnerPageSliverAppBar(pageTitle: "Thread",),
    //       SliverToBoxAdapter(
    //         child: BlocSelector<ThreadPreviewCubit, ThreadPreviewState, ThreadModel>(
    //           selector: (threadPreviewState){
    //             return threadPreviewState.threadPreviews.firstWhere((element) => element.id == widget.thread.id);
    //           },
    //           builder: (_, ThreadModel reactiveThread) {
    //             return Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 /// thread content here -------------------
    //                 Padding(
    //                   padding: const EdgeInsets.only(top: 10),
    //                   child: SeparatedColumn(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisSize: MainAxisSize.min,
    //                     separatorBuilder: (BuildContext context, int index) {
    //
    //                       /// Spacing between each component (this creates an even spaces)
    //                       return const SizedBox(height: 8,);
    //
    //                     },
    //                     children: [
    //                       if(reactiveThread.isPinned != null) ... {
    //                         Padding(
    //                           padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
    //                           child: Row(
    //                             children: [
    //                               SvgPicture.asset('assets/svg/pin.svg',
    //                                   colorFilter: const ColorFilter.mode(kAppGold, BlendMode.srcIn),
    //                                   height: 13),
    //                               const SizedBox(width: 10,),
    //                               const Text('Pinned Thread',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),)
    //                             ],
    //                           ),
    //                         )
    //                       },
    //                       if((reactiveThread.boostedBy ?? []).isNotEmpty) ... {
    //                         Padding(
    //                           padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
    //                           child: ThreadBoostedListWidget(thread: reactiveThread),
    //                         )
    //                       },
    //                       Padding(
    //                         padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
    //                         child: GestureDetector(
    //                             onTap: () {
    //
    //                             },
    //
    //                             child: Row(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               mainAxisAlignment: MainAxisAlignment.start,
    //                               children: [
    //                                 UserProfileIconWidget(
    //                                   user: reactiveThread.user!,
    //                                   dimension: '100x',
    //                                   size: 50,
    //                                 ),
    //                                 const SizedBox(width: 8,),
    //                                 Expanded(child:
    //                                 /// Meta data about thread here  --------------
    //                                 ThreadUserMetaDataWidget(
    //                                   thread: reactiveThread,
    //                                 ),
    //                                 )
    //                               ],
    //                             )
    //
    //
    //                         ),
    //                       ),
    //
    //
    //                       /// Title section
    //                       if(!reactiveThread.title.isNullOrEmpty())...{
    //                         Padding(
    //                             padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
    //                             child: Text(reactiveThread.title ?? '', style: TextStyle(
    //                                 height: defaultLineHeight,
    //                                 fontSize: defaultFontSize + 2,
    //                                 fontWeight: FontWeight.w700,
    //                                 color: Theme.of(context).colorScheme.onBackground)
    //                             )
    //                         )
    //
    //                       },
    //
    //                       /// Message Section
    //                       if(!reactiveThread.message.isNullOrEmpty())...{
    //
    //                         Padding(
    //                           padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
    //                           child: ThreadMessageWidget(
    //                             threadModel: reactiveThread,
    //                             maxLines: 5,
    //                           ),
    //                         )
    //
    //                         // if(isContainingAnyLink(thread.message) && thread.linkPreviewMeta == null)AnyLinkPreviewWidget(message:thread.message!,)
    //
    //                       },
    //
    //                       /// Link preview section
    //                       if(reactiveThread.linkPreviewMeta != null )...{
    //                         CustomLinkPreviewWidget(linkPreviewMeta: reactiveThread.linkPreviewMeta!),
    //                       }else if(!reactiveThread.message.isNullOrEmpty() && isContainingAnyLink(reactiveThread.message)) ...{
    //                         CustomAnyLinkPreviewWidget(message:reactiveThread.message!,)
    //                       },
    //
    //                       /// Images section
    //                       if((reactiveThread.images ?? []).isNotEmpty) ...{
    //                         CustomImagesWidget(
    //                           images: reactiveThread.images ?? [],
    //                           onTap: (index, images){
    //                             context.push(context.generateRoutePath(subLocation: "thread-images-preview"), extra: {
    //                               'thread': reactiveThread,
    //                               'galleryItems': images,
    //                               'initialPageIndex': index
    //                             });
    //                           },
    //                         ),
    //                       },
    //
    //                       /// Video section
    //                       if(!reactiveThread.videoUrl.isNullOrEmpty()) ...{
    //                         if(checkIfLinkIsYouTubeLink(reactiveThread.videoUrl!)) ...{
    //                           CustomYoutubeVideoWidget(url: reactiveThread.videoUrl!, detachOnClick: false, autoplay: true,)
    //                         }else ... {
    //                           CustomRegularVideoWidget(autoPlay: true,
    //                               tag: reactiveThread.videoUrl!,
    //                               videoSource: VideoSource.mediaId, networkUrl: reactiveThread.videoUrl!, fit: BoxFit.none),
    //                         }
    //                       },
    //
    //                       /// Gif section
    //                       if(reactiveThread.gif != null) ...{
    //                         CustomGifWidget(url: reactiveThread.gif?.tiny?.url ?? '', onTap: () {
    //                           context.push(context.generateRoutePath(subLocation: "thread-images-preview"), extra: {
    //                             'thread': reactiveThread,
    //                             'galleryItems': [reactiveThread.gif?.tiny?.url ?? ''],
    //                             'initialPageIndex': 0
    //                           });
    //                         },),
    //                       },
    //
    //
    //                       /// Code section
    //                       if(!reactiveThread.code.isNullOrEmpty()) ...{
    //                         CustomCodeViewWidget(tag: reactiveThread.id.toString(), code: reactiveThread.code ?? '',
    //                           codeLanguage: reactiveThread.codeLanguage,
    //                           onTap: () {
    //                             context.push(context.generateRoutePath(subLocation: "thread-code-preview"), extra: {
    //                               'thread': reactiveThread,
    //                               'code': reactiveThread.code,
    //                               'tag': reactiveThread.id.toString()
    //                             });
    //                           },
    //                         ),
    //                       },
    //
    //                       /// Poll Section
    //                       if(reactiveThread.poll != null) ...{
    //                         Container(
    //                           color: theme.colorScheme.surface,
    //                           // padding: const EdgeInsets.only(left: threadSymmetricPadding, right: threadSymmetricPadding),
    //                           child: ThreadPollWidget(
    //                             thread:  reactiveThread,),
    //                         ),
    //                       }
    //
    //                     ],
    //                   ),
    //                 ),
    //                 /// End of thread content ---------------------------
    //
    //                 const SizedBox(height: 10,),
    //                 /// Thread action bar -----
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
    //                   child: ThreadFeedActionBarWidget(thread: reactiveThread,),
    //                 )
    //               ],
    //             );
    //           },
    //         ),
    //       ),
    //       const SliverToBoxAdapter(
    //         child: CustomBorderWidget(),
    //       )
    //     ];
    //   },
    //   body: PagedListView<int, ThreadModel>.separated(
    //     physics: const NeverScrollableScrollPhysics(),
    //     padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
    //     pagingController: state.pagingController,
    //     builderDelegate: PagedChildBuilderDelegate<ThreadModel>(
    //       itemBuilder: (context, item, index) {
    //         return BlocSelector<ThreadPreviewCubit, ThreadPreviewState, ThreadModel>(
    //           selector: (threadPreviewState) {
    //             return threadPreviewState.threadReplies[widget.thread.id]!.firstWhere((element) => element.id == item.id);
    //           },
    //           builder: (context, reactiveThread) {
    //             return ThreadReplyItemWidget(thread: reactiveThread,);
    //           },
    //         );
    //
    //       },
    //       firstPageProgressIndicatorBuilder: (_) => const Center(child: CustomAdaptiveCircularIndicator(),),
    //       newPageProgressIndicatorBuilder: (_) => const Padding(
    //           padding: EdgeInsets.only(top: 20, bottom: 20),
    //           child: SizedBox(
    //             height: 50, width: double.maxFinite,
    //             child: Align(
    //               alignment: Alignment.topCenter,
    //               child: CustomAdaptiveCircularIndicator(),
    //             ),
    //           )),
    //       noItemsFoundIndicatorBuilder: (_) => const SizedBox.shrink(),
    //       noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
    //       firstPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
    //       newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
    //     ),
    //     separatorBuilder: (context, index) => Container(
    //       height: 7,
    //       color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.background,
    //     ),
    //   ),
    // ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadPreviewPageController extends State<ThreadPreviewPage> {

  final ScrollController scrollController = ScrollController();
  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, ThreadModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);

  late ThreadPreviewCubit threadPreviewCubit;
  late StreamSubscription<ThreadPreviewState> threadPreviewStateStreamSubscription;
  @override
  Widget build(BuildContext context) => _ThreadPreviewPageView(this);

  @override
  void initState() {
    threadPreviewCubit = context.read<ThreadPreviewCubit>();
    threadPreviewCubit.setThreadPreview(thread: widget.thread);
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchThreadReplies(pageKey);
      if(response.isLeft()){
        pagingController.error = response.asLeft();
        return;
      }
      final newItems = response.asRight();
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    });
    threadPreviewStateStreamSubscription = threadPreviewCubit.stream.listen(_threadPreviewCubitListener);
    super.initState();
  }

  Future<dartz.Either<String, List<ThreadModel>>> fetchThreadReplies(int pageKey) async {
    return await threadPreviewCubit.fetchThreadComments(pageKey: pageKey, parentThread: widget.thread);
  }

  void _threadPreviewCubitListener(ThreadPreviewState event) {
    if(event.status == ThreadStatus.deleteThreadPreviewSuccessful){
      if(event.data is ThreadModel){
          final deletedThread = event.data as ThreadModel;
          if(deletedThread.id == widget.thread.id){
            context.showSnackBar("Thread deleted");
            context.pop();
          }
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

}