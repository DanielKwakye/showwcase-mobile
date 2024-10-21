import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/reorder_proxy_util.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tag_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/profile_tag_widget.dart';

class PersonalExpertiseProfileTagsPage extends StatefulWidget {

  const PersonalExpertiseProfileTagsPage({Key? key}) : super(key: key);

  @override
  PersonalProfileTagsPageController createState() => PersonalProfileTagsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ProfileTagsPageView extends WidgetView<PersonalExpertiseProfileTagsPage, PersonalProfileTagsPageController> {

  const _ProfileTagsPageView(PersonalProfileTagsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return Scaffold(

      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const CustomInnerPageSliverAppBar(
            pinned: true,
            pageTitle: 'Your Expertise',
          )
        ];

      }, body: BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
        selector: (userState) {
          final currentUser = AppStorage.currentUserSession!;
          final userProfiles = [...userState.userProfiles];
          final index = userProfiles.indexWhere((element) => element.username == currentUser.username);
          if(index < 0){
            return null;
          }
          final userInfo = userProfiles[index].userInfo;
          return userInfo;
        },
          builder: (context, userInfo) {
            return ListView(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15 + (kToolbarHeight + (kToolbarHeight / 2)), top: 15),
                children: [
                  ValueListenableBuilder(
                    valueListenable: state.expanded,
                    builder: (_, expanded, __) {
                      return Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          // list of tags
                          ...suggestedTags.map((json) => UserTagModel.fromJson(json))
                              .map((tag) {
                                bool selected = false;
                                if(userInfo != null && (userInfo.tags ?? []).isNotEmpty) {
                                  final indexFound = (userInfo.tags ?? []).indexWhere((element) => element.name == tag.name);
                                  if(indexFound > -1) {
                                    selected = true;
                                  }
                                }
                                return ProfileTagWidget(key: ValueKey(tag.name),tag: tag, onSelect: (selected) {
                                  state.onTagSelectionChanged(
                                      userInfo,
                                      tag, selected);
                              },  selected: selected,);
                              })
                              .take(expanded ? 200 : 5).toList(),
        
                          // see more button here -----
                          GestureDetector(
                            onTap: () {
                              state.expanded.value = !state.expanded.value;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  //color: backgroundColor,
                                  border: Border.all(color: theme.colorScheme.outline),
                                  color: theme.colorScheme.outline
                              ),
                              padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
                              child: Text(expanded ? "See less" : "See all", style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: (defaultFontSize - 2)),),
                            ),
                          )
                        ],
                      );
                    }
                  ),

                  if((userInfo?.tags ?? []).isNotEmpty)...{
                    const CustomBorderWidget(top: 15, bottom: 10,),
                  },

                  // to show ReOrderable list of selected tags---
                 if((userInfo?.tags ?? []).length > 1) ... {

                   const Padding(
                     padding: EdgeInsets.symmetric(horizontal: 5.0),
                     child: Text('Long press to select item and then drag to arrange', style: TextStyle(color: kAppRed, fontSize: 12, fontWeight: FontWeight.w600) ,),
                   ),
                   const SizedBox(height: 10,),
                 },

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ReorderableListView.builder(itemBuilder: (c, i) {
                      final tag = (userInfo?.tags ?? [])[i];
                      return ClipRRect(
                        key: ValueKey(tag.name),
                        borderRadius: BorderRadius.circular(100),
                        child: Row(
                          children: [
                            const Icon(Icons.menu_rounded, size: 20,),
                            const SizedBox(width: 15,),
                            Expanded(child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: theme.colorScheme.outline),
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(tag.name ?? ''),
                            )),
                            const SizedBox(width: 0,),
                            IconButton(icon: const Icon(Icons.clear, color: kAppRed, size: 20,), onPressed: () {
                              state.onTagSelectionChanged(userInfo, tag, false);
                            },)
                          ],

                        ),
                      );
                    }, itemCount: (userInfo?.tags ?? []).length, onReorder: (oldIndex, newIndex) => state.onReOrder(<UserTagModel>[...userInfo?.tags ?? []], oldIndex, newIndex),
                      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      proxyDecorator: (widget, _, __){
                        return ReOrderProxyUtil(child: widget);
                      },
                    ),
                  )
                ],
              );
          },
        ),

      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PersonalProfileTagsPageController extends State<PersonalExpertiseProfileTagsPage> {

  late AuthCubit authCubit;
  late UserProfileCubit userCubit;
  final ValueNotifier<bool> expanded = ValueNotifier(true);

  @override
  Widget build(BuildContext context) => _ProfileTagsPageView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    userCubit = context.read<UserProfileCubit>();
  }

  void onTagSelectionChanged(UserModel? user, UserTagModel tag,  bool selected) {
    // user should not / cannot be null
    if(user == null) {
      return;
    }
    final tags = <UserTagModel>[...(user.tags ?? [])];
    if (selected) {
      tags.add(tag);
    } else {
      tags.removeWhere((element) => element.name == tag.name);
    }
    // update selected user's tags
    userCubit.setUserInfo(userInfo: user.copyWith(
      tags: tags
    ));
    authCubit.updateAuthUserData(AppStorage.currentUserSession!.copyWith(
        tags: tags
    ), emitToSubscribers: false);
  }

  void onReOrder(List<UserTagModel> tags, int oldIndex, int newIndex){
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = tags.removeAt(oldIndex);
    tags.insert(newIndex, item);

    // save the order on the server
    final user = AppStorage.currentUserSession!;
    userCubit.setUserInfo(userInfo: user.copyWith(
        tags: tags
    ));
    authCubit.updateAuthUserData(user.copyWith(
        tags: tags
    ), emitToSubscribers: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

}