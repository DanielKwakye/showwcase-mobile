import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_code_thread_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_preview_cubit.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_preview_state.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_thread_tags_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_item_widget.dart';

class CommunitiesCodeThread extends StatefulWidget {
  final CommunityModel communityModel;

  const CommunitiesCodeThread(
      {Key? key, required this.communityModel, })
      : super(key: key);

  @override
  CommunitiesCodeThreadController createState() =>
      CommunitiesCodeThreadController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class CommunitiesCodeThreadView
    extends WidgetView<CommunitiesCodeThread, CommunitiesCodeThreadController> {
  const CommunitiesCodeThreadView(CommunitiesCodeThreadController state,
      {super.key})
      : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      /// Categories
      children: [
        CommunityThreadTagsWidget(communityModel: widget.communityModel,),
        Expanded(
          child: PagedListView<int, ThreadModel>.separated(
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            pagingController: state.pagingController,
            builderDelegate: PagedChildBuilderDelegate<ThreadModel>(
              itemBuilder: (context, item, index) =>
                  Container(
                      color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
                      child: BlocSelector<CommunityCodeThreadsCubit, ThreadState, ThreadModel?>(
                        selector: (state) {return state.threads.firstWhereOrNull((element) => element.id == item.id);},
                        builder: (context, thread) {
                          return ThreadItemWidget(threadModel: thread ?? item,pageName: '',);
                        },
                      )
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
          ) ,
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CommunitiesCodeThreadController extends State<CommunitiesCodeThread>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{
  late TabController tabController;

  late CommunityPreviewCubit communityPreviewCubit;
  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, ThreadModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late CommunityCodeThreadsCubit codeThreadsCubit;
  late StreamSubscription<CommunityPreviewState> communityPreviewStateStreamSubscription;
  final ValueNotifier<bool> activateThreadTags = ValueNotifier(true);
  String? selectedTag ;

  @override
  void initState() {

    communityPreviewCubit = context.read<CommunityPreviewCubit>();
    codeThreadsCubit = context.read<CommunityCodeThreadsCubit>();
    tabController = TabController(length: 1, vsync: this);
    communityPreviewCubit.fetchCommunityTags(communityModel: widget.communityModel);
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchCommunityCodeThreadFeeds( pageKey: pageKey,tag: selectedTag);
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
    communityPreviewStateStreamSubscription = communityPreviewCubit.stream.listen((event) {
      if(event.status == CommunityStatus.selectCommunityThreadTagCompleted){
        final tag = event.selectedCommunityTag;
        selectedTag = tag.name;
        pagingController.refresh();
      }
    });
    super.initState();
  }

  Future<dartz.Either<String, List<ThreadModel>>> fetchCommunityCodeThreadFeeds({required int pageKey,required String? tag}) async {
    return await codeThreadsCubit.fetchCommunityCodeThreadFeeds(pageKey:pageKey, communityName: widget.communityModel.slug ?? '',tag: tag,feedType: 'code');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CommunitiesCodeThreadView(this);
  }

  @override
  void dispose() {
    communityPreviewStateStreamSubscription.cancel() ;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
