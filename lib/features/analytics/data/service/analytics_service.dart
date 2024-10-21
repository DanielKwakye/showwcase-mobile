import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/features/analytics/data/repositories/analytics_repository.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Singleton instance
  static final AnalyticsService instance = AnalyticsService._();

  final analyticsRepository = AnalyticsRepository(NetworkProvider());

  // Private constructor
  AnalyticsService._();

  // Method to send a custom event
  Future<void> sendEvent(String eventName, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }

  Future<void> sendEventCommunityJoin({required CommunityModel communityModel}) async {
    Map<String, dynamic> parameters =  {
      'community_id': communityModel.id,
      'page_name': communityPreviewPage,
      'page_title': communityModel.name,
      'page_url': 'https://www.showwcase.com/community/${communityModel.slug}',
      'page_id': communityModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'community_join', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'community_join',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventProfileFollowAndUnfollow({required UserModel userModel ,required FollowerAction action}) async {
    Map<String, dynamic> parameters =  {
      'profile_id': userModel.id,
      'page_name': publicProfilePage,
      'page_title': userModel.displayName,
      'page_url': 'https://www.showwcase.com/${userModel.username}',
      'page_id': userModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name:  action == FollowerAction.follow ? 'profile_follow' :'profile_unfollow', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action':  action == FollowerAction.follow ? 'profile_follow' :'profile_unfollow',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventSeriesTap({required SeriesModel seriesModel,required String pageName}) async {
    Map<String, dynamic> parameters =  {
      'series_id': seriesModel.id,
      'page_name': pageName,
      'page_title': seriesModel.title,
      'page_url': 'https://www.showwcase.com/series/${seriesModel.id}/${seriesModel.slug}',
      'page_id': seriesModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'series_tap', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'series_tap',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventSeriesImpression({required SeriesModel seriesModel,required String pageName}) async {
    Map<String, dynamic> parameters =  {
      'series_id': seriesModel.id,
      'page_name': pageName,
      'page_title': seriesModel.title,
      'page_url': 'https://www.showwcase.com/series/${seriesModel.id}/${seriesModel.slug}',
      'page_id': seriesModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'series_impression', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'series_impression',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventThreadLinkTap({required ThreadModel threadModel,required String pageName}) async {
    Map<String, dynamic> parameters =  {
      'thread_id': threadModel.id,
      'page_name': pageName,
      'page_title': threadModel.title,
      'page_url': 'https://www.showwcase.com/thread/${threadModel.id}',
      'page_id': threadModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'thread_link_tap', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'thread_link_tap',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventShowsImpression({required ShowModel showModel,required String pageName}) async {
    Map<String, dynamic> parameters =  {
      'series_id': showModel.id,
      'page_name': pageName,
      'page_title': showModel.title,
      'page_url': 'https://www.showwcase.com/show/${showModel.id}/${showModel.slug}',
      'page_id': showModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'show_impression', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'show_impression',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventResumeGenerate({required UserModel userModel,required String pageName}) async {
    Map<String, dynamic> parameters =  {
      'page_name': pageName,
      'page_title': userModel.username,
      'page_url': userModel.resumeUrl,
      'page_id': userModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'resume_generate', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'resume_generate',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventResumePreview({required UserModel userModel,required String pageName}) async {
    Map<String, dynamic> parameters =  {
      'page_name': pageName,
      'page_title': userModel.username,
      'page_url': userModel.resumeUrl,
      'page_id': userModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'resume_preview', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'resume_preview',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventResumeView({required UserModel userModel,required String pageName}) async {
    Map<String, dynamic> parameters =  {
      'page_name': pageName,
      'page_title': userModel.username,
      'page_url': userModel.resumeUrl,
      'page_id': userModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'resume_view', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'resume_view',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventCommunityImpression({required CommunityModel communityModel,required String pageName,required String containerName}) async {
    Map<String, dynamic> parameters =  {
      'page_name': pageName,
      'community_id': communityModel.id,
      'container_name': containerName,
      'page_title': communityModel.name,
      'page_url': 'https://www.showwcase.com/community/${communityModel.slug}',
      'page_id': communityModel.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'community_impression', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'community_impression',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventSignUpSuccess() async {
    Map<String, dynamic> parameters =  {
      'page_name': 'complete_profile',
      'page_title': AppStorage.currentUserSession?.username,
      'page_id': AppStorage.currentUserSession?.id,
      'origin': 'internal',
    };
    await _analytics.logEvent(name: 'signup_success', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'signup_success',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventSeriesStart({required SeriesModel seriesModel,required String containerName,required String pageName }) async {
    Map<String, dynamic> parameters =  {
      'series_id': seriesModel.id,
      'page_name': pageName,
      'page_title': seriesModel.title,
      'page_id': seriesModel.id,
      'origin': 'internal',
      'container_name': containerName,
      'page_url': 'https://www.showwcase.com/series/${seriesModel.id}/${seriesModel.slug}',
    };
    await _analytics.logEvent(name: 'series_start', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'series_start',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventJobApply({required JobModel jobModel}) async {
    Map<String, dynamic> parameters =  {
      'job_id': jobModel.id,
      'page_name': jobsPreviewPage,
      'page_title': jobModel.title,
      'page_id': jobModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/jobs/${jobModel.id}/${jobModel.slug}',
    };
    await _analytics.logEvent(name: 'job_apply', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'job_apply',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventShowCopyLink({required ShowModel showModel,required String pageName }) async {
    Map<String, dynamic> parameters =  {
      'show_id': showModel.id,
      'page_name': pageName,
      'page_title': showModel.title,
      'page_id': showModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/show/${showModel.id}/${showModel.slug}',
    };
    await _analytics.logEvent(name: 'show_copy_link', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'show_copy_link',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventShowBookmarks({required ShowModel showModel,required String pageName }) async {
    Map<String, dynamic> parameters =  {
      'show_id': showModel.id,
      'page_name': pageName,
      'page_title': showModel.title,
      'page_id': showModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/show/${showModel.id}/${showModel.slug}',
    };
    await _analytics.logEvent(name: 'show_bookmark', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'show_bookmark',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventShowComments({required ShowModel showModel ,required  ShowCommentModel showCommentModel }) async {
    Map<String, dynamic> parameters =  {
      'show_id': showModel.id,
      'page_name': showCommentsPage,
      'page_title': showModel.title,
      'page_id': showModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/show/${showModel.id}/${showModel.slug}',
      'comment_id': showCommentModel.id,
    };
    await _analytics.logEvent(name: 'show_comment', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'show_comment',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventShowLike({required ShowModel showModel  }) async {
    Map<String, dynamic> parameters =  {
      'show_id': showModel.id,
      'page_name': showCommentsPage,
      'page_title': showModel.title,
      'page_id': showModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/show/${showModel.id}/${showModel.slug}',
    };
    await _analytics.logEvent(name: 'show_like', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'show_like',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventShowTap({required ShowModel showModel,required String pageName }) async {
    Map<String, dynamic> parameters =  {
      'show_id': showModel.id,
      'page_name': pageName,
      'page_title': showModel.title,
      'page_id': showModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/show/${showModel.id}/${showModel.slug}',
    };
    await _analytics.logEvent(name: 'show_tap', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'show_tap',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventJobTap({required JobModel jobModel ,required String containerName}) async {
    Map<String, dynamic> parameters =  {
      'job_id': jobModel.id,
      'page_name': jobsPage,
      'page_title': jobModel.title,
      'page_id': jobModel.id,
      'origin': 'internal',
      'containerName': containerName,
      'page_url': 'https://www.showwcase.com/job/${jobModel.id}/${jobModel.slug}',
    };
    await _analytics.logEvent(name: 'job_tap', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'job_tap',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventJobImpression({required JobModel jobModel ,required String containerName}) async {
    Map<String, dynamic> parameters =  {
      'job_id': jobModel.id,
      'page_name': jobsPage,
      'page_title': jobModel.title,
      'page_id': jobModel.id,
      'origin': 'internal',
      'containerName': containerName,
      'page_url': 'https://www.showwcase.com/job/${jobModel.id}/${jobModel.slug}',
    };
    await _analytics.logEvent(name: 'job_impression', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'job_impression',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventThreadPost({required ThreadModel threadModel }) async {
    Map<String, dynamic> parameters =  {
      'thread_id': threadModel.id,
      'page_name': 'create_thread',
      'page_title': threadModel.title,
      'page_id': threadModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/thread/${threadModel.id}',
      'thread_parent_id': threadModel.parentId,
      'thread_community_id': threadModel.communityId,
      'thread_composer':'main',
    };
    await _analytics.logEvent(name: 'thread_post', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'thread_post',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventThreadDelete({required ThreadModel threadModel,required String pageName  }) async {
    Map<String, dynamic> parameters =  {
      'thread_id': threadModel.id,
      'page_name': pageName,
      'page_title': threadModel.title,
      'page_id': threadModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/thread/${threadModel.id}',
    };
    await _analytics.logEvent(name: 'thread_delete', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'thread_delete',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventThreadBookmark({required ThreadModel threadModel ,required String pageName }) async {
    Map<String, dynamic> parameters =  {
      'thread_id': threadModel.id,
      'page_name': pageName,
      'page_title': threadModel.title,
      'page_id': threadModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/thread/${threadModel.id}',
    };
    await _analytics.logEvent(name: 'thread_bookmark', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'thread_bookmark',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventThreadLike({required ThreadModel threadModel ,required String pageName }) async {
    Map<String, dynamic> parameters =  {
      'thread_id': threadModel.id,
      'page_name': pageName,
      'page_title': threadModel.title,
      'page_id': threadModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/thread/${threadModel.id}',
    };
    await _analytics.logEvent(name: 'thread_like', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'thread_like',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventThreadImpression({required ThreadModel threadModel ,required String pageName }) async {
    Map<String, dynamic> parameters =  {
      'thread_id': threadModel.id,
      'page_name': pageName,
      'page_title': threadModel.title,
      'page_id': threadModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/thread/${threadModel.id}',
    };
    await _analytics.logEvent(name: 'thread_impression', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'thread_impression',
        'event_parameters': parameters
      }
    ]);
  }

  Future<void> sendEventThreadTap({required ThreadModel threadModel ,required String pageName }) async {
    Map<String, dynamic> parameters =  {
      'thread_id': threadModel.id,
      'page_name': pageName,
      'page_title': threadModel.title,
      'page_id': threadModel.id,
      'origin': 'internal',
      'page_url': 'https://www.showwcase.com/thread/${threadModel.id}',
    };
    await _analytics.logEvent(name: 'thread_tap', parameters: parameters);
    analyticsRepository.sendAnalyticsToCollect([
      {
        'action': 'thread_tap',
        'event_parameters': parameters
      }
    ]);
  }



}
