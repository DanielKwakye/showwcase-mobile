import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/profile_tag_widget.dart';

class PublicProfessionalismWidget extends StatefulWidget {

  final UserModel userModel;
  const PublicProfessionalismWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  ProfessionalismWidgetController createState() => ProfessionalismWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ProfessionalismWidgetView extends WidgetView<PublicProfessionalismWidget, ProfessionalismWidgetController> {

  const _ProfessionalismWidgetView(ProfessionalismWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
        selector: (userState) {

          final index = userState.userProfiles.indexWhere((element) => element.username == widget.userModel.username);
          if(index < 0){
            return null;
          }
          final userInfo = userState.userProfiles[index].userInfo;
          return userInfo;
        },
        builder: (context, userInfo) {


          if(userInfo == null) {
            return const SizedBox.shrink();
          }
          // final user = userProfile!.userInfo!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               if((userInfo.tags ?? []).isNotEmpty || (userInfo.details?.languages ?? [] ).isNotEmpty)
                 const Text('Professionalism', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              const SizedBox(height: 15,),

              //! Collaborated with

              BlocSelector<UserProfileCubit, UserProfileState, List<UserModel>>(
                selector: (userProfileState) {
                  return userProfileState.collaborators[userInfo.username]?.toList() ?? <UserModel>[];
                },
                builder: (context, collaborators) {
                  if(collaborators.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Previously collaborated with", style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600),),
                        const SizedBox(height: 10,),
                        Wrap(
                          runSpacing: 8,
                          spacing: 8,
                          children: [

                            ...collaborators.take(5).map((user) {
                              return GestureDetector(
                                onTap: () {
                                  pushToProfile(context, user: user);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      border:  Border.all(color: theme.colorScheme.outline)
                                  ),
                                  padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 14),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // const Icon(Icons.verified, color: kAppBlue,),
                                      CustomUserAvatarWidget(username: user.username, networkImage: user.profilePictureKey,),
                                      // const SizedBox(),
                                      Text(user.displayName ?? '', style: TextStyle(
                                          color:  theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: (defaultFontSize - 2)),)
                                    ],
                                  ),
                                ),
                              );
                            }),
                            if(collaborators.take(5).length < collaborators.length) ... {
                              ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child:  GestureDetector(
                                  onTap: (){
                                    context.push(context.generateRoutePath(subLocation: circlesPage), extra: {
                                      'user': userInfo,
                                      'initialTabIndex': 0
                                    });
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      //color: backgroundColor,
                                      //   color: theme.colorScheme.outline,
                                        borderRadius: BorderRadius.circular(200),
                                        border: Border.all(color: theme.colorScheme.outline)
                                    ),
                                    // padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
                                    child:  Center(
                                      child: Text('+${collaborators.length - 5}', style: theme.textTheme.bodyMedium,),
                                    ),
                                  ),
                                ),
                              )
                            }
                          ],
                        ),
                      ],
                    ),
                  );
                  return Text(state.toString());
                },
              ),

              //! Expertise ----

              //! Expertise ----
              ValueListenableBuilder(valueListenable: state.expertiseExpanded, builder: (_, expanded, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     if((userInfo.tags ?? []).isNotEmpty) ... [
                       Text("Expertise", style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600),),

                       const SizedBox(height: 8,),
                       // list all added profile tags
                       Wrap(
                         runSpacing: 8,
                         spacing: 8,
                         children: [
                           ...(userInfo.tags ?? []).take(expanded ? 100 : 5).map((tag) => ProfileTagWidget(tag: tag, selectable: false,)).toList(),
                           if(expanded || (userInfo.tags ?? []).take(5).length < (userInfo.tags ?? []).length) ... {
                             ClipRRect(
                               borderRadius: BorderRadius.circular(200),
                               child:  GestureDetector(
                                 onTap: (){
                                   state.expertiseExpanded.value = !state.expertiseExpanded.value;
                                 },
                                 child: Container(
                                   width: !expanded ? 40 : 80,
                                   height: 40,
                                   decoration: BoxDecoration(
                                     //color: backgroundColor,
                                     //   color: theme.colorScheme.outline,
                                       borderRadius: BorderRadius.circular(200),
                                       border: Border.all(color: theme.colorScheme.outline)
                                   ),
                                   // padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
                                   child:   Center(
                                       child: !expanded ?
                                       Text('+${(userInfo.tags ?? []).length - 5}', style: theme.textTheme.bodyMedium,)
                                           : Text('See less', style: theme.textTheme.bodyMedium?.copyWith(color: kAppBlue),)
                                   ),
                                 ),
                               ),
                             )
                           },
                         ],
                       ),
                       const SizedBox(height: 20,),
                     ],
                   ],
                );
              }),



              if((userInfo.details?.languages ?? [] ).isNotEmpty) ... [
                Text("Fluent in", style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600),),

                /// Languages ------------
                // list all added languages
                const SizedBox(height: 8,),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...(userInfo.details?.languages ?? []).map((languageName) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          //color: backgroundColor,
                          border: Border.all(color: theme.colorScheme.outline)
                      ),
                      padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
                      child: Text(languageName, style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: (defaultFontSize - 2)
                      ),),
                    )).toList(),
                  ],
                ),
              ],
              const SizedBox(
                height: 20,
              ),
              const CustomBorderWidget(top: 0, bottom: 0,)
            ],
          );

        },
      );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ProfessionalismWidgetController extends State<PublicProfessionalismWidget> {


  ValueNotifier<bool> expertiseExpanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => _ProfessionalismWidgetView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}