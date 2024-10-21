import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_preview_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_preview_state.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/communities_details_page.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/communities_all_thread.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/communities_code_thread.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/communities_links_thread.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_media_thread.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_polls_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_sliver_fab_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_visibility_app_bar_title_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/swipe_back_tabview_wrapper_widget.dart';

class CommunityPreviewPage extends StatefulWidget {
  final CommunityModel communityModel;

  const CommunityPreviewPage({Key? key, required this.communityModel})
      : super(key: key);

  @override
  CommunitiesPageController createState() => CommunitiesPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CommunitiesPageView
    extends WidgetView<CommunityPreviewPage, CommunitiesPageController> {
  const _CommunitiesPageView(CommunitiesPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<CommunityPreviewCubit, CommunityPreviewState,
        CommunityModel>(
      selector: (state) {
        return state.communityPreviews.firstWhere((element) => element.id == widget.communityModel.id);
      },
      builder: (context, updatedCommunity) {
        return SafeArea(
          bottom: true,
          child: Scaffold(
              extendBodyBehindAppBar: true,
              floatingActionButton: (updatedCommunity.communityPermissions?.contains('thread_create') ?? false) ||
                  (updatedCommunity.communityPermissions?.contains('admin') ?? false)
                  ? FloatingActionButton(
                      onPressed: () {
                        context.push(threadEditorPage,
                            extra: {'community': updatedCommunity});
                      },
                      tooltip: 'Add new thread',
                      child: const Icon(Icons.add),
                    )
                  : const SizedBox.shrink(),
              body: SliverFabWidget(
                controller: state._scrollController,
                expandedHeight: 200,
                headerSlivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: theme.colorScheme.primary,
                    expandedHeight: 200,
                    elevation: 0,
                    centerTitle: true,
                    title: CustomVisibilityControlAppBarTitleWidget(
                      child: Text(
                        widget.communityModel.name ?? '',
                        style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w700,
                            fontSize: defaultFontSize),
                      ),
                    ),
                    leading: BackButton(
                      color: theme.colorScheme.onBackground,
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          showCommunitiesOptions(context, updatedCommunity);
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.more_horiz,
                              color: theme.colorScheme.onBackground,
                              size: 30,
                            )),
                      ),
                    ],
                    flexibleSpace: Stack(
                      children: [
                        /// When appbar is expanded
                        FlexibleSpaceBar(
                          background: CachedNetworkImage(
                            imageUrl: widget.communityModel.coverImageUrl ?? '',
                            cacheKey: widget.communityModel.coverImageKey,
                            errorWidget: (context, url, error) => Container(
                              color: kAppBlue,
                            ),
                            placeholder: (ctx, url) => Container(
                              color: kAppBlue,
                            ),
                            fit: BoxFit.cover,
                          ),
                          centerTitle: true,
                        )
                      ],
                    ),
                  ),

                  /// Community details
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!(updatedCommunity.isMember ?? false)) ...{
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15, top: 20),
                              child: CustomButtonWidget(
                                text: 'Join',
                                appearance: Appearance.primary,
                                onPressed: () {
                                  context
                                      .read<CommunityCubit>()
                                      .joinLeaveCommunity(
                                          communityModel: widget.communityModel,
                                          action: CommunityJoinLeaveAction.join);
                                },
                              ),
                            ),
                          ),
                        } else ...{
                          const SizedBox(
                            height: 60,
                          )
                        },
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            widget.communityModel.name ?? '',
                            style: TextStyle(
                                color: theme.colorScheme.onBackground,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            widget.communityModel.description ?? '',
                            style: TextStyle(
                                color: theme.colorScheme.onBackground,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        if (widget.communityModel.category != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                FittedBox(
                                  child: Row(
                                    children: [
                                      if (widget.communityModel.category!.name !=
                                          null) ...{
                                        Icon(
                                          Icons.apps_outlined,
                                          color: theme.colorScheme.onPrimary,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          widget.communityModel.category!.name!,
                                          style: TextStyle(
                                              color: theme.colorScheme.onPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                      },
                                    ],
                                  ),
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      if (widget.communityModel.createdAt !=
                                          null) ...{
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: theme.colorScheme.onPrimary,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Created ${getFormattedDateWithIntl(widget.communityModel.createdAt!)}',
                                          style: TextStyle(
                                              color: theme.colorScheme.onPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                      },
                                    ],
                                  ),
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      if (widget.communityModel.totalMembers !=
                                          null) ...{
                                        Icon(
                                          Icons.people_outline,
                                          color: theme.colorScheme.onPrimary,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          widget.communityModel.totalMembers
                                              .toString(),
                                          style: TextStyle(
                                              color: theme.colorScheme.onPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      },
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),

                  /// tabs here!
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarTabBarDelegate(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        tabBar: TabBar(
                          //isScrollable: true,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          indicator: const UnderlineTabIndicator(
                              insets: EdgeInsets.only(
                                left: 0,
                                right: 0,
                                bottom: 0,
                              ),
                              borderSide: BorderSide(color: kAppBlue, width: 2)),
                          labelPadding:
                              const EdgeInsets.only(left: 0, right: 0),
                          controller: state.tabController,
                          labelColor: theme.colorScheme.onBackground,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: theme.colorScheme.onPrimary, // change unselected color with this
                          tabs: const [
                            Tab(
                              child: Text('All',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: defaultFontSize - 1,
                                  )),
                            ),
                            Tab(
                              child: Text('Code',
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            Tab(
                              child: Text('Links',
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            Tab(
                              child: Text('Poll',
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            Tab(
                              child: Text('Media',
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ],
                        )),
                  ),
                ],
                body: SwipeBackTabviewWrapperWidget(
                  child: TabBarView(
                    controller: state.tabController,
                    children: [
                      CommunitiesAllThread(
                        communityModel: widget.communityModel,
                      ),
                      CommunitiesCodeThread(
                        communityModel: widget.communityModel,
                      ),
                      CommunitiesLinkThread(
                        communityModel: widget.communityModel,
                      ),
                      CommunitiesPollsThread(
                        communityModel: widget.communityModel,
                      ),
                      CommunitiesMediaThread(
                        communityModel: widget.communityModel,
                      ),
                    ],
                  ),
                ),
                floatingWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    width: 90,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.communityModel.pictureUrl ?? '',
                      errorWidget: (context, url, error) => _fallbackIcon(
                          context, widget.communityModel.name ?? 'Communities'),
                      placeholder: (ctx, url) => _fallbackIcon(
                          context, widget.communityModel.name ?? 'Communities'),
                      cacheKey: widget.communityModel.pictureKey,
                      fit: BoxFit.cover,
                    ),

                    // ,
                  ),
                ),
              )),
        );
      },
    );
  }

  Widget _fallbackIcon(BuildContext context, String name) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(5)),
      child: Center(
          child: Text(
        getInitials(name.toUpperCase()),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontSize: 24,
            fontWeight: FontWeight.w600),
      )),
    );
  }

  void showCommunitiesOptions(
      BuildContext context, CommunityModel updatedCommunity) {
    final ch = SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(
              FeatherIcons.file,
              size: 20,
            ),
            minLeadingWidth: 0,
            title: const Text('Community details'),
            onTap: () {
              pop(context);
              pushScreen(
                  context,
                  CommunitiesDetailsPage(
                    communityModel: widget.communityModel,
                  ));
              // context.push(communitiesDetailsPage);
            },
          ),
          ListTile(
            leading: const Icon(
              FeatherIcons.copy,
              size: 20,
            ),
            minLeadingWidth: 0,
            title: const Text('Copy Community link'),
            onTap: () {
              pop(context);
              copyTextToClipBoard(context,
                  'https://showwcase.com/community/${widget.communityModel.slug}');
            },
          ),
          ListTile(
            leading: const Icon(
              FeatherIcons.share,
              size: 20,
            ),
            minLeadingWidth: 0,
            title: const Text('Share Community link'),
            onTap: () {
              shareLink(context);
            },
          ),
          if (updatedCommunity.communityPermissions?.contains("admin") ??
              false) ...[
            ListTile(
              leading: Icon(
                  (updatedCommunity.isFeatured ?? false)
                      ? FeatherIcons.star
                      : FeatherIcons.sunset,
                  size: 20),
              minLeadingWidth: 0,
              title: Text((updatedCommunity.isFeatured ?? false)
                  ? 'UnFeature Community'
                  : 'Feature Community'),
              onTap: () {
                context.read<CommunityCubit>().featureAndUnFeature(
                    action: (updatedCommunity.isFeatured ?? false)
                        ? FeatureUnfeatureCommunityAction.unfeature
                        : FeatureUnfeatureCommunityAction.feature,
                    communityModel: widget.communityModel);
                pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                FeatherIcons.settings,
                size: 20,
              ),
              minLeadingWidth: 0,
              title: const Text('Settings'),
              onTap: () {
                context.push(
                    context.generateRoutePath(
                        subLocation: communitiesSettingsPage),
                    extra: widget.communityModel);
                pop(context);
              },
            ),
          ] else ...[
            if (updatedCommunity.isMember ?? false) ...{
              ListTile(
                leading: const Icon(
                  FeatherIcons.logOut,
                  size: 20,
                ),
                minLeadingWidth: 0,
                textColor: Colors.red,
                iconColor: Colors.red,
                title: const Text('Leave Community'),
                onTap: () {
                  pop(context);
                  context.read<CommunityCubit>().joinLeaveCommunity(
                      communityModel: widget.communityModel,
                      action: CommunityJoinLeaveAction.leave);
                },
              ),
            },

            ListTile(
              leading: const Icon(
                FeatherIcons.flag,
                size: 20,
              ),
              minLeadingWidth: 0,
              title: const Text('Report Community'),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                pop(context);
              },
            ),
            // const CustomBorderWidget(),
          ],
        ],
      ),
    );

    showCustomBottomSheet(context, child: ch);
  }

  void shareLink(BuildContext context) {
    pop(context);
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    flutterShareMe.shareToSystem(
        msg:
            'Join ${widget.communityModel.name} on Showwcase \n https://showwcase.com/community/${widget.communityModel.slug}');
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CommunitiesPageController extends State<CommunityPreviewPage>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CommunityPreviewPage> {
  late TabController tabController;

  late CommunityAdminCubit communityAdminCubit;
  late CommunityCubit communityCubit;
  late StreamSubscription<CommunityState> communityStateStreamSubscription;

  // late ValueNotifier<bool> showCreateThread;
  late CommunityPreviewCubit communityPreviewCubit;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _CommunitiesPageView(this);
  }

  @override
  void initState() {
    communityAdminCubit = context.read<CommunityAdminCubit>();
    communityPreviewCubit = context.read<CommunityPreviewCubit>();
    communityCubit = context.read<CommunityCubit>();
    communityStateStreamSubscription = communityCubit.stream.listen((event) {
      if(event.status == CommunityStatus.joinLeaveCommunitySuccessful){
        context.showSnackBar("You joined this community");
      }
      if(event.status == CommunityStatus.joinLeaveCommunitySuccessful){
        context.showSnackBar("You featured this community");
      }
    });
    communityPreviewCubit.setCommunityPreview(community: widget.communityModel);
    // isAdmin = ValueNotifier(widget.communityModel.communityPermissions?.contains('admin') ?? false);
    // isFeatured = ValueNotifier(widget.communityModel.isFeatured ?? false);
    tabController = TabController(length: 5, vsync: this);
    // showCreateThread = ValueNotifier(
    //     widget.communityModel.communityPermissions!.contains('thread_create') ||
    //         widget.communityModel.communityPermissions!.contains('admin'));
    super.initState();
  }

  @override
  void dispose() {
    communityStateStreamSubscription.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
