import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_any_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_view_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_images_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_markdown_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_bookmark_block_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_content_image_block_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_content_text_block_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_content_video_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_gist_block_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_links_block_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_skills_techs_block_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_statistics_block_widget.dart';

class ShowBlocksContentWidget extends StatelessWidget {
  final ShowBlockModel block;
  final ShowModel show;

  const ShowBlocksContentWidget({required this.block, required this.show, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);


    switch(block.projectBlockType) {
      case 1: // text block [from 1 -
        return ShowContentTextBlockWidget(block: block);
      case 3: // skill set block
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: ShowSkillsTechsBlockWidget(block: block, show: show),
        );
      case 4: // image block
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: ShowContentImageBlockWidget(block: block, show: show,),
        );
      case 5: //video block
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Builder(
            builder: (_) {
              final url = block.videoBlock?.url;
              if(url != null) {
                return ShowContentVideoWidget(videoUrl: url, show: show, );
              }
              return const SizedBox.shrink();
            }
          ),
        );
      case 6: // statisticsBlock
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
          child: ShowStatisticsBlockWidget(block: block, show: show,),
        );
      case 7: // Divider
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
          child: Divider(color: theme.colorScheme.outline,),
        );
      case 9: //galleryBlock
        return Builder(
          builder: (_) {
            if((block.galleryBlock?.images ?? []).isEmpty) return const SizedBox.shrink();
            final images = block.galleryBlock!.images!.where((element) => !element.url.isNullOrEmpty()).map((e) => e.url!).toList();
            if(images.isEmpty) return const SizedBox.shrink();
            return CustomImagesWidget(images: images, onTap: (index, images) {
              context.push(context.generateRoutePath(subLocation: showImagesPreviewPage), extra: {
                'show': show,
                'galleryItems': images,
                'initialPageIndex': index
              });
            },);
          }
        );
      case 10: //code
        if(block.codeBlock?.code == null || block.codeBlock!.code!.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: CustomCodeViewWidget(tag: show.id.toString(), code: block.codeBlock!.code!, codeLanguage: block.codeBlock?.language,
            onTap: (code, language) {
              context.push(context.generateRoutePath(subLocation: showCodePreviewPage), extra: {
                "show": show,
                "code" : block.codeBlock!.code!,
                "tag" : show.id.toString()
              });
            },
          ),
        );

      case 11: // markdown block
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: CustomMarkdownWidget(markdown: block.markdownBlock?.markdown ?? ''),
        );
      case 12: // gist block
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: ShowGistBlockWidget(block: block, show: show,),
        );
      case 13: // linksBlock
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: ShowLinksBlockWidget(block: block, show: show,),
        );
      case 14: // tweetBlock
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: CustomAnyLinkPreviewWidget(message: block.tweetBlock?.url ?? '', onTap: (link){
            context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
              "show": show,
              "url" : link
            });
          },),
        );
      case 15: // threadBlock
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: CustomAnyLinkPreviewWidget(message: block.threadBlock?.url ?? '',
              onTap: (link) {
                context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
                  "show": show,
                  "url" : link
                });
              },
          ),
        );
      case 16: //BookmarkBlock bookmarkBlock;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: ShowBookmarkBlockWidget(show: show, block: block,),
        );

    }

    return const SizedBox.shrink();
  }
}
