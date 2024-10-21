import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

import '../../../shared/presentation/widgets/custom_border_widget.dart';

class DisplaySettingsPage extends StatefulWidget {

  const DisplaySettingsPage({Key? key}) : super(key: key);

  @override
  DisplaySettingsPageController createState() => DisplaySettingsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _DisplaySettingsPageView extends WidgetView<DisplaySettingsPage, DisplaySettingsPageController> {

  const _DisplaySettingsPageView(DisplaySettingsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final color = theme.colorScheme.onBackground;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, next) {
        return
            next.status == AuthStatus.updateAuthUserSettingSuccessful ||
            next.status == AuthStatus.updateAuthUserSettingFailed ||
            next.status == AuthStatus.updateAuthUserDataSuccessful ||
            next.status == AuthStatus.updateAuthUserDataFailed ||
            next.status == AuthStatus.optimisticUpdateAuthUserDataSuccessful ||
            next.status == AuthStatus.optimisticUpdateAuthUserDataFailed;
      },
      builder: (_, authState) {

        final currentUser = AppStorage.currentUserSession!;
        debugPrint("customLog: theme -> ${currentUser.theme} && state = ${authState.status}");

        return Scaffold(
            body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const CustomInnerPageSliverAppBar(pageTitle: "Display & More",)
              ];
            }, body: SafeArea(
              top: false,
              bottom: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Theme selection section ----------------------------
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Appearance',
                      style: TextStyle(
                          color: color, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      'You’ve two modes to choose from.',
                      style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {

                        return IgnorePointer(
                          ignoring: authState.status == AuthStatus.updateAuthUserDataInProgress || authState.status == AuthStatus.optimisticUpdateAuthUserDataInProgress ,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    state.setThemeMode(context, theme: "system"); // defaults to system
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: currentUser.theme == 'system' ? kAppBlue : Colors.transparent, width: 1),
                                              borderRadius: BorderRadius.circular(5.0)),
                                          width: 100,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: SvgPicture.asset(
                                              'assets/svg/system.svg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),

                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Radio(
                                                value: 'system',
                                                groupValue: currentUser.theme,
                                                activeColor: kAppBlue,
                                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                onChanged: (String? value) {
                                                  state.setThemeMode(context, theme:"system"); // defaults to system
                                                }),
                                            const SizedBox(width: 10,),
                                            const Expanded(
                                              child: Text('System'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5.0,),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    state.setThemeMode(context, theme:"light");
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: currentUser.theme == 'light' ? kAppBlue : Colors.transparent, width: 1),
                                              borderRadius: BorderRadius.circular(5.0)
                                          ),
                                          width: 100,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: SvgPicture.asset(
                                              'assets/svg/light_mode.svg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Radio(
                                                value: 'light',
                                                groupValue: currentUser.theme,
                                                activeColor: kAppBlue,
                                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                onChanged: (String? value) {
                                                  state.setThemeMode(context, theme:"light");
                                                }),
                                            const SizedBox(width: 10,),
                                            const Expanded(child: Text('Light'))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5.0,),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    state.setThemeMode(context, theme:"dark");
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all(color: currentUser.theme == 'dark' ? kAppBlue : Colors.transparent, width: 1),
                                              borderRadius: BorderRadius.circular(5.0)),
                                          width: 100,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: SvgPicture.asset('assets/svg/dark_theme.svg', fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Radio(
                                                value: 'dark',
                                                groupValue: currentUser.theme,
                                                activeColor: kAppBlue,
                                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                onChanged: (String? value) {
                                                  state.setThemeMode(context, theme:"dark");
                                                }),
                                            const SizedBox(width: 10,),
                                            const Expanded(child: Text('Dark'))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    const CustomBorderWidget(),
                    const SizedBox(
                      height: 20,
                    ),


                    /// Custom domain layout section ---------

                    Text(
                      'Custom Domain Layout',
                      style: TextStyle(
                          color: color, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Select from the profile layout options below. This will also change the layout on your custom domain.',
                      style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              state.updateDomainLayout(currentUser.settings, "modern");
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: SvgPicture.asset(
                                    'assets/svg/creators_mode.svg',
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: 'modern',
                                      groupValue: currentUser.settings?.customDomainLayout,
                                      visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (String? value) {
                                        state.updateDomainLayout(currentUser.settings, "modern");
                                      },
                                    ),
                                    const SizedBox(width: 10,),
                                    const Expanded(child: Text('Creators Modern'))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              state.updateDomainLayout(currentUser.settings, "developer");
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: SvgPicture.asset(
                                    'assets/svg/developer_mode.svg',
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                        value: 'developer',
                                        groupValue: currentUser.settings?.customDomainLayout,
                                        visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        onChanged: (String? value) {
                                          state.updateDomainLayout(currentUser.settings, "developer");
                                        },
                                    ),
                                    const SizedBox(width: 10,),
                                    const Expanded(child: Text('Developer'))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                  ],
                ),
              ),
            ),)
        );
      },
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class DisplaySettingsPageController extends State<DisplaySettingsPage> {

  late AuthCubit authCubit;
  late StreamSubscription<AuthState> authStateStreamSubscription;

  @override
  Widget build(BuildContext context) => _DisplaySettingsPageView(this);

  @override
  void initState() {

    authCubit = context.read<AuthCubit>();
    authStateStreamSubscription = authCubit.stream.listen((event) {
    });

    super.initState();
  }


  @override
  void dispose() {
    authStateStreamSubscription.cancel();
    super.dispose();
  }

  void updateDomainLayout(UserSettingsModel? settingsModel, String customDomainLayout) {

    final updatedSettings = settingsModel?.copyWith(
      customDomainLayout: customDomainLayout,
    );

    // its not triggering a rebuild for strange reasons check it out
    authCubit.updateAuthUserSetting(updatedSettings);
  }


  // its not triggering a rebuild for strange reasons check it out
  void setThemeMode(BuildContext context, {required String theme}){
    // state._darkThemeTap
    if(theme == Brightness.dark.name) {
      AdaptiveTheme.of(context).setDark();
    }else if (theme == Brightness.light.name){
      AdaptiveTheme.of(context).setLight();
    }else {
      AdaptiveTheme.of(context).setSystem();
    }
    // set the theme on the server as well, and then in session

    final updatedUser = AppStorage.currentUserSession!.copyWith(
        theme: theme
    );
    authCubit.updateAuthUserData(updatedUser, optimistic: true);

  }

}