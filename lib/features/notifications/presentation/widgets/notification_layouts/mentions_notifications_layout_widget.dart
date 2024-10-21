import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_enums.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_mention_cubit.dart';
import 'package:showwcase_v3/features/notifications/data/bloc/notification_state.dart';
import 'package:showwcase_v3/features/notifications/data/models/notification_model.dart';
import 'package:showwcase_v3/features/notifications/presentation/widgets/notification_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_shared_refresh_indicator.dart';




class MentionsNotificationsLayoutWidget extends StatefulWidget {

  final NotificationCategory category;
  final List<String> type;
  final ScrollController scrollController;
  const MentionsNotificationsLayoutWidget({
    required this.category,
    required this.type,
    required this.scrollController,
    Key? key}) : super(key: key);

  @override
  State<MentionsNotificationsLayoutWidget> createState() => _NotificationsLayoutWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _NotificationsLayoutWidgetView extends WidgetView<MentionsNotificationsLayoutWidget, _NotificationsLayoutWidgetController> {

  const _NotificationsLayoutWidgetView(_NotificationsLayoutWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomSharedRefreshIndicator(
      onRefresh: () async{
        final response = await state.fetchMentionNotifications(0);
        if(response.isLeft()){
          return;
        }
        final notifications = response.asRight();
        state.pagingController.value = PagingState(
            nextPageKey: 1,
            itemList: notifications
        );
      },
      child: PagedListView<int, NotificationModel>.separated(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        pagingController: state.pagingController,
        builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
          itemBuilder: (context, item, index) {
            bool showBackgroundColor = (AppStorage.currentUserSession?.lastNotificationRead != null && AppStorage.currentUserSession!.lastNotificationRead!.isBefore(item.createdAt!));
            return Container(
              color: showBackgroundColor ? const Color(0xFF4595D0).withOpacity(0.18) : (theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite) ,
              padding: const EdgeInsets.symmetric(horizontal: showSymmetricPadding, vertical: 20),
              child: BlocSelector<NotificationMentionsCubit, NotificationState, NotificationModel>(
                selector: (state) {
                  return state.notifications.firstWhere((element) => element.id == item.id);
                },
                builder: (context, notification) {
                  return NotificationItemWidget(notificationResponse: notification,);
                },
              )
              ,
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

class _NotificationsLayoutWidgetController extends State<MentionsNotificationsLayoutWidget> with AutomaticKeepAliveClientMixin<MentionsNotificationsLayoutWidget> {

  late NotificationMentionsCubit _notificationCubit;
  final PagingController<int, NotificationModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);

  @override
  initState(){
    super.initState();
    _notificationCubit = context.read<NotificationMentionsCubit>();
    pagingController.addPageRequestListener((pageKey) async {
      final response = await fetchMentionNotifications(pageKey);
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
    // _listenForPushNotifications();

    // push notification received
    OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
      final response = await _notificationCubit.fetchMentionNotifications(0);
      if(response.isLeft()){
        return;
      }
      final notifications = response.asRight();
      pagingController.value = PagingState(
          nextPageKey: 1,
          itemList: notifications
      );
    });

  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _NotificationsLayoutWidgetView(this);
  }
  Future<dartz.Either<String, List<NotificationModel>>> fetchMentionNotifications(int pageKey) async {
    return await _notificationCubit.fetchMentionNotifications(pageKey);
  }

  @override
  bool get wantKeepAlive => true;
  
}