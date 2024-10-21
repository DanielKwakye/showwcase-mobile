import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_cubit.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_state.dart';
import 'package:showwcase_v3/features/spaces/data/models/space_model.dart';
import 'package:showwcase_v3/features/spaces/presentation/pages/active_space_page.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class SpacesPage extends StatefulWidget {

  const SpacesPage({Key? key}) : super(key: key);

  @override
  SpacesPageController createState() => SpacesPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SpacesPageView extends WidgetView<SpacesPage, SpacesPageController> {

  const _SpacesPageView(SpacesPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final currentUser = AppStorage.currentUserSession!;

    return SafeArea(
      top: false,bottom: true,
      child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.push(context.generateRoutePath(subLocation: spaceEditorPage));
              },
              backgroundColor: kAppPurple,
              tooltip: 'Start your huddle',
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
            top: false,bottom: true,
              child: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const CustomInnerPageSliverAppBar(pageTitle: "Spaces",)
              ];
            },
                body:
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding, vertical: threadSymmetricPadding),
                  child: SeparatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 20,);
                     },
                     children: [

                       // heading section
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Happening now", style: theme.textTheme.titleLarge,),
                            Text("Spaces going on right now", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary),),
                          ],
                       ),

                       BlocBuilder<SpacesCubit, SpacesState>(
                         builder: (context, spacesState) {
                           if(spacesState.ongoingSpaces.isEmpty) {
                             return Container(
                               width: double.maxFinite,
                               decoration: BoxDecoration(
                                   border: Border.all(color: theme.colorScheme.outline,),
                                   borderRadius: BorderRadius.circular(10)
                               ),
                               padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                               child: const Text("There are no ongoing spaces. Click on the plus bottom below to start a new space",
                                 textAlign: TextAlign.start,
                                 style: TextStyle(color: kAppPurple),),
                             );
                           }
                           return Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               ...spacesState.ongoingSpaces.map((space) =>
                                   GestureDetector(
                                    onTap: () {
                                      showActiveSpacePage(context,
                                          space: space);
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(color: kAppPurple,
                                          borderRadius: BorderRadius.circular(10)), child: SeparatedColumn(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const SizedBox(
                                            height: 15,
                                          );
                                        },
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  space.title,
                                                  style: theme
                                                      .textTheme.titleLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kAppWhite),
                                                ),
                                              ),
                                              const Row(
                                                children: [
                                                  Icon(
                                                    Icons.headphones_outlined,
                                                    size: 15,
                                                    color: kAppWhite,
                                                  ),
                                                  SizedBox(width: 7,),
                                                  Text(
                                                    "open",
                                                    style: TextStyle(
                                                        color: kAppWhite),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              CustomUserAvatarWidget(
                                                username:
                                                    space.creator.username,
                                                size: 20,
                                                borderSize: 2,
                                                networkImage: space
                                                    .creator.profilePictureKey,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Created by @${space.creator.username}",
                                                style: theme
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: kAppWhite),
                                              ),
                                            ],
                                          )
                                          // Stack(
                                          //   clipBehavior: Clip.none,
                                          //   children: [
                                          //     ...state.randomUsers.asMap().keys.toList().take(3).map((index) {
                                          //       final user = state.randomUsers[index];
                                          //       // final left = 8.w/2 ;
                                          //       // return SizedBox.shrink();
                                          //       if(index == 0){
                                          //         return CustomUserAvatarWidget(username: space.creator.username, size: 20,borderSize: 2, networkImage: space.creator.profilePictureKey,);
                                          //       }
                                          //       return Positioned(
                                          //         left: (20.0 * index),
                                          //         child: CustomUserAvatarWidget(username: user.username!, size: 20,borderSize: 2, networkImage: user.profilePictureKey),
                                          //       );}
                                          //     )
                                          //   ],),
                                        ],
                                      ),
                                    ),
                                  ))
                             ],
                           );
                         },
                       )
                     ],
                  ),
                ),
              )
            )
      ),
    );

  }

  void showActiveSpacePage(BuildContext context, {required SpaceModel space}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.90,
          builder: (_, controller) {
            return ActiveSpacePage(
              space: space,
            );
          }),
      // bounce: true
      // useRootNavigator: true,
      // expand: false
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SpacesPageController extends State<SpacesPage> {

  late List<UserModel> randomUsers;
  late SpacesCubit spacesCubit;

  @override
  Widget build(BuildContext context) => _SpacesPageView(this);

  @override
  void initState() {
    spacesCubit = context.read<SpacesCubit>();
    spacesCubit.fetchOngoingSpaces();
    randomUsers = List.generate(3, (index) =>  UserModel(
        id: index,
        username: "Showwcase Dummy"
    ));

    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}