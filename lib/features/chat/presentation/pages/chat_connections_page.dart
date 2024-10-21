import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/inner_drawer.dart';
import 'package:showwcase_v3/core/utils/sliver_pinned_box_adapter.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_state.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_status.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_connection_model.dart';
import 'package:showwcase_v3/features/chat/presentation/pages/message_screener.dart';
import 'package:showwcase_v3/features/chat/presentation/pages/new_message.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/chat_connection_item_widget.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_enums.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_state.dart';
import 'package:showwcase_v3/features/home/presentation/pages/ios_drawer_style_wrapper.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';


class ChatConnectionsPage extends StatefulWidget {
  const ChatConnectionsPage({Key? key}) : super(key: key);

  @override
  State<ChatConnectionsPage> createState() => _ChatConnectionsPageState();
}

class _ChatConnectionsPageState extends State<ChatConnectionsPage> {

  late ChatCubit _chatCubit;
  late StreamSubscription<ChatState> chatStateStreamSubscription;
  late ScrollController _scrollController;
  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, ChatConnectionModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: defaultPageSize);
  final drawerKey = GlobalKey<InnerDrawerState>();
  late HomeCubit homeCubit;
  late StreamSubscription<HomeState> homeStateStreamStreamSubscription;

  @override
  void initState() {
    _scrollController = ScrollController();
    _chatCubit = context.read<ChatCubit>();
    chatStateStreamSubscription = _chatCubit.stream.listen(chatStreamSubscriptionListener);
    homeCubit = context.read<HomeCubit>();
    // get data from cache
    final recipients = _chatCubit.getConnectedRecipientsFromCache();
    if(recipients.isNotEmpty) {
      pagingController.itemList = recipients;
    }

    // get data from server
    pagingController.addPageRequestListener((pageKey) async {

      final response = await fetchChatConnections(pageKey);
      if(response.isLeft()){
        pagingController.error = response.asLeft();
        return;
      }
      final newItems = response.asRight();
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {

        if(pageKey == 0) {
          pagingController.value = PagingState(nextPageKey: 1, itemList: newItems);
        }else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }


      }

    });

    OneSignal.Notifications.addClickListener((event) async {
      debugPrint('customLog -> Onesignal in chat connections: $event');
    });

    // final response = await fetchChatConnections(pageKey);
    // if(response.isLeft()){
    //   pagingController.error = response.asLeft();
    //   return;
    // }

    /// Listen to home scaffold interactions
    homeStateStreamStreamSubscription = homeCubit.stream.listen((event) {

      if(event.status == HomeStatus.onActiveIndexTappedCompleted){
        if(_scrollController.hasClients && (event.data as int) == 4){
          _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 375), curve: Curves.linear);
        }
      }

    });

    super.initState();
  }

  Future<dartz.Either<String, List<ChatConnectionModel>>>  fetchChatConnections(int pageKey) async {
    return _chatCubit.fetchConnectedRecipients(pageKey: pageKey);
  }

  void chatStreamSubscriptionListener(ChatState event) {

    // Rebuild UI there's a new list new list with the conditions below
    if(
        event.status == ChatStatus.refreshChatMessagesSuccessful ||
        event.status == ChatStatus.requestConnectionWithRecipientSuccessful ||
        event.status == ChatStatus.updateConnectedRecipientsSuccessful ||
        event.status == ChatStatus.updatingTotalUnreadMessagesOnASelectedChatSuccessful){

      /// build ui
      pagingController.itemList = event.connectedRecipients;
    }

    // update cache anytime data changes on the conditions below
    if( event.status == ChatStatus.refreshChatMessagesSuccessful ||
        event.status == ChatStatus.requestConnectionWithRecipientSuccessful ||
        event.status == ChatStatus.updateConnectedRecipientsSuccessful ||
        event.status == ChatStatus.updatingTotalUnreadMessagesOnASelectedChatSuccessful) {

              /// update the cache anytime the UI receives new list
      _chatCubit.updateConnectedRecipientCache(event.connectedRecipients);

    }


  }

  
  @override
  void dispose() {
    chatStateStreamSubscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IOSDrawerStyleWrapper(
      drawerKey: drawerKey,
      page: Scaffold(
        body: ExtendedNestedScrollView(
          floatHeaderSlivers: true,
          controller: _scrollController,
          onlyOneScrollInBody: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [

              /// App bar section
              ChatAppBarWidget(onProfileTapped: () {
                drawerKey.currentState?.open();
              }, pinned: false,),

              /// Screener section ------------
              SliverPinnedBoxAdapter(
                widget: BlocSelector<ChatCubit, ChatState,int>(
                  bloc: _chatCubit,
                  selector:(state){
                    return state.notificationTotals.totalPendingRequests;
                  } ,
                  builder: (context,int  totalPendingRequests) {
                    return ColoredBox(
                      color: theme.colorScheme.background,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomBorderWidget(),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MessageScreener()));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: theme.colorScheme.surface,
                                          borderRadius: BorderRadius.circular(4)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset('assets/svg/mail.svg',
                                              height: 17),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Screener',
                                            style: TextStyle(
                                                color:
                                                    theme.colorScheme.onPrimary,
                                                fontSize: defaultFontSize,
                                                fontWeight: FontWeight.w700),
                                          ),

                                          //! Screener badge here -----
                                          if(totalPendingRequests > 0) ... {
                                            Container(

                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.circular(100)),
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.only(left: 10),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                                                child: FittedBox(
                                                  child: Text(
                                                    '$totalPendingRequests',
                                                    style: const TextStyle(color: kAppWhite),
                                                  ),
                                                ),
                                              ),
                                            )
                                          }

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NewMessage()));
                                    },
                                    child: SvgPicture.asset(
                                        'assets/svg/write.svg',
                                        height: 25,
                      colorFilter: const ColorFilter.mode(kAppBlue, BlendMode.srcIn),
                                        color: kAppBlue)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const CustomBorderWidget(),
                        ],
                      ),
                    );
                  },
                ),
              )

            ];
          },
          /// connected recipients ------------------------------------
          body: PagedListView<int, ChatConnectionModel>.separated(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 2 * kToolbarHeight),
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<ChatConnectionModel>(
            itemBuilder: (context, item, index) {
              return ChatConnectionItemWidget(connectionModel: item, key: ValueKey(item.id),);
            },
            firstPageProgressIndicatorBuilder: (_) => const Center(
              child: CustomAdaptiveCircularIndicator(),
            ),
            newPageProgressIndicatorBuilder: (_) => const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                  height: 100,
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CustomAdaptiveCircularIndicator(),
                  ),
                )),
            noItemsFoundIndicatorBuilder: (_) => const CustomEmptyContentWidget(),
            noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
            firstPageErrorIndicatorBuilder: (_) => const CustomNoConnectionWidget(
              title: "Restore connection and swipe to refresh ...",
            ),
            newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
          ),
          separatorBuilder: (context, index) => const SizedBox(
              height: 20,
            ),
        ),
      )
          // BlocConsumer<ChatCubit, ChatState>(
          //   bloc: _chatCubit,
          //   listener: (context, state) {
          //     if(state.status == ChatStatus.refreshChatMessagesSuccessful ||
          //         state.status == ChatStatus.requestConnectionWithRecipientSuccessful ||
          //         state.status == ChatStatus.updateConnectedRecipientsSuccessful ||
          //         state.status == ChatStatus.updatingTotalUnreadMessagesOnASelectedChatSuccessful) {
          //
          //       // update the cache anytime the UI receives new list
          //       _chatCubit.updateConnectedRecipientCache(state.connectedRecipients);
          //
          //     }
          //   },
          //   buildWhen: (_, next) {
          //     return next.status == ChatStatus.fetchConnectedRecipientsSuccessful ||
          //         next.status == ChatStatus.fetchConnectedRecipientsFailed ||
          //         next.status == ChatStatus.refreshChatMessagesSuccessful ||
          //         next.status == ChatStatus.requestConnectionWithRecipientSuccessful ||
          //         next.status == ChatStatus.updateConnectedRecipientsSuccessful ||
          //         next.status == ChatStatus.updatingTotalUnreadMessagesOnASelectedChatSuccessful;
          //   },
          //   builder: (context, state) {
          //     if (state.status ==
          //             ChatStatus.fetchConnectedRecipientsSuccessful ||
          //         state.status == ChatStatus.refreshChatMessagesSuccessful ||
          //         state.status == ChatStatus.requestConnectionWithRecipientSuccessful ||
          //         state.status == ChatStatus.updateConnectedRecipientsSuccessful ||
          //         state.status == ChatStatus.updatingTotalUnreadMessagesOnASelectedChatSuccessful
          //     ) {
          //       return ListView.separated(
          //         itemCount: state.connectedRecipients.length,
          //         // physics: const NeverScrollableScrollPhysics(),
          //         padding: const EdgeInsets.all(20),
          //         itemBuilder: (BuildContext context, int index) {
          //           String? message = parseHtmlString(state.connectedRecipients[index].lastMessage?.text ?? '');
          //
          //           UserModel? networkResponse = state
          //               .connectedRecipients[index].users
          //               ?.firstWhere((e) =>
          //                   e.username !=
          //                   AppStorage.currentUserSession!.username);
          //           return GestureDetector(
          //             behavior: HitTestBehavior.translucent,
          //             onTap: () {
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => MessagesPage(
          //                             networkResponse: networkResponse,
          //                             connection:
          //                                 state.connectedRecipients[index],
          //                           )));
          //             },
          //             child: Row(
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 UserProfileIconWidget(
          //                   user: networkResponse!,
          //                   dimension: '100x',
          //                   size: 40,
          //                 ),
          //                 const SizedBox(
          //                   width: 10,
          //                 ),
          //                 Expanded(
          //                     child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       children: [
          //                         Flexible(child: Text(
          //                           networkResponse.displayName ?? 'N/A',
          //                           maxLines: 1,
          //                           overflow: TextOverflow.ellipsis,
          //                           style: TextStyle(
          //                               color: theme.colorScheme.onBackground,
          //                               fontSize: defaultFontSize,
          //                               fontWeight: FontWeight.bold),
          //                         )),
          //                         const SizedBox(
          //                           width: 5,
          //                         ),
          //                         if (state.connectedRecipients[index]
          //                                 .lastMessage?.createdAt !=
          //                             null)
          //                           const CustomDotWidget(),
          //                         if (state.connectedRecipients[index]
          //                                 .lastMessage?.createdAt !=
          //                             null)
          //                           const SizedBox(
          //                             width: 5,
          //                           ),
          //                         Text(
          //                           state.connectedRecipients[index].lastMessage
          //                                       ?.createdAt !=
          //                                   null
          //                               ? getTimeAgo(state
          //                                   .connectedRecipients[index]
          //                                   .lastMessage!
          //                                   .createdAt!)
          //                               : '',
          //                           style: TextStyle(
          //                               color: theme.colorScheme.onPrimary,
          //                               fontSize: defaultFontSize - 4,
          //                               fontWeight: FontWeight.bold),
          //                         ),
          //                       ],
          //                     ),
          //                     const SizedBox(
          //                       height: 3,
          //                     ),
          //                     if (state
          //                             .connectedRecipients[index].lastMessage !=
          //                         null) ...{
          //                           Text(
          //                           state.connectedRecipients[index].lastMessage
          //                               ?.userId ==
          //                           AppStorage
          //                               .currentUserSession!.id
          //                           ? 'You: ${!message.isNullOrEmpty() ? message : ((state.connectedRecipients[index].lastMessage?.attachments ?? []).isNotEmpty ? 'image' : '')}'
          //                               : '${networkResponse.displayName}:  ${!message.isNullOrEmpty() ? message : ((state.connectedRecipients[index].lastMessage?.attachments ?? []).isNotEmpty ? 'image' : '')}',
          //                           maxLines: 2,
          //                           overflow: TextOverflow.ellipsis,
          //                           style: TextStyle(
          //                           color: theme.colorScheme.onPrimary,
          //                           fontSize: defaultFontSize - 3,
          //                           fontWeight: FontWeight.w500),
          //                           )
          //                           },
          //
          //                   ],
          //                 )),
          //                 if ((state.connectedRecipients[index].totalUnreadMessages ?? 0) > 0)
          //                   Container(
          //                       decoration: BoxDecoration(
          //                           color: kAppBlue,
          //                           borderRadius: BorderRadius.circular(100)),
          //                       height: 20,
          //                       width: 20,
          //                       margin: const EdgeInsets.only(left: 10),
          //                       child: Padding(
          //                         padding: const EdgeInsets.symmetric(
          //                             vertical: 2.0, horizontal: 2.0),
          //                         child: FittedBox(
          //                           child: Text(
          //                             '${state.connectedRecipients[index].totalUnreadMessages}',
          //                             style: const TextStyle(color: kAppWhite),
          //                           ),
          //                         ),
          //                       ))
          //                 // Container(
          //                   //   padding: const EdgeInsets.symmetric(
          //                   //       horizontal: 5, vertical: 5),
          //                   //   decoration: const BoxDecoration(
          //                   //       color: kAppBlue,
          //                   //       borderRadius:
          //                   //           BorderRadius.all(Radius.circular(40))),
          //                   //   child: Text(
          //                   //       state.connectedRecipients[index]
          //                   //           .totalUnreadMessages
          //                   //           .toString(),
          //                   //       style: const TextStyle(
          //                   //           color: Colors.white,
          //                   //           fontSize: 12,
          //                   //           fontWeight: FontWeight.w600)),
          //                   // )
          //               ],
          //             ),
          //           );
          //         },
          //         separatorBuilder: (BuildContext context, int index) {
          //           return const SizedBox(
          //             height: 20,
          //           );
          //         },
          //       );
          //     }
          //     if (state.status ==
          //         ChatStatus.fetchConnectedRecipientsInProgress) {
          //       return const ChatShimmer();
          //     }
          //     if (state.status == ChatStatus.fetchConnectedRecipientsFailed) {
          //       return CustomNoConnectionWidget(
          //         title: state.message,
          //         showRetryButton: true,
          //         onRetry: () {
          //           _chatCubit.fetchConnectedRecipients(replaceFirstPage: true);
          //         },
          //       );
          //     }
          //     return const SizedBox.shrink();
          //   },
          //
          // )),
      ),
    );
  }
}
