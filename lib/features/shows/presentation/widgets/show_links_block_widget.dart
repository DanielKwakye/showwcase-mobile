import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class ShowLinksBlockWidget extends StatelessWidget with LaunchExternalAppMixin {

  final ShowBlockModel block;
  final ShowModel show;
  const ShowLinksBlockWidget({required this.block,
    required this.show,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(block.linksBlock?.links == null) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return StaggeredGrid.count(
        crossAxisCount: block.linksBlock!.links!.length == 1 ? 1 : 2, // if images are more that 1 show 2 on a row
        crossAxisSpacing: 10,
        children: [
          ...block.linksBlock!.links!.map((linkPreviewMeta) {

            String title = "";
            String link = "";
            Function()? onTap;
            VideoType? videoType;

            title = linkPreviewMeta.title ?? "";
            link = linkPreviewMeta.value ?? "";


            /// In-app preview for youtube videos
            if(checkIfLinkIsYouTubeLink(link)){
              videoType = VideoType.youtube;
              onTap = () {
              //   return changeScreenWithConstructor(context, VideoPreviewPage(
              //     videoUrl: link,
              //     videoType: videoType!
              // ));
              //   launchBrowser(link, context);
                context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
                  "show": show,
                  "url" : link
                });
              };
            }else{
              onTap = () {

                context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
                  "show": show,
                  "url" : link
                });

              };


            }


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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    if(title.isNotEmpty)...{
                      Text(title,
                        style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),
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

          })
        ],

    );
  }

}
