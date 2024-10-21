import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/core/utils/world_languages_constant.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_details_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class PersonalWorldLanguagesPage extends StatefulWidget {

  const PersonalWorldLanguagesPage({Key? key}) : super(key: key);

  @override
  PersonalWorldLanguagesPageController createState() => PersonalWorldLanguagesPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PersonalWorldLanguagesPageView extends WidgetView<PersonalWorldLanguagesPage, PersonalWorldLanguagesPageController> {

  const _PersonalWorldLanguagesPageView(PersonalWorldLanguagesPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const CustomInnerPageSliverAppBar(
              pinned: true,
              pageTitle: 'Your Language',
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder<bool>(
                valueListenable: state.showCancelSearchButton,
                builder: (_, showCancelSearchButton, __) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         CustomTextFieldWidget(
                           controller: state.searchTextEditingController,
                           label: 'Languages spoken',
                           placeHolder: 'Search here ...',
                           onChange: state.onSearchLanguage,
                           suffix: showCancelSearchButton ? IconButton(icon: const Icon(Icons.close, color: kAppRed,), onPressed: () {
                              state.searchTextEditingController.clear();
                              state.onSearchLanguage('');
                           },) : null),
                         const SizedBox(height: 5,),
                         const Text('Start typing and select from the filtered list below', style: TextStyle(color: kAppBlue, fontSize: 12),),
                         const CustomBorderWidget(top: 10, bottom: 10,),
                       ],
                    ),
                  );
                }
              )
            )
          ];
        }, body: BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
          selector: (userState) {
            final currentUser = AppStorage.currentUserSession!;
            final userProfiles = userState.userProfiles;
            final index = userProfiles.indexWhere((element) => element.username == currentUser.username);
            if(index < 0){
              return null;
            }
            return userProfiles[index].userInfo;
          },
          builder: (_, userInfo) {

            // selected items should come first, followed by unselected ones
            
            return ValueListenableBuilder(
              valueListenable: state.filteredLanguages,
              builder: (_, filteredLanguages, __) {

                final reOrderedLanguages = <String>[...userInfo?.details?.languages ?? []];
                final unselectedWorldLanguages = filteredLanguages.where((element) => !reOrderedLanguages.contains(element['name'])).toList();
                reOrderedLanguages.addAll(unselectedWorldLanguages.map((e) => e['name'] as String));


                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(bottom: kToolbarHeight, left: 20, right: 20),
                  children: [
                    Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children:
                      reOrderedLanguages.map((languageName) {

                        bool selected = (userInfo?.details?.languages ?? []).where((selectedLanguage) => selectedLanguage == languageName).firstOrNull != null;

                        return GestureDetector(
                          onTap: () {
                            state.onLanguageSelected(userInfo, languageName, !selected);
                          } ,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                //color: backgroundColor,
                                color: selected ? kAppBlue : null,
                                border: selected ? null : Border.all(color: theme.colorScheme.outline)
                            ),
                            padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
                            child: Text(languageName, style: TextStyle(
                                color: selected ? kAppWhite : theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: (defaultFontSize - 2)
                            ),),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                );
              }
            );
          },
        ),)
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PersonalWorldLanguagesPageController extends State<PersonalWorldLanguagesPage> {

  late AuthCubit authCubit;
  late UserProfileCubit userCubit;
  late ValueNotifier<List<Map<String, String>>> filteredLanguages;
  final ValueNotifier<bool> showCancelSearchButton = ValueNotifier(false);
  final TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => _PersonalWorldLanguagesPageView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    userCubit = context.read<UserProfileCubit>();
    filteredLanguages = ValueNotifier(worldLanguages);
  }

  void onLanguageSelected(UserModel? user, String language, bool selected) {

    if(user == null){
      return;
    }

    final languages = <String>[...user.details?.languages ?? []];
    if(selected) {
      languages.add(language);
    }else {
      languages.remove(language);
    }

    final userDetails = (user.details ?? const UserDetailsModel()).copyWith(
      languages: languages
    );

    // update userProfile languages
    userCubit.setUserInfo(userInfo: user.copyWith(
        details: userDetails,
        languages: languages
    ));
    // update userProfile on server
    authCubit.updateAuthUserData(user.copyWith(
        details: userDetails,
        languages: languages
    ), emitToSubscribers: false);

  }

  void onSearchLanguage(String? searchText) {

    EasyDebounce.debounce(
        'languages-search-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method

          debugPrint('searchText: $searchText');

          if(searchText.isNullOrEmpty()) {
            filteredLanguages.value = worldLanguages;
            showCancelSearchButton.value = false;
            return;
          }

          final filtered = worldLanguages.where((element) => (element['name'] as String).trim().toLowerCase().contains(searchText!.toLowerCase())).toList();
          filteredLanguages.value = filtered;
          showCancelSearchButton.value = true;

        }
    );
  }


  @override
  void dispose() {
    super.dispose();
    searchTextEditingController.dispose();
  }

}