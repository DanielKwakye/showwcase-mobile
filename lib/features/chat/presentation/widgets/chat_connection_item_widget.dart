import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_connection_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

class ChatConnectionItemWidget extends StatelessWidget {

  final ChatConnectionModel connectionModel;
  const ChatConnectionItemWidget({Key? key, required this.connectionModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

     final theme = Theme.of(context);
     String? message = parseHtmlString(connectionModel.lastMessage?.text ?? '');

     final UserModel? user = connectionModel.users?.firstWhere((e) => e.username != AppStorage.currentUserSession!.username);

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // pushScreen(context, ChatMessagesPage(user: user, connection: connectionModel,));
          context.push(context.generateRoutePath(subLocation: chatPreviewPage), extra:  {
            'user': user,
            'connection': connectionModel
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserProfileIconWidget(
              user: user!,
              dimension: '100x',
              size: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(
                      user.displayName ?? 'N/A',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: defaultFontSize,
                          fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    if (connectionModel.lastMessage?.createdAt != null)
                      const CustomDotWidget(),
                    if (connectionModel.lastMessage?.createdAt !=
                        null)
                      const SizedBox(
                        width: 5,
                      ),
                    Text(
                      connectionModel.lastMessage
                                  ?.createdAt !=
                              null
                          ? getTimeAgo(connectionModel
                              .lastMessage!
                              .createdAt!)
                          : '',
                      style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: defaultFontSize - 4,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                if (connectionModel.lastMessage !=
                    null) ...{
                      Text(
                      connectionModel.lastMessage
                          ?.userId ==
                      AppStorage
                          .currentUserSession!.id
                      ? 'You: ${!message.isNullOrEmpty() ? message : ((connectionModel.lastMessage?.attachments ?? []).isNotEmpty ? 'image' : '')}'
                          : '${user.displayName}:  ${!message.isNullOrEmpty() ? message : ((connectionModel.lastMessage?.attachments ?? []).isNotEmpty ? 'image' : '')}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: defaultFontSize - 3,
                      fontWeight: FontWeight.w500),
                      )
                      },

              ],
            )),
            if ((connectionModel.totalUnreadMessages ?? 0) > 0)
              Container(
                  decoration: BoxDecoration(
                      color: kAppBlue,
                      borderRadius: BorderRadius.circular(100)),
                  height: 20,
                  width: 20,
                  margin: const EdgeInsets.only(left: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 2.0),
                    child: FittedBox(
                      child: Text(
                        '${connectionModel.totalUnreadMessages}',
                        style: const TextStyle(color: kAppWhite),
                      ),
                    ),
                  ))
            // Container(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: 5, vertical: 5),
              //   decoration: const BoxDecoration(
              //       color: kAppBlue,
              //       borderRadius:
              //           BorderRadius.all(Radius.circular(40))),
              //   child: Text(
              //       state.connectedRecipients[index]
              //           .totalUnreadMessages
              //           .toString(),
              //       style: const TextStyle(
              //           color: Colors.white,
              //           fontSize: 12,
              //           fontWeight: FontWeight.w600)),
              // )
          ],
        ),
      );
  }
}
