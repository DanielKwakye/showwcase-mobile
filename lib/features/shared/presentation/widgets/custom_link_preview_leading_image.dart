import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shared/presentation/pages/youtube_preview_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_play_icon.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_youtube_video_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/utils/enums.dart';


class CustomLinkPreviewLeadingImage extends StatefulWidget {
  final String? imageUrl;
  final VideoType? videoType;
  final String link;
  final Function(String) onTap;
  const CustomLinkPreviewLeadingImage({Key? key,
    this.imageUrl,
    this.videoType,
    required this.link,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomLinkPreviewLeadingImage> createState() => _CustomLinkPreviewLeadingImageState();
}

class _CustomLinkPreviewLeadingImageState extends State<CustomLinkPreviewLeadingImage> {

  bool playYoutubeVid = false;

  @override
  Widget build(BuildContext context) {
    final isSvg = widget.imageUrl?.endsWith('.svg');
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);


    // To improve performance CachedNetworkImage  resize the image
    final desiredWidth = size.width;
    double aspectRatio = 16 / 9;
    final  desiredHeight = desiredWidth / aspectRatio;

    return Container(
      // constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5)
      ),
      child: (isSvg != null && isSvg == true) ? SizedBox(
        width: size.width,

        child: SvgPicture.network(
          widget.imageUrl ?? '',
          fit: BoxFit.cover,
          height: desiredHeight,
          placeholderBuilder: (ctx) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          },
        ),
      )
          : Stack(
        children: [
          if(widget.videoType == VideoType.youtube) ... {
            // CustomVideoWidget(block: Block(videoBlock: VideoBlock(url: link)), autoPlay: true,)
            // videoId = YoutubePlayer.convertUrlToId(widget.url);
            // CustomYoutubeVideoWidget(url: link, detachOnClick: true, autoplay: false, mute: true, onDetachedVideoExternalLinkTapped: (){
            //   onTap.call(link);
            // }, onTap: () {
            //   onTap.call(link);
            // },)
            //
            //
            if(playYoutubeVid) ... {
              CustomYoutubeVideoWidget(url: widget.link, detachOnClick: true,
                autoplay: false, mute: false,
                playDetachedVideo: true,
                onDetachedVideoExternalLinkTapped: (){
              // widget.onTap.call(widget.link);
              //     pushScreen(context, YoutubePreviewPage(url: widget.link), fullscreenDialog: true);
                  context.push(youtubePreviewPage, extra: widget.link);
              }, onTap: () {
              widget.onTap.call(widget.link);
              },)
            }else ... {

              AspectRatio(
                aspectRatio: 16 / 9,
                child: GestureDetector(
                  onTap: () {
                    setState((){
                      playYoutubeVid = true;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [
                      Container(
                        color: theme.colorScheme.surface,
                        width: size.width, // makes image perfectly fit screen width
                        // height: desiredHeight,
                        child: CachedNetworkImage(
                          imageUrl: getYoutubeThumbnail(videoId: YoutubePlayer.convertUrlToId(widget.link)!),
                          // maxHeightDiskCache: desiredHeight.toInt(), // this is to reduce the resolution of the image for faster rendering
                          maxHeightDiskCache: desiredHeight.toInt(), // this is to reduce the resolution of the image for faster rendering
                          // maxWidthDiskCache: desiredWidth.toInt(),
                          errorWidget: (context, url, error) =>
                          const SizedBox.shrink(),
                          // placeholder: (ctx, url) => const AspectRatio(
                          //   aspectRatio: 16 / 9,
                          //   child: Center(
                          //     child: CupertinoActivityIndicator(),
                          //   ),
                          // ),
                          placeholder: (ctx, url) {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          },
                          cacheKey: 'link-${widget.imageUrl}',
                          fit: BoxFit.cover,
                          // imageBuilder: (ctx, imageProvider) {
                          //   return NetworkImage(imageProvider.u);
                          // },
                        ),
                      ),
                      const CustomPlayIcon()
                    ],
                  ),
                ),
              )

            }


          }else ... {
            // image was here
            Container(
              color: theme.colorScheme.surface,
              width: size.width, // makes image perfectly fit screen width
              // height: desiredHeight,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl ?? '',
                maxHeightDiskCache: 500, // this is to reduce the resolution of the image for faster rendering
                // maxWidthDiskCache: desiredWidth.toInt(),
                errorWidget: (context, url, error) =>
                const SizedBox.shrink(),
                // placeholder: (ctx, url) => const AspectRatio(
                //   aspectRatio: 16 / 9,
                //   child: Center(
                //     child: CupertinoActivityIndicator(),
                //   ),
                // ),
                placeholder: (ctx, url) {
                  return const SizedBox.shrink();
                },
                cacheKey: 'link-${widget.imageUrl}',
                fit: BoxFit.cover,
                // imageBuilder: (ctx, imageProvider) {
                //   return NetworkImage(imageProvider.u);
                // },
              ),
            ),
          },

          // if (videoType == VideoType.youtube) ...{
          //   const AspectRatio(
          //     aspectRatio: 16 / 9,
          //     child: Center(
          //       child: CustomPlayIcon(),
          //     ),
          //   )
          // }
        ],
      ),
    );
  }
}
