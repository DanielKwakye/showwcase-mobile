import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/data/bloc/thread_editor_communities_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';

class ThreadEditorCommunityListPage extends StatefulWidget {

  final Function(CommunityModel)? onTap;

  const ThreadEditorCommunityListPage({Key? key, this.onTap}) : super(key: key);

  @override
  ThreadEditorCommunityListPageController createState() => ThreadEditorCommunityListPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadEditorCommunityListPageView extends WidgetView<ThreadEditorCommunityListPage, ThreadEditorCommunityListPageController> {

  const _ThreadEditorCommunityListPageView(ThreadEditorCommunityListPageController state) : super(state);

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
        title: Text('Communities', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700,fontSize: defaultFontSize ),),
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(2),
            child: CustomBorderWidget()
        ),
      ),
      body: CustomSharedRefreshIndicator(
        onRefresh: () async {
          final response = await state.fetchCurrentUserCommunities(0);
          if(response.isLeft()){return;}
          final threads = response.asRight();
          state.pagingController.value = PagingState(nextPageKey: 1, itemList: threads);
        },
        child: PagedListView<int, CommunityModel>.separated(
          padding: const EdgeInsets.only(top: 0,left: 24,right: 20),
          pagingController: state.pagingController,
          builderDelegate: PagedChildBuilderDelegate<CommunityModel>(
            itemBuilder: (context, item, index) {

              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  if(widget.onTap != null) {
                    widget.onTap?.call(item);
                    Navigator.of(context).pop();
                  }

                },
                child:  IgnorePointer(
                  ignoring: true,
                  child: CommunityItemWidget(
                    community: item,
                    showJoinedAction: false,
                    onTap: (){},
                    containerName: 'thread_editor_community_list',
                    pageName: 'thread_editor_community_list',
                  ),
                ),
              );

            },
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
            firstPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
            newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
          ),
          separatorBuilder: (context, index) => const SizedBox.shrink(),
        ),
      ),
    );

  }

  Widget _fallbackIcon(BuildContext context, String name) {
    return Center(
        child: Text(
          getInitials(name.toUpperCase()),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground, fontSize: 10),
        ));
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadEditorCommunityListPageController extends State<ThreadEditorCommunityListPage> {

  late ThreadEditorCommunitiesCubit threadEditorCommunitiesCubit;
  final PagingController<int, CommunityModel> pagingController  = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);


  @override
  Widget build(BuildContext context) => _ThreadEditorCommunityListPageView(this);

  @override
  void initState() {

    threadEditorCommunitiesCubit =  context.read<ThreadEditorCommunitiesCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchCurrentUserCommunities(pageKey);
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

    super.initState();
  }


  Future<dartz.Either<String, List<CommunityModel>>> fetchCurrentUserCommunities(int pageKey) async {
    final user = AppStorage.currentUserSession!;
    return await threadEditorCommunitiesCubit.fetchThreadEditorCommunities(userModel: user, pageKey: pageKey);
  }


  @override
  void dispose() {
    super.dispose();
  }

}