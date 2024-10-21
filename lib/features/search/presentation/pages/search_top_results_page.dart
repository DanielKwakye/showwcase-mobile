import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_item_widget.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_cubit.dart';
import 'package:showwcase_v3/features/search/data/models/top_search_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_item_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_item_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_list_tile_widget.dart';

class SearchTopResultsPage extends StatefulWidget {

  final TopSearchModel? topSearchModel;
  const SearchTopResultsPage({Key? key, this.topSearchModel}) : super(key: key);

  @override
  SearchTopResultsPageController createState() => SearchTopResultsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SearchTopResultsPageView extends WidgetView<SearchTopResultsPage, SearchTopResultsPageController> {

  const _SearchTopResultsPageView(SearchTopResultsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final topSearch = widget.topSearchModel ?? state.searchCubit.state.topSearch;
    final users = topSearch?.users;
    final threads = topSearch?.threads;
    final projects = topSearch?.projects;
    final communities = topSearch?.communities;

    if((users ?? []).isEmpty && (threads ?? []).isEmpty && (projects ?? []).isEmpty && (communities ?? []).isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


              /// Users matching the search ---
              if((users ?? []).isNotEmpty) ... {
                _header("People", context),
                ...users!.map((user) => Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: UserListTileWidget(userModel: user,),
                ))
              },


              /// Threads matching the search ---

              if(threads != null && threads.isNotEmpty) ... {
                _header("Threads", context),
                ...threads.map((thread) => Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: ThreadItemWidget(threadModel: thread, showActionBar: false,pageName: searchPage,),
                ))
              },


              if((projects ?? []).isNotEmpty) ... {

                _header("Shows", context),
                ...projects!.map((project) => Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  child: ShowItemWidget(showModel: project, showActionBar: false,pageName: searchPage,),
                ))
              },


              if((communities ?? []).isNotEmpty) ... {
                _header("Communities", context),
                ...communities!.map((community) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: CommunityItemWidget(community: community,
                    onTap: () {
                    context.push(context.generateRoutePath(subLocation: communityPreviewPage),extra: community);
                    },
                    showJoinedAction: false,
                    pageName: searchPage,
                    containerName: 'community_search_results',
                  ),
                ))
              }


            ],
          ),
        )
    );

  }

  Widget _header(String text, BuildContext context){
    final theme = Theme.of(context);
    return  Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(text, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),),
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SearchTopResultsPageController extends State<SearchTopResultsPage> {

  late SearchCubit searchCubit;

  @override
  Widget build(BuildContext context) => _SearchTopResultsPageView(this);

  @override
  void initState() {
    searchCubit = context.read<SearchCubit>();
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}