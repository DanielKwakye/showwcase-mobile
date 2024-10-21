import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/series_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_item_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_module_model.dart';

class PublicCustomTabWidget extends StatefulWidget {

  final List<UserModuleModel> modules;
  final UserModel userModel;
  const PublicCustomTabWidget({Key? key, required this.modules, required this.userModel}) : super(key: key);

  @override
  PublicCustomTabWidgetController createState() => PublicCustomTabWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PublicCustomTabWidgetView extends WidgetView<PublicCustomTabWidget, PublicCustomTabWidgetController> {

  const _PublicCustomTabWidgetView(PublicCustomTabWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            //! Progress Loader
            BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, userProfileState) {
                if(userProfileState.status == UserStatus.fetchCustomFeaturedShowsInProgress || userProfileState.status == UserStatus.fetchCustomFeaturedSeriesInProgress) {
                  return const SizedBox(
                    width: double.maxFinite,
                    height: 70,
                    child: Center(child: CustomAdaptiveCircularIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            SeparatedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              separatorBuilder: (BuildContext context, int index) {
                return const CustomBorderWidget(top: 10, bottom: 0,);
              },
              children: [

                /// Custom featured shows section ----
                BlocSelector<UserProfileCubit, UserProfileState, List<ShowModel>>(
                  selector: (userProfileState) {
                    return userProfileState.customFeaturedShows[widget.userModel.username] ?? <ShowModel>[];
                  },
                  builder: (context, customFeaturedShows) {

                    return SeparatedColumn(
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 7,
                          color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.background,
                        );
                      },
                      children: [
                        ...customFeaturedShows.map((show) {
                          return Container(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: showSymmetricPadding),
                              color: theme.brightness == Brightness.dark ? kAppBlack : kAppWhite,
                              child: ShowItemWidget(showModel: show, showActionBar: false,pageName: 'custom_tab_featured_shows',)
                          );

                        })
                      ],
                    );

                  },
                ),


                /// Custom featured series section ------
                BlocSelector<UserProfileCubit, UserProfileState, List<SeriesModel>>(
                  selector: (userProfileState) {
                    return userProfileState.customFeaturedSeries[widget.userModel.username] ?? <SeriesModel>[];
                  },
                  builder: (context, customFeaturedSeries) {

                    return SeparatedColumn(
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 7,
                          color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.background,
                        );
                      },
                      children: [
                        ...customFeaturedSeries.map((series) {
                          return Container(
                              key: ValueKey(series.id),
                              padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding, vertical: 10),
                              color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
                              child: SeriesItemWidget(seriesItem: series, itemIndex: 0, key: ValueKey(series.id),pageName: publicProfilePage,)
                          );
                        })
                      ],
                    );

                  },
                )

              ],
            ),
          ],
        ),
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PublicCustomTabWidgetController extends State<PublicCustomTabWidget> {

  late UserProfileCubit userProfileCubit;

  @override
  Widget build(BuildContext context) => _PublicCustomTabWidgetView(this);

  @override
  void initState() {
    super.initState();
    userProfileCubit = context.read<UserProfileCubit>();

    for(UserModuleModel module in widget.modules){
      if(module.type ==  "featured_shows"){
        final data = module.data as Map<String, dynamic>;
        final ids = List<int>.from(data["id"]);
        userProfileCubit.fetchCustomFeaturedShows(userModel: widget.userModel, projectIds: ids);
      }else if(module.type ==  "featured_series") {
        final data = module.data as Map<String, dynamic>;
        final ids = List<int>.from(data["id"]);
        userProfileCubit.fetchCustomFeaturedSeries(userModel: widget.userModel, seriesIds: ids);
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

}