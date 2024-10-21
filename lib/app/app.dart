import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:showwcase_v3/app/routing/routes.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/injector.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_broadcast_repository.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_repository.dart';
import 'package:showwcase_v3/features/bookmarks/data/bloc/bookmark_shows_cubit.dart';
import 'package:showwcase_v3/features/bookmarks/data/bloc/bookmark_threads_cubit.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/repositories/chat_repository.dart';
import 'package:showwcase_v3/features/chat/data/repositories/chat_socket_repository.dart';
import 'package:showwcase_v3/features/circles/data/bloc/circles_cubit.dart';
import 'package:showwcase_v3/features/circles/data/repositories/circles_broadcast_repository.dart';
import 'package:showwcase_v3/features/circles/data/repositories/circles_repository.dart';
import 'package:showwcase_v3/features/communities/data/bloc/active_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_all_threads_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_code_thread_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_links_thread_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_media_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_members_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_poll_thread_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_preview_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/drawer_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/growing_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/proposed_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/suggested_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/thread_editor_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/repositories/community_broadcast_repository.dart';
import 'package:showwcase_v3/features/communities/data/repositories/community_repository.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_cubit.dart';
import 'package:showwcase_v3/features/companies/data/repositories/company_repository.dart';
import 'package:showwcase_v3/features/dashboard/data/bloc/dashboard_cubit.dart';
import 'package:showwcase_v3/features/dashboard/data/bloc/dashboard_shows_cubit.dart';
import 'package:showwcase_v3/features/dashboard/data/bloc/dashboard_thread_cubit.dart';
import 'package:showwcase_v3/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:showwcase_v3/features/explore/data/bloc/explore_cubit.dart';
import 'package:showwcase_v3/features/explore/data/repositories/explore_repository.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/file_manager/data/repositories/file_manager_repository.dart';
import 'package:showwcase_v3/features/guestbook/data/bloc/guestbook_cubit.dart';
import 'package:showwcase_v3/features/guestbook/data/repositories/guestbook_repository.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_enums.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_state.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/bookmarked_job_feeds_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/job_feeds_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/job_preview_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/repositories/job_broadcast_repository.dart';
import 'package:showwcase_v3/features/jobs/data/repositories/jobs_repository.dart';
import 'package:showwcase_v3/features/locations/data/bloc/location_cubit.dart';
import 'package:showwcase_v3/features/locations/data/repositories/location_repository.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_all_cubit.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_community_cubit.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_cubit.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_mention_cubit.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_requests_cubit.dart';
import 'package:showwcase_v3/features/notifications/repositories/notification_repository.dart';
import 'package:showwcase_v3/features/refferals/data/bloc/invite_cubit.dart';
import 'package:showwcase_v3/features/refferals/data/repositories/invites_repository_impl.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_archived_series_cubit.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_contributors_cubit.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_cubit.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_preview_cubit.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_related_communities_cubit.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_series_cubit.dart';
import 'package:showwcase_v3/features/roadmaps/data/repositories/roadmap_repository.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_communities_cubit.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_cubit.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_shows_cubit.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_threads_cubit.dart';
import 'package:showwcase_v3/features/search/data/repositories/search_respository.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_cubit.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_feeds_cubit.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_preview_cubit.dart';
import 'package:showwcase_v3/features/series/data/repositories/series_repository.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_cubit.dart';
import 'package:showwcase_v3/features/shared/data/repositories/shared_repository.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_feeds_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_browser_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_code_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_images_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_video_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_upvoters_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_broadcast_repository.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_repository.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_cubit.dart';
import 'package:showwcase_v3/features/spaces/data/repositories/spaces_repository.dart';
import 'package:showwcase_v3/features/threads/data/bloc/following_feeds_thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/for_you_feeds_thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/latest_feeds_thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/news_feeds_thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_poll_voters_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_browser_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_code_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_images_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_video_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_up_voters_cubit.dart';
import 'package:showwcase_v3/features/threads/data/repositories/thread_broadcast_repository.dart';
import 'package:showwcase_v3/features/threads/data/repositories/thread_repository.dart';
import 'package:showwcase_v3/features/users/data/bloc/profile_series_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/profile_shows_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/profile_threads_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/users_cubit.dart';
import 'package:showwcase_v3/features/users/data/repositories/user_broadcast_repository.dart';
import 'package:showwcase_v3/features/users/data/repositories/user_repository.dart';

import '../features/roadmaps/data/bloc/roadmap_archived_shows_cubit.dart';
import '../features/search/data/bloc/search_users_cubit.dart';

class App extends StatelessWidget {

  final AdaptiveThemeMode? savedThemeMode;

  const App({this.savedThemeMode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(

      light: lightTheme(context),
      dark: darkTheme(context),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (ThemeData theme, ThemeData darkTheme) {
        
        final userRepository = sl<UserRepository>();
        final authRepository = sl<AuthRepository>();
        final authBroadcastRepository = sl<AuthBroadcastRepository>();
        final fileManagerRepository = sl<FileManagerRepository>();
        final communityRepository = sl<CommunityRepository>();
        final companyRepository = sl<CompanyRepository>();
        final locationRepository = sl<LocationRepository>();
        final sharedRepository = sl<SharedRepository>();
        final threadRepository = sl<ThreadRepository>();
        final showsRepository = sl<ShowsRepository>();
        final circlesRepository = sl<CirclesRepository>();
        final circlesBroadcastRepository = sl<CirclesBroadcastRepository>();
        final threadBroadCastRepository = sl<ThreadBroadcastRepository>();
        final showsBroadCastRepository = sl<ShowsBroadcastRepository>();
        final communityBroadCastRepository = sl<CommunityBroadcastRepository>();
        final jobsRepository = sl<JobsRepository>();
        final jobsBroadcastRepository = sl<JobBroadcastRepository>();
        final userBroadCastRepository = sl<UserBroadcastRepository>();
        final chatRepository = sl<ChatRepository>();
        final searchRepository = sl<SearchRepository>();
        final exploreRepository = sl<ExploreRepository>();
        final dashBoardRepository = sl<DashboardRepository>();
        final chatSocket = sl<ChatSocketRepository>();
        final seriesRepository = sl<SeriesRepository>();
        final notificationRepository = sl<NotificationRepository>();
        final inviteRepository = sl<InvitesRepository>();
        final roadmapRepository = sl<RoadmapRepository>();
        final guestbookRepository = sl<GuestBookRepository>();
        final spacesRepository = sl<SpacesRepository>();

        return MultiBlocProvider(
            providers: [
              /// Register global providers
              BlocProvider(create: (context) => AuthCubit(authRepository: authRepository, authBroadcastRepository: authBroadcastRepository, userBroadcastRepository: userBroadCastRepository)),
              BlocProvider(create: (context) => UserProfileCubit(userRepository: userRepository, authBroadcastRepository: authBroadcastRepository, userBroadcastRepository: userBroadCastRepository, circlesBroadcastRepository: circlesBroadcastRepository)),
              BlocProvider(create: (context) => UsersCubit(userRepository: userRepository, userBroadcastRepository: userBroadCastRepository)),

              BlocProvider(create: (context) => FileManagerCubit(fileManagerRepository: fileManagerRepository)),
              BlocProvider(create: (context) => CommunityCubit(communityRepository: communityRepository, authBroadcastRepository: authBroadcastRepository, communityBroadcastRepository: communityBroadCastRepository,)),
              BlocProvider(create: (context) => DrawerCommunitiesCubit(communityRepository: communityRepository, authBroadcastRepository: authBroadcastRepository, communityBroadcastRepository: communityBroadCastRepository,)),
              BlocProvider(create: (context) => ThreadEditorCommunitiesCubit(communityRepository: communityRepository, authBroadcastRepository: authBroadcastRepository, communityBroadcastRepository: communityBroadCastRepository,)),
              BlocProvider(create: (context) => SuggestedCommunitiesCubit(communityRepository: communityRepository, authBroadcastRepository: authBroadcastRepository, communityBroadcastRepository: communityBroadCastRepository,)),
              BlocProvider(create: (context) => ProposedCommunitiesCubit(communityRepository: communityRepository, authBroadcastRepository: authBroadcastRepository, communityBroadcastRepository: communityBroadCastRepository,)),
              BlocProvider(create: (context) => ActiveCommunitiesCubit(communityRepository: communityRepository, authBroadcastRepository: authBroadcastRepository, communityBroadcastRepository: communityBroadCastRepository,)),
              BlocProvider(create: (context) => GrowingCommunitiesCubit(communityRepository: communityRepository, authBroadcastRepository: authBroadcastRepository, communityBroadcastRepository: communityBroadCastRepository,)),
              BlocProvider(create: (context) => CommunityPreviewCubit(communityRepository: communityRepository, communityBroadcastRepository: communityBroadCastRepository)),


              BlocProvider(create: (context) => CompanyCubit(companyRepository: companyRepository)),
              BlocProvider(create: (context) => LocationCubit(locationRepository: locationRepository)),
              BlocProvider(create: (context) => SharedCubit(sharedRepository: sharedRepository)),
              BlocProvider(create: (context) => HomeCubit()),
              BlocProvider(create: (context) => JobsCubit(jobsRepository: jobsRepository, jobBroadcastRepository: jobsBroadcastRepository)),
              BlocProvider(create: (context) => JobFeedsCubit(jobsRepository: jobsRepository, jobBroadcastRepository: jobsBroadcastRepository)),
              BlocProvider(create: (context) => JobPreviewCubit(jobsRepository: jobsRepository, jobBroadcastRepository: jobsBroadcastRepository)),
              BlocProvider(create: (context) => BookmarkedJobFeedsCubit(jobsRepository: jobsRepository, jobBroadcastRepository: jobsBroadcastRepository)),
              BlocProvider(create: (context) => InvitesCubit(invitesRepository: inviteRepository)),
              BlocProvider(create: (context) => DashboardCubit(dashboardRepository: dashBoardRepository)),
              BlocProvider(create: (context) => ShowPreviewCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => ShowPreviewVideoCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => ShowPreviewBrowserCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => ShowPreviewImagesCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => ShowPreviewCodeCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => ThreadCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              //! subclasses of ThreadCubit here --
              BlocProvider(create: (context) => CommunityMembersCubit(userRepository: userRepository, userBroadcastRepository: userBroadCastRepository )),
              BlocProvider(create: (context) => CommunityMediaThreadsCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => CommunityAllThreadsCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => CommunityCodeThreadsCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => CommunityLinkThreadsCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => CommunityPollThreadsCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => ForYouFeedsThreadCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => NewsFeedsThreadCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => LatestFeedsThreadCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => FollowingFeedsThreadCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => BookmarkThreadsCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => DashboardThreadsCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => ProfileThreadsCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => ThreadPollVotersCubit(threadRepository)),
              BlocProvider(create: (context) => ThreadUpVotersCubit(threadRepository)),
              BlocProvider(create: (context) => ThreadPreviewCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => ThreadPreviewBrowserCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => ThreadPreviewImagesCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => ThreadPreviewVideoCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => ThreadPreviewCodeCubit(threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => ChatCubit(chatRepository: chatRepository, chatSocket: chatSocket,searchRepository: searchRepository, authBroadcastRepository: authBroadcastRepository)),
              BlocProvider(create: (context) => CirclesCubit(circlesRepository: circlesRepository, circlesBroadcastRepository: circlesBroadcastRepository)),
              BlocProvider(create: (context) => CommunityAdminCubit(communitiesRepository: communityRepository)),
              BlocProvider(create: (context) => ShowsCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
             // Subclasses of ShowsCubit here ---
              BlocProvider(create: (context) => ShowFeedsCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => BookmarkShowsCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => DashboardShowsCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => ProfileShowsCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => ShowUpVotersCubit(showsRepository: showsRepository)),

              BlocProvider(create: (context) => SeriesCubit(seriesRepository: seriesRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => SeriesPreviewCubit(seriesRepository: seriesRepository, showsBroadcastRepository: showsBroadCastRepository)),
              // Subclasses of SeriesCubit here ---
              BlocProvider(create: (context) => SeriesFeedsCubit(seriesRepository: seriesRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => ProfileSeriesFeedsCubit(seriesRepository: seriesRepository, showsBroadcastRepository: showsBroadCastRepository)),

              BlocProvider(create: (context) => NotificationCubit(notificationRepository: notificationRepository)),
              // Subclasses of Notifications here ---
              BlocProvider(create: (context) => NotificationAllCubit(notificationRepository: notificationRepository)),
              BlocProvider(create: (context) => NotificationMentionsCubit(notificationRepository: notificationRepository)),
              BlocProvider(create: (context) => NotificationCommunityCubit(notificationRepository: notificationRepository)),
              BlocProvider(create: (context) => NotificationRequestsCubit(notificationRepository: notificationRepository)),

              BlocProvider(create: (context) => SearchCubit(searchRepository: searchRepository)),
              BlocProvider(create: (context) => SearchCommunitiesCubit(communityRepository: communityRepository, authBroadcastRepository: authBroadcastRepository, communityBroadcastRepository: communityBroadCastRepository,)),
              BlocProvider(create: (context) => SearchShowsCubit(showsRepository: showsRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => SearchThreadsCubit( threadRepository, threadBroadcastRepository: threadBroadCastRepository)),
              BlocProvider(create: (context) => SearchUsersCubit(userRepository: userRepository, userBroadcastRepository: userBroadCastRepository, )),

              BlocProvider(create: (context) => ExploreCubit(exploreRepository: exploreRepository)),
              BlocProvider(create: (context) => RoadmapCubit(roadmapRepository: roadmapRepository)),
              BlocProvider(create: (context) => RoadmapPreviewCubit(roadmapRepository: roadmapRepository)),
              BlocProvider(create: (context) => RoadmapArchivedSeriesCubit(seriesRepository: seriesRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => RoadmapSeriesCubit(seriesRepository: seriesRepository, showsBroadcastRepository: showsBroadCastRepository)),
              BlocProvider(create: (context) => RoadmapArchivedShowsCubit(showsBroadcastRepository: showsBroadCastRepository, showsRepository: showsRepository)),
              BlocProvider(create: (context) => RoadmapContributorsCubit(userRepository: userRepository, userBroadcastRepository: userBroadCastRepository)),
              BlocProvider(create: (context) => RoadmapRelatedCommunitiesCubit(communityRepository: communityRepository, authBroadcastRepository: authBroadcastRepository, communityBroadcastRepository: communityBroadCastRepository, )),
              BlocProvider(create: (context) => GuestbookCubit(guestBookRepository: guestbookRepository)),
              BlocProvider(create: (context) => SpacesCubit(spacesRepository: spacesRepository)),

            ],
            child: RefreshConfiguration(
              child: BackGestureWidthTheme(
                backGestureWidth: BackGestureWidth.fraction(1.0),
                child: MaterialApp.router(
                      title: 'Showwcase',
                      darkTheme: darkTheme,
                      debugShowCheckedModeBanner: false,
                          theme: theme.copyWith(
                            pageTransitionsTheme: const PageTransitionsTheme(
                              builders: {
                                TargetPlatform.android: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
                                TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
                              },
                            ),
                          ),
                      routerConfig: router,
                      builder: (ctx, widget) => _Initialize(child: widget),
                    ),
              ),
            )

        );
      },
    );
  }
}


/// Global App Initializations --------
class _Initialize extends StatefulWidget {

  final Widget? child;
  const _Initialize({Key? key, required this.child}) : super(key: key);

  @override
  State<_Initialize> createState() => _InitializeState();
}

class _InitializeState extends State<_Initialize> {

  late ChatCubit chatCubit;

  @override
  void initState() {
    super.initState();


    // session Id is used through out the app for api requests
    // the server requires it for impressions
    AppStorage.refreshSessionId();

    // initialize global cubit dependencies
    final userCubit = context.read<UserProfileCubit>();
    context.read<AuthCubit>();
    context.read<CommunityCubit>();
    context.read<SharedCubit>();
    context.read<CompanyCubit>();
    chatCubit = context.read<ChatCubit>();
    context.read<ShowFeedsCubit>().fetchShowCategories();

    /// Initializations that requires user to be logged in are initialized here ----
    onWidgetBindingComplete(onComplete: () async {
      final user = AppStorage.currentUserSession;
      if(user != null) {
          userCubit.setUserInfo(userInfo: user);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // all initializations of app status bar, app navigation bar setup
    // setAppSystemOverlay(theme: theme, useThemeOverlays: true);
    setSystemUIOverlays(theme.brightness);
    return widget.child ?? const SizedBox.shrink();
  }
}

