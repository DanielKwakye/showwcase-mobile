import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/series_item_projects_widget.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_link_preview_meta_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_link_preview_leading_image.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_user_meta_data_widget.dart';


class CustomLinkPreviewWidget extends StatelessWidget {

  final SharedLinkPreviewMetaModel linkPreviewMeta;
  final Function(String)? onTap;
  const CustomLinkPreviewWidget({
    required this.linkPreviewMeta,
    this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unescape = HtmlUnescape();

    //int? id;
    ThreadModel? linkPreviewThread;
    SeriesModel? seriesPreviewThread;
    String title = "";
    String? subTitle;
    String link = "";
    String? imageUrl;
    Function()? onLinkTapped;
    VideoType? videoType;

    /// link preview can be a project
    if(linkPreviewMeta.type?.toLowerCase() == "project" && linkPreviewMeta.project?.user?.username != null){
      final id = linkPreviewMeta.project?.id ?? "";
      title = linkPreviewMeta.project!.title ?? "";
      // link = "${ApiConfig.baseUrl}/${linkPreviewMeta.project!.slug}";
      final slug = linkPreviewMeta.project!.slug;
      if(linkPreviewMeta.project!.coverImage != null){
        imageUrl = linkPreviewMeta.project!.coverImage!;
      }else{
        imageUrl = kExternalShowwcaseBanner;
      }
      link = "${ApiConfig.websiteUrl}/show/$id/$slug";
      onLinkTapped = () {
        // onTap?.call(link);
        context.read<HomeCubit>().redirectLinkToPage(url: link, fallBackRoutePath: browserPage, fallBackRoutePathData:  link);
      };
    }

    else if (linkPreviewMeta.type == "thread" && linkPreviewMeta.thread?.user?.username != null) {
      final id = linkPreviewMeta.thread?.id ?? "";
      linkPreviewThread = linkPreviewMeta.thread;
      subTitle = linkPreviewMeta.thread?.message ?? "";
      link = "${ApiConfig.websiteUrl}/thread/$id";
      debugPrint("link-> $link");
      final images = linkPreviewMeta.thread?.images ?? [];
      if(images.isNotEmpty) {
        imageUrl = images.first;
      }

      onLinkTapped = () {
        context.read<HomeCubit>().redirectLinkToPage(url: link, fallBackRoutePath: browserPage, fallBackRoutePathData:  link);
        // onTap?.call(link);
      };
    }

    /// link preview can be external
    else if (linkPreviewMeta.type == "external"){
      title = linkPreviewMeta.title ?? "";
      subTitle = linkPreviewMeta.description ?? "";
      link = linkPreviewMeta.url ?? "";
      if(linkPreviewMeta.images != null && linkPreviewMeta.images!.isNotEmpty){
        imageUrl = linkPreviewMeta.images!.first;
      }

      /// In-app preview for youtube videos
      if(checkIfLinkIsYouTubeLink(link)){
        videoType = VideoType.youtube;
      }

      onLinkTapped = () {
        // return launchBrowser(link, context);
        onTap?.call(link);
      };

    }

    /// series meta
    else if (linkPreviewMeta.type == "series") {


      final id = linkPreviewMeta.series?.id ?? "";
      final slug = linkPreviewMeta.series?.slug ?? "";
      imageUrl = linkPreviewMeta.series!.coverImageKey;
      if(imageUrl != null && imageUrl != ""){
        imageUrl = getProjectImage(imageUrl);
      }
      title = linkPreviewMeta.series!.title ?? '';
      subTitle = linkPreviewMeta.series!.description;
      link = "${ApiConfig.websiteUrl}/series/$id/$slug";
      seriesPreviewThread = linkPreviewMeta.series;
      debugPrint("$linkPreviewMeta");

      onLinkTapped = () {

        context.read<HomeCubit>().redirectLinkToPage(url: link, fallBackRoutePath: browserPage, fallBackRoutePathData: link);

        // onTap?.call(link);
        // return launchBrowser(link, context);
        // preview notification from a thread
        // changeScreenWithConstructor(context, SeriesPreviewPage(seriesItem: linkPreviewMeta.series!, itemIndex: 0),args: {'page_title':'series_preview','page_id': id});
      };

    }

    /// community meta
    else if (linkPreviewMeta.type == "community") {
      final slug = linkPreviewMeta.communityModel?.slug ?? "";
       imageUrl = linkPreviewMeta.communityModel!.coverImageKey;
      if(imageUrl != null && imageUrl != ""){
        imageUrl = getProjectImage(imageUrl);
      }
       title = linkPreviewMeta.communityModel!.name ?? '';
      subTitle = linkPreviewMeta.communityModel!.description;
      link = "${ApiConfig.websiteUrl}/community/$slug";
      debugPrint("$linkPreviewMeta");

      onLinkTapped = () {
        // onTap?.call(link);
        context.read<HomeCubit>().redirectLinkToPage(url: link, fallBackRoutePath: browserPage, fallBackRoutePathData: link);
        // changeScreenWithConstructor(context, CommunitiesFeeds( slug:slug),args: {'page_title':'communities_feed','page_id': id});
      };

    }

    /// return nothing if link preview type has not been captured yet
    // else if(linkPreviewMeta.type == "thread") {
    //   if(thread?.message == null) {
    //     return const SizedBox.shrink();
    //   }
    //   return  CustomAnyLinkPreviewWidget(message:thread!.message!,);
    // }

    if(title.isEmpty && link.isEmpty){
      return const SizedBox.shrink();
    }

    // logger.i('link preveiw: image url: $imageUrl');

    return GestureDetector(
      // onTap: videoType == onTap,
      onTap: onLinkTapped,
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: theme.colorScheme.outline),
          // color: theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xff202021),
          color: theme.colorScheme.surface,
        ),
        padding: EdgeInsets.only(top: imageUrl.isNullOrEmpty() ? 15: 0 , bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if(!imageUrl.isNullOrEmpty())...{
               Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: CustomLinkPreviewLeadingImage(imageUrl: imageUrl, videoType: videoType, link: link, onTap: (link){
                  context.read<HomeCubit>().redirectLinkToPage(url: link, fallBackRoutePath: browserPage, fallBackRoutePathData: link);
                  // onTap?.call(link);
                },),
              ),
              const SizedBox(height: 10,),
            },

            if(linkPreviewThread != null)...{
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    CustomUserAvatarWidget(
                        username: linkPreviewThread.user?.username ??'',
                        size: 30,
                        networkImage: linkPreviewThread.user!.profilePictureKey,
                      borderSize: 0,
                    ),
                    const SizedBox(width: 10,),
                    Expanded(child: ThreadUserMetaDataWidget(thread: linkPreviewThread,pageName: 'custom_link_preview', ))
                  ],
                ),
              ),
              const SizedBox(height: 10,),
            },

            if(title.isNotEmpty)...{
             Padding(
               padding: const EdgeInsets.only(left: 15, right: 15),
               child: Text(unescape.convert(title),
                 style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),
               ),
             ),
             const SizedBox(height: 10,),
           },

           if(subTitle != null && subTitle.isNotEmpty)...{
             Padding(
               padding: const EdgeInsets.only(left: 15, right: 15),
               child: Text(unescape.convert(subTitle),
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: TextStyle(color: theme.colorScheme.onPrimary,),
               ),
             ),
             const SizedBox(height: 10,),
           },
            if(link.isNotEmpty)...{
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    SvgPicture.asset(kLinkIconSvg, color: theme.colorScheme.onPrimary,),
                    Expanded(child: Text(link,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.colorScheme.onPrimary,),
                    ))
                  ],
                ),
              ),
             // const SizedBox(height: 10,),
            },
            if(seriesPreviewThread != null) ...{
              // implement series preview when series widget is done
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IgnorePointer(
                  ignoring: true,
                  child: SeriesItemProjectsWidget(
                    seriesItem: seriesPreviewThread,
                    projects: seriesPreviewThread.projects?.take(3).toList() ?? <ShowModel>[],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
            }
          ],
        ),
      ),
    );
  }


}
