import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_cubit.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_enums.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_app_shimmer.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class TopTrendingShowsWidget extends StatefulWidget {

  const TopTrendingShowsWidget({Key? key}) : super(key: key);

  @override
  State<TopTrendingShowsWidget> createState() => _TrendingShowsWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _TrendingShowsWidgetView extends WidgetView<TopTrendingShowsWidget, _TrendingShowsWidgetController> {

  const _TrendingShowsWidgetView(_TrendingShowsWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ExploreCubit, ExploreState>(
      buildWhen: (_, searchState) {
        return searchState.status == ExploreStatus.fetchTrendingShowsSuccess
            // || searchState.status == ApiStatus.fetchingTopShows
            || searchState.status == ExploreStatus.fetchTrendingShowsFailure;
      },
      builder: (context, searchState) {
        // if searchState.list is empty return empty widget

        if(searchState.status == ExploreStatus.fetchTrendingShowsSuccess &&  searchState.trendingShows.isNotEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: theme.colorScheme.background),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Trending Shows', style: TextStyle(fontWeight: FontWeight.bold, fontSize: defaultFontSize + 4),),
                const SizedBox(height: 15,),
                ...searchState.trendingShows.map((show) {
                  return _ListItem(show: show);
                })
              ],
            ),

          );
        }


        if(searchState.status == ExploreStatus.fetchTrendingShowsSuccess) {
          return Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: theme.colorScheme.background),
            child:  const CustomAppShimmer(contentPadding: EdgeInsets.zero,),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class _TrendingShowsWidgetController extends State<TopTrendingShowsWidget> {

  late ExploreCubit searchCubit;

  @override
  void initState() {
    super.initState();
    searchCubit = context.read<ExploreCubit>();
    searchCubit.fetchTrendingShows();
  }


  @override
  Widget build(BuildContext context) => _TrendingShowsWidgetView(this);
}

class _ListItem extends StatelessWidget  with LaunchExternalAppMixin  {
  final ShowModel show;
  const _ListItem({
    required this.show,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(context.generateRoutePath(subLocation: showPreviewPage), extra: show);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomUserAvatarWidget(
              username: show.user?.username ?? '',
              networkImage: show.user?.profilePictureKey ?? '',
            ),

            const SizedBox(width: 10,),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Text(show.user?.displayName ?? '', style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w700),),
                  const SizedBox(height: 5,),
                  Text(show.title ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700),),
                const SizedBox(height: 5,),
                  Text('${show.visits ?? '0'} views', style: TextStyle(color: theme.colorScheme.onPrimary),)
              ],
            ))
          ],
        ),
      ),
    );
  }
}