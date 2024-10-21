import 'package:flutter/material.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/analytics/data/repositories/analytics_repository.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class AppRouteObserver extends RouteObserver<PageRoute> {
  final analyticsRepository = AnalyticsRepository(NetworkProvider());

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint("customLog: didPush -> routePath: ${route.settings.name} :: argument: ${route.settings}");

    if ((route.settings.name ?? '').isEmpty) {
      return;
    }

    final routePath = route.settings.name;
    final argument = route.settings.arguments;
    final previousRoutePath = previousRoute?.settings.name;
    final previousArgument = previousRoute?.settings.arguments;

    final pageData = getPageData(routePath!, argument);
    final previousPageData = getPageData(previousRoutePath ?? '', previousArgument);

    sendAnalyticsData(pageData, previousPageData);
  }

  Map<String, String?> getPageData(String routePath, dynamic argument) {
    String? pageTitle;
    String? pageId;
    String? pageUrl;
    String? origin = 'internal';

    ///series , community, profile , thread, job, show , roadmap

    if (checksEqual(routePath, threadPreviewPage)) {
      if (argument is ThreadModel) {
        pageId = argument.id.toString();
        pageUrl = 'https://www.showwcase.com/thread/$pageId';
      }
    }
    else if (checksEqual(routePath, jobsPreviewPage)) {
      if (argument is JobModel) {
        pageId = argument.id?.toString();
        pageUrl = 'https://www.showwcase.com/jobs/$pageId';
      }
    }
    else if (checksEqual(routePath, showPreviewPage)) {
      if (argument is ShowModel) {
        pageId = argument.id.toString();
        pageUrl = 'https://showwcase.com/show/$pageId/${argument.slug}';
      }
    } else if (checksEqual(routePath, publicProfilePage) ||
        checksEqual(routePath, personalProfilePage)) {
      if (argument is UserModel) {
        pageId = argument.id.toString();
        pageUrl = 'https://showwcase.com/profile/$pageId';
      }
    }else if (checksEqual(routePath, communityPreviewPage)) {
      if (argument is CommunityModel) {
        pageId = argument.id.toString();
        pageUrl = 'https://www.showwcase.com/community/${argument.slug}';
      }
    }
    else if (checksEqual(routePath, roadmapsPreviewPage )) {
      if (argument is RoadmapModel) {
        pageId = argument.id.toString();
        pageUrl = 'https://www.showwcase.com/roadmap/${argument.id}//${argument.slug}';
      }
    }
    else if (checksEqual(routePath, seriesPreviewPage )) {
      if (argument is SeriesModel) {
        pageId = argument.id.toString();
        pageUrl = 'https://www.showwcase.com/series/${argument.id}/${argument.slug}';
      }

    }
      return {
        'page_name': routePath,
        "page_title": pageTitle,
        'origin': origin,
        'page_url': pageUrl,
        'page_id': pageId,
      }
        ..removeWhere((key, value) => value == null);

  }

  void sendAnalyticsData(Map<String, String?> pageData, Map<String, String?> previousPageData) {
    analyticsRepository.sendAnalyticsToFirebase(
      name: 'custom_page_view',
      parameters: {
        ...pageData,
        'prev_page_title': previousPageData['page_title'],
        'prev_page_url': previousPageData['page_url'],
        'prev_page_name': previousPageData['page_name'],
        'prev_page_id': previousPageData['page_id'],
      },
    );

    final collectRequest = [
      {
        ...pageData,
        'prev_page_title': previousPageData['page_title'],
        'prev_page_url': previousPageData['page_url'],
        'prev_page_name': previousPageData['page_name'],
        'prev_page_id': previousPageData['page_id'],
      },
    ]..removeWhere((entry) => entry.values.any((value) => value == null));

    analyticsRepository.sendAnalyticsToCollect(collectRequest);
  }
}


