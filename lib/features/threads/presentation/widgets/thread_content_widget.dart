import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_any_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_view_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_gif_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_images_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_link_preview_widget.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';

class ThreadContentWidget extends StatelessWidget {

  final ThreadModel thread;
  const ThreadContentWidget({Key? key, required this.thread}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
        separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10,);
      },

      children: [
        //! Title section
        if (!thread.title.isNullOrEmpty()) ...{
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(thread.title ?? '',
                  style: TextStyle(
                      height: defaultLineHeight,
                      fontSize: defaultFontSize + 2,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onBackground)))
        },

        // /// Message Section
        if (!thread.message.isNullOrEmpty()) ...{
          ThreadMessageWidget(
            threadModel: thread,
          )
          // if(isContainingAnyLink(thread.message) && thread.linkPreviewMeta == null)AnyLinkPreviewWidget(message:thread.message!,)
        },

        /// Link preview section
        if (thread.linkPreviewMeta != null) ...{
          CustomLinkPreviewWidget(
            linkPreviewMeta: thread.linkPreviewMeta!,
            onTap: (url) => context.push(
                context.generateRoutePath(
                  subLocation: threadBrowserPage,
                ),
                extra: {"url": url, "thread": thread}),
          ),
        } else if (!thread.message.isNullOrEmpty() &&
            isContainingAnyLink(thread.message)) ...{
          CustomAnyLinkPreviewWidget(
            message: thread.message!,
            onTap: (url) {
              context.push(
                  context.generateRoutePath(subLocation: threadBrowserPage),
                  extra: {"url": url, "thread": thread});
            },
          )
        },

        /// Images section
        if ((thread.images ?? []).isNotEmpty) ...{
          CustomImagesWidget(
            images: thread.images ?? [],
            onTap: (index, images) {
              context.push(
                  context.generateRoutePath(
                      subLocation: threadImagesPreviewPage),
                  extra: {
                    'thread': thread,
                    'galleryItems': images,
                    'initialPageIndex': index
                  });
            },
          ),
        },

        /// Gif section
        if (thread.gif != null) ...{
          CustomGifWidget(
            url: thread.gif?.tiny?.url ?? '',
            onTap: () {
              context.push(
                  context.generateRoutePath(
                      subLocation: threadImagesPreviewPage),
                  extra: {
                    'thread': thread,
                    'galleryItems': [thread.gif?.tiny?.url ?? ''],
                    'initialPageIndex': 0
                  });
            },
          ),
        },

        /// Code section
        if (!thread.code.isNullOrEmpty()) ...{
          CustomCodeViewWidget(
            tag: thread.id.toString(),
            code: thread.code ?? '',
            codeLanguage: thread.codeLanguage,
            onTap: (code, language) {
              context.push(
                  context.generateRoutePath(subLocation: threadCodePreviewPage),
                  extra: {
                    'thread': thread,
                    'code': thread.code,
                    'tag': thread.id.toString()
                  });
            },
          ),
        },
      ],
    );
  }
}
