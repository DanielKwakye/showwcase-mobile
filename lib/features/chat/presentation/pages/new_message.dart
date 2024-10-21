import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_state.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_status.dart';
import 'package:showwcase_v3/features/chat/presentation/pages/chat_messages_page.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/chat_shimmer.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  late ChatCubit _chatCubit;
  final ValueNotifier<bool> _isSearchLoading = ValueNotifier<bool>(false);

  // final ValueNotifier<bool> _isInviteLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    _chatCubit = context.read<ChatCubit>();
    _chatCubit.fetchSuggestedFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: theme.colorScheme.background,
          centerTitle: true,
          title: Text(
            'New Message',
              style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700,fontSize: defaultFontSize ),
          ),
          iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, ),
              child: CupertinoSearchTextField(
                style: TextStyle(color: theme.colorScheme.onBackground),
                padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
                placeholder: 'Who would you like to send a message to ?',

                placeholderStyle:
                    TextStyle(fontSize: defaultFontSize, color: theme.colorScheme.onPrimary),
                prefixIcon: const Icon(Icons.search),
                onChanged: (String value) {
                  EasyDebounce.debounce(
                      'chat-search-debouncer',
                      // <-- An ID for this particular debouncer
                      const Duration(milliseconds: 500),
                      // <-- The debounce duration
                      () {
                    _chatCubit.searchPeopleToChat(searchText: value);
                  });
                },
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            ValueListenableBuilder(
              valueListenable: _isSearchLoading,
              builder: (BuildContext context, bool value, Widget? child) {
                return value
                    ? const LinearProgressIndicator(
                        backgroundColor: kAppBlue, minHeight: 2)
                    : const SizedBox.shrink();
              },
            ),
            BlocConsumer<ChatCubit, ChatState>(
                bloc: _chatCubit,
                buildWhen: (previousState, currentState) {
                  return currentState.status ==
                          ChatStatus.fetchSuggestedFollowersSuccessful ||
                      currentState.status == ChatStatus.searchPeopleLoaded ||
                      currentState.status ==
                         ChatStatus.searchPeopleError ||
                      currentState.status == ChatStatus.fetchSuggestedFollowersInProgress ||
                      currentState.status == ChatStatus.requestConnectionWithRecipientSuccessful ||
                      currentState.status ==
                          ChatStatus.fetchSuggestedFollowersFailed;
                },
                builder: (context, state) {
                  if (state.status ==
                          ChatStatus.fetchSuggestedFollowersSuccessful ||
                      state.status == ChatStatus.searchPeopleLoaded ||
                     state.status == ChatStatus.requestConnectionWithRecipientSuccessful
                  ) {
                    return Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          Text(
                            'Suggestions for you',
                            style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: defaultFontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ListView.separated(
                              itemCount: state.filteredUsers.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                UserModel networkResponse = state.filteredUsers[index] ;
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    _chatCubit.requestConnectionToRecipient(
                                        suggestedUserId:
                                            state.filteredUsers[index].id!);
                                  },
                                  child: Row(
                                    children: [
                                      CustomUserAvatarWidget(
                                        size: 50,
                                        username: networkResponse.username,
                                        networkImage: networkResponse.profilePictureKey ?? '',),
                                      const SizedBox(width: 10,),
                                      Expanded(child: Row(
                                         children: [
                                            Expanded(child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${networkResponse.displayName}',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: theme.colorScheme.onBackground,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14)),
                                                const SizedBox(height: 5,),
                                                Text(
                                                  '@${networkResponse.username}',
                                                  style: TextStyle(
                                                      color: theme.colorScheme.onPrimary,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )),
                                            BlocBuilder<ChatCubit, ChatState>(
                                             builder: (BuildContext context, state) {
                                               return (state.status ==
                                                   ChatStatus
                                                       .requestConnectionWithRecipientInProgress &&
                                                   state.message ==
                                                       state.filteredUsers[index]
                                                           .id!
                                                           .toString())
                                                   ? const SizedBox(
                                                   height: 20,
                                                   width: 20,
                                                   child: Center(
                                                       child:
                                                       CircularProgressIndicator
                                                           .adaptive(
                                                         backgroundColor: kAppBlue,
                                                         strokeWidth: 2,
                                                       )))
                                                   : const SizedBox.shrink();
                                             },
                                           )
                                         ],
                                      ))
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 5,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  if (state.status ==
                      ChatStatus.fetchSuggestedFollowersInProgress) {
                    return const ChatShimmer();
                  }
                  if (state.status == ChatStatus.fetchSuggestedFollowersFailed
                  || state.status == ChatStatus.searchPeopleError
                  ) {
                    return Center(
                      child: CustomNoConnectionWidget(
                        title: state.message,
                        showRetryButton: true,
                        onRetry: () {
                          _chatCubit.fetchSuggestedFollowers();
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                listener: (context, state) {
                  if (state.status == ChatStatus.searchPeopleLoading) {
                    _isSearchLoading.value = true;
                  }

                  if (state.status == ChatStatus.searchPeopleLoaded) {
                    _isSearchLoading.value = false;
                  }
                  if (state.status == ChatStatus.fetchSuggestedFollowersFailed || state.status == ChatStatus.searchPeopleError){
                    _isSearchLoading.value = false;
                  }
                  // if(state.status == ChatEvent.requestConnectionWithRecipientInProgress){
                  //   _isInviteLoading.value = true ;
                  // }
                  if (state.status == ChatStatus.requestConnectionWithRecipientSuccessful) {

                    context.push(context.generateRoutePath(subLocation: chatPreviewPage), extra:  {
                      'user': state.selectedRecipient!.users!.firstWhere((e) => checksNotEqual(e.username!,AppStorage.currentUserSession!.username!)),
                      'connection': state.selectedRecipient!
                    });
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ChatMessagesPage(
                    //               user: state
                    //                   .selectedRecipient!.users!
                    //                   .firstWhere((e) => checksNotEqual(e.username!,AppStorage.currentUserSession!.username!)),
                    //               connection: state.selectedRecipient!,
                    //             )));
                  }
                }),
          ],
        ));
  }
}
