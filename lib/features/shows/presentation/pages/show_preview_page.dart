import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_cubit.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_enums.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_linear_loading_indicator_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_markdown_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_state.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_worked_with_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_blocks_content_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_item_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_preview_lexical_block_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/shows_action_bar_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_list_tile_widget.dart';


class ShowPreviewPage extends StatefulWidget {

  final ShowModel showModel;
  final List<Widget> actions;
  final bool hideRecommendedShows;
  const ShowPreviewPage({Key? key, required this.showModel, this.actions = const [], this.hideRecommendedShows = false}) : super(key: key);

  @override
  ShowPreviewPageController createState() => ShowPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ShowPreviewPageView extends WidgetView<ShowPreviewPage, ShowPreviewPageController> {

  const _ShowPreviewPageView(ShowPreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final networkImage = getProfileImage(widget.showModel.coverImage);

    return BlocSelector<ShowPreviewCubit, ShowPreviewState, ShowModel>(
      selector: (state) {
        return state.showPreviews.firstWhere((element) => element.id == widget.showModel.id);
      },
      builder: (context, updatedShow) {

        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            color: theme.colorScheme.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
               children: [
                 const CustomBorderWidget(),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: BlocSelector<ShowPreviewCubit, ShowPreviewState, ShowModel>(
                     selector: (state) {
                       return state.showPreviews.firstWhere((element) => element.id == widget.showModel.id);
                     },
                     builder: (context, show) {
                       return ShowsActionBarWidget(showModel: show,);
                     },
                   )

                 )
               ],
            ),
          ),
          body: CustomScrollView(
            controller: state.scrollController,
            slivers:
              [

                /// App bar (Flexible) --------
                SliverAppBar(
                  pinned: true,
                  backgroundColor: theme.colorScheme.primary,
                  leadingWidth: media.size.width,
                  elevation: 0,
                  leading: UnconstrainedBox(
                    alignment: Alignment.centerLeft,
                    child: BackButton(color: theme.colorScheme.onBackground,),
                  ),
                  actions: [
                    ...widget.actions.map((action) => UnconstrainedBox(
                      child: action,
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: threadSymmetricPadding),
                      child: PopupMenuButton<String>(

                        padding: const EdgeInsets.only(right: 0.0,bottom: 0),
                        onSelected: (menu) {
                          if(menu == "report"){
                            _reportThreadUI(context);
                            return;
                          }
                          _onMoreMenuItemTapped(context, menu);
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        itemBuilder: (ctx) => [
                          _buildPopupMenuItem(context, 'Click to copy', Icons.copy, "copy"),
                          const PopupMenuDivider(),
                          _buildPopupMenuItem(context, 'Report show', Icons.flag_outlined, "report"),
                        ],
                        child: Container(
                          height: 24,
                          width: 24,
                          alignment: Alignment.centerRight,
                          child: Icon(
                              Icons.more_horiz,
                              color:theme.colorScheme.onPrimary.withOpacity(0.7)
                          ),
                        ),
                      ),
                    ),

                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(2),
                    child: BlocBuilder<SeriesCubit, SeriesState>(
                      builder: (_, seriesState) {
                        return BlocBuilder<ShowPreviewCubit, ShowPreviewState>(
                          builder: (context, showPreviewState) {
                            if(showPreviewState.status == ShowsStatus.fetchShowsPreviewInProgress || seriesState.status == SeriesStatus.markProjectAsCompleteInProgress) {
                              return const CustomLinearLoadingIndicatorWidget();
                            }
                            return const SizedBox.shrink();
                          },
                        );
                      },
                    )
                  ),

                ),

                /// Main Show preview  -----------
                SliverToBoxAdapter(
                  child: SeparatedColumn(
                    separatorBuilder: (BuildContext context, int index) {
                      return const CustomBorderWidget();
                    },
                    children: [
                      CachedNetworkImage(
                        imageUrl: networkImage,
                        errorWidget: (context, url, error) => Container(
                          color: kAppBlue,
                        ),
                        placeholder: (ctx, url) => Container(
                          color: kAppBlue,
                        ),
                        cacheKey: networkImage,
                        fit: BoxFit.cover,
                      ),
                      /// meta data
                      // Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Padding(padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding, vertical: 15),
                      //       child: Row(
                      //         mainAxisSize: MainAxisSize.max,
                      //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Expanded(child: SeparatedRow(
                      //             mainAxisSize: MainAxisSize.min,
                      //             separatorBuilder: (BuildContext ctx, int index) {
                      //               return const SizedBox(width: 5,);
                      //             },
                      //             children: [
                      //               if (!categoryName.isNullOrEmpty()) ...{
                      //                 Container(
                      //                   // margin: const EdgeInsets.only(right: 10),
                      //                   padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                      //                   decoration: BoxDecoration(
                      //                     color: backgroundColor,
                      //                     borderRadius: BorderRadius.circular(16),
                      //                     border: Border.all(
                      //                         color: foregroundColor.withOpacity(0.3), width: 0.5),
                      //                   ),
                      //                   child: Row(
                      //                     children: [
                      //                       SvgPicture.asset(
                      //                         icon!,
                      //                         colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
                      //                         width: 18,
                      //                       ),
                      //                       const SizedBox(
                      //                         width: 5,
                      //                       ),
                      //                       Text(categoryName!, style: TextStyle(color: foregroundColor,fontWeight: FontWeight.w600,fontSize: 12)),
                      //                       const SizedBox(
                      //                         width: 5,
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //               },
                      //               if(updatedShow.readingStats != null && updatedShow.readingStats!.time != 0) ... {
                      //                 Text(
                      //                   updatedShow.readingStats!.text ?? '', style: TextStyle(
                      //                     color: theme.colorScheme.onPrimary, fontSize: 13),
                      //                   overflow: TextOverflow.ellipsis,
                      //                   maxLines: 1,),
                      //
                      //               },
                      //             ],
                      //           )),
                      //
                      //
                      //           if( updatedShow.publishedDate != null) ... {
                      //             Text(
                      //               updatedShow.publishedDate != null
                      //                   ? getFormattedDateWithIntl(updatedShow.publishedDate!,
                      //                   format: 'd MMMM, y')
                      //                   : '', style: TextStyle(color: theme.colorScheme
                      //                 .onPrimary, fontSize: 13),
                      //               overflow: TextOverflow.ellipsis,
                      //               maxLines: 1,),
                      //           },
                      //         ],
                      //       ),
                      //     ),

                      //   ],
                      // ),

                      // BlocBuilder<ShowPreviewCubit, ShowPreviewState>(
                      //   builder: (context, showState) {
                      //     if(showState.status == ShowsStatus.fetchShowsPreviewInProgress){
                      //       /// Progress indicator for loading remaining Show details
                      //       return const LinearProgressIndicator(color: kAppBlue, minHeight: 1,);
                      //     }
                      //     return const SizedBox.shrink();
                      //   },
                      // ),

                      SeparatedColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10,);
                        },
                        children: [

                          /// Title
                          if(!updatedShow.title.isNullOrEmpty()) ... {
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding, vertical: 8),
                              child: Text(updatedShow.title!, style: theme.textTheme.titleMedium?.copyWith(fontSize: defaultFontSize + 5, fontWeight: FontWeight.w700)),
                            )
                          },

                          /// Project description
                          if(!updatedShow.projectSummary.isNullOrEmpty()) ... {
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding),
                              child: Text(updatedShow.projectSummary!, style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: defaultFontSize ,
                                  height: defaultLineHeight
                              ),),
                            )
                          },

                          const CustomBorderWidget(left: 15, right: 15,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding),
                            child: SeparatedColumn(separatorBuilder: (_, __) {
                              return const SizedBox(height: 10,);
                            }, children: [

                              /// Author of Show
                              if(widget.showModel.user != null) ... {
                                UserListTileWidget(userModel: widget.showModel.user!, showHeadLine: false, showUsername: false,
                                  subTitleWidget: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      if( updatedShow.publishedDate != null) ... {
                                        Text(
                                          updatedShow.publishedDate != null
                                              ? getFormattedDateWithIntl(updatedShow.publishedDate!,
                                              format: 'd MMMM, y')
                                              : '', style: TextStyle(color: theme.colorScheme
                                            .onPrimary, fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,),
                                      },

                                      if((updatedShow.readingStats != null && updatedShow.readingStats!.time != 0) &&  updatedShow.publishedDate != null) ... {
                                        const CustomDotWidget(leftPadding: 5, rightPadding: 5,),
                                      },
                                      if(updatedShow.readingStats != null && updatedShow.readingStats!.time != 0) ... {
                                        Text(
                                          updatedShow.readingStats!.text ?? '', style: TextStyle(
                                            color: theme.colorScheme.onPrimary, fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,),

                                      },

                                    ],
                                  ),
                                ),
                              },

                              /// contributors,
                              if((updatedShow.workedwiths ?? <ShowWorkedWithModel>[]).isNotEmpty) ... {
                                ...(updatedShow.workedwiths ?? <ShowWorkedWithModel>[]).where((element) => element.colleague != null).map((workedWith) {
                                  return UserListTileWidget(userModel: workedWith.colleague!, showHeadLine: false, showUsername: true,);
                                })
                              },

                            ],),
                          ),

                          const CustomBorderWidget(left: 15, right: 15,),

                          /// content goes here ---------------
                          // markdown
                          SeparatedColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            separatorBuilder: (_, __){
                              return const SizedBox(height: 10,);
                            }, children: [
                            if (!updatedShow.markdown.isNullOrEmpty()) ...{
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding,),
                                child: CustomMarkdownWidget(
                                  markdown: updatedShow.markdown!,
                                  onLinkTapped: (link) {
                                    context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
                                      "show": updatedShow,
                                      "url" : link
                                    });
                                  },
                                  onMentionTapped: (mention) {
                                    context.read<HomeCubit>().redirectLinkToPage(url: mention, fallBackRoutePath: browserPage, fallBackRoutePathData:  {
                                      "url": mention,
                                    });
                                  },
                                  onCodeTapped: (code, language) {
                                    context.push(context.generateRoutePath(subLocation: showCodePreviewPage), extra: {
                                      "show": updatedShow,
                                      "code" : code,
                                      "tag" : updatedShow.id.toString(),
                                      "codeLanguage": language
                                    });
                                  },
                                ),
                              )
                            },
                            //blocks
                            if (updatedShow.content?.blocks != null) ...{
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding,),
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(top: 0),
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      ...? updatedShow.content?.blocks?.map((block) {

                                        // final block = show.content!.blocks![i];
                                        return ShowBlocksContentWidget(
                                          block: block,
                                          show: updatedShow,
                                        );

                                      })
                                    ],
                                  )

                              )
                            },

                            // LexicalBlock in html (for new threadEditor) goes here
                            if(updatedShow.content?.lexicalBlock != null) ... {
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding,),
                                child: ShowPreviewLexicalBlockWidget(lexicalBlock: updatedShow.content!.lexicalBlock!, show: updatedShow,),
                              )
                            },

                            SeparatedRow(
                               separatorBuilder: (BuildContext context, int index) {
                                 return const SizedBox(width: 10,);
                               },
                               children: [
                                 if((widget.showModel.totalUpvotes??0) > 0)  GestureDetector(
                                   onTap: (){
                                     context.push(context.generateRoutePath(subLocation: showUpVotersPage), extra: widget.showModel);
                                   },
                                   child: Padding(
                                     padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10,left: 15),
                                     child: RichText(
                                       text: TextSpan(
                                         text: (formatHumanReadable(widget.showModel.totalUpvotes ?? 0)).toString(),
                                         style: theme.textTheme.bodyMedium?.copyWith(
                                             color:  theme.colorScheme.onPrimary,
                                             fontWeight: FontWeight.w600),
                                         children: <TextSpan>[
                                           if ((widget.showModel.totalUpvotes ?? 0) > 1) ...{
                                             TextSpan(
                                                 text: ' Likes',
                                                 style: TextStyle(
                                                     color: theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                                           },
                                           if ((widget.showModel.totalUpvotes ?? 0) == 1) ...{
                                             TextSpan(
                                                 text: ' Like',
                                                 style: TextStyle(
                                                     color: theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                                           },
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),

                                 if((widget.showModel.totalComments??0) > 0)  GestureDetector(
                                   onTap: (){
                                     context.push(context.generateRoutePath(subLocation: showCommentsPage), extra: widget.showModel);
                                   },
                                   child: Padding(
                                     padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
                                     child: RichText(
                                       text: TextSpan(
                                         text: (formatHumanReadable(widget.showModel.totalComments ?? 0)),
                                         style: theme.textTheme.bodyMedium?.copyWith(
                                             color:  theme.colorScheme.onPrimary,
                                             fontWeight: FontWeight.w600),
                                         children: <TextSpan>[
                                           if ((widget.showModel.totalComments ?? 0) > 1) ...{
                                             TextSpan(
                                                 text: ' Comments',
                                                 style: TextStyle(
                                                     color: theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                                           },
                                           if ((widget.showModel.totalComments ?? 0) == 1) ...{
                                             TextSpan(
                                                 text: ' Comment',
                                                 style: TextStyle(
                                                     color: theme.colorScheme.onPrimary,fontWeight: FontWeight.w400,fontSize: defaultFontSize - 1)),
                                           },
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               ],
                            )




                          ],),

                          if(updatedShow.tags != null) Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 10.0,
                              children: List.generate(updatedShow.tags!.length, (index) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.outline,
                                    borderRadius: BorderRadius.circular(4)),
                                child:  Text(
                                  updatedShow.tags![index].tagDescription!,
                                  style: const TextStyle(
                                      color: kAppGray,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ) ),
                            ),
                          ),


                        ],
                      ),


                    ],
                  ),
                ),

                /// Recommended shows ------
                ///
                if(!widget.hideRecommendedShows) ... {
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: showSymmetricPadding, vertical: 20),
                      child: Text("Recommended Shows", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),

                  PagedSliverList<int, ShowModel>.separated(
                    pagingController: state.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<ShowModel>(
                      itemBuilder: (context, item, index) =>
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding, vertical: 10),
                              color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
                              child: BlocSelector<ShowPreviewCubit, ShowPreviewState, ShowModel>(
                                selector: (showState) {
                                  return showState.recommendedShows[widget.showModel.id!]!.firstWhere((element) => element.id == item.id);
                                },
                                builder: (_, show) {
                                  return ShowItemWidget(showModel: show,pageName: showPreviewPage,);
                                },
                              )
                            // ,
                          ),
                      firstPageProgressIndicatorBuilder: (_) => const Center(child: CustomAdaptiveCircularIndicator(),),
                      newPageProgressIndicatorBuilder: (_) => const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: SizedBox(
                            height: 100, width: double.maxFinite,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: CustomAdaptiveCircularIndicator(),
                            ),
                          )),
                      noItemsFoundIndicatorBuilder: (_) => const CustomEmptyContentWidget(),
                      noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
                      firstPageErrorIndicatorBuilder: (_) => const CustomNoConnectionWidget(
                        title:
                        "Restore connection and swipe to refresh ...",
                      ),
                      newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
                    ),
                    separatorBuilder: (context, index) => Container(
                      height: 7,
                      color: theme.brightness == Brightness.light ? theme.colorScheme.surface : theme.colorScheme.background,
                    ),
                  )
                },

              ]
            ,


          ),
        );
      },
    );


  }

  void _onMoreMenuItemTapped(BuildContext context, String menu){
    if (menu == "copy"){
      final copyUrl = "${ApiConfig.websiteUrl}/show/${widget.showModel.id}/${widget.showModel.slug}";
      copyTextToClipBoard(context, copyUrl);
      // AnalyticsManager.showCopyLink(pageTitle: 'shows', pageName: 'copy_show',pageId: widget.show.id!);
    }
  }

  void _reportThreadUI(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme(context).colorScheme.primary,
        context: context,
        builder: (ctx) {
          return Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(alignment: Alignment.topRight, child: CloseButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),),
                  const CustomBorderWidget(),
                  const SizedBox(height: 20,),
                  Text('Why are you reporting this show?', style: theme(context).textTheme.bodyText2,),
                  const SizedBox(height: 10,),
                  ValueListenableBuilder(valueListenable: state.selectedReport,
                      builder: (ctx, value, _) {
                        return Row(
                          children:  [
                            ChoiceChip(label: Text("Spam", style: TextStyle(color: value == "spam" ? kAppWhite : theme(context).colorScheme.onBackground.withOpacity(0.5)),),
                              selected: value == "spam",
                              selectedColor: kAppBlue,
                              onSelected: (v) {
                                state.reportReason = "Spam";
                                state.selectedReport.value = "spam";
                                state.activateReportButton.value = true;
                                state._reportMessageController.clear();
                              }, ),
                            const SizedBox(width: 10,),
                            ChoiceChip(label: Text("Inappropriate", style: TextStyle(color: value == "inappropriate" ? kAppWhite : theme(context).colorScheme.onBackground.withOpacity(0.5)),), selected: value == "inappropriate", selectedColor: kAppBlue, onSelected: (v) {
                              state.selectedReport.value = "inappropriate";
                              state.reportReason = "Inappropriate";
                              state.activateReportButton.value = true;
                              state._reportMessageController.clear();
                            },),
                            const SizedBox(width: 10,),
                            ChoiceChip(label: Text("Plagiarism", style: TextStyle(color: value == "plagiarism" ? kAppWhite : theme(context).colorScheme.onBackground.withOpacity(0.5))), selected: value == "plagiarism", selectedColor: kAppBlue, onSelected: (v) {
                              state.selectedReport.value = "plagiarism";
                              state.reportReason = "Plagiarism";
                              state.activateReportButton.value = true;
                              state._reportMessageController.clear();
                            },),
                          ],
                        );
                      }
                  ),
                  const SizedBox(height: 10,),
                  CustomTextFieldWidget(
                    controller: state._reportMessageController,
                    label: "Other reason", placeHolder: "Enter your reason",
                    onChange: (value) => _onReportReasonChanged(value!),
                  ),
                  const SizedBox(height: 10,),
                  Builder(builder: (ctx) {
                    return ValueListenableBuilder<bool>(valueListenable: state.activateReportButton, builder: (ctx, bool activate, _) {

                      return CustomButtonWidget(text: "Submit report",
                          appearance: Appearance.clean,
                          textColor: activate ? kAppBlue : null,
                          outlineColor: activate ? kAppBlue : null,
                          backgroundColor: activate ? null : theme(context).colorScheme.outline,
                          onPressed: activate ? () {
                            _submitReport(ctx);
                          } : null );

                    },);
                  }
                  ),
                  const SizedBox(height: kToolbarHeight,),
                ],
              ),
            ),
          );
        });
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, String title, IconData iconData, String value) {
    return PopupMenuItem(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      value: value,
      height: 30,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 12,),
          Icon(iconData, color: theme(context).colorScheme.onBackground, size: 16,),
          // const SizedBox(width: 15,),
          const SizedBox(width: 8,),
          Text(title, style: TextStyle(color: theme(context).colorScheme.onBackground, fontSize: defaultFontSize - 1),),
          const SizedBox(width: 8,),
        ],
      ),
    );
  }

  void _submitReport(BuildContext ctx) {
    state.showCubit.reportShow(message: state.reportReason, projectId: widget.showModel.id!);
    Navigator.of(ctx).pop();
  }

  void _onReportReasonChanged(String value) {
    state.selectedReport.value = null;
    if(value.isNotEmpty){
      state.activateReportButton.value = true;
    }else {
      state.activateReportButton.value = false;
    }
    state.reportReason = value;
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ShowPreviewPageController extends State<ShowPreviewPage> {

  late ShowPreviewCubit showPreviewCubit;
  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, ShowModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize,);

  final ScrollController scrollController = ScrollController();
  late ShowsCubit showCubit;
  late TextEditingController _reportMessageController;
  // late ThreadsResponse upvoteThread, boostTread, bookmarkThread;
  ValueNotifier<String?> selectedReport = ValueNotifier(null);
  ValueNotifier<bool> activateReportButton = ValueNotifier(false);
  String reportReason = '';
  late StreamSubscription<ShowPreviewState> showPreviewStateStreamSubscription;

  @override
  Widget build(BuildContext context) => _ShowPreviewPageView(this);

  @override
  void initState() {
    super.initState();
    showPreviewCubit = context.read<ShowPreviewCubit>();
    showPreviewCubit.setShowPreview(show: widget.showModel, updateIfExist: false);
    showPreviewCubit.fetchShowsPreview(showId: widget.showModel.id!);
    showPreviewStateStreamSubscription = showPreviewCubit.stream.listen((event) {
      if(event.status == ShowsStatus.fetchShowsPreviewSuccessful) {
        // scroll to top
        scrollController.animateTo(0.0, duration: const Duration(milliseconds: 800), curve: Curves.linear);
      }
    });
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchRecommendedShows(pageKey);
      if(response.isLeft()){
        pagingController.error = response.asLeft();
        return;
      }
      final newItems = response.asRight();
      pagingController.appendLastPage(newItems.take(4).toList());
      //final isLastPage = newItems.isEmpty;
      // if (isLastPage) {
      //   pagingController.appendLastPage(newItems);
      // } else {
      //   final nextPageKey = pageKey + 1;
      //   pagingController.appendPage(newItems, nextPageKey);
      // }
    });

  }


  Future<dartz.Either<String, List<ShowModel>>> fetchRecommendedShows(int pageKey) async {
    return await  showPreviewCubit.fetchRecommendedShows(pageKey: pageKey, currentProjectId: widget.showModel.id!);
  }

  @override
  void dispose() {
    super.dispose();
  }

}