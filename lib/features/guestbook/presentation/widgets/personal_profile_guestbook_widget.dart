import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/guestbook/data/bloc/guestbook_cubit.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_model.dart';
import 'package:showwcase_v3/features/guestbook/presentation/widgets/guestbook_item.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class PersonalProfileGuestBookWidget extends StatefulWidget {
  final UserModel userModel;

  const PersonalProfileGuestBookWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  GuestBookWidgetController createState() => GuestBookWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class GuestBookWidgetView extends WidgetView<PersonalProfileGuestBookWidget, GuestBookWidgetController> {

  const GuestBookWidgetView(GuestBookWidgetController state, {super.key}) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomSharedRefreshIndicator(
      onRefresh: () async {
        final response = await state.fetchGuestBookFeeds(pageKey: 0, userName: widget.userModel.username!);
        if(response.isLeft()){
          return;
        }
        final shows = response.asRight();
        state.pagingController.value = PagingState(
            nextPageKey: 1,
            itemList: shows
        );

      },
      child: PagedListView<int, GuestBookModel>.separated(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        pagingController: state.pagingController,

        builderDelegate: PagedChildBuilderDelegate<GuestBookModel>(
          itemBuilder: (context, item, index) {
            return Container(
                key: ValueKey(item.id),
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite,
                child: GuestBookItem(guestbook: item,  key: ValueKey(item.id), onDeleted: (){}, onEdit: (){},userName: widget.userModel.username!,)
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
          noItemsFoundIndicatorBuilder: (_) =>  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Text(
                      'You currently have no written messages in your Guestbook',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: theme.brightness == Brightness.dark ? kAppBlack : kAppWhite,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tell people about your Guestbook",
                              style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Write a Thread to tell people about your page',
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimary))
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomButtonWidget(
                        text: 'Create Thread',
                        appearance: Appearance.primary,
                        onPressed: () {
                          context.push(threadEditorPage);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
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
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class GuestBookWidgetController extends State<PersonalProfileGuestBookWidget> {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, GuestBookModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  late GuestbookCubit guestbookCubit;


  @override
  void initState() {
    guestbookCubit = context.read<GuestbookCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchGuestBookFeeds(pageKey: pageKey, userName: widget.userModel.username!);
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


  Future<dartz.Either<String, List<GuestBookModel>>> fetchGuestBookFeeds({required int pageKey, required String userName}) async {
    return await guestbookCubit.fetchGuestBook(userName: userName, pageKey: pageKey);
  }


  @override
  Widget build(BuildContext context) => GuestBookWidgetView(this);

}