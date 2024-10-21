import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_regular_video_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

import '../../../../core/utils/functions.dart';
import '../../../shared/presentation/widgets/custom_youtube_video_widget.dart';

class ShowContentVideoWidget extends StatelessWidget {

  final String videoUrl;
  final String? caption;
  final ShowModel show;
  const ShowContentVideoWidget({Key? key, required this.videoUrl, this.caption, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SeparatedColumn(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10,);
      },
      children: [
        /// Video section
        if(!videoUrl.isNullOrEmpty()) ...{
          if(checkIfLinkIsYouTubeLink(videoUrl)) ...{
            CustomYoutubeVideoWidget(url:videoUrl, detachOnClick: false, autoplay: true, onTap: (){
              // context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
              //   "show": show,
              //   "url" : videoUrl
              // });
              context.push(youtubePreviewPage, extra: videoUrl);
            }, pauseVideoOnTap: true,)
          }else ... {
            CustomRegularVideoWidget(
              autoPlay: true, videoSource: VideoSource.network,
              tag: videoUrl,
              networkUrl: videoUrl, onTap: (){
              context.push(context.generateRoutePath(subLocation: showVideoPreviewPage), extra: {
                "show": show,
                "url" : videoUrl
              });
            },),
          }
        },
        if(!caption.isNullOrEmpty()) ... {
          SizedBox(width: double.maxFinite,
              child : Text(caption!, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center,)
          )
        }
      ],
    );
  }
}
