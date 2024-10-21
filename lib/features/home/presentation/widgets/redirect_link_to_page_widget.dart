import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_enums.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_state.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_page_loading_indicator_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';

class RedirectLinkToPageWidget extends StatefulWidget {

  final Widget child;
  const RedirectLinkToPageWidget({Key? key, required this.child}) : super(key: key);

  @override
  RedirectLinkToPageWidgetController createState() => RedirectLinkToPageWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _RedirectLinkToPageWidgetView extends WidgetView<RedirectLinkToPageWidget, RedirectLinkToPageWidgetController> {

  const _RedirectLinkToPageWidgetView(RedirectLinkToPageWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return CustomPageLoadingIndicatorWidget(
      loading: state.showLoader,
      child: widget.child,

    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class RedirectLinkToPageWidgetController extends State<RedirectLinkToPageWidget> {

  late HomeCubit homeCubit;
  late StreamSubscription<HomeState> homeStateStreamSubscription;
  bool showLoader = false;

  @override
  Widget build(BuildContext context) => _RedirectLinkToPageWidgetView(this);

  @override
  void initState() {
    homeCubit = context.read<HomeCubit>();
    homeStateStreamSubscription = homeCubit.stream.listen(homeCubitListener);
    super.initState();
  }


  void homeCubitListener(HomeState event) async {
    if(event.status == HomeStatus.redirectLinkToPageRequested) {
      final url = event.data['url'] as String?;
      if(url == null){return;}

      final fallBackRoutePath = event.data['fallBackRoutePath'] as String;
      final fallBackRoutePathData = event.data['fallBackRoutePathData'] as dynamic;
      final bool hideLoader = event.data['hideLoader'] as bool;

      if(!hideLoader){
        setState(() {showLoader = true;});
      }

      // determine which page the url can navigate to

      const showLink = "https://www.showwcase.com/show/";
      const threadLink = "https://www.showwcase.com/thread/";
      const communityLink = "https://www.showwcase.com/community/";
      const seriesLink = "https://www.showwcase.com/series/";
      const jobLink = "https://www.showwcase.com/job/";
      const jobsLink = "https://www.showwcase.com/jobs";
      const userLinkProbably = "https://www.showwcase.com/";


      // check if word is a link to a show
      if( url.startsWith(showLink)){
        // then this is a show
        const lengthOfShowUrl = showLink.length;
        final newWord = url.substring(lengthOfShowUrl);
        final newWordSplit = newWord.split('/');
        var showIdInString = newWordSplit.first;
        final showId = int.tryParse(showIdInString);
        if(showId != null){
          pushToShow(context, showId: showId, onFail: (){
            context.push(fallBackRoutePath.startsWith('/') ? fallBackRoutePath : context.generateRoutePath(subLocation: fallBackRoutePath), extra: fallBackRoutePathData);
          });
          return;
        }

      }

      // check if word is a link to a show
      if(url.startsWith(threadLink)){
        // then this is a show
        const lengthOfThreadUrl = threadLink.length;
        final newWord = url.substring(lengthOfThreadUrl);
        final newWordSplit = newWord.split('/');
        var threadIdInString = newWordSplit.first;
        final threadId = int.tryParse(threadIdInString);
        if(threadId != null){
          pushToThread(context, threadId: threadId, onFail: (){
            context.push(fallBackRoutePath.startsWith('/') ? fallBackRoutePath : context.generateRoutePath(subLocation: fallBackRoutePath), extra: fallBackRoutePathData);
          });
          return;
        }
      }

      // check if word is a link to a community
      if(url.startsWith(communityLink)){
        // then this is a community
        const lengthOfCommunityUrl = communityLink.length;
        final newWord = url.substring(lengthOfCommunityUrl);
        final newWordSplit = newWord.split('/');
        var communitySlug = newWordSplit.last;
        pushToCommunity(context, slug: communitySlug, onFail: (){
          context.push(fallBackRoutePath.startsWith('/') ? fallBackRoutePath : context.generateRoutePath(subLocation: fallBackRoutePath), extra: fallBackRoutePathData);
        });
        return;
      }

      // check if word is a link to a series
      if(url.startsWith(seriesLink)){
        // then this is a community
        const lengthOfSeriesUrl = seriesLink.length;
        final newWord = url.substring(lengthOfSeriesUrl);
        final newWordSplit = newWord.split('/');
        var seriesIdInString = newWordSplit.first;
        final seriesId = int.tryParse(seriesIdInString);
        if(seriesId != null) {
          pushToSeries(context, seriesId: seriesId, onFail: (){
            context.push(fallBackRoutePath.startsWith('/') ? fallBackRoutePath : context.generateRoutePath(subLocation: fallBackRoutePath), extra: fallBackRoutePathData);
          });
          return;
        }
      }

      // check if word is a link to a job
      if(url.startsWith(jobLink)){
        // then this is a community
        const lengthOfJobUrl = jobLink.length;
        final newWord = url.substring(lengthOfJobUrl);
        final newWordSplit = newWord.split('/');
        var jobIdAndSlug = newWordSplit.first;
        final jobIdInString = jobIdAndSlug.split('-').first;
        final jobId = int.tryParse(jobIdInString);
        if(jobId != null) {
          pushToJob(context, jobId: jobId, onFail: (){
            context.push(fallBackRoutePath.startsWith('/') ? fallBackRoutePath : context.generateRoutePath(subLocation: fallBackRoutePath), extra: fallBackRoutePathData);
          });
          return;
        }
      }

      // check if word is a link to a user /// this if should always run last
      if(url.startsWith(userLinkProbably)){
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
              pushToUserProfile(context, username: username, onFail: (){
                context.push(fallBackRoutePath.startsWith('/') ? fallBackRoutePath : context.generateRoutePath(subLocation: fallBackRoutePath), extra: fallBackRoutePathData);
              });
              return;
            }

          }
        }

      }

      setState(() { showLoader = false; });
      context.push(fallBackRoutePath.startsWith('/') ? fallBackRoutePath : context.generateRoutePath(subLocation: fallBackRoutePath), extra: fallBackRoutePathData);
      return;

    }
  }


  void pushToShow(BuildContext context, {required int showId, required Function onFail}) async {
    // fetch data based on Id here
    final show = await context.read<ShowsCubit>().fetchShowById(showId: showId);
    setState(() { showLoader = false; });
    if(mounted && show != null){
      context.push(context.generateRoutePath(subLocation: showPreviewPage), extra: show);
      return;
    }
    onFail.call();
  }

  void pushToThread(BuildContext context, {required int threadId, required Function onFail}) async {
    // fetch data based on Id here
    final thread = await context.read<ThreadCubit>().getThreadFromId(threadId: threadId);
    setState(() { showLoader = false; });
    if(mounted && thread != null){
      // push to page and return
      context.push(context.generateRoutePath(subLocation: threadPreviewPage), extra: thread);
      return;
    }
    onFail.call();
  }

  void pushToCommunity(BuildContext context, {required String slug, required Function onFail}) async {
    // fetch data based on Id here
    final community = await context.read<CommunityCubit>().getCommunityFromSlug(slug: slug);
    setState(() { showLoader = false; });
    if(mounted && community != null){
      // push to page and return
      context.push(context.generateRoutePath(subLocation: communityPreviewPage), extra: community);
      return;
    }
    onFail.call();
  }

  void pushToSeries(BuildContext context, {required int seriesId, required Function onFail}) async {
    // fetch data based on Id here
    final series = await context.read<SeriesCubit>().getSeriesById(seriesId: seriesId);
    setState(() { showLoader = false; });
    if(mounted && series != null){
      // push to page and return
      context.push(context.generateRoutePath(subLocation: seriesPreviewPage), extra: {
        "series" : series
      });
      return;
    }
    onFail.call();
  }

  void pushToJob(BuildContext context, {required int jobId, required Function onFail}){
    // fetch data based on Id here
    setState(() { showLoader = false; });
    if(mounted){
      // push to page and return
      return;
    }
    onFail.call();
  }

  void pushToUserProfile(BuildContext context, {required String username, required Function onFail}) async {
    final user = await context.read<UserProfileCubit>().getUserInfoUsername(username: username);
    setState(() { showLoader = false; });
    if(mounted){
      if(user != null){
        pushToProfile(context, user: user);
        return;
      }
    }
    onFail.call();

  }

  @override
  void dispose() {
    homeStateStreamSubscription.cancel();
    super.dispose();
  }

}