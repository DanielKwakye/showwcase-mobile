import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/dynamic_sliver_app_bar.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/sliver_appbar_tabbar_delegate.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_enums.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_preview_cubit.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_preview_state.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/pages/tabs/roadmap_archives_tab_page.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/pages/tabs/roadmap_cointributors_tab_page.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/pages/tabs/roadmap_related_communities_tab_page.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/pages/tabs/roadmap_series_tab_page.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/widgets/roadmap_about_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_gradient_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_visibility_app_bar_title_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/swipe_back_tabview_wrapper_widget.dart';

class RoadmapPreviewPage extends StatefulWidget {

  final RoadmapModel roadmapModel;
  const RoadmapPreviewPage({Key? key, required this.roadmapModel,}) : super(key: key);

  @override
  RoadmapPreviewPageController createState() => RoadmapPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _RoadmapPreviewPageView extends WidgetView<RoadmapPreviewPage, RoadmapPreviewPageController> {

  const _RoadmapPreviewPageView(RoadmapPreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final  theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            /// Roadmaps header  ------------------------------

            // the size of the app bar content can me more than the expanded hight
            // using DynamicHeightAppBar to avoid overflows
            DynamicSliverAppBar(
              backgroundColor: theme.colorScheme.background,
              reduceBottomSpaceBy: 0,
              // backgroundColor: Colors.red,
              // toolbarHeight: 40,
              iconTheme: IconThemeData(color: theme.colorScheme.onBackground,),
              elevation: 0.0,
              pinned: true,
              centerTitle: true,
              leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    width: 35,
                    height: 35,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kAppWhite,),
                    child: const Icon(Icons.arrow_back_ios_sharp,color: Colors.black,size: 15),
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 5,bottom: 0),
                child: CustomVisibilityControlAppBarTitleWidget(
                  child: Text(widget.roadmapModel.title ?? "Roadmaps",
                    style: TextStyle(color: theme.colorScheme.onBackground,
                        fontSize: 16,fontWeight: FontWeight.w600),),
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xff202021),
                      const Color(0xff202021),
                      HexColor.fromHex(widget.roadmapModel.color ?? "#202021")
                    ],
                        begin: Alignment.bottomLeft,
                        stops: const [0.0, 0.3, 1.0],
                        end: Alignment.topRight
                    )
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: kToolbarHeight,),
                        const Text('Roadmaps', style: TextStyle(color: kAppBlue, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 5,),
                        Text(widget.roadmapModel.title ?? "", style: theme.textTheme.titleMedium?.copyWith(color: kAppWhite, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 15,),
                        Text(widget.roadmapModel.description ?? "", style: theme.textTheme.bodyText2?.copyWith(color: kAppWhite, fontWeight: FontWeight.normal),),
                        const SizedBox(height: 15,),
                        CustomButtonWidget(
                          text: 'Share', appearance: Appearance.secondary,
                          textColor: kAppWhite,
                          backgroundColor: kAppBlue,
                          outlineColor: Colors.transparent,
                          icon:  const Icon(Icons.share, color: kAppWhite, size: 15,),
                          onPressed: () {
                            final link = "${ApiConfig.websiteUrl}/roadmaps/${widget.roadmapModel.id}/${widget.roadmapModel.slug}";
                            copyTextToClipBoard(context, link);
                            final FlutterShareMe flutterShareMe = FlutterShareMe();
                            flutterShareMe.shareToSystem(msg: link);
                          },
                        ),
                        const SizedBox(height: 10,),

                        /// -------- Progress ------ ///

                        CustomGradientBorderWidget(
                            padding: 15,
                            borderRadius: 4,
                            strokeWidth: 2,
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xff6e77fe),
                                  Color(0xff3ad3ff),
                                ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Claim certification of completion', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: kAppWhite),),
                                const SizedBox(height: 10,),
                                Text('Earn a credential that will accelerate your developer journey', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: const Color(0xffd4d4d4)),),
                                const SizedBox(height: 10,),
                                BlocBuilder<RoadmapPreviewCubit, RoadmapPreviewState>(
                                  buildWhen: (_, next) {
                                    return next.status == RoadmapStatus.roadmapsPreviewSuccessful
                                        || next.status == RoadmapStatus.roadmapsPreviewError;
                                  },
                                  builder: (_, roadmapState) {
                                    // if(roadmapState.status == RoadmapStatus.roadmapsPreviewLoading) {
                                    //   return  const CustomAppShimmer(showLeadingCircularAvatar: false, repeat: 1, contentPadding: EdgeInsets.zero, showSecondBar: false,);
                                    // }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                BlocSelector<RoadmapPreviewCubit, RoadmapPreviewState, RoadmapModel>(
                                  bloc: state.roadmapPreivewCubit,
                                  selector: (roadmapState) {
                                    return roadmapState.roadmapPreviews.firstWhere((element) => element.id == widget.roadmapModel.id);
                                  },
                                  builder: (context, roadmap) {

                                    final percCompletedShows = (double.parse((roadmap.userReadPercentage ?? 0.0).toString())) / 100;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: ClipRRect(
                                                borderRadius: BorderRadius.circular(3),
                                                child: LinearPercentIndicator(
                                                  // width: double.infinity,
                                                  // key: ValueKey(widget.thread.id),
                                                  lineHeight: 10.0,
                                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                                  percent: percCompletedShows,
                                                  backgroundColor: const Color(0xffd4d4d4),
                                                  progressColor: kAppBlue,
                                                  // animation: true,
                                                  // animateFromLastPercent: true,
                                                  // animationDuration: 1000,
                                                )),
                                            ),
                                            const SizedBox(width: 10,),
                                            Text('${percCompletedShows * 100}%', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: kAppWhite),),
                                          ],
                                        ),
                                        // const SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap: () {
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10,),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Status ${(widget.roadmapModel.userReadPercentage ?? 0.0 ) >= 100 ? 'Completed' : 'Incomplete' }', style: theme.textTheme.bodyText2?.copyWith(fontWeight: FontWeight.normal, color: const Color(0xffd4d4d4)),),
                                                const SizedBox(width: 5,),
                                                const Icon(Icons.arrow_forward, color:  Color(0xffd4d4d4), size: 18,)
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );

                                  },
                                )
                              ],
                            )
                        )

                        ///  ------ Progress -------- ///
                      ],
                    ),
                  ),
                ),
              ),

            ),
            /// Tabs
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarTabBarDelegate(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  tabBar: TabBar(
                    controller: state.tabController,
                    isScrollable: true,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    indicator: const UnderlineTabIndicator(
                        insets: EdgeInsets.only(
                          left: 0,
                          right: 20,
                          bottom: 0,
                        ),
                        borderSide:
                        BorderSide(color: kAppBlue, width: 2)),
                    labelPadding:
                    const EdgeInsets.only(left: 0, right: 20),
                    labelColor: theme.colorScheme.onBackground,
                    tabs: [
                      ...state.tabItems.map((e) => Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(e['title'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ))
                    ],
                  )),
            ),
          ];

        },
          body: SwipeBackTabviewWrapperWidget(
            child: TabBarView(
              controller: state.tabController,
              children:  [
                ...state.tabItems.map((e) {
                  return e['page'] as Widget;
                })
            ],
            ),
          ),
        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class RoadmapPreviewPageController extends State<RoadmapPreviewPage> with TickerProviderStateMixin {

  late TabController tabController;
  late ScrollController scrollController;
  late RoadmapPreviewCubit roadmapPreivewCubit;

  late List<Map<String, dynamic>> tabItems;

  @override
  Widget build(BuildContext context) => _RoadmapPreviewPageView(this);

  @override
  void initState() {
    tabItems = [
      <String, dynamic>{
        'index': 0,
        'title': "About",
        "page":  RoadmapAboutWidget(roadmapModel: widget.roadmapModel),
      },
      <String, dynamic>{
        'index': 1,
        'title': "The Roadmap",
        "page":  RoadmapSeriesTabPage(roadmapModel: widget.roadmapModel),
      },
      <String, dynamic>{
        'index': 2,
        'title': 'Archives',
        "page": RoadmapArchivesTabPage(roadmapModel: widget.roadmapModel,)
      },
      <String, dynamic>{
        'index': 3,
        'title': 'Related Communities',
        'page': RoadmapRelatedCommunitiesTabPage(roadmapModel: widget.roadmapModel,)
      },
      <String, dynamic>{
        'index': 4,
        'title': 'Contributors',
        'page': RoadmapContributorsTabPage(roadmapModel: widget.roadmapModel,)
      },
    ];
    tabController = TabController(length: tabItems.length, vsync: this);
    scrollController = ScrollController();
    roadmapPreivewCubit = context.read<RoadmapPreviewCubit>();
    roadmapPreivewCubit.setRoadmapPreview(roadmap: widget.roadmapModel);
    roadmapPreivewCubit.fetchRoadmapPreview(roadmapId: widget.roadmapModel.id!);
    super.initState();
  }



}