import 'package:get_it/get_it.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_broadcast_repository.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_repository.dart';
import 'package:showwcase_v3/features/chat/data/repositories/chat_repository.dart';
import 'package:showwcase_v3/features/chat/data/repositories/chat_socket_repository.dart';
import 'package:showwcase_v3/features/circles/data/repositories/circles_broadcast_repository.dart';
import 'package:showwcase_v3/features/circles/data/repositories/circles_repository.dart';
import 'package:showwcase_v3/features/communities/data/repositories/community_broadcast_repository.dart';
import 'package:showwcase_v3/features/communities/data/repositories/community_repository.dart';
import 'package:showwcase_v3/features/companies/data/repositories/company_repository.dart';
import 'package:showwcase_v3/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:showwcase_v3/features/explore/data/repositories/explore_repository.dart';
import 'package:showwcase_v3/features/file_manager/data/repositories/file_manager_repository.dart';
import 'package:showwcase_v3/features/guestbook/data/repositories/guestbook_repository.dart';
import 'package:showwcase_v3/features/jobs/data/repositories/job_broadcast_repository.dart';
import 'package:showwcase_v3/features/jobs/data/repositories/jobs_repository.dart';
import 'package:showwcase_v3/features/locations/data/repositories/location_repository.dart';
import 'package:showwcase_v3/features/notifications/repositories/notification_repository.dart';
import 'package:showwcase_v3/features/refferals/data/repositories/invites_repository_impl.dart';
import 'package:showwcase_v3/features/roadmaps/data/repositories/roadmap_repository.dart';
import 'package:showwcase_v3/features/search/data/repositories/search_respository.dart';
import 'package:showwcase_v3/features/series/data/repositories/series_repository.dart';
import 'package:showwcase_v3/features/shared/data/repositories/shared_repository.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_broadcast_repository.dart';
import 'package:showwcase_v3/features/shows/data/repositories/shows_repository.dart';
import 'package:showwcase_v3/features/spaces/data/repositories/spaces_repository.dart';
import 'package:showwcase_v3/features/threads/data/repositories/thread_broadcast_repository.dart';
import 'package:showwcase_v3/features/threads/data/repositories/thread_repository.dart';
import 'package:showwcase_v3/features/users/data/repositories/user_broadcast_repository.dart';
import 'package:showwcase_v3/features/users/data/repositories/user_repository.dart';

/// Using Get It as the service locator -> for dependency injections
final sl = GetIt.instance;

/// Initializes all dependencies.
/// We register as lazy singletons to boost performance
/// meaning, Get It would instantiate objects on demand
Future<void> init() async {

  //! State managements
  // eg: sl.registerFactory(() => ExampleBloc());
  sl.registerLazySingleton(() => ThreadBroadcastRepository());
  sl.registerLazySingleton(() => AuthBroadcastRepository());
  sl.registerLazySingleton(() => ShowsBroadcastRepository());
  sl.registerLazySingleton(() => UserBroadcastRepository());
  sl.registerLazySingleton(() => CommunityBroadcastRepository());
  sl.registerLazySingleton(() => CirclesBroadcastRepository());
  sl.registerLazySingleton(() => JobBroadcastRepository());
  // sl.registerLazySingleton(() => ExampleRepository());


  //! External
   sl.registerLazySingleton(() => NetworkProvider());

  //! Repositories
   sl.registerLazySingleton(() => UserRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => AuthRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => FileManagerRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => CommunityRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => CompanyRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => LocationRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => SharedRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => ThreadRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => ShowsRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => CirclesRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => JobsRepository(networkProvider: sl<NetworkProvider>()));
   sl.registerLazySingleton(() => ChatRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => SearchRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => ExploreRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => DashboardRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => ChatSocketRepository());
   sl.registerLazySingleton(() => SeriesRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => NotificationRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => InvitesRepository(networkProvider: sl<NetworkProvider>()));
   sl.registerLazySingleton(() => RoadmapRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => GuestBookRepository(sl<NetworkProvider>()));
   sl.registerLazySingleton(() => SpacesRepository(sl<NetworkProvider>()));


  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  //! Data sources
  //eg: sl.registerLazySingleton<ICacheDataSource>(() => CacheDataSourceImpl(sl()));

  //! Core
  //eg: sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  //eg: sl.registerLazySingleton(() => http.Client());


}