import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_enums.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_preview_cubit.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_preview_state.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_review_stats_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_reviewer_model.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/reviewer_item_widget.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/series_item_projects_widget.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/series_rating_stats_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_markdown_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/social_share_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_list_tile_widget.dart';


class SeriesPreviewPage extends StatefulWidget {

  final SeriesModel seriesItem;
  final int? itemIndex;
  const SeriesPreviewPage({Key? key, required this.seriesItem, this.itemIndex}) : super(key: key);

  @override
  SeriesPreviewPageController createState() => SeriesPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SeriesPreviewPageView extends WidgetView<SeriesPreviewPage, SeriesPreviewPageController> {

  const _SeriesPreviewPageView(SeriesPreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final networkImage = getProjectImage(widget.seriesItem.coverImageKey);

    final shareUrl = '/series/${widget.seriesItem.id}/${widget.seriesItem.slug}';

    return Scaffold(
      body: SafeArea(
        top: false,
          bottom: true,
          child: CustomScrollView(
        slivers: [
          CustomInnerPageSliverAppBar(
            pageTitle: '',
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
          ),
          SliverToBoxAdapter(
            child: Hero(
                tag: "$networkImage-${widget.itemIndex ?? ''}",
                child: CustomNetworkImageWidget(
                  imageUrl: networkImage,
                )),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        kSeriesIconSvg,
                        color: kAppBlue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Series',
                        style: TextStyle(
                            color: kAppBlue,
                            fontSize: defaultFontSize + 2,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SocialShareWidget(
                    imageUrl: networkImage,
                    url: '${ApiConfig.websiteUrl}/$shareUrl',
                    title: widget.seriesItem.title,
                  )
                ],
              ),
            ),
          ),

          //const SliverToBoxAdapter(child: SizedBox(height: 10,),),
          /// title

          if (!widget.seriesItem.title.isNullOrEmpty()) ...{
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(widget.seriesItem.title!,
                    style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: defaultFontSize + 6)),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
          },

          if (!widget.seriesItem.description.isNullOrEmpty()) ...{
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(widget.seriesItem.description!,
                    style: TextStyle(color: theme.colorScheme.onPrimary)),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
          },

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),

          /// Start series button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomButtonWidget(
                borderRadius: 4,
                text: 'Start Series',
                onPressed: () {
                    context.push(context.generateRoutePath(subLocation: seriesProjectsPreviewPage), extra:  {
                      "series": widget.seriesItem,
                      "initialProjectIndex": 0 // optional (defaults to 0)
                    });
                    AnalyticsService.instance.sendEventSeriesStart(seriesModel: widget.seriesItem,pageName: seriesPreviewPage,containerName: 'button ');
                },
                expand: true,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),

          /// Series Projects here
          if (widget.seriesItem.projects != null &&
              widget.seriesItem.projects!.isNotEmpty) ...{
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SeriesItemProjectsWidget(
                  projects: widget.seriesItem.projects!,
                  seriesItem: widget.seriesItem,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
          },

          /// author
          if(widget.seriesItem.user != null) ... {
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: UserListTileWidget(userModel: widget.seriesItem.user!),
              ),
            )
          },


          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),

          const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: CustomBorderWidget(),
              )),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),

          if (widget.seriesItem.summary != null && widget.seriesItem.summary!.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomMarkdownWidget(
                  markdown: widget.seriesItem.summary!,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: CustomBorderWidget(),
                )),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
          ],

          /// Information

          // info title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("Information",
                  style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: defaultFontSize + 2)),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: LayoutGrid(
                    // set some flexible track sizes based on the crossAxisCount
                    columnSizes: [1.fr, 1.fr],
                    // set all the row sizes to auto (self-sizing height)
                    rowSizes: const [auto, auto],
                    rowGap: 20,
                    // equivalent to mainAxisSpacing
                    columnGap: 0,
                    // equivalent to crossAxisSpacing
                    // note: there's no childAspectRatio
                    children: [
                      // render all the cards with *automatic child placement*
                      if (!widget.seriesItem.difficulty.isNullOrEmpty()) ...{
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Level",
                                style: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                    fontWeight: FontWeight.w600,
                                    fontSize: defaultFontSize + 2)),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(widget.seriesItem.difficulty!.capitalize(),
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: defaultFontSize))
                          ],
                        )
                      },
                      if (widget.seriesItem.publishedDate != null) ...{
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Date published",
                                style: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                    fontWeight: FontWeight.w600,
                                    fontSize: defaultFontSize + 2)),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                                getFormattedDateWithIntl(widget.seriesItem.publishedDate!,
                                    format: 'dd MMM, yyyy'),
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: defaultFontSize))
                          ],
                        )
                      },
                      if (widget.seriesItem.categories != null &&
                          widget.seriesItem.categories!.isNotEmpty) ...{
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Category",
                                style: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                    fontWeight: FontWeight.w600,
                                    fontSize: defaultFontSize + 2)),
                            const SizedBox(
                              height: 4,
                            ),
                            // Text(getFormattedDateWithIntl(item.publishedDate!, format: 'dd MMM, yyyy'), style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize)),
                            RichText(
                                text: TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                        fontSize: defaultFontSize),
                                    children: [
                                      ...widget.seriesItem.categories!.map((e) => TextSpan(
                                        text:
                                        '${widget.seriesItem.categories!.first.name} ',
                                      ))
                                    ]))
                          ],
                        )
                      },
                    ],
                  )
              )),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),

          const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: CustomBorderWidget(),
              )),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),

          /// Rating & Review



          if (widget.seriesItem.settings?.enableReview != null &&
              widget.seriesItem.settings!.enableReview!) ...{

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocSelector<SeriesPreviewCubit, SeriesPreviewState, SeriesReviewStatsModel?>(
                    selector: (seriesPreviewState) {
                      return seriesPreviewState.stats[widget.seriesItem.id];
                    },
                    builder: (context, stats) {
                      if(stats == null){return const SizedBox.shrink();}

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SeriesRatingStatsWidget(
                          series: widget.seriesItem,
                          stats: stats,
                        ),
                      );

                    },
                  )
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: CustomBorderWidget(top: 20, bottom: 20,),
            ),



            //       BlocBuilder<SeriesPreviewCubit, SeriesPreviewState>(
            //         buildWhen: (_, next) {
            //           return next.status == ApiStatus.seriesRatingStatsFetching ||
            //               next.status ==
            //                   ApiStatus.seriesRatingStatsFetchingSuccessful ||
            //               next.status == ApiStatus.seriesRatingStatsFetchingFailed;
            //         },
            //         builder: (context, seriesState) {
            // if (seriesState.status == ApiStatus.seriesRatingStatsFetchingSuccessful) {
            // return SliverToBoxAdapter(
            // child: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 15),
            // child: SeriesRatingStatsWidget(
            // series: item,
            // stats: seriesState.reviewStats!,
            // ),
            // ),
            // );
            // }
            // else
            // if(seriesState.status == ApiStatus.seriesRatingStatsFetching) {
            // return SliverToBoxAdapter(
            // child: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 15),
            // child: Text('Fetching stats ...', style: TextStyle(color: theme.colorScheme.onBackground), ),
            // ),
            // );
            // }
            //
            // return const SliverToBoxAdapter(
            // child: SizedBox.shrink(),
            // );
            // }

          } else ... {
            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 40),
                child: Text(
                  'Reviews are disabled for this series',
                  style: TextStyle(color: theme.colorScheme.onBackground),
                ),
              ),
            ),
          },

          PagedSliverList<int, SeriesReviewerModel>.separated(
            pagingController: state.pagingController,
            addAutomaticKeepAlives: true,
            builderDelegate: PagedChildBuilderDelegate<SeriesReviewerModel>(
              itemBuilder: (context, item, index) {
                return Padding(
                  key: ValueKey(item.id),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ReviewerItemWidget(reviewerModel: item, seriesModel: widget.seriesItem, ),
                );

              },
              firstPageProgressIndicatorBuilder: (_) => const Center(child: CustomAdaptiveCircularIndicator(),),
              newPageProgressIndicatorBuilder: (_) => const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    height: 50, width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CustomAdaptiveCircularIndicator(),
                    ),
                  )),
              noItemsFoundIndicatorBuilder: (_) {
                return   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Be the first to write something nice",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onBackground),),
                );
              },
              noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
              firstPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
              newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
            ),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 15,);
            },
          )
          // if (widget.seriesItem.settings?.enableReview != null && widget.seriesItem.settings!.enableReview!) ...{
          //   // BlocBuilder<SeriesPreviewCubit, SeriesPreviewState>(
          //   //   buildWhen: (_, next) {
          //   //     return next.status == ApiStatus.seriesRatingStatsFetching ||
          //   //         next.status ==
          //   //             ApiStatus.seriesRatingStatsFetchingSuccessful ||
          //   //         next.status == ApiStatus.seriesRatingStatsFetchingFailed;
          //   //   },
          //   //   builder: (context, seriesState) {
          //   //     if (seriesState.status == ApiStatus.seriesRatingStatsFetchingSuccessful) {
          //   //       return SliverToBoxAdapter(
          //   //         child: Padding(
          //   //           padding: const EdgeInsets.symmetric(horizontal: 15),
          //   //           child: SeriesRatingStatsWidget(
          //   //             series: item,
          //   //             stats: seriesState.reviewStats!,
          //   //           ),
          //   //         ),
          //   //       );
          //   //     }
          //   //     else if(seriesState.status == ApiStatus.seriesRatingStatsFetching) {
          //   //       return SliverToBoxAdapter(
          //   //         child: Padding(
          //   //           padding: const EdgeInsets.symmetric(horizontal: 15),
          //   //           child: Text('Fetching stats ...', style: TextStyle(color: theme.colorScheme.onBackground),),
          //   //         ),
          //   //       );
          //   //     }
          //   //
          //   //     return const SliverToBoxAdapter(
          //   //       child: SizedBox.shrink(),
          //   //     );
          //   //   },
          //   // ),
          //
          //   const SliverToBoxAdapter(
          //     child: SizedBox(
          //       height: 20,
          //     ),
          //   ),
          //
          //   /// horizontal line ------
          //   const SliverToBoxAdapter(
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 15),
          //         child: CustomBorderWidget(),
          //       )),
          //
          //   SliverToBoxAdapter(
          //     child: SeriesRatingListWidget(
          //       scrollController: state.scrollController,
          //       series: item,
          //     ),
          //   )
          // } else ...{
          //   SliverToBoxAdapter(
          //     child: Padding(
          //       padding:
          //       const EdgeInsets.only(left: 15, right: 15, bottom: 40),
          //       child: Text(
          //         'Reviews are disabled for this series',
          //         style: TextStyle(color: theme.colorScheme.onBackground),
          //       ),
          //     ),
          //   )
          // }
        ],
      )
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SeriesPreviewPageController extends State<SeriesPreviewPage> {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, SeriesReviewerModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late SeriesPreviewCubit seriesPreviewCubit;
  late StreamSubscription<SeriesPreviewState> seriesPreviewStateStreamSubscription;

  @override
  Widget build(BuildContext context) => _SeriesPreviewPageView(this);

  @override
  void initState() {
    seriesPreviewCubit = context.read<SeriesPreviewCubit>();
    seriesPreviewCubit.setSeriesPreview(series: widget.seriesItem);
    seriesPreviewCubit.fetchSeriesRatingStats(seriesId: widget.seriesItem.id!);


    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchSeriesReviews(pageKey);
      if(response.isLeft()){
        pagingController.error = response.asLeft();
        return;
      }
      final newItems = response.asRight();
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    });

    seriesPreviewStateStreamSubscription = seriesPreviewCubit.stream.listen((event) async {
      if(event.status == SeriesStatus.seriesRatingCreatingSuccessful) {
        final reviewers  = event.reviewers[widget.seriesItem.id!];
        if(reviewers != null) {
          pagingController.itemList = [...reviewers];
        }

        // fetch stats again
        seriesPreviewCubit.fetchSeriesRatingStats(seriesId: widget.seriesItem.id!);

      }
    });

    super.initState();
  }

  Future<dartz.Either<String, List<SeriesReviewerModel>>> fetchSeriesReviews(int pageKey) async {
    return await seriesPreviewCubit.fetchSeriesRatingList(pageKey: pageKey, seriesModel: widget.seriesItem);
  }


  @override
  void dispose() {
    super.dispose();
  }

}