import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:url_launcher/url_launcher.dart';


/// In this mix all methods related to launch applications including browser, tel, email can be here
mixin LaunchExternalAppMixin {

  launchBrowser(String url, BuildContext context, {bool launchExtBrowserStrictly = false, bool launchInternalBrowserStrictly = false}) async{
    final launchUri = Uri.encodeFull(url.trim());
    try{

      const showLink = "https://www.showwcase.com/show/";
      const threadLink = "https://www.showwcase.com/thread/";
      const communityLink = "https://www.showwcase.com/community/";
      const seriesLink = "https://www.showwcase.com/series/";
      const jobLink = "https://www.showwcase.com/job/";
      const jobsLink = "https://www.showwcase.com/jobs";
      const userLinkProbably = "https://www.showwcase.com/";


      // check if word is a link to a show
      if( !launchInternalBrowserStrictly && !launchExtBrowserStrictly && url.startsWith(showLink)){
        // then this is a show
        const lengthOfShowUrl = showLink.length;
        final newWord = url.substring(lengthOfShowUrl);
        final newWordSplit = newWord.split('/');
        var showIdInString = newWordSplit.first;
        final showId = int.tryParse(showIdInString);
        if(showId != null){
          openShow(context, showId: showId);
          return;
        }

      }

      // check if word is a link to a show
      if(!launchInternalBrowserStrictly && !launchExtBrowserStrictly && url.startsWith(threadLink)){
        // then this is a show
        const lengthOfThreadUrl = threadLink.length;
        final newWord = url.substring(lengthOfThreadUrl);
        final newWordSplit = newWord.split('/');
        var threadIdInString = newWordSplit.first;
        final threadId = int.tryParse(threadIdInString);
        if(threadId != null){
          openThread(context, threadId: threadId);
          return;
        }
      }

      // check if word is a link to a community
      if(!launchInternalBrowserStrictly && !launchExtBrowserStrictly && url.startsWith(communityLink)){
        // then this is a community
        const lengthOfCommunityUrl = communityLink.length;
        final newWord = url.substring(lengthOfCommunityUrl);
        final newWordSplit = newWord.split('/');
        var communitySlug = newWordSplit.last;
        openCommunity(context, slug: communitySlug);
        return;
      }

      // check if word is a link to a series
      if(!launchInternalBrowserStrictly && !launchExtBrowserStrictly && url.startsWith(seriesLink)){
        // then this is a community
        const lengthOfSeriesUrl = seriesLink.length;
        final newWord = url.substring(lengthOfSeriesUrl);
        final newWordSplit = newWord.split('/');
        var seriesIdInString = newWordSplit.first;
        final seriesId = int.tryParse(seriesIdInString);
        if(seriesId != null) {
          openSeries(context, seriesId: seriesId);
          return;
        }
      }

      // check if word is a link to a job
      if(!launchInternalBrowserStrictly && !launchExtBrowserStrictly && url.startsWith(jobLink)){
        // then this is a community
        const lengthOfJobUrl = jobLink.length;
        final newWord = url.substring(lengthOfJobUrl);
        final newWordSplit = newWord.split('/');
        var jobIdAndSlug = newWordSplit.first;
        final jobIdInString = jobIdAndSlug.split('-').first;
        final jobId = int.tryParse(jobIdInString);
        if(jobId != null) {
          openJob(context, jobId: jobId);
          return;
        }
      }

      // check if word is a link to a user /// this if should always run last
      if(!launchInternalBrowserStrictly && !launchExtBrowserStrictly && url.startsWith(userLinkProbably)){
        // then this is a community
        if(!url.startsWith(jobsLink)) {
          const lengthOfUserLinkProbably = userLinkProbably.length;
          final newWord = url.substring(lengthOfUserLinkProbably);
          final newWordSplit = newWord.split('/');
          if(newWordSplit.length == 1) {
            // if its a user profile then the newWordSplit should always be 1
            // and that's the user name
            final username = newWordSplit.first;
            if(username.isNotEmpty) {
              openUserProfile(context, username: username);
              return;
            }

          }
        }

      }

      debugPrint("url: ${launchUri.toString()}");
      await canLaunchUrl(Uri.parse(launchUri)) ? ( launchExtBrowserStrictly ? await launchUrl(Uri.parse(launchUri))
          // : changeScreenWithConstructor(context, BrowserPage(url: launchUri), rootNavigator: true) )
          : context.push(browserPage, extra: launchUri) )

          : throw 'Could not launch $launchUri';

    }catch (error){
      debugPrint(error.toString());
    }

  }

  void openShow(BuildContext context, {required int showId}){
    // preview notification from a show
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => ShowsPreviewPage<ShowPreviewCubit>(
    //       // parentId: parentId,
    //       showId: showId,
    //     ),
    //         settings: RouteSettings(arguments: {'page_title':'shows_preview','page_id': showId})
    //     )
    // );

  }

  void openThread(BuildContext context, {required int threadId}){
    // preview notification from a show
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => ThreadPreviewPage<ThreadPreviewCubit>(
    //       // parentId: parentId,
    //       threadId: threadId,
    //     ),settings: RouteSettings(arguments: {'page_title':'thread_preview','page_id': threadId})
    //     )
    // );
  }

  void openCommunity(BuildContext context, {required String slug}){
    // preview notification from a show
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => CommunitiesFeeds(slug: slug,),settings: RouteSettings(arguments: {'page_title':'community_feed','page_id': slug})
    //     )
    // );
  }

  void openSeries(BuildContext context, {required int seriesId}){
    // preview notification from a show
    // changeScreenWithConstructor(context, SeriesPreviewPage(seriesItem: linkPreviewMeta.series!, itemIndex: 0));
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => SeriesPreviewPage(seriesId: seriesId,),settings: RouteSettings(arguments: {'page_title':'series_preview','page_id': seriesId})
    //     )
    // );
  }

  void openJob(BuildContext context, {required int jobId}){
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => JobPreviewPage(jobId: jobId,),settings: RouteSettings(arguments: {'page_title':'jobs_preview','page_id': jobId})
    //     )
    // );
  }

  void openUserProfile(BuildContext context, {required String username}){
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => ProfilePage(username: username,),)
    // );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> openEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

}