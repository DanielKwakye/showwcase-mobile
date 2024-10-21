import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/01_profile_setup_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/02_get_started_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/03_complete_profile_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/03_interests_setup_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_communities_setup_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_01_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_02_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_03_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_04_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_05_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_06_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_07_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_08_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_09_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_10_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_11_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/04_set_work_preferences/04_12_set_work_preferences_page.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class OnboardingTabsPage extends StatefulWidget {

  const OnboardingTabsPage({Key? key}) : super(key: key);

  @override
  OnboardingPageController createState() => OnboardingPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _OnboardingPageView extends WidgetView<OnboardingTabsPage, OnboardingPageController> {

  const _OnboardingPageView(OnboardingPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () {
        return Future.value(state.onBackPressed());
      },
      child: Scaffold(
          body: NestedScrollView(
            controller: state.scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                  ValueListenableBuilder<int>(valueListenable: state.activeStepIndex, builder: (_, activeStep, __) {
                    return SliverAppBar(
                      iconTheme: IconThemeData(color: theme.colorScheme.onBackground,),
                      pinned: true,
                      elevation: 0.0,
                      centerTitle: true,
                      leading: BackButton(color: theme.colorScheme.onBackground, onPressed: () {
                        state.onBackPressed();
                      },),
                      title: Text(state.tabItems[activeStep]['title'] as String,  style: TextStyle(color: theme.colorScheme.onBackground,fontSize: defaultFontSize, fontWeight: FontWeight.w700),),
                      bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(2),
                          child: Row(
                            children: List.generate(state.tabItems.length, (index) => index).map((index) {
                              final active = index == activeStep;
                              return Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: LinearProgressIndicator(
                                      minHeight: 2,
                                      backgroundColor: active ? kAppBlue
                                          : index < activeStep ? Colors.green
                                          : theme.colorScheme.outline,
                                      // value: value.toDouble(),
                                      color: active ? kAppBlue
                                          : index < activeStep ? Colors.green
                                          : theme.colorScheme.outline,
                                    ),
                                  ));
                            }).toList(),
                          )
                      ),
                    );
                  })
              ];
          }, body:
            PageView(
            controller: state.pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: state._onPageChanged,
            children: List.generate(state.tabItems.length, (index) => index).map((index) {
              if(state.tabItems.indexWhere((element) => element['index'] as int == index) < 0){
                return const SizedBox.shrink();
              }
              final tabItem = state.tabItems[index];
              return tabItem['page'] as Widget;
            }).toList(),
          ),
          )
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class OnboardingPageController extends State<OnboardingTabsPage> {

  late List<Map<String, dynamic>> tabItems;

  late AuthCubit authCubit;
  late StreamSubscription<AuthState> authStateStreamSubscription;
  final ValueNotifier<int> activeStepIndex = ValueNotifier(0);
  final completedSteps = [];
  final PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => _OnboardingPageView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    authStateStreamSubscription = authCubit.stream.listen((event) {

        if(event.status == AuthStatus.markOnboardingAsCompleteSuccessful) {
          final currentUser = AppStorage.currentUserSession;
          debugPrint("customLog: onboardedAndComplete: -> ${currentUser?.onboarded} :: onboardedReason -> ${currentUser?.settings?.onboardingReason}");
          if(AppStorage.currentUserSession?.onboarded == true) {
            context.go("/");
          }
        }

        //
        if(event.status == AuthStatus.markOnboardingAsCompleteSuccessfulWithOptionToContinue) {
          final currentUser = AppStorage.currentUserSession;
          debugPrint("customLog: onboardedAndContinue: -> ${currentUser?.onboarded} :: onboardedReason -> ${currentUser?.settings?.onboardingReason}");
          pageController.nextPage(duration: const Duration(milliseconds: 375), curve: Curves.linear);
        }

    });
    tabItems = [
      {
        'index': 0,
        'title': 'Set up your profile',
        'page': ProfileSetupPage(onCompleted: onPageCompleted,)
      },
      {
        'index': 1,
        'title': 'Get started',
        'page': GetStarted(onCompleted: onGetStartedCompleted,)
      },
    ];
  }

  void _onPageChanged(int index) {
    activeStepIndex.value = index;
  }

  void onGetStartedCompleted() {

    if(authCubit.state.getStartedReason == null) {
      return;
    }

    // update the tab pages depending on the get started reason
    setState(() {


      bool hasIndexGreaterThanTwo = tabItems.any((map) => map['index'] >= 2);
      if(hasIndexGreaterThanTwo) {
        tabItems.removeWhere((element) => element['index'] >= 2);
      }


      if(authCubit.state.getStartedReason == GetStartedReason.connectWithCommunity){
        tabItems.addAll([
          {
            'index': 2,
            'title': 'Select Interests',
            'page': InterestsSetupPage(onCompleted: onPageCompleted,)
          },
          {
            'index': 3,
            'title': 'Select communities',
            'page': CommunitiesSetupPage(onCompleted: () => onPageCompleted(markAsComplete: true, caContinueOnboarding: false),)
          },
        ]);

        onPageCompleted(markAsComplete: false,);

      }else {

        tabItems.addAll([
          {
            'index': 2,
            'title': 'Complete Profile',
            'page': CompleteProfilePage(onCompleted: onPageCompleted,)
          },
          {
            'index': 3,
            'title': 'Set work preferences',
            'page': SetWorkPreferencesPage01(onCompleted: (String? nextPageRoute) {

                bool hasIndexGreaterThanFour = tabItems.any((map) => map['index'] >= 4);
                if(hasIndexGreaterThanFour) {
                  tabItems.removeWhere((element) => element['index'] >= 4);
                }

                if(nextPageRoute == null){
                  addWorkPreferencesTabs();
                  Future.delayed(const Duration(milliseconds: 10), (){
                    onPageCompleted();
                  });
                  return;
                }else{

                  context.go(nextPageRoute);

                }

            },)
          },
        ]);

        onPageCompleted(markAsComplete: true, caContinueOnboarding: true);

      }

    });

  }

  void onPageCompleted({bool markAsComplete = false, bool caContinueOnboarding = false}) {

    scrollController.animateTo(0.00, duration: const Duration(milliseconds: 10), curve: Curves.linear);

    if(markAsComplete){
      // onboarding complete
      authCubit.markOnboardingAsComplete(updatedUser: AppStorage.currentUserSession!.copyWith(
        onboarded: true
      ), caContinueOnboarding: caContinueOnboarding);
      return;
    }
    pageController.nextPage(duration: const Duration(milliseconds: 375), curve: Curves.linear);
    AnalyticsService.instance.sendEventSignUpSuccess();
  }

  void addWorkPreferencesTabs() {
    setState(() {
      tabItems.addAll([
        {
          'index': 4,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage02(onCompleted: onPageCompleted,)
        },
        {
          'index': 5,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage03(onCompleted: onPageCompleted,)
        },
        {
          'index': 6,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage04(onCompleted: onPageCompleted,)
        },
        {
          'index': 7,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage05(onCompleted: onPageCompleted,)
        },
        {
          'index': 8,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage06(onCompleted: onPageCompleted,)
        },
        {
          'index': 9,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage07(onCompleted: onPageCompleted,)
        },
        {
          'index': 10,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage08(onCompleted: onPageCompleted,)
        },
        {
          'index': 11,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage09(onCompleted: onPageCompleted,)
        },
        {
          'index': 12,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage10(onCompleted: onPageCompleted,)
        },
        {
          'index': 13,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage11(onCompleted: onPageCompleted,)
        },
        {
          'index': 14,
          'title': 'Set work preferences',
          'page': SetWorkPreferencesPage12(onCompleted: (String nextPageRoute) {
            // context.go(nextPageRoute);
            // requires deep linking
            context.go(nextPageRoute);
          },)
        },
      ]);
    });
  }

  void refreshTabIndicators() {
    setState(() {

      if(activeStepIndex.value == 0 || activeStepIndex.value == 1){
        final pagesMoreThanPageIndex = tabItems.any((element) => element['index'] > 1);
        if(pagesMoreThanPageIndex) {
          tabItems.removeWhere((element) => element['index'] > 1);
        }
      }else if (activeStepIndex.value == 2 || activeStepIndex.value == 3) {
        final pagesMoreThanPageIndex = tabItems.any((element) => element['index'] > 3);
        if(pagesMoreThanPageIndex) {
          tabItems.removeWhere((element) => element['index'] > 3);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    authStateStreamSubscription.cancel();
    scrollController.dispose();
  }

  bool onBackPressed() {
    if(activeStepIndex.value == 0) {
      context.go(walkthroughPage);
      return false;
    }
    final previousIndex = activeStepIndex.value - 1;
    pageController.animateToPage(previousIndex, duration: const Duration(milliseconds: 375), curve: Curves.linear).then((value) {
      scrollController.animateTo(0.00, duration: const Duration(milliseconds: 10), curve: Curves.linear);
      refreshTabIndicators();
    });
    return false;
  }

}