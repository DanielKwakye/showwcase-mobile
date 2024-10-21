import 'dart:async';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:open_store/open_store.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_message_model.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/messages_badge_widget.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/drawer_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/suggested_communities_cubit.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_enums.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_state.dart';
import 'package:showwcase_v3/features/home/presentation/pages/ios_bottom_navigation_style_wrapper.dart';
import 'package:showwcase_v3/features/home/presentation/widgets/redirect_link_to_page_widget.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_cubit.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_badge_widget.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_linear_loading_indicator_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_submission_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {

  final Widget child;
  const HomePage({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  HomePageController createState() => HomePageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _HomePageView extends WidgetView<HomePage, HomePageController> {

  const _HomePageView(HomePageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        final GoRouter route = GoRouter.of(context);
        final String location = route.location;
        if (location != "/") {
          state.activeIndex = 0;
          route.go("/");
          return false;
        }
        return true;
      },
      child: RedirectLinkToPageWidget(
        child: ThreadSubmissionWidget(
          child: Scaffold(
              extendBody: true,
              backgroundColor: theme.colorScheme.background,
              key: state._scaffoldState,
              // drawer: Platform.isAndroid ? const Drawer( // Android
              //   child: DrawerPage(),
              // ) : null, // ios drawer has already been catered for  by the ios_style_wrapper
              // body: ColorfulSafeArea(
              //   bottom: true, top: true, left: false, right: false,
              //   overflowRules: Platform.isIOS ? const OverflowRules.all(true) : const OverflowRules.all(false),
              //   // overflowRules: const OverflowRules.all(true) ,
              //   filter: Platform.isIOS ? ImageFilter.blur(sigmaX: 5, sigmaY: 5) : null,
              //   child:  ,
              // ),
              body: SafeArea(
                  bottom: false,
                 top: true,
                 child: widget.child
              ),

              /// Bottom navigation bar here -------------
              /// On android the bottom navigation bar Hides when user scrolls

              bottomNavigationBar : Column(
                mainAxisSize: MainAxisSize.min,
                children: [


                  IOSBottomNavigationStyleWrapper(
                      bottomNavigation: bottomNavigation(theme)
                  )

                  /// dismissible bottom navigation
                  // if(Platform.isIOS) ... {
                  //
                  //   IOSBottomNavigationStyleWrapper(
                  //       bottomNavigation: bottomNavigation(theme)
                  //   )
                  // }else ... {
                  //   ValueListenableBuilder<bool>(valueListenable: state.enableBottomNavigationBarHideShowBehavior, builder: (ctx, enableBottomNavigationBarHideShowBehavior, child){
                  //
                  //     if(!enableBottomNavigationBarHideShowBehavior){
                  //       return  SlideInUp(child: child!);
                  //     }
                  //
                  //     return ValueListenableBuilder<bool>(valueListenable: state.showBottomNavigationBar, builder: (_, showBottomNavigationBar, ch) {
                  //
                  //       /// hide bottom nav
                  //       if(!showBottomNavigationBar){
                  //         return SlideOutDown(child: ch!,);
                  //       }
                  //
                  //       /// show bottom nav
                  //       return SlideInUp(
                  //         child: ch!,
                  //       );
                  //
                  //     }, child: child!,
                  //     );
                  //   }, child: bottomNavigation(theme),)
                  // }



                ],
              )


          ),
        ),
      ),
    );


  }

  Widget bottomNavigation (ThemeData theme) {
    return Theme(
    data: theme.copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
    child: Column(
      children: [

        /// Page loader
        // show loader and widgets on top of bottom navigation bar here -------
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (_, next) {
            return next.status == HomeStatus.enablePageLoad
                || next.status == HomeStatus.dismissPageLoad;
          },
          builder: (context, homeState) {

            File? attachedImaged;
            bool? attachedVideo;
            double? progress;

            if(homeState.status == HomeStatus.enablePageLoad){
              if(homeState.data is Map<String, dynamic>?){
                final data = homeState.data as  Map<String, dynamic>?;
                attachedImaged = data?['attachImage'] as File?;
                attachedVideo = data?['attachVideo'] as bool?;
                progress = data?['progress'] as double?;
              }

            }

            return  CustomLinearLoadingIndicatorWidget(
              loading: homeState.status == HomeStatus.enablePageLoad,
              attachedImage: attachedImaged,
              attachedVideo: attachedVideo,
              progress: progress,
            );

          },
        ),

        const CustomBorderWidget(),

        /// Actual bottom navication bar
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Platform.isIOS ? theme.colorScheme.background.withAlpha(200) : theme.colorScheme.background,
          elevation: 0,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(kHomeIconSvg,
                  colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn), width: 22,height: 20),
              activeIcon: SvgPicture.asset(kHomeActiveIconSvg,
                  colorFilter: const ColorFilter.mode(kAppBlue, BlendMode.srcIn)
                  , width: 22,height: 20),
              label: 'Threads',
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/svg/shows-new-outline.svg',
                    colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
                    width: 22,height: 18),
                activeIcon: SvgPicture.asset('assets/svg/shows-new.svg',
                    colorFilter: const ColorFilter.mode(kAppBlue, BlendMode.srcIn),
                    width: 22,height: 24),
                label: 'shows'
            ),
            BottomNavigationBarItem(
                icon: UnconstrainedBox(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kAppBlue,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.add, color: kAppWhite, size: 20,),
                  ),
                ),
                label: 'add'
            ),
            const BottomNavigationBarItem(
                  icon: NotificationBadgeWidget(active: false,),
                  activeIcon:  NotificationBadgeWidget(active: true,),
              //   icon: SvgPicture.asset('assets/svg/notification_icon.svg',
              //       colorFilter:  ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
              //       width: 20,height: 20),
              //   activeIcon: SvgPicture.asset('assets/svg/notification_solid.svg',
              //       colorFilter:  const ColorFilter.mode(kAppBlue, BlendMode.srcIn),
              //       width: 22,height: 22),
                label: 'notification'
            ),
            const BottomNavigationBarItem(
                icon: MessagesBadgeWidget(active:false),
                activeIcon: MessagesBadgeWidget(active:true),
                label: 'mail'
              //activeIcon: SvgPicture.asset(kCommunitiesIconSvg, color: kAppBlue, width: 24),
              // label: 'Shows',
            ),
          ],
          currentIndex: state.calculateSelectedIndex,
          onTap: state.onItemTapped,
          iconSize: 20,
          selectedItemColor: theme.colorScheme.primary,

          // selectedLabelStyle: const TextStyle(fontSize: 12, height: 1.8),
          // unselectedLabelStyle: const TextStyle(fontSize: 12, height: 1.8),

        ),
      ],
    ),
      );
  }



}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class HomePageController extends State<HomePage> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  late HomeCubit homeCubit;
  late UserProfileCubit userCubit;
  late ChatCubit chatCubit;
  late DrawerCommunitiesCubit drawerCommunitiesCubit;
  late SuggestedCommunitiesCubit suggestedCommunitiesCubit;
  late StreamSubscription<HomeState> homeStateStreamStreamSubscription;
  ValueNotifier<bool> showBottomNavigationBar = ValueNotifier(true); // determines whether to hide or show bottom nav
  ValueNotifier<bool> enableBottomNavigationBarHideShowBehavior = ValueNotifier(true); // determines whether the hide / and show  behavior should be enabled in the first place
  int activeIndex = 0;
  final newVersion = NewVersionPlus();

  @override
  Widget build(BuildContext context) => _HomePageView(this);

  @override
  void initState() {
    super.initState();
    // OneSignal.shared.setExternalUserId(AppStorage.currentUserSession?.username ?? '');
    homeCubit = context.read<HomeCubit>();
    userCubit = context.read<UserProfileCubit>();
    chatCubit = context.read<ChatCubit>();
    drawerCommunitiesCubit = context.read<DrawerCommunitiesCubit>();
    suggestedCommunitiesCubit = context.read<SuggestedCommunitiesCubit>();
    homeStateStreamStreamSubscription = homeCubit.stream.listen(homeCubitListener);

    //! initialize dependencies first lands on homepage
    initialize();

  }

  //! initialize app dependencies first lands on homepage
  initialize() async {
    final user = AppStorage.currentUserSession;
    if(user != null) {
      userCubit.setUserInfo(userInfo: user);
      chatCubit.initializeChatSocket();
      chatCubit.setChatConnectedRecipients();
      drawerCommunitiesCubit.fetchDrawerCommunities(userModel: user, pageKey: 0);
      suggestedCommunitiesCubit.fetchSuggestedCommunities(pageKey: 0);

      // fetch updated current user details from server
      // this automatically updates currentUser constant and the userProfile in UserCubit
      await userCubit.fetchUserProfileByUsername(username: user.username!);
      final updatedUserInfo = AppStorage.currentUserSession!;
      // once user info is updated

      userCubit.fetchUserTabs(userModel: updatedUserInfo);
      // proactively fetch profile modules
      userCubit.fetchExperiences(updatedUserInfo);
      userCubit.fetchTechStacks(userModel: updatedUserInfo);
      userCubit.fetchCertifications(updatedUserInfo);

      // change theme to correspond with server
      if(mounted && updatedUserInfo.theme == 'light'){
        AdaptiveTheme.of(context).setLight();
      }else if (mounted && updatedUserInfo.theme == 'dark'){
        AdaptiveTheme.of(context).setDark();
      }else if(mounted) {
        AdaptiveTheme.of(context).setSystem();
      }

      // push notifications -----------------------

      listenPushNotifications();

      onWidgetBindingComplete(onComplete: () {
        promptUserToUpdateApp();
        promptUserToSubscribeToPushNotification();
      });

    }
  }

  void showBottomBar() {
    // if its already showing don't do anything
    showBottomNavigationBar.value = true;
  }

  void hideBottomBar() {
    // if its already hidden don't do anything
    showBottomNavigationBar.value = false;
  }


  int get calculateSelectedIndex {

    final GoRouter route = GoRouter.of(context);
    final String location = route.location;
    if (location.startsWith("/shows")) { return 1; }
    if (location.startsWith("/notifications")) { return 3; }
    if (location.startsWith("/chat")) { return 4; }
    if (location.startsWith("/")) { return 0; }
    return activeIndex;

  }
  void onItemTapped(int index) {

    if(index == 2) {
      context.push(threadEditorPage);
      return;
    }
    // an existing active index has been tapped again
    if(index == activeIndex) {
      homeCubit.onActiveIndexTapped(index);
      return;
    }

    activeIndex = index;
    switch (index) {
      case 0:
        context.go("/");
        break;
      case 1:
        context.go("/shows");
        break;
      case 3:
        context.go("/notifications");
      case 4:
        context.go("/chat");
        break;
      default:
        context.go("/");
        break;
    }

  }

  @override
  void dispose() {
    homeStateStreamStreamSubscription.cancel();
    super.dispose();
  }

  void homeCubitListener(HomeState event) {
    /// listen for child gestures and act accordingly

    if(event.status == HomeStatus.onOpenDrawerRequestCompleted){
      _scaffoldState.currentState?.openDrawer();
    }
    if(event.status == HomeStatus.onPageScrollCompleted) {
      if(event.data == PageScrollDirection.down){
        showBottomBar();
      }
      if(event.data == PageScrollDirection.up){
        hideBottomBar();
      }
    }

    if(event.status == HomeStatus.enablePageLoad){

      // show bottom nav and lock it to show linear progress bar
      showBottomNavigationBar.value = true;
      enableBottomNavigationBarHideShowBehavior.value = false;

    }

    if(event.status == HomeStatus.dismissPageLoad){
      // after page load return hide/show behavior can be enabled again
      enableBottomNavigationBarHideShowBehavior.value = true;
    }


  }

  void promptUserToUpdateApp() async {
    final versionStatus = await newVersion.getVersionStatus();
    debugPrint("versionStatus?.canUpdate ${versionStatus?.canUpdate}"); // (true)
    debugPrint("versionStatus?.localVersion ${versionStatus?.localVersion}"); // // (1.2.1)
    debugPrint("versionStatus?.storeVersion ${versionStatus?.storeVersion}"); // (1.2.3)
    debugPrint("versionStatus?.appStoreLink ${versionStatus?.appStoreLink}"); // (https://itunes.apple.com/us/app/google/id284815942?mt=8)

    if(versionStatus != null && versionStatus.canUpdate) {

      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        // minimumFetchInterval: kReleaseMode ? const Duration(hours: 1) : const Duration(seconds: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      var storeVersionAndroid = versionStatus.storeVersion;
      var storeVersionIOS = versionStatus.storeVersion;
      var  releaseNotesAndroid ="Get the latest version of the app";
      var releaseNotesIOS = "Get the latest version of the app";
      var forceUpdateAndroid = false;
      var forceUpdateIOS = false;

      await remoteConfig.setDefaults( {
        "storeVersionAndroid": storeVersionAndroid,
        "storeVersionIOS": storeVersionIOS,
        "releaseNotesAndroid": releaseNotesAndroid,
        "releaseNotesIOS": releaseNotesIOS,
        "forceUpdateAndroid": forceUpdateAndroid,
        "forceUpdateIOS": forceUpdateIOS
      });

      await remoteConfig.ensureInitialized();
      await remoteConfig.fetchAndActivate();

      if(!mounted){
        return;
      }


      storeVersionAndroid = remoteConfig.getString("storeVersionAndroid");
      storeVersionIOS = remoteConfig.getString("storeVersionIOS");
      releaseNotesAndroid = remoteConfig.getString("releaseNotesAndroid");
      releaseNotesIOS = remoteConfig.getString("releaseNotesIOS");
      forceUpdateAndroid = remoteConfig.getBool("forceUpdateAndroid");
      forceUpdateIOS = remoteConfig.getBool("forceUpdateIOS");

      if(Platform.isAndroid) {

        if(storeVersionAndroid == versionStatus.storeVersion) {
          // remote config for the latest update and description
          showConfirmDialog(context, title: 'Update available',
            subtitle: releaseNotesAndroid,
            showCancelButton: forceUpdateAndroid ? false : true,
            isDismissible: forceUpdateAndroid ? false : true,
            showCloseButton: forceUpdateAndroid ? false : true,
            confirmAction: "Update",
            onConfirmTapped: () async {

              _openStore();

            },
          );
        }

      }else if(Platform.isIOS) {

        if(storeVersionIOS == versionStatus.storeVersion) {

          // remote config for the latest update and description
          showConfirmDialog(context, title: 'Update available',
            subtitle: releaseNotesIOS,
            isDismissible: forceUpdateIOS ? false : true,
            showCancelButton: forceUpdateIOS ? false : true,
            showCloseButton: forceUpdateIOS ? false : true,
            confirmAction: "Update",
            onConfirmTapped: () async {

                _openStore();

            },
          );

        }


      }


    }

  }
  void _openStore(){
    OpenStore.instance.open(
        appStoreId: '1615094954', // AppStore id of your app for iOS
        androidAppBundleId: 'com.showwcase.mobile.v2.showwcase_v2', // Android app bundle package name
    );
  }

  void promptUserToSubscribeToPushNotification() async {

    if(AppStorage.currentUserSession == null) {
      // if user is not logged in, don't show notification prompt
      return;
    }

    // final deviceState = await OneSignal.shared.getDeviceState();
    // if(deviceState != null && deviceState.subscribed) {
    //   return;
    // }

    // open prompt for user to enable notification
    PermissionStatus permissionStatus = await NotificationPermissions.getNotificationPermissionStatus();
    if(permissionStatus == PermissionStatus.denied) {
      // if user explicitly denied notifications, we don't want to show them again
      return;
    }

    if(permissionStatus != PermissionStatus.granted){

      if(!mounted) return;

      showConfirmDialog(context,
        title: 'Enable notification alerts',
        subtitle: 'Showwcase would like to send you push notifications when there is any activity on your account',
        onConfirmTapped: () async {
          final requestResponse =  await NotificationPermissions.requestNotificationPermissions();
          if(requestResponse == PermissionStatus.granted){
            // user granted permission
            registerUserForPushNotification();
            return;
          }
        },
      );

    }else {
      registerUserForPushNotification();
    }

  }


  void registerUserForPushNotification() async {

    if(AppStorage.currentUserSession == null) {
      // if user is not logged in, don't show notification prompt
      return;
    }

    final user = AppStorage.currentUserSession!;
    // final registrationStatus = await ShowwcaseStorage.getPushRegistrationStatus;

    var myCustomUniqueUserId = "${user.username}";
    //await OneSignal.shared.removeExternalUserId();
    await OneSignal.login(myCustomUniqueUserId);
    // debugPrint("setExtPushIdResponse: $setExtPushIdResponse :: newDeviceId: $myCustomUniqueUserId");


  }


  void listenPushNotifications() {

    // remove all previous listeners
    // OneSignal.Notifications.removeForegroundWillDisplayListener(foregroundWillDisplayListener);
    // OneSignal.Notifications.removeClickListener(pushNotificationTappedListener);


    // When the app is already opened
    OneSignal.Notifications.addForegroundWillDisplayListener(foregroundWillDisplayListener);


    // When the app is opened from external push notification alert
    OneSignal.Notifications.addClickListener(pushNotificationTappedListener);


    OneSignal.User.pushSubscription.addObserver((state) {
      debugPrint("customLog -> Onesignal: pushSubscription-> ${state.current.jsonRepresentation()}");
      // context.showSnackBar("pushNotificationTappedListener called");
    });

  }

  /// Onesignal notification listeners

  // When the app is already opened
  foregroundWillDisplayListener(OSNotificationWillDisplayEvent event) {

    // context.showSnackBar("foregroundWillDisplayListener called");

    debugPrint('customLog -> Onesignal: NOTIFICATION Received in foreground: $event');
    /// preventDefault to not display the notification
    if(event.notification.additionalData?.containsKey("chatId") ?? false) {

      final parentRoutePath = context.getParentRoutePath();
      if(parentRoutePath.contains("chat")){
        // sockets will handle the message -------
        event.preventDefault();
      }else{

        // only fetch and update notification totals if user is not on the chat route
        context.read<ChatCubit>().fetchChatNotificationTotals();
      }

    }else {

      //  fetch notifications total and new notifications
      context.read<NotificationCubit>().fetchNotificationTotal();

    }


  }

  //  When the app is opened from external push notification alert
  pushNotificationTappedListener(OSNotificationClickEvent event) async {
    debugPrint('customLog -> Onesignal: NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');

    // context.showSnackBar("pushNotificationTappedListener called");

    final data = event.notification.additionalData;

    if(data != null){

      if(data['username'] != null) {

        homeCubit.enablePageLoad();
        final user = await context.read<UserProfileCubit>().getUserInfoUsername(username: data['username']);
        homeCubit.dismissPageLoad();

        if(user != null && mounted){
          pushToProfile(context, user: user);
        }

      }else if(data['threadId'] != null && data['threadId'] != '') {


        homeCubit.enablePageLoad();
        final thread = await context.read<ThreadCubit>().getThreadFromId(threadId: int.parse(data['threadId'].toString()));
        homeCubit.dismissPageLoad();

        if(thread != null && mounted){
          context.push(context.generateRoutePath(subLocation: threadPreviewPage), extra: thread);
        }


      }else if(data['projectId'] != null && data['projectId'] != '') {

        homeCubit.enablePageLoad();
        final show = await context.read<ShowsCubit>().getShowFromId(showId: int.parse(data['projectId'].toString()));
        homeCubit.dismissPageLoad();

        // preview notification from a show
        if(show != null && mounted){
          context.push(context.generateRoutePath(subLocation: showPreviewPage), extra: show);
        }

      }
      else if(data['community'] != null || data['communityId'] != null){
        String? communitySlug = data.containsKey('community') ? data['community'].toString() : data['communityId']?.toString();
        if(communitySlug == null) {
          return;
        }

        homeCubit.enablePageLoad();
        final community = await context.read<CommunityCubit>().getCommunityFromSlug(slug: communitySlug);
        homeCubit.dismissPageLoad();

        // preview notification from a show
        if(community != null && mounted){
          context.push(context.generateRoutePath(subLocation: communityPreviewPage), extra: community);
        }

      }
      else if(data['chatId'] != null){

        context.go("/chat");
        activeIndex = 4;

        try {

          final Map<Object?, Object?>? userData = data['user'];
          if(userData != null) {
            final Map<String, dynamic> mappedUserData = userData.cast<String, dynamic>();
            data['user'] = mappedUserData;
          }

          final List? attachments = data['attachments'];
          if(attachments != null) {

            final List<Map<String, dynamic>> mappedList = [];
            for (var element in attachments) {
              if(element is Map<Object?, Object?>) {
                final Map<String, dynamic> mappedElement = element.cast<String, dynamic>();
                if(mappedElement['meta'] != null) {
                  if(mappedElement['meta'] is Map<Object?, Object?>) {
                    final Map<String, dynamic> mappedMetaElement = mappedElement['meta'].cast<String, dynamic>();
                    mappedElement['meta'] = mappedMetaElement;
                  }

                }
                mappedList.add(mappedElement);
              }
            }
            data["attachments"] = mappedList;
          }


          final message = ChatMessageModel.fromJson(data);
          if(message.chatId.isNullOrEmpty()){
            return;
          }

          homeCubit.enablePageLoad();
          final either = await context.read<ChatCubit>().getConnectedRecipientById(connectedRecipientId: message.chatId!);
          homeCubit.dismissPageLoad();

          if(!mounted){
            return;
          }

          if(either.isLeft()){
            return;
          }

          // Successful ---

          final chatConnection = either.asRight();

          // preview notification from a show
          context.push("/chat/$chatPreviewPage", extra:  {
            'user': chatConnection.users!.firstWhere((e) => checksNotEqual(e.username!,AppStorage.currentUserSession!.username!)),
            'connection': chatConnection
          });

          context.read<ChatCubit>().onMessageReceived(message);

        }catch(e) {
          debugPrint("customLog: push notification error -> ${e.toString()}");
        }

      }
      else if(data['seriesId'] != null){

        // homeCubit.enablePageLoad();
        // final community = await context.read<CommunityCubit>().getCommunityFromSlug(slug: data['community']);
        // homeCubit.dismissPageLoad();

        // preview notification from a show
        homeCubit.enablePageLoad();
        final series = await context.read<SeriesCubit>().getSeriesById(seriesId: data['seriesId']);
        homeCubit.dismissPageLoad();

        if(series != null && mounted){
          context.push(context.generateRoutePath(subLocation: seriesPreviewPage), extra: {
            "series" : series
          });
        }

      }

    }


  }

}