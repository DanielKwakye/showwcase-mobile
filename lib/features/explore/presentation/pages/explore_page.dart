import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_cubit.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_enums.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_state.dart';
import 'package:showwcase_v3/features/explore/presentation/widgets/top_trending_shows_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_linear_loading_indicator_widget.dart';

class ExplorePage extends StatefulWidget {

  const ExplorePage({Key? key}) : super(key: key);

  @override
  ExplorePageController createState() => ExplorePageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ExplorePageView extends WidgetView<ExplorePage, ExplorePageController> {

  const _ExplorePageView(ExplorePageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            /// Search app bar
            SliverAppBar(
              // automaticallyImplyLeading: true,
              backgroundColor: theme.colorScheme.background,
              // leadingWidth: 40,
              iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
              pinned: true,
              elevation: 0,
              expandedHeight: kToolbarHeight,
              actions: [
                UnconstrainedBox(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      context.push(context.generateRoutePath(subLocation: searchPage));
                    },
                    child: Container(
                      width: width(context) - 75,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          color:theme.brightness == Brightness.light ? kAppLightGray : kDarkOutlineColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(tag: "search-placeholder", child: Row(
                              mainAxisSize: MainAxisSize.min,
                             children: [
                               SvgPicture.asset(kSearchIconSvg, width: 14,colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary.withOpacity(0.5), BlendMode.srcIn)),
                               const SizedBox(width: 5,),
                               Text("Search", style: TextStyle(fontSize: 14, color: theme.colorScheme.onPrimary.withOpacity(0.5)),)
                             ],
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: BlocBuilder<ExploreCubit, ExploreState>(
                  builder: (context, exploreState) {
                    if(exploreState.status == ExploreStatus.fetchTrendingShowsLoading) {
                      return const CustomLinearLoadingIndicatorWidget();
                    }
                    return const SizedBox.shrink();
                  },

                ),
              ),

            ),
          ];

        }, body: const SingleChildScrollView(
          child: Column(
            children: [
              TopTrendingShowsWidget()
            ],
          ),
        ),

        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ExplorePageController extends State<ExplorePage> {

  @override
  Widget build(BuildContext context) => _ExplorePageView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}