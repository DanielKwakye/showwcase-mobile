import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/app_route_observer.dart';
import 'package:showwcase_v3/app/routing/page_not_found.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_repository.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/login/login_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/onboarding_tabs_page.dart';
import 'package:showwcase_v3/features/auth/presentation/pages/signup/signup_page.dart';
import 'package:showwcase_v3/features/bookmarks/presentation/pages/bookmark_tabs_page.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_connection_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_message_model.dart';
import 'package:showwcase_v3/features/chat/presentation/pages/chat_connections_page.dart';
import 'package:showwcase_v3/features/chat/presentation/pages/chat_images_preview_page.dart';
import 'package:showwcase_v3/features/chat/presentation/pages/chat_messages_page.dart';
import 'package:showwcase_v3/features/circles/presentation/pages/circle_members_tabs_page.dart';
import 'package:showwcase_v3/features/circles/presentation/pages/collaboration_request.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/welcome_screen_response.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/community_settings.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/edit_welcome_screen.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/communities_details_page.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/community_preview_page.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/discover_communities_page.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/see_more_active_communities.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/see_more_fastest_growing_communitities.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/see_more_proposed_communities.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/companies/presentation/widgets/company_preview_page.dart';
import 'package:showwcase_v3/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:showwcase_v3/features/explore/presentation/pages/explore_page.dart';
import 'package:showwcase_v3/features/guestbook/presentation/pages/create_guestbook.dart';
import 'package:showwcase_v3/features/guestbook/presentation/pages/edit_guestbook.dart';
import 'package:showwcase_v3/features/home/presentation/pages/home_page.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';
import 'package:showwcase_v3/features/jobs/presentation/pages/job_filters_page.dart';
import 'package:showwcase_v3/features/jobs/presentation/pages/job_locations_page.dart';
import 'package:showwcase_v3/features/jobs/presentation/pages/job_positions_page.dart';
import 'package:showwcase_v3/features/jobs/presentation/pages/job_preview_page.dart';
import 'package:showwcase_v3/features/jobs/presentation/pages/job_stacks_page.dart';
import 'package:showwcase_v3/features/jobs/presentation/pages/job_types_page.dart';
import 'package:showwcase_v3/features/jobs/presentation/pages/jobs_tabs_page.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/notifications/presentation/pages/notification_initiators_page.dart';
import 'package:showwcase_v3/features/notifications/presentation/pages/notifications_page.dart';
import 'package:showwcase_v3/features/refferals/presentation/pages/invites_page.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/pages/roadmap_preview_page.dart';
import 'package:showwcase_v3/features/search/presentation/pages/search_page.dart';
import 'package:showwcase_v3/features/search/presentation/pages/search_results_tabs_page.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/presentation/pages/series_preview_page.dart';
import 'package:showwcase_v3/features/series/presentation/pages/series_projects_preview_page.dart';
import 'package:showwcase_v3/features/settings/presentation/pages/account_settings_page.dart';
import 'package:showwcase_v3/features/settings/presentation/pages/areas_of_interest_settings_page.dart';
import 'package:showwcase_v3/features/settings/presentation/pages/display_settings_page.dart';
import 'package:showwcase_v3/features/settings/presentation/pages/job_preferences.dart';
import 'package:showwcase_v3/features/settings/presentation/pages/settings_page.dart';
import 'package:showwcase_v3/features/shared/presentation/pages/browser_page.dart';
import 'package:showwcase_v3/features/shared/presentation/pages/youtube_preview_page.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_browser_preview_page.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_code_preview_page.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_comments_editor_page.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_comments_page.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_images_preview_page.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_preview_page.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_upvoters_page.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_video_preview_page.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/shows_tabs_page.dart';
import 'package:showwcase_v3/features/spaces/presentation/pages/space_editor_page.dart';
import 'package:showwcase_v3/features/spaces/presentation/pages/spaces_page.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_code_preview_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_editor_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_feeds_tab_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_images_preview_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_poll_voters_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_preview_browser_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_preview_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_up_voters_page.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_video_preview_page.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/pages/personal/personal_edit_profile_page.dart';
import 'package:showwcase_v3/features/users/presentation/pages/personal/user_personal_profile_page.dart';
import 'package:showwcase_v3/features/users/presentation/pages/public/user_public_profile_page.dart';
import 'package:showwcase_v3/features/users/presentation/pages/shared/user_resume_preview_page.dart';
import 'package:showwcase_v3/features/walkthrough/presentation/pages/walkthrough_page.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey<NavigatorState>(debugLabel: 'root');
GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

// GoRouter configuration
final router = GoRouter(
  // initialLocation: homePageRoute,
  debugLogDiagnostics: true,
  errorBuilder: (_, __) {
    return const PageNotFound();
  },
  navigatorKey: _rootNavigator,
  observers: [
    AppRouteObserver()
  ],
  redirect: (BuildContext context, state) async {
    /// Guest Routes
    final List<String> guestRoutes = [
      logInPage,
      signupPage,
      walkthroughPage,
      browserPage,
    ];

    // allow all guest route navigation
    if (guestRoutes.contains(state.matchedLocation)) {
      return null;
    }

    final authRepository = AuthRepository(NetworkProvider());

    final user = await authRepository.getCurrentUserSession();

    // if user is not logged in --- redirect to login page
    if (user == null) {
      return walkthroughPage;
    }

    // if user has not completed on
    if (user.onboarded != true) {
      return onboardingPage;
    }

    // else allow the user to go to the intended route
    return null;
  },
  initialLocation: "/",
  routes: [
    /// Home page shell
    StatefulShellRoute.indexedStack(
      // navigatorKey: _shellNavigatorKey,

      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomePage(child: child);
      },
      branches: [
        // The route branch for the 1º Tab
        StatefulShellBranch(
          // Add this branch routes
          routes: <RouteBase>[
            GoRoute(
                path: "/",
                pageBuilder: (ctx, state) =>
                     NoTransitionPage(child: const ThreadFeedsTabPage(), name: state.path, arguments: state.extra),
                routes: [...innerAuthRoutes]),
          ],
          observers: [
            AppRouteObserver()
          ]
        ),

        // The route branch for 2º Tab
        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          GoRoute(
              path: "/shows",
              pageBuilder: (ctx, state) =>
                   NoTransitionPage(child: const ShowsTabsPage(), name: state.fullPath,  arguments: state.extra),
              routes: [...innerAuthRoutes]),
        ], observers: [
          AppRouteObserver()
        ]),

        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          GoRoute(
              path: notifications,
              pageBuilder: (ctx, state) {
                return NoTransitionPage(child: const NotificationsPage(), name: state.fullPath, arguments: state.extra);
              },
              routes: [...innerAuthRoutes]),
        ],
            observers: [
          AppRouteObserver()
        ]),

        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          GoRoute(
              path: "/chat",
              pageBuilder: (ctx, state) =>
                   NoTransitionPage(child: const ChatConnectionsPage(), name: state.fullPath, arguments: state.extra),
              routes: [...innerAuthRoutes]),
        ], observers: [
          AppRouteObserver()
        ]),
      ],
    ),

    //! Routes which do not require authenticated user
    ...guestRoutes,

    ///! Routes outside the home shell
    GoRoute(
        path: threadEditorPage,
        parentNavigatorKey: _rootNavigator,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>?;
          final ThreadModel? threadToEdit = data?['threadToEdit'] as ThreadModel?;
          final ThreadModel? threadToReply = data?['threadToReply'] as ThreadModel?;
          final String? usernameToReply = data?['usernameToReply'] as String?;
          final CommunityModel? community = data?['community'] as CommunityModel?;
          return CustomTransitionPage(
            key: state.pageKey,
            fullscreenDialog: true,
            name: state.fullPath,
            arguments: data,
            transitionsBuilder: (_, __, ___, child) => child,
            child:  ThreadEditorPage(
              threadToEdit: threadToEdit,
              threadToReply: threadToReply,
              usernameToReply: usernameToReply,
              community: community ?? threadToEdit?.community ?? threadToReply?.community,
            ),
          );
        })

    //
    //

    //
    // GoRoute(
    //   path: showPreviewPage,
    //   builder: (context, state) {
    //     final show = state.extra as ShowModel;
    //     return  ShowPreviewPage(showModel: show);
    //   },
    // ),
    //

    //
    // GoRoute(
    //   path: communitiesPage,
    //   builder: (context, state) {
    //     return  const CommunitiesPage();
    //   },
    // ),
    //
    // GoRoute(
    //   path: dashboardPage,
    //   builder: (context, state) {
    //     return  const DashboardPage();
    //   },
    // ),
    //
    // GoRoute(
    //   path: personalProfilePage,
    //   builder: (context, state) {
    //     return  const UserPersonalProfilePage();
    //   },
    // ),
    //
    // GoRoute(
    //   path: chatPreviewPage,
    //   builder: (context, state) {
    //     final obj = state.extra as Map<String, dynamic>;
    //     final user  = obj['user'] as UserModel;
    //     final connection  = obj['connection'] as ChatConnectionModel;
    //     return  ChatMessagesPage(user: user, connection: connection);
    //   },
    // ),
    //
  ],
);

/// Guest routes (For unauthenticated Users -----------
final guestRoutes = [
  GoRoute(
    path: walkthroughPage,
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const WalkThroughPage()),
  ),

  GoRoute(
    path: logInPage,
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const LoginPage()),
  ),

  GoRoute(
    path: signupPage,
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const SignupPage()),
  ),

  GoRoute(
    path: onboardingPage,
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const OnboardingTabsPage(),),
  ),

  //! shared routes
  GoRoute(
    path: browserPage,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return MaterialPage(child: BrowserPage(url: state.extra as String), arguments: state.extra, name: state.path);
    },
  ),
  GoRoute(
    path: "/$editProfilePage",
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const EditProfilePage()),
  ),
  GoRoute(
    path: youtubePreviewPage,
    parentNavigatorKey: _rootNavigator,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return MaterialPage(child: YoutubePreviewPage(url: state.extra as String), arguments: state.extra, name: state.path);
    },
  ),
];

/// Inner page routes (For authenticated Users -----------
//! we do this to share these routes among the shell routes. So that from any page, you can move to these inner pages whiles maintaining the selected shell tab
final innerAuthRoutes = [
  GoRoute(
    path: personalProfilePage, // stand alone jobs page
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const UserPersonalProfilePage()),
  ),
  GoRoute(
    path: publicProfilePage,
    pageBuilder: (context, state) {
      final user = state.extra as UserModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: UserPublicProfilePage(
        userModel: user,
      ));
    },
  ),
  GoRoute(
    path: dashboardPage,
    pageBuilder: (context, state) {
      return MaterialPage(name: state.path, arguments: state.extra,child: const DashboardPage());
    },
  ),
  GoRoute(
    path: jobsPage, // stand alone jobs page
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const JobsTabsPage()),
  ),
  GoRoute(
    path: jobFiltersPage, // stand alone jobs page
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const JobFiltersPage()),
  ),
  GoRoute(
    path: jobsPositionPage,
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const JobPositionsPage()),
  ),
  GoRoute(
    path: jobsLocationPage,
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const JobLocationsPage()),
  ),

  GoRoute(
    path: jobsTypesPage,
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const JobTypesPage()),
  ),

  GoRoute(
    path: jobsTechStackPage,
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const JobStacksPage()),
  ),


  GoRoute(
    path: threadCodePreviewPage,
    parentNavigatorKey: _rootNavigator,
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      final thread = extra['thread'] as ThreadModel;
      final code = extra['code'] as String;
      final tag = extra['tag'] as String;
      final codeLanguage = extra['codeLanguage'] as String?;
      return CustomTransitionPage(
        fullscreenDialog: true,
        arguments: extra,
        name: state.fullPath,
        opaque: false,
        transitionsBuilder: (_, __, ___, child) => child,
        child: ThreadCodePreviewPage(
          thread: thread,
          code: code,
          tag: tag,
          codeLanguage: codeLanguage,
        ),
      );
    },
  ),
  GoRoute(
    path: showCodePreviewPage,
    parentNavigatorKey: _rootNavigator,
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      final show = extra['show'] as ShowModel;
      final code = extra['code'] as String;
      final tag = extra['tag'] as String;
      final codeLanguage = extra['codeLanguage'] as String?;
      return CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        arguments: extra,
        name: state.fullPath,
        transitionsBuilder: (_, __, ___, child) => child,
        child: ShowCodePreviewPage(
          showModel: show,
          code: code,
          tag: tag,
          codeLanguage: codeLanguage,
        ),
      );
    },
  ),
  GoRoute(
    path: threadImagesPreviewPage,
    parentNavigatorKey: _rootNavigator,
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      final thread = extra['thread'] as ThreadModel;
      final galleryItems = extra['galleryItems'] as List<String>;
      final initialPageIndex = extra['initialPageIndex'] as int;
      return CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        arguments: extra,
        name: state.fullPath,
        transitionsBuilder: (_, __, ___, child) => child,
        child: ThreadImagesPreviewPage(
          thread: thread,
          galleryItems: galleryItems,
          initialPageIndex: initialPageIndex,
        ),
      );
    },
  ),
  GoRoute(
    path: threadVideoPreviewPage,
    parentNavigatorKey: _rootNavigator,
    pageBuilder: (context, state) {
      final thread = state.extra as ThreadModel;
      return CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        arguments: state.extra,
        name: state.fullPath,
        transitionsBuilder: (_, __, ___, child) {
          return child;
        },
        child: ThreadVideoPreviewPage(thread: thread),
      );
    },
  ),
  GoRoute(
    path: threadBrowserPage,
    pageBuilder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final url = data['url'] as String;
      final thread = data['thread'] as ThreadModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: ThreadPreviewBrowserPage(
        url: url,
        thread: thread,
      ));
    },
  ),
  GoRoute(
    path: seriesPreviewPage,
    pageBuilder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final series = data['series'] as SeriesModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: SeriesPreviewPage(
        seriesItem: series,
      ));
    },
  ),
  GoRoute(
    path: roadmapsPreviewPage,
    pageBuilder: (context, state) {
      final roadmap = state.extra as RoadmapModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: RoadmapPreviewPage(
        roadmapModel: roadmap,
      ));
    },
  ),
  GoRoute(
    path: showBrowserPage,

    pageBuilder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final url = data['url'] as String;
      final show = data['show'] as ShowModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: ShowPreviewBrowserPage(
        url: url,
        show: show,
      ));
    },
  ),

  GoRoute(
    path: showVideoPreviewPage,
    parentNavigatorKey: _rootNavigator,
    pageBuilder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final url = data['url'] as String;
      final show = data['show'] as ShowModel;
      return CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        arguments: state.extra,
        name: state.fullPath,
        transitionsBuilder: (_, __, ___, child) {
          return child;
        },
        child:  ShowVideoPreviewPage(
            show: show,
            videoUrl: url,
        ),
      );
    },
  ),


  GoRoute(
    path: showImagesPreviewPage,
    parentNavigatorKey: _rootNavigator,
    pageBuilder: (context, state) {

      final data = state.extra as Map<String, dynamic>;
      final show = data['show'] as ShowModel;

      final galleryItems = data['galleryItems'] as List<String>;
      final initialPageIndex = data['initialPageIndex'] as int;

      return CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        arguments: state.extra,
        name: state.fullPath,
        transitionsBuilder: (_, __, ___, child) => child,
        child: ShowImagesPreviewPage(
          show: show,
          galleryItems: galleryItems,
          initialPageIndex: initialPageIndex,
        ),
      );
    },
  ),

  GoRoute(
    path: chatImagesPreviewPage,
    parentNavigatorKey: _rootNavigator,
    pageBuilder: (context, state) {

      final data = state.extra as Map<String, dynamic>;
      final chat = data['chat'] as ChatMessageModel;
      final galleryItems = data['galleryItems'] as List<String>;
      final initialPageIndex = data['initialPageIndex'] as int;

      return CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        arguments: state.extra,
        name: state.fullPath,
        transitionsBuilder: (_, __, ___, child) => child,
        child: ChatImagesPreviewPage(
          chat: chat,
          galleryItems: galleryItems,
          initialPageIndex: initialPageIndex,
        ),
      );
    },
  ),

  GoRoute(
    path: jobsPreviewPage,
    pageBuilder: (BuildContext context, GoRouterState state) {
      final thread = state.extra as JobModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: JobPreviewPage(job: thread,),);
    },
  ),

  GoRoute(
    path: userResumePreviewPage,
    pageBuilder: (context, state) {
      final user = state.extra as UserModel;
      return  MaterialPage(name: state.path, arguments: state.extra,child: UserResumePage(user: user));
    },
  ),


  GoRoute(
      path: threadPreviewPage,
      pageBuilder: (context, state) {
        final thread = state.extra as ThreadModel;
        return  MaterialPage(name: state.path, arguments: state.extra,
            child: ThreadPreviewPage(thread: thread,)
        );
      },


    ),
  GoRoute(
    path: editProfilePage,
    pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const EditProfilePage()),
  ),
  GoRoute(
    path: threadPollVotersPage,
    pageBuilder: (BuildContext context, GoRouterState state) {
      final thread = state.extra as ThreadModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: ThreadPollVotersPage(
        thread: thread,
      ));
    },
  ),
  GoRoute(
      path: threadUpVotersPage,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final thread = state.extra as ThreadModel;
        return MaterialPage(name: state.path, arguments: state.extra,child: ThreadUpVotersPage(thread: thread,));
      },
    ),
  GoRoute(
      path: showUpVotersPage,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final show = state.extra as ShowModel;
        return MaterialPage(name: state.path, arguments: state.extra,child: ShowUpvotersPage(showModel: show,));
      },
    ),

  GoRoute(
      path: bookmarksPage,
      pageBuilder: (context, state) => MaterialPage(name: state.path, arguments: state.extra,child: const BookmarkTabsPage()),
    ),

  GoRoute(
      path: circlesPage,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final user = data['user'] as UserModel;
        final initialTabIndex = data['initialTabIndex'] as int?;
        return  MaterialPage(name: state.path, arguments: state.extra,child: CircleMembersTabsPage(user: user, initialTabIndex: initialTabIndex ?? 0,));
      },
    ),

  GoRoute(
    path: settingsPage,
    pageBuilder: (context, state) {
      return MaterialPage(name: state.path, arguments: state.extra,child: const SettingsPage());
    },
  ),
  GoRoute(
    path: jobPreferencesSettingsPage,
    pageBuilder: (context, state) {
      return MaterialPage(name: state.path, arguments: state.extra,child: const JobPreferences());
    },
  ),
  GoRoute(
    path: communityPreviewPage,
    pageBuilder: (context, state) {
      final community = state.extra as CommunityModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: CommunityPreviewPage(
        communityModel: community,
      ));
    },
  ),
  GoRoute(
    path: showPreviewPage,
    pageBuilder: (context, state) {
      final show = state.extra as ShowModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: ShowPreviewPage(showModel: show));
    },
  ),
  GoRoute(
    path: showCommentsEditorPage,
    pageBuilder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final show = data['show'] as ShowModel;
      final commentToEdit = data['commentToEdit'] as ShowCommentModel?;
      final parentComment = data['parentComment'] as ShowCommentModel?;
      return  MaterialPage(name: state.path, arguments: state.extra,child: ShowCommentsEditorPage(showModel: show, commentToEdit: commentToEdit, parentComment: parentComment,));
    },
  ),
  GoRoute(
    path: showCommentsPage,
    pageBuilder: (context, state) {
      final show = state.extra as ShowModel;
      return  MaterialPage(name: state.path, arguments: state.extra,child: ShowCommentsPage(showModel: show),);
    },
  ),

  GoRoute(
      path: notificationsPage,
      pageBuilder: (context, state) {
        final notification = state.extra as NotificationModel;
        return  MaterialPage(name: state.path, arguments: state.extra,child: NotificationInitiatorsPage(notificationModel: notification,));
      },
    ),


  GoRoute(
    path: searchPage,
    pageBuilder: (BuildContext context, GoRouterState state) {
      final searchText = state.extra as String?;

      return CustomTransitionPage(
        key: state.pageKey,
        fullscreenDialog: true,
        arguments: state.extra,
        name: state.fullPath,
        transitionsBuilder: (_, __, ___, child) => child,
        child:  SearchPage(searchText: searchText,),
      );
    },

  ),

  GoRoute(
    path: explorePage,
    pageBuilder: (context, state) {
      return  MaterialPage(
          name: state.path,
          arguments: state.extra,child: const ExplorePage()
      );
    },
  ),

  GoRoute(
    path: createGuestBook,
    pageBuilder: (context, state) {
      final userName = state.extra as String;

      return  MaterialPage(name: state.path, arguments: state.extra,child:  CreateGuestBookPage( userName: userName,));
    },
  ),

  GoRoute(
    path: editGuestBook,
    pageBuilder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final String userName = data['userName'];
      final String message = data['message'];
      final int guestbookId = data['guestbookId'];

      return  MaterialPage(name: state.path, arguments: state.extra,child:  EditGuestBookPage( userName: userName, message: message, guestbookId: guestbookId,));
    },
  ),


  GoRoute(
    path: communityDetailsPreviewPage,
    pageBuilder: (context, state) {
      final community = state.extra as CommunityModel;
      return MaterialPage(
          name: state.path,
          arguments: state.extra,
          child: CommunitiesDetailsPage(communityModel: community)
      );
    },
  ),
  GoRoute(
    path: communitiesSettingsPage,
    pageBuilder: (context, state) {
      final community = state.extra as CommunityModel;
      return MaterialPage(name: state.path, arguments: state.extra,child: CommunitySettings(communityModel: community));
    },
  ),
  GoRoute(
    path: refferalsPage,
    pageBuilder: (context, state) {
      return MaterialPage(
          name: state.path,
          arguments: state.extra,child: const Referrals()
      );
    },
  ),
  GoRoute(
    path: discoverCommunitiesPage,
    pageBuilder: (context, state) {
      return MaterialPage(
          name: state.path,
          arguments: state.extra,
          child: const DiscoverCommunitiesPage()
      );
    },
  ),
  GoRoute(
    path: seeMoreActiveCommunities,
    pageBuilder: (context, state) {
      return MaterialPage(name: state.path, arguments: state.extra,child: const SeeMoreActiveCommunities());
    },
  ),
  GoRoute(
    path: seeMoreGrowingCommunities,
    pageBuilder: (context, state) {
      return MaterialPage(name: state.path, arguments: state.extra,child: const SeeMoreFastestGrowingCommunities());
    },
  ),
  GoRoute(
    path: seeMoreProposedCommunities,
    pageBuilder: (context, state) {
      return MaterialPage(name: state.path, arguments: state.extra,child: const SeeMoreProposedCommunities());
    },
  ),
  GoRoute(
    path: chatPreviewPage,
    pageBuilder: (context, state) {
      final obj = state.extra as Map<String, dynamic>;
      final user  = obj['user'] as UserModel;
      final connection  = obj['connection'] as ChatConnectionModel;
      return  MaterialPage(name: state.path, arguments: state.extra,child: ChatMessagesPage(user: user, connection: connection));
    },
  ),
  GoRoute(
    path: searchResultsPage,
    pageBuilder: (context, state) {
      final searchText = state.extra as String;
      return MaterialPage(name: state.path, arguments: state.extra,child: SearchResultsTabsPage(searchText: searchText,));
    },
  ),
  GoRoute(
    path: accountSettingsPage,
    pageBuilder: (context, state) {
      return MaterialPage(name: state.path, arguments: state.extra,child: const AccountSettingsPage());
    },
  ),
  GoRoute(
    path: displaySettingsPage,
    pageBuilder: (context, state) {
      return MaterialPage(name: state.path, arguments: state.extra,child: const DisplaySettingsPage());
    },
  ),
  GoRoute(
    path: interestSettingPage,
    pageBuilder: (context, state) {
      return MaterialPage(name: state.path, arguments: state.extra,child: const AreasOfInterestSettingsPage());
    },
  ),
  GoRoute(
    path: collaboratorsRequest,
    pageBuilder: (context, state) {
      final userModel = state.extra as UserModel ;
      return MaterialPage(
          name: state.path,
          arguments: state.extra,
          child:  CollaborationRequestPage(userModel: userModel,)
      );
    },
  ),
  GoRoute(
    path: spacesPage,
    pageBuilder: (context, state) {
      // final userModel = state.extra as UserModel ;
      return MaterialPage(
          name: state.path,
          arguments: state.extra,
          child:  const SpacesPage()
      );
    },
  ),
  GoRoute(
      path: spaceEditorPage,
      pageBuilder: (BuildContext context, GoRouterState state) {
        // final data = state.extra as Map<String, dynamic>?;
        // final ThreadModel? threadToEdit = data?['threadToEdit'] as ThreadModel?;
        // final ThreadModel? threadToReply = data?['threadToReply'] as ThreadModel?;
        // final String? usernameToReply = data?['usernameToReply'] as String?;
        // final CommunityModel? community = data?['community'] as CommunityModel?;
        return CustomTransitionPage(
          key: state.pageKey,
          fullscreenDialog: true,
          name: state.fullPath,
          arguments: state.extra,
          transitionsBuilder: (_, __, ___, child) => child,
          child:  const SpacesEditorPage(),
        );
      }
  ),


  GoRoute(
    path: seriesProjectsPreviewPage,
    pageBuilder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final SeriesModel seriesModel = data['series'];
      final int? initialProjectIndex = data['initialProjectIndex'] as int? ;
      // final
      return MaterialPage(name: state.path, arguments: state.extra,
          child:  SeriesProjectsPreviewPage(seriesModel: seriesModel, initialProjectIndex: initialProjectIndex ?? 0,)
      );
    },
  ),
  GoRoute(
    path: editWelcomeScreen,
    pageBuilder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final WelcomeScreenResponse? welcomeScreenResponse = data['welcomeScreenResponse'];
      final CommunityModel? communityModel = data['communitiesResponse']  ;
      final int? welcomeScreenIndex = data['welcomeScreenIndex'] as int? ;
      // final
      return MaterialPage(
          name: state.path,
          arguments: state.extra,
          child:  EditWelcomeScreen(welcomeScreenResponse: welcomeScreenResponse, communityModel: communityModel,welcomeScreenIndex : welcomeScreenIndex)
      );
    },
  ),
];
