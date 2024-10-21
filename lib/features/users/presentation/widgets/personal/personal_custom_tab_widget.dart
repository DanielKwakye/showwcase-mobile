import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
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
import 'package:showwcase_v3/features/users/data/models/user_module_model.dart';

class PersonalCustomTabWidget extends StatefulWidget {

  final List<UserModuleModel> modules;
  const PersonalCustomTabWidget({Key? key, required this.modules}) : super(key: key);

  @override
  PersonalCustomTabWidgetController createState() => PersonalCustomTabWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PersonalCustomTabWidgetView extends WidgetView<PersonalCustomTabWidget, PersonalCustomTabWidgetController> {

  const _PersonalCustomTabWidgetView(PersonalCustomTabWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = AppStorage.currentUserSession!;
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
                      return userProfileState.customFeaturedShows[currentUser.username] ?? <ShowModel>[];
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
                      return userProfileState.customFeaturedSeries[currentUser.username] ?? <SeriesModel>[];
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
                                  child: SeriesItemWidget(seriesItem: series, itemIndex: 0, key: ValueKey(series.id),pageName: personalProfilePage,)
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

class PersonalCustomTabWidgetController extends State<PersonalCustomTabWidget> {

  late UserProfileCubit userProfileCubit;

  @override
  Widget build(BuildContext context) => _PersonalCustomTabWidgetView(this);

  @override
  void initState() {
    super.initState();
    userProfileCubit = context.read<UserProfileCubit>();
    final currentUser = AppStorage.currentUserSession!;
    for(UserModuleModel module in widget.modules){
      if(module.type ==  "featured_shows"){
        final data = module.data as Map<String, dynamic>;
        final ids = List<int>.from(data["id"]);
        userProfileCubit.fetchCustomFeaturedShows(userModel: currentUser, projectIds: ids);
      }else if(module.type ==  "featured_series") {
        final data = module.data as Map<String, dynamic>;
        final ids = List<int>.from(data["id"]);
        userProfileCubit.fetchCustomFeaturedSeries(userModel: currentUser, seriesIds: ids);
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

}