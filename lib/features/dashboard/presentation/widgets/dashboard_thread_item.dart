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
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_any_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_view_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_gif_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_images_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_regular_video_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_youtube_video_widget.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_preview_page.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_boosted_list_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_item_video_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_poll_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

class DashboardThreadItemWidget extends StatelessWidget {
  final ThreadModel threadModel;
  final bool showBoostsText;

  DashboardThreadItemWidget(
      {Key? key, required this.threadModel, this.showBoostsText = true})
      : super(key: ValueKey(threadModel.id));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // context.push(threadPreviewPage, extra: threadModel);
        // pushScreen(context, ThreadPreviewPage(thread: threadModel));
        context.push(
          context.generateRoutePath(subLocation: threadPreviewPage),
          extra: threadModel.parent ?? threadModel,
        );
      },
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
                if (threadModel.isPinned != null) ...{
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
                if (showBoostsText &&
                    (threadModel.boostedBy ?? []).isNotEmpty) ...{
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: threadSymmetricPadding),
                    child: ThreadBoostedListWidget(thread: threadModel),
                  )
                },
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: threadSymmetricPadding),
                  child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          UserProfileIconWidget(
                            user: threadModel.user!,
                            dimension: '100x',
                            size: 50,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child:

                                /// Meta data about thread here  --------------
                                ThreadUserMetaDataWidget(
                              thread: threadModel,
                                  pageName: "dashboard_thread",
                            ),
                          )
                        ],
                      )),
                ),

                /// Title section
                if (!threadModel.title.isNullOrEmpty()) ...{
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: threadSymmetricPadding),
                      child: Text(threadModel.title ?? '',
                          style: TextStyle(
                              height: defaultLineHeight,
                              fontSize: defaultFontSize + 2,
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).colorScheme.onBackground)))
                },

                /// Message Section
                if (!threadModel.message.isNullOrEmpty()) ...{
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: threadSymmetricPadding),
                    child: ThreadMessageWidget(
                      threadModel: threadModel,
                      maxLines: 5,
                    ),
                  )

                  // if(isContainingAnyLink(thread.message) && thread.linkPreviewMeta == null)AnyLinkPreviewWidget(message:thread.message!,)
                },

                /// Link preview section
                if(threadModel.linkPreviewMeta != null )...{
                  CustomLinkPreviewWidget(linkPreviewMeta: threadModel.linkPreviewMeta!, onTap: (url) {
                    context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {
                      "url": url,
                      "thread": threadModel
                    });
                  },),
                }else if(!threadModel.message.isNullOrEmpty() && isContainingAnyLink(threadModel.message)) ...{
                  CustomAnyLinkPreviewWidget(message:threadModel.message!, onTap: (url) {
                    context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {
                      "url": url,
                      "thread": threadModel
                    });
                  },)
                },

                /// Images section
                if((threadModel.images ?? []).isNotEmpty) ...{
                  CustomImagesWidget(
                    images: threadModel.images ?? [],
                    onTap: (index, images){
                      context.push(context.generateRoutePath(subLocation: "thread-images-preview"), extra: {
                        'thread': threadModel,
                        'galleryItems': images,
                        'initialPageIndex': index
                      });
                    },
                  ),
                },

                /// Video section
                if (!threadModel.videoUrl.isNullOrEmpty()) ...{
                  if (checkIfLinkIsYouTubeLink(threadModel.videoUrl!)) ...{
                    CustomYoutubeVideoWidget(
                      url: threadModel.videoUrl!,
                      detachOnClick: false,
                      autoplay: false,
                      onTap: () {
                        context.push(
                            context.generateRoutePath(
                                subLocation: threadBrowserPage),
                            extra: {
                              "url": threadModel.videoUrl!,
                              "thread": threadModel
                            });
                      },
                    )
                  } else ...{
                    ThreadItemVideoWidget(threadModel: threadModel,)
                  }
                },

                /// Gif section
                if(threadModel.gif != null) ...{
                  CustomGifWidget(url: threadModel.gif?.tiny?.url ?? '', onTap: () {
                    context.push(context.generateRoutePath(subLocation: "thread-images-preview"), extra: {
                      'thread': threadModel,
                      'galleryItems': [threadModel.gif?.tiny?.url ?? ''],
                      'initialPageIndex': 0
                    });
                  },),
                },

                /// Code section
                if(!threadModel.code.isNullOrEmpty()) ...{
                  CustomCodeViewWidget(tag: threadModel.id.toString(), code: threadModel.code ?? '',
                    codeLanguage: threadModel.codeLanguage,
                    onTap: (code, language) {
                      context.push(context.generateRoutePath(subLocation: "thread-code-preview"), extra: {
                        'thread': threadModel,
                        'code': threadModel.code,
                        'tag': threadModel.id.toString()
                      });
                    },
                  ),
                },

                /// Poll Section
                if (threadModel.poll != null) ...{
                  Container(
                    color: theme.colorScheme.surface,
                    // padding: const EdgeInsets.only(left: threadSymmetricPadding, right: threadSymmetricPadding),
                    child: ThreadPollWidget(
                      thread: threadModel,
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

          /// Thread stats bar -----
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Impressions',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${(threadModel.views ?? 0) + (threadModel.visits ?? 0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Views',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${threadModel.views}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 20,
                ),
                const Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Interactions',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 20,
                ),
                const Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Engagement',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}
