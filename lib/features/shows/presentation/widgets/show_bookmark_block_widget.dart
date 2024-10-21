import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_play_icon.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_item_widget.dart';

class ShowBookmarkBlockWidget extends StatelessWidget with LaunchExternalAppMixin {

  final ShowModel show;
  final ShowBlockModel block;
  const ShowBookmarkBlockWidget({
    required this.show,
    required this.block,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(block.bookmarkBlock?.preview == null) return const SizedBox.shrink();

    final linkPreviewMeta = block.bookmarkBlock!.preview!;

    if(linkPreviewMeta.type == "thread" && linkPreviewMeta.thread != null){
      return ThreadItemWidget(threadModel: linkPreviewMeta.thread!,pageName: 'show_bookmark_block',);
    }

    String title = "";
    String? subTitle;
    String link = "";
    String? imageUrl;
    Function()? onTap;
    VideoType? videoType;


    /// link preview can be external
    if (linkPreviewMeta.type == "external"){
      title = linkPreviewMeta.title ?? "";
      subTitle = linkPreviewMeta.description ?? "";
      link = linkPreviewMeta.url ?? "";
      if(linkPreviewMeta.images != null && linkPreviewMeta.images!.isNotEmpty){
        imageUrl = linkPreviewMeta.images!.first;
      }

      /// In-app preview for youtube videos
      if(checkIfLinkIsYouTubeLink(link)){
        videoType = VideoType.youtube;
        onTap = () {
          // return changeScreenWithConstructor(context, VideoPreviewPage(
          //   videoUrl: link,
          //   thumbNailImageUrl: imageUrl,
          //   videoType: videoType!));

          // launchBrowser(link, context);
          context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
            "show": show,
            "url" : link
          });

        };
      }else{
        onTap = () => launchBrowser(link, context);
      }

    }
    /// return nothing if link preview type has not been captured yet
    else {
      return const SizedBox.shrink();
    }

    if(title.isEmpty && link.isEmpty){
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(5)
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if(!imageUrl.isNullOrEmpty())...{
              _leadingImage(imageUrl, videoType),
              const SizedBox(height: 10,),
            },
            if(title.isNotEmpty)...{
              Text(title,
                style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10,),
            },
            if(subTitle.isNotEmpty)...{
              Text(subTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.colorScheme.onPrimary,),
              ),
              const SizedBox(height: 10,),
            },
            if(link.isNotEmpty)...{
              Row(
                children: [
                  SvgPicture.asset(kLinkIconSvg, color: theme.colorScheme.onPrimary,),
                  Expanded(child: Text(link,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.colorScheme.onPrimary,),
                  ))
                ],
              ),
            }
          ],
        ),
      ),
    );
  }

  Widget _leadingImage(String? imageUrl, VideoType? videoType, { double maxHeight = 200} ) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5)
      ),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl!,
            errorWidget: (context, url, error) => const SizedBox.shrink(),
            placeholder: (ctx, url) => const Center(child: CupertinoActivityIndicator(),),
            cacheKey: 'link-$imageUrl',
            fit: BoxFit.cover,
          ),
          if(videoType != null && videoType == VideoType.youtube) ...{
            const CustomPlayIcon()
          }
        ],
      ),

    );
  }

}
