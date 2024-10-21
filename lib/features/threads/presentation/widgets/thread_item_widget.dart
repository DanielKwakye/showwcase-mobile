import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/communities/data/models/community_thread_tag.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_any_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_view_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_gif_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_images_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_regular_video_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_youtube_video_widget.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_comment_item_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_feed_action_bar_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_item_video_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_more_menu_action.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_poll_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ThreadItemWidget extends StatefulWidget {
  final ThreadModel threadModel;
  final bool showBoostsText;
  final bool showActionBar;
  final bool showReplies;
  final String pageName;

  final CommunityThreadTagsModel? communityThreadTag;

  ThreadItemWidget(
      {Key? key,
      required this.threadModel,
      this.showBoostsText = true,
      this.showActionBar = true,
      this.showReplies = false,
      this.communityThreadTag,
      required this.pageName})
      : super(key: key ?? ValueKey(threadModel.id));

  @override
  State<ThreadItemWidget> createState() => _ThreadItemWidgetState();
}

class _ThreadItemWidgetState extends State<ThreadItemWidget> {

  @override
  void initState() {
    AnalyticsService.instance.sendEventThreadImpression(threadModel: widget.threadModel,pageName: widget.pageName );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // AnalyticsService.instance.sendEventThreadImpression(threadModel: threadModel,pageName: pageName );

    return GestureDetector(
      onTap: () {
        context.push(
          context.generateRoutePath(subLocation: threadPreviewPage),
          extra: widget.threadModel.parent ?? widget.threadModel,
        );
        AnalyticsService.instance.sendEventThreadTap(threadModel: widget.threadModel,pageName:widget.pageName );
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /// thread content here -------------------
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SeparatedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              separatorBuilder: (BuildContext context, int index) {
                /// Spacing between each component (this creates an even spaces)
                return const SizedBox(
                  height: 8,
                );
              },
              children: [
                if (widget.threadModel.isPinned != null) ...{
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: threadSymmetricPadding),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/pin.svg',
                            colorFilter: const ColorFilter.mode(
                                kAppGold, BlendMode.srcIn),
                            height: 13),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Pinned Thread',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        )
                      ],
                    ),
                  )
                },
                // if(showBoostsText && (threadModel.boostedBy ?? []).isNotEmpty) ... {
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding),
                //     child: ThreadBoostedListWidget(thread: threadModel),
                //   )
                // },
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: threadSymmetricPadding),
                  child: GestureDetector(
                      onTap: () {
                        pushToProfile(context, user: widget.threadModel.user!);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          UserProfileIconWidget(
                            user: widget.threadModel.user!,
                            dimension: '100x',
                            networkImage: (widget.threadModel.isAnonymous ?? false)
                                ? anonymousPostUserImage
                                : null,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child:

                                /// Meta data about thread here  --------------
                                ThreadUserMetaDataWidget(
                              hideDisplayName: true,
                              thread: widget.threadModel,
                                  pageName: widget.pageName,
                            ),
                          ),

                          /// thread feed actions
                          ///
                          ThreadMoreMenuAction(
                            thread: widget.threadModel,
                            paddingRight: 0,
                          ),
                        ],
                      )),
                ),
                if (widget.communityThreadTag != null)
                  Container(
                    // alignment: Alignment.topCenter,
                    margin: const EdgeInsets.symmetric(
                        horizontal: threadSymmetricPadding),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                              '0xff${(widget.communityThreadTag?.color ?? '#A16D4F').substring(1)}'))
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.communityThreadTag?.name ?? '',
                      style: TextStyle(
                          color: Color(int.parse(
                              '0xff${(widget.communityThreadTag?.color ?? '#A16D4F').substring(1)}')),
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ),

                /// Title section
                if (!widget.threadModel.title.isNullOrEmpty()) ...{
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: threadSymmetricPadding),
                      child: Text(widget.threadModel.title ?? '',
                          style: TextStyle(
                              height: defaultLineHeight,
                              fontSize: defaultFontSize + 2,
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).colorScheme.onBackground)))
                },

                /// Message Section
                if (!widget.threadModel.message.isNullOrEmpty()) ...{
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: threadSymmetricPadding),
                    child: ThreadMessageWidget(
                      threadModel: widget.threadModel,
                      maxLines: 5,
                    ),
                  )

                  // if(isContainingAnyLink(thread.message) && thread.linkPreviewMeta == null)AnyLinkPreviewWidget(message:thread.message!,)
                },

                /// Link preview section
                if (widget.threadModel.linkPreviewMeta != null) ...{
                  CustomLinkPreviewWidget(
                    linkPreviewMeta: widget.threadModel.linkPreviewMeta!,
                    onTap: (url) {
                      context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {"url": url, "thread": widget.threadModel});
                      AnalyticsService.instance.sendEventThreadLinkTap(threadModel: widget.threadModel,pageName: widget.pageName);
                    },
                  ),
                } else if (!widget.threadModel.message.isNullOrEmpty() &&
                    isContainingAnyLink(widget.threadModel.message)) ...{
                  CustomAnyLinkPreviewWidget(
                    message: widget.threadModel.message!,
                    onTap: (url) {
                      context.push(
                          context.generateRoutePath(subLocation: threadBrowserPage), extra: {"url": url, "thread": widget.threadModel});
                      AnalyticsService.instance.sendEventThreadLinkTap(threadModel: widget.threadModel,pageName: widget.pageName);
                    },
                  )
                },

                /// Images section
                if ((widget.threadModel.images ?? []).isNotEmpty) ...{
                  CustomImagesWidget(
                    images: widget.threadModel.images ?? [],
                    compress: true,
                    onTap: (index, images) {
                      context.push(
                          context.generateRoutePath(
                              subLocation: threadImagesPreviewPage),
                          extra: {
                            'thread': widget.threadModel,
                            'galleryItems': images,
                            'initialPageIndex': index
                          });
                    },
                  ),
                },

                /// Video section
                if (!widget.threadModel.videoUrl.isNullOrEmpty()) ...{
                  if (checkIfLinkIsYouTubeLink(widget.threadModel.videoUrl!)) ...{
                    CustomYoutubeVideoWidget(
                      url: widget.threadModel.videoUrl!,
                      detachOnClick: false,
                      autoplay: false,
                      onTap: () {
                        context.push(
                            context.generateRoutePath(
                                subLocation: threadBrowserPage),
                            extra: {
                              "url": widget.threadModel.videoUrl!,
                              "thread": widget.threadModel
                            });
                      },
                    )
                  } else ...{
                    ThreadItemVideoWidget(threadModel: widget.threadModel,)
                  }
                },

                /// Gif section
                if (widget.threadModel.gif != null) ...{
                  CustomGifWidget(
                    url: widget.threadModel.gif?.tiny?.url ?? '',
                    onTap: () {
                      context.push(
                          context.generateRoutePath(
                              subLocation: threadImagesPreviewPage),
                          extra: {
                            'thread': widget.threadModel,
                            'galleryItems': [widget.threadModel.gif?.tiny?.url ?? ''],
                            'initialPageIndex': 0
                          });
                    },
                  ),
                },

                /// Code section
                if (!widget.threadModel.code.isNullOrEmpty()) ...{
                  CustomCodeViewWidget(
                    tag: widget.threadModel.id.toString(),
                    code: widget.threadModel.code ?? '',
                    codeLanguage: widget.threadModel.codeLanguage,
                    onTap: (code, language) {
                      context.push(
                          context.generateRoutePath(
                              subLocation: threadCodePreviewPage),
                          extra: {
                            'thread': widget.threadModel,
                            'code': widget.threadModel.code,
                            'tag': widget.threadModel.id.toString()
                          });
                    },
                  ),
                },

                /// Poll Section
                if (widget.threadModel.poll != null) ...{
                  Container(
                    color: theme.colorScheme.surface,
                    // padding: const EdgeInsets.only(left: threadSymmetricPadding, right: threadSymmetricPadding),
                    child: ThreadPollWidget(
                      thread: widget.threadModel,
                    ),
                  ),
                }
              ],
            ),
          ),

          /// End of thread content ---------------------------

          const SizedBox(
            height: 10,
          ),

          /// Thread action bar -----
          if (widget.showActionBar) ...{
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: threadSymmetricPadding),
              child: ThreadFeedActionBarWidget(
                thread: widget.threadModel,
              ),
            ),
          },

          /// Thread replies if any-
          if (widget.showReplies) ...{
            if (widget.threadModel.replies != null &&
                widget.threadModel.replies!.isNotEmpty) ...[
              /// border

              const CustomBorderWidget(
                left: threadSymmetricPadding,
                right: threadSymmetricPadding,
                bottom: 15,
              ),

              /// Thread replies here -----
              ...widget.threadModel.replies!.take(2).toList().map((reply) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: 0,
                      right: 0,
                      bottom: (widget.threadModel.totalReplies != null &&
                              widget.threadModel.totalReplies! > 2)
                          ? 0
                          : 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // const SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () {
                          context.push(
                              context.generateRoutePath(
                                  subLocation: threadPreviewPage),
                              extra: reply);
                        },
                        child: ThreadCommentItemWidget(
                          comment: reply,
                          thread: widget.threadModel,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // view all comments //////
              if ((widget.threadModel.totalReplies != null &&
                  widget.threadModel.totalReplies! > 2)) ...{
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextButton(
                    onPressed: () {
                      context.push(
                          context.generateRoutePath(
                              subLocation: threadPreviewPage),
                          extra: widget.threadModel);
                    },
                    child: const Text(
                      "View All Comments",
                      style: TextStyle(color: kAppBlue),
                    ),
                  ),
                )
              }
            ],
          }
        ],
      ),
    );
  }
}
