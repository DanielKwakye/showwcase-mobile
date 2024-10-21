import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_linear_loading_indicator_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_state.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_comment_item_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_item_widget.dart';


class ShowCommentsPage extends StatefulWidget {

  final ShowModel showModel;
  const ShowCommentsPage({Key? key, required this.showModel}) : super(key: key);

  @override
  ShowCommentsPageController createState() => ShowCommentsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ShowsCommentsPageView extends WidgetView<ShowCommentsPage, ShowCommentsPageController> {

  const _ShowsCommentsPageView(ShowCommentsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.colorScheme.primary,
          actions: const [
            CloseButton()
          ],
          title: Text("Discussion", style: TextStyle(color: theme.colorScheme.onBackground, fontSize: defaultFontSize),),
          iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
          automaticallyImplyLeading: false,
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: CustomBorderWidget()
          ),
        ),
        bottomNavigationBar: _bottomBar(context),
        body: Column(
           children: [
             Padding(
               padding: const EdgeInsets.only(left: showSymmetricPadding, right: showSymmetricPadding, top: 10),
               child: ShowItemWidget(showModel: widget.showModel, showActionBar: false, onTap: () {},pageName: showCommentsPage,),
             ),
             const CustomBorderWidget(),

             Expanded(child:
              BlocConsumer<ShowPreviewCubit, ShowPreviewState>(
                listenWhen: (_, next){
                  return next.status == ShowsStatus.refreshShowCommentsCompleted;
                },
                listener: (context, showPreviewState) {
                  if(showPreviewState.status == ShowsStatus.refreshShowCommentsCompleted){
                    final itemList = showPreviewState.comments[widget.showModel.id];
                    state.pagingController.itemList = itemList;
                  }
                },
                builder: (context, threadPreviewState) {
                  return PagedListView<int, ShowCommentModel>.separated(
                    pagingController: state.pagingController,
                    addAutomaticKeepAlives: true,
                    padding: const EdgeInsets.only(left: showSymmetricPadding, right: showSymmetricPadding, top: 10),
                    builderDelegate: PagedChildBuilderDelegate<ShowCommentModel>(
                      itemBuilder: (context, item, index) {
                        return BlocSelector<ShowPreviewCubit, ShowPreviewState, ShowCommentModel>(
                          key: ValueKey(item.id),
                          selector: (threadPreviewState) {
                            return threadPreviewState.comments[widget.showModel.id]!.firstWhere((element) => element.id == item.id);
                          },
                          builder: (context, reactiveComment) {
                            return ShowCommentItemWidget(key: ValueKey(reactiveComment.id),comment: reactiveComment, show: widget.showModel);
                          },
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
                  );
                },
              )
             )
           ],
        )
    );

  }

  Widget _bottomBar(BuildContext context) {
    final theme = Theme.of(context);
    return BottomAppBar(
      elevation: 0,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          BlocBuilder<ShowPreviewCubit, ShowPreviewState>(
            builder: (context, showPreviewState) {
              if(showPreviewState.status == ShowsStatus.deleteCommentInProgress){
                return const CustomLinearLoadingIndicatorWidget();
              }
              return const SizedBox.shrink();
            },
          ),
          const CustomBorderWidget(),
          Padding(padding: const EdgeInsets.symmetric(vertical: 0),
            child: Row(
              children: [
                const  SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                    style: TextStyle(color: theme.colorScheme.onBackground),
                    maxLines: null, // makes text field grow downwards
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      hintText: 'Write something nice...',
                    ),
                    readOnly: true,
                    onTap: () => context.push(context.generateRoutePath(subLocation: showCommentsEditorPage), extra: {
                      'show': widget.showModel
                    }),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: GestureDetector(
                      onTap:  null,
                      child: Container(
                        color: theme.colorScheme.outline,
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(kSendIconSvg, colorFilter: const ColorFilter.mode(kAppGray, BlendMode.srcIn),
                          width: 22,
                          // height: 22,
                        ),
                      )

                    // ,
                  ),
                ),
                const SizedBox(width: 10,),
              ],
            ),
          )


        ],
      ),
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ShowCommentsPageController extends State<ShowCommentsPage> {

  final ScrollController scrollController = ScrollController();
  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, ShowCommentModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late ShowPreviewCubit showPreviewCubit;
  late StreamSubscription<ShowPreviewState> showPreviewStateStreamSubscription;

  @override
  Widget build(BuildContext context) => _ShowsCommentsPageView(this);

  @override
  void initState() {
    showPreviewCubit = context.read<ShowPreviewCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchShowComments(pageKey);
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
    showPreviewStateStreamSubscription = showPreviewCubit.stream.listen(_showPreviewCubitListener);
    super.initState();
  }

  Future<dartz.Either<String, List<ShowCommentModel>>> fetchShowComments(int pageKey) async {
    return await showPreviewCubit.fetchShowComments(pageKey: pageKey, projectId: widget.showModel.id!);
  }

  void _showPreviewCubitListener(ShowPreviewState event) {
    if(event.status == ShowsStatus.deleteShowCommentSuccessful){
      // if(event.data is ThreadModel){
      //   final deletedThread = event.data as ThreadModel;
      //   if(deletedThread.id == widget.thread.id){
      //     context.showSnackBar("Thread deleted");
      //     context.pop();
      //   }
      // }
    }
  }

  @override
  void dispose() {
    showPreviewStateStreamSubscription.cancel();
    super.dispose();
  }

}