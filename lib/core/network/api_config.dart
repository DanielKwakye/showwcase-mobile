import 'package:flutter/foundation.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_filters_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_type_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';
import 'package:showwcase_v3/flavors.dart';

abstract class ApiConfig {


  static String  baseUrl = F.baseUrl;
  static String  apiBaseUrl = F.apiBaseUrl;

  static  String preSignedUrl = '$baseUrl/helpers/presigned-url';
  static  String videoPreSignedUrl = '$baseUrl/helpers/video/presigned-url';

  static String twitterEmbedBaseUrl = "https://publish.twitter.com/oembed";
  static const String websiteUrl = 'https://www.showwcase.com';
  static const String profileUrl = 'https://profile-assets.showwcase.com';
  static const String companyAssetUrl = 'https://company-assets.showwcase.com';
  static const String projectUrl = 'https://project-assets.showwcase.com';
  static const String stackIconsUrl = 'https://stack-icons.showwcase.com';
  static const String aboutUrl = 'https://about.showwcase.com/tos';
  static const String logosUrl = 'https://showwcase-companies-logos.s3.amazonaws.com';
  static String websiteHashTagSearchUrl(String tag) => "$websiteUrl/search?tag=hashTag&q=$tag";
  static String websiteCashTagSearchUrl(String tag) => "$websiteUrl/search?tag=cashTag&q=$tag";
  static String websiteCommunityUrl(String community) => "$websiteUrl/community/$community";
  static String? socialImageUrl(String name) {
    var url = stackIconsUrl;
    final social = storeSocialLinksList.firstWhere((element) => element?['name'] == name, orElse: () => null);
    if(social == null) return null;

    final socialImageUrl = "$url/elsewhere/${social['icon']}";
    debugPrint(socialImageUrl);
    return socialImageUrl;
  }

  static String collect = "$apiBaseUrl/collect/";

  static String fetchJobFeeds({int limit = 25, int skip = 0, JobFiltersModel? jobFilters, double? salary = 0.0,}) {
    var urlBuilder = '$baseUrl/jobs?fields=id,title,score,views,visits,role,applyUrl,slug,salary,location,arrangement,type,publishedDate,addons,preferences,company(id,logo,name),stacks,user&limit=$limit&skip=$skip';

    String filters = '';

    if ((salary ?? 0.0) != 0.0) {
      filters = '$filters&salary=$salary';
    }

    if(jobFilters != null){

      final positions = jobFilters.positions?.where((element) => element['selected'] == true) ?? [];
      final locations = jobFilters.locations?.where((element) => element['selected'] == true) ?? [];
      final types = jobFilters.types?.where((element) => element['selected'] == true) ?? [];
      final stacks = jobFilters.stacks?.where((element) => element['selected'] == true) ?? [];

      if (positions.isNotEmpty) {
        for (var v in positions ) {
          filters = '$filters&position[]=${v['filter']}';
        }
      }

      if (locations.isNotEmpty) {
        for (var v in locations ) {
          filters = '$filters&location[]=${v['filter']}';
        }
      }

      if (types.isNotEmpty) {
        for (var v in types ) {
          final jobType = v["filter"] as JobTypeModel;
          filters = '$filters&type[]=${jobType.value}';
        }
      }

      if (stacks.isNotEmpty) {
        for (var v in stacks ) {
          final stack = v["filter"] as UserStackModel;
          filters = "$filters&stacks[]=${stack.name ?? ''}";
        }
      }

      /// this is currently not in use as at 28/June/2022
      // if (jobFilters.teamSizes != null && jobFilters.teamSizes!.isNotEmpty) {
      //   queryParams.addAll({'teamSize': jobFilters.teamSizes});
      // }
      // /// this is currently not in use as at 28/June/2022
      // if (jobFilters.industries != null && jobFilters.industries!.isNotEmpty) {
      //   queryParams.addAll({'industries': jobFilters.industries});
      // }
    }

    if(filters.isNotEmpty) {
      urlBuilder = "$urlBuilder$filters";
    }

    return urlBuilder;
  }

  static String fetchJobs({int limit = 25, int skip = 0, String? filters , JobCategory category = JobCategory.newArrivals}) {
    // String path = baseUrl + '/jobs?&limit=$limit&skip=$skip&fields=id,title,score,views,visits,role,applyUrl,slug,salaryFrom,salaryTo,location,arrangement,type,publishedDate,addons,preferences,company(id,logo,name),description,stacks(name,icon,id,isMatched),score&updateCache=true';
    var urlBuilder = '$baseUrl/jobs';
    if(category == JobCategory.recommended) {
      urlBuilder = "$urlBuilder/recommended";
    }else if(category == JobCategory.popular) {
      urlBuilder = "$urlBuilder/popular";
    }

    urlBuilder = "$urlBuilder?limit=$limit&skip=$skip";

    if(category == JobCategory.newArrivals) {
      urlBuilder = "$urlBuilder&fields=id,title,score,views,visits,role,applyUrl,slug,salary,location,arrangement,type,publishedDate,addons,preferences,company(id,logo,name),stacks,user";
    }

    if(filters != null && filters.isNotEmpty) {
      urlBuilder = "$urlBuilder$filters";
    }

    return urlBuilder;
  }

  /// we can get these details from
  /// https://beta-cache.showwcase.com/helpers/video/status?id=${mediaId}
  // static const String videoDeliveryUrl = 'https://videodelivery.net';
  static String fetchVideoDetails({required String mediaId}) =>   '$baseUrl/helpers/video/status?id=$mediaId';
  static String fetchTwitterDetails({required String tweetId}) {

    final tweetLink =  "https://twitter.com/x/status/$tweetId";
    return '$twitterEmbedBaseUrl?url=$tweetLink&omit_script=true';
  }

  static  String authDetails = '$baseUrl/auth';
  static  String updateProfile = '$baseUrl/profile';
  static  String updateInterests = '$baseUrl/profile/interests';
  static  String updateProfileSettings = '$baseUrl/profile/settings';
  static  String bookmark = '$baseUrl/bookmarks';
  static  String createThreads = '$baseUrl/threads';
  static String editThread({int? threadId}) => '$baseUrl/threads/$threadId';
  static  String createComment = '$baseUrl/comments';
  static  String updateComment(int commentId) => '$baseUrl/comments/$commentId';
  static  String deleteComment(int commentId) => '$baseUrl/comments/$commentId';
  static  String loginWithEmail = '$baseUrl/auth/otp';
  static  String videoThumbnailEndpoint =  '/thumbnails/thumbnail.jpg';
  static  String complaints = '$baseUrl/complaints';
  static  String suggestedFollowers = '$baseUrl/users/suggested_followers';
  static  String showCategories = '$baseUrl/projects/categories';
  static  String fetchRecommendedTags = '$baseUrl/tags/recommended?limit=10&s=${AppStorage.sessionId}';//https://cache.showwcase.com/tags/recommended?limit=10&s=L0gukYbIsxyOIpqzbWFux
  static  String profileTags = '$baseUrl/profile/tags';
  static  String fetchNotificationTotal =  '$baseUrl/notifications/total';
  static  String notifications =  '$baseUrl/notifications';
  static  String reviewSeries =  '$baseUrl/reviews';
  static String fetchIndustries  =   '$baseUrl/companies/industries';
  static String stacks  =   '$baseUrl/profile/stacks';
  static String interests  =   '$baseUrl/users/interests';
  static String reasons  =   '$baseUrl/network/circles/reasons';
  static String sendCircleInvite  =   '$baseUrl/network/worked_withs/invite';
  static String socials  =   '$baseUrl/users/socials';
  static String updateSocials  =   '$baseUrl/profile/socials';
  static String modules  =   '$baseUrl/profile/modules';
  static String unLinkGithub  =   '$baseUrl/auth/github';
  static String fetchRoadmaps  =   '$baseUrl/roadmaps';
  static String featuredShows  =   '$baseUrl/projects/featured';
  static String referral  =   '$baseUrl/referrals/invites';

  static String fetchRoadmapReadersList({required int roadmapId, int limit = 3}) => '$baseUrl/roadmaps/$roadmapId/readers?limit=$limit';
  static String fetchRoadmapPreview({required int roadmapId}) => '$baseUrl/roadmaps/$roadmapId';

  static String fetchRoadmapSeries({required int roadmapId, int limit = 25, int skip = 0,}) => '$baseUrl/roadmaps/$roadmapId/series?limit=$limit&skip=$skip';
  static String fetchRoadmapShowsInArchive({int limit = 25, int skip = 0, required int roadmapId}) =>   '$baseUrl/roadmaps/$roadmapId/projects?status=APPROVED&type=popular&limit=$limit&skip=$skip';
  static String fetchRoadmapSeriesInArchive({int limit = 25, int skip = 0, required int roadmapId}) =>   '$baseUrl/roadmaps/$roadmapId/series/archives?status=APPROVED&limit=$limit&skip=$skip';
  static String fetchRoadmapCommunities({int limit = 25, int skip = 0, required int roadmapId}) =>   '$baseUrl/roadmaps/$roadmapId/communities?limit=$limit&skip=$skip';
  static String fetchRoadmapContributors({int limit = 25, int skip = 0, required int roadmapId}) =>   '$baseUrl/roadmaps/$roadmapId/contributors?status=APPROVED&limit=$limit&skip=$skip';

  //! search apis
  static String search({required String text, required String type, int limit = 25, int skip = 0 }) =>   '$baseUrl/search?term=$text&type=$type&limit=$limit&skip=$skip';
  static String topUpComingEvents({int limit = 7}) =>   '$baseUrl/events/upcoming?limit=$limit';
  static String topRemoteJobs({int limit = 8}) =>   '$baseUrl/jobs/recommended?limit=$limit';
  static String topShows({int limit = 5}) =>   '$baseUrl/projects/trending?limit=$limit';
  static String topAccounts({int limit = 5}) =>   '$baseUrl/users/suggested_followers?limit=$limit';
  static String topCommunities({int limit = 5}) =>   '$baseUrl/communities/featured?limit=$limit';
  //! end of search apis

  static String fetchUrlMeta(String url) => '$baseUrl/urlmeta?url=$url';
  static String loginWithSocial(String loginType) => '$baseUrl/auth/$loginType';
  static String fetchCitySuggestion(String cityName) => '$baseUrl/helpers/city-suggestion?query=$cityName';
  static String checkUsernameOrEmail(String query) => '$baseUrl/users/check?$query';
  static String boostThread({required int threadId, required String actionType }) =>   '$baseUrl/threads/$threadId/$actionType';
  static String upvote({required String actionType }) =>   '$baseUrl/voting/$actionType';
  static String threadComments({required int? threadId, int? limit = 25, int? skip = 0}) =>   '$baseUrl/threads?parentId=$threadId&limit=$limit&skip=$skip';
  static String threadCommentReplies({required int? commentId, int? limit = 25, int? skip = 0}) =>   '$baseUrl/threads/$commentId/replies?limit=$limit&skip=$skip&s=${AppStorage.sessionId}';

  static String deleteStacks({String? stackId} )  =>   '$baseUrl/profile/stacks/$stackId';
  static String profileExperiences  =   '$baseUrl/profile/experiences';
  static String profileCertifications  =   '$baseUrl/profile/certification';
  static String profileExperiencesStacks({required int? stackId})  =>   '$baseUrl/profile/experiences/$stackId/stacks';
  static String manageRepositories({required int repositoryID,required String action} )  =>   '$baseUrl/github/$repositoryID/$action';
  static String fetchThreads({int limit = 25, int skip = 0, String? filter, String? interval, String? sessionId}) {
    String path =  '$baseUrl/feeds/discover?limit=$limit&skip=$skip';
    if(!filter.isNullOrEmpty()){
      path = '$path&type=$filter';
    }
    if(!interval.isNullOrEmpty()){
      path = '$path&interval=$interval';
    }
    if(sessionId != null) {
      path = '$path&s=$sessionId';
    }

    return path;
  }

  static String fetchForYouThreadFeeds({int limit = 25, int skip = 0}) {
    // refresh session id for every first page fetch
    String path =  '$baseUrl/feeds/discover?limit=$limit&skip=$skip';
    if(skip == 0) {AppStorage.refreshSessionId();}
    path = "$path&s=${AppStorage.sessionId}";

     return path;
  }

  static String fetchNewsThreadFeeds({int limit = 25, int skip = 0}) {
    // refresh session id for every first page fetch
    String path =  '$baseUrl/feeds/news?limit=$limit&skip=$skip';
    if(skip == 0) {AppStorage.refreshSessionId();}
    path = "$path&s=${AppStorage.sessionId}";
    return path;
  }

  static String fetchFollowingThreadFeeds({int limit = 25, int skip = 0}) {
    // refresh session id for every first page fetch

    String path =  '$baseUrl/feeds/following?limit=$limit&skip=$skip';
    if(skip == 0) {AppStorage.refreshSessionId();}
    path = "$path&s=${AppStorage.sessionId}";
     return path;
  }

  static String fetchLatestThreadFeeds({int limit = 25, int skip = 0}) {
    // refresh session id for every first page fetch
    if(skip == 0) {AppStorage.refreshSessionId();}
     String path =  '$baseUrl/feeds/discover/latest?limit=$limit&skip=$skip&s=${AppStorage.sessionId}';
     return path;
  }

  static String fetchThreadPreview({required int threadId}) =>   '$baseUrl/threads/$threadId';
  static String deleteThread({required int threadId}) =>   '$baseUrl/threads/$threadId';
  static String searchTechStacks({required String query}) =>   '$baseUrl/stacks/list?search=$query';
  static String searchCompanies({required String query}) =>   '$baseUrl/companies?search=$query';
  static String getCompanyBySlug({required String slug}) =>   '$baseUrl/companies/$slug';
  static String getCompanySizes =  '$baseUrl/companies/sizes';
  static String getCompanyIndustries =   '$baseUrl/companies/industries';
  static String getCompanyStages =   '$baseUrl/companies/stages';
  static String companies =   '$baseUrl/companies';
  static String fetchProfileThreads({int limit = 25, int skip = 0,required String userName,required String type }) =>   '$baseUrl/user/$userName/feed?type$type&limit=$limit&skip=$skip';
  static String fetchShows({int limit = 25, int skip = 0, String? category, int? currentProjectId}) {
    String path = '$baseUrl/projects/recommended?limit=$limit&skip=$skip&draft=false';
    if(category != null){
      path = '$path&category=$category';
    }
    if(currentProjectId != null) {
      path = '$path&projectId=$currentProjectId';
    }
    // if(skip == 0) {AppStorage.refreshSessionId();}
    // path = '$path&s=${AppStorage.sessionId}';

    return path;
  }

  static String fetchCompanyJobs({required String slug, int limit = 25, int skip = 0}) =>   '$baseUrl/companies/$slug/jobs?limit=$limit&skip=$skip';
  static String fetchCompanies({int limit = 25, int skip = 0}) =>   '$baseUrl/companies?limit=$limit&skip=$skip';
  static String fetchJobPreview({required int jobId}) => '$baseUrl/jobs/$jobId';
  static String fetchJobFilters =    '$baseUrl/jobs/filters';

  static String fetchShowComments({required showId, int limit = 25, int skip = 0}) =>   '$baseUrl/comments?projectId=$showId&limit=$limit&skip=$skip';
  static String fetchThreadPollVoters({required int? threadId, required int? pollId, int limit = 25, int skip = 0}) =>   '$baseUrl/threads/$threadId/poll/voters?pollId=$pollId&limit=$limit&skip=$skip';
  static String fetchThreadUpVoters({required int? threadId, int limit = 25, int skip = 0}) =>   '$baseUrl/threads/$threadId/votes?&limit=$limit&skip=$skip&s=${AppStorage.sessionId}';
  static String fetchShowUpVoters({required int? showId, int limit = 25, int skip = 0}) =>   '$baseUrl/projects/$showId/votes?&limit=$limit&skip=$skip&s=${AppStorage.sessionId}';
  static String fetchShowPreview({required int showId}) =>   '$baseUrl/projects/$showId?s=${AppStorage.sessionId}';
  static String fetchSeriesProjectPreview({required int projectId}) =>   '$baseUrl/projects/$projectId?s=${AppStorage.sessionId}';
  static String fetchSeriesPreview({required int seriesId}) =>   '$baseUrl/series/$seriesId';
  static String fetchSeriesRatingList({required int seriesId, int limit = 25, int skip = 0}) =>   '$baseUrl/reviews?seriesId=$seriesId&limit=$limit&skip=$skip';
  static String fetchSeriesRatingStats({required int seriesId}) =>   '$baseUrl/series/$seriesId/ratings';

  static String votePoll({required int? threadId}) =>   '$baseUrl/threads/$threadId/poll/vote';
  static String searchUser ({required String keyword, required String type }) =>   '$baseUrl/search?limit=15&type=$type&term=$keyword&s=${AppStorage.sessionId}';
  static String fetchProfile ({required String userName}) =>   '$baseUrl/user/$userName';
  static String updateResume ({required String userName}) =>   '$baseUrl/user/$userName/resume';
  static String fetchProfileByUserId ({required String userId}) =>   '$baseUrl/user/$userId';
  static String fetchRepositories ({required String userName}) =>   '$baseUrl/user/$userName/github_repos';
  static String fetchFeaturedCommunities ({required String userName}) =>   '$baseUrl/user/$userName/communities/featured';
  static String fetchUserProjects ({required String userName}) =>   '$baseUrl/user/$userName/projects/featured';
  static String fetchCustomFeaturedProjects ({required String userName}) =>   '$baseUrl/user/$userName/projects';
  static String fetchCustomFeaturedSeries ({required String userName}) =>   '$baseUrl/user/$userName/series';
  static String fetchSocials ({required String userName}) =>   '$baseUrl/user/$userName/socials';
  static String fetchStacks ({required String userName}) =>   '$baseUrl/user/$userName/stacks';
  static String fetchCertifications ({required String userName}) =>   '$baseUrl/user/$userName/certifications';
  static String fetchExperiences ({required String userName}) =>   '$baseUrl/user/$userName/experiences';
  static String followAndUnfollow ({required String actionType}) =>   '$baseUrl/network/followers/$actionType';
  static String joinAndLeaveCommunity ({required String actionType,required int communityId}) =>   '$baseUrl/communities/$communityId/$actionType';
  static String fetchUserModules ({required String userName}) =>   '$baseUrl/user/$userName/modules';
  static String fetchUserTabs ({required String userName}) =>   '$apiBaseUrl/users/$userName/modules';
  static String fetchFollowing({int? limit = 25, int? skip = 0,required int userId}) => '$baseUrl/network/following?userId=$userId&limit=$limit&skip=$skip';
  static String fetchFollowers({int? limit = 25 ,int? skip = 0,required int userId}) => '$baseUrl/network/followers?userId=$userId&limit=$limit&skip=$skip';
  static String fetchCircleMembers({int? limit = 20,int? skip = 0,required int userId}) => '$baseUrl/network/worked_withs/active?userId=$userId&limit=$limit&skip=$skip';
  static String fetchWorkedWiths({required int userId}) => '$baseUrl/network/worked_withs/active?userId=$userId';
  static String fetchInterestingCommunities({int limit = 25, int skip = 0}) =>   '$baseUrl/communities/interesting?limit=$limit&skip=$skip';
  static String fetchCommunities({int limit = 25, int skip = 0}) =>   '$baseUrl/profile/communities?limit=$limit&skip=$skip';
  static String fetchThreadBookmarks({int limit = 25, int skip = 0}) =>   '$baseUrl/bookmarks?limit=$limit&skip=$skip&type=thread';
  static String fetchShowsBookmarks({int limit = 25, int skip = 0}) =>   '$baseUrl/bookmarks?limit=$limit&skip=$skip&type=project';
  static String fetchJobBookmarks({int limit = 25, int skip = 0}) =>   '$baseUrl/bookmarks?limit=$limit&skip=$skip&type=job';
  static String fetchPurchases({int limit = 25, int skip = 0}) =>   '$baseUrl/orders/?limit=$limit&skip=$skip';
  static String blockAndUnblock ({required String userName,required String actionType}) =>   '$baseUrl/user/$userName/$actionType';
  static String fetchCommunityDetails({required String slug}) =>   '$baseUrl/communities/$slug';
  static String fetchUserCommunities ({required String userName,int limit = 25, int skip = 0}) =>   '$baseUrl/user/$userName/communities?limit=$limit&skip=$skip';
  static String searchCommunities ({required String keyword}) =>   '$baseUrl/search?limit=15&type=communities&term=$keyword';
  static String fetchActiveCommunities ({int limit = 25, int skip = 0}) =>   '$baseUrl/communities/?order=activity&limit=$limit&skip=$skip';
  static String fetchGrowingCommunities ({int limit = 25, int skip = 0}) =>   '$baseUrl/communities/?order=growth&limit=$limit&skip=$skip';
  static String fetchProposedCommunities ({int limit = 25, int skip = 0}) =>   '$baseUrl/communities/featured?limit=$limit&skip=$skip';
  static String fetchCommunitiesMembers ({int limit = 25, int skip = 0,required int communityId}) =>   '$baseUrl/communities/$communityId/members?limit=$limit&skip=$skip';
  static String fetchProfileShows ({int limit = 25, int skip = 0,required String userName}) =>   '$baseUrl/user/$userName/projects?limit=$limit&skip=$skip&draft=false';
  static String fetchProfileMedia ({int limit = 25, int skip = 0,required String userName}) =>   '$baseUrl/user/$userName/media?limit=$limit&skip=$skip';
  static String fetchProfileCode ({int limit = 25, int skip = 0,required String userName}) =>   '$baseUrl/user/$userName/code-snippets?limit=$limit&skip=$skip';
  static String fetchProfilePolls ({int limit = 25, int skip = 0,required String userName}) =>   '$baseUrl/user/$userName/feed?type=polls&limit=$limit&skip=$skip';
  static String fetchProfileGuestbook ({int limit = 25, int skip = 0,required String userName}) =>   '$baseUrl/user/$userName/guestbook?limit=$limit&skip=$skip';
  static String createGuestbook ({required String userName}) =>   '$baseUrl/user/$userName/guestbook';
  static String editAndDeleteGuestbook ({required String userName,required int guestBookID}) =>   '$baseUrl/user/$userName/guestbook/$guestBookID';
  static String fetchDashboardStat ({required int? startDate,required int? endDate}) {
    String path = '$baseUrl/profile/dashboard';
    if(startDate != null && endDate != null){
      path = '$path?startDate=$startDate&endDate=$endDate';
    }
    return path;
  }
  static String fetchDashboardThreads ({int limit = 25, int skip = 0}) =>   '$baseUrl/profile/dashboard/threads?limit=$limit&skip=$skip';
  static String fetchDashboardShows ({int limit = 25, int skip = 0}) =>   '$baseUrl/profile/dashboard/projects?limit=$limit&skip=$skip';
  static String fetchCommunitiesFeeds ({required String communityName,String? feedType,required String orderType,String? tag,int limit = 25, int skip = 0}) {
    var path = '$baseUrl/communities/$communityName/feed?order=$orderType&limit=$limit&skip=$skip';
    if(feedType != null){
      path = '$path&type=$feedType';
    }
    if(tag != null && checksNotEqual(tag, 'All')){
      path = '$path&tag=$tag';
    }
    return path;
  }
  static String fetchSeries({int limit = 25, int skip = 0}) =>   '$baseUrl/series?limit=$limit&skip=$skip&draft=false';
  static String fetchFeaturedSeries({int limit = 25, int skip = 0}) =>   '$baseUrl/series/featured?limit=$limit&skip=$skip&draft=false';
  static String fetchProfileSeries({required String userName,int limit = 25, int skip = 0}) =>   '$baseUrl/user/$userName/series?draft=false&limit=$limit&skip=$skip';
  static String markProjectAsComplete({required int projectId}) =>  '$baseUrl/projects/$projectId/complete';
  static String searchCommunityTag({required String keyword}) => '$baseUrl/search?term=$keyword&type=contentTags&limit=5&s=ofe8cO_ruqHDj9Ktbkwe6';
  static String updateFeedsTag({required int communityId}) => '$baseUrl/communities/$communityId/feed/tags';
  static String updateCommunityTag({required int communityId}) => '$baseUrl/communities/$communityId/tags';
  static String featureAndUnFeature({required String action,required int communityId}) => '$baseUrl/communities/$communityId/$action';
  static String fetchCommunityRoles({required int communityId}) => '$baseUrl/communities/$communityId/settings/roles';
  static String assignCommunityRoles({required int communityId}) => '$baseUrl/communities/$communityId/members/role';
  static String updateCommunityRoles({required int communityId,required int roleID}) => '$baseUrl/communities/$communityId/settings/roles/$roleID/permissions';
  static String updateCommunityRoleName({required int? communityId,required int? roleID}) => '$baseUrl/communities/$communityId/settings/roles/$roleID';
  static String sendCommunityInvite({required int? communityId}) => '$baseUrl/communities/$communityId/invite';
  static String fetchCommunityTags({required String? slug}) => '$baseUrl/communities/$slug/feed/tags';
  static String updateCommunityInterest({required String slug}) => '$baseUrl/communities/$slug/interests';
  static String updateCommunityDetails({required int? communityId}) => '$baseUrl/communities/$communityId';
  static String fetchCommunityCategory = '$baseUrl/communities/categories?limit=1000';

  /// Chat endpoints
  static String requestConnectionWithRecipient = '$apiBaseUrl/chat/';
  static String sendMessageToRecipient({required String chatId}) =>   '$apiBaseUrl/chat/$chatId';
  static String fetchConnectedRecipients({int limit = 25, int skip = 0,}) =>   '$apiBaseUrl/chat/?limit=$limit&skip=$skip&updateCache=true';
  static String fetchPendingConnections({int limit = 25, int skip = 0,}) =>   '$apiBaseUrl/chat/pending?limit=$limit&skip=$skip';
  static String fetchRejectedConnections({int limit = 25, int skip = 0,}) =>   '$apiBaseUrl/chat/rejected?limit=$limit&skip=$skip';
  static String fetchChatMessages({required String chatId}) =>   '$apiBaseUrl/chat/$chatId/messages?limit=50';
  static String getConnectedRecipient({required String connectionId}) => '$apiBaseUrl/chat/$connectionId';
  static String markChatMessagesAsRead({required String connectionId}) => '$apiBaseUrl/chat/$connectionId/read/';
  static String acceptPendingConnection({required String connectionId}) => '$apiBaseUrl/chat/$connectionId/accept/';
  static String rejectPendingConnection({required String connectionId}) => '$apiBaseUrl/chat/$connectionId/reject/';
  static String fetchChatNotificationTotals = '$apiBaseUrl/chat/totals';


}
