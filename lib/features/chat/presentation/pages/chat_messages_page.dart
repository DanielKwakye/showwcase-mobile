import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_state.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_status.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_connection_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_message_model.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/send_message.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_any_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_images_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';
import 'package:url_launcher/url_launcher.dart';


class ChatMessagesPage extends StatefulWidget {
  final UserModel user;
  final ChatConnectionModel connection;

  const ChatMessagesPage(
      {Key? key, required this.user, required this.connection})
      : super(key: key);

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> with LaunchExternalAppMixin {
  late ChatCubit _chatCubit;
  int counter = 0;
  int lengthCounter = 0;

  @override
  void initState() {
    _chatCubit = context.read<ChatCubit>();
    _chatCubit.setActiveChat(connection: widget.connection);

    // surrounding with null checker cus for some reasons, the connection.id is null after accepting a pending request
    if(widget.connection.id != null) {
      _chatCubit.markChatMessagesAsRead(connectionId: widget.connection.id!);
    }

    // replace list of messages with data from sercer
    _chatCubit.fetchChatMessages(connection: widget.connection);

    // get chat data from cached
    _chatCubit.fetchChatMessagesFromCache(connection: widget.connection);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _chatCubit.setActiveChat(connection: null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: theme.colorScheme.background,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileIconWidget(
                user: widget.user,
                dimension: '100x',
                size: 35,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.displayName ?? 'N/A',
                        style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      Text('@${widget.user.username}',
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: defaultFontSize - 3,
                              fontWeight: FontWeight.w500))
                    ],
                  ))
            ],
          ),
          iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1), child: CustomBorderWidget()),
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: BlocBuilder<ChatCubit, ChatState>(
          buildWhen: (previousState, currentState) {
            return currentState.status == ChatStatus.refreshChatMessagesSuccessful;
          },
          // listener: (context, state) {
          //   if(state.status == ChatStatus.refreshChatMessagesSuccessful) {
          //     if(widget.connection.id != null) {
          //
          //     }
          //   }
          // },
          builder: (context, state) {
            if (state.status == ChatStatus.refreshChatMessagesSuccessful) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.chats.keys.length,
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      reverse: true,
                      itemBuilder: (context, index) {
                        DateTime date = state.chats.keys.elementAt(index);
                        List<List<ChatMessageModel>> dateGroupedModels = state.chats[date]!;
                        return Column(
                          key: ValueKey(date),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Days here  --------
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                      color: theme.colorScheme.surface),
                                  child: Text(
                                    getFormattedDateWithIntl(date,
                                        format: 'MMMM dd, yyyy'),
                                    style: TextStyle(
                                        color: theme.colorScheme.onBackground,
                                        fontSize: defaultFontSize - 3),
                                  )),
                            ),
                            SeparatedColumn(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20,),
                              children: [

                                ...dateGroupedModels.map((group) {
                                  ChatMessageModel firstModel = group.first;

                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      /// Profile image of user
                                      Row(
                                        children: [
                                          UserProfileIconWidget(
                                            user: firstModel.user!,
                                            dimension: '100x',
                                            size: 40,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            /// User meta data here --------
                                            Row(
                                              children: [
                                                Text(
                                                  firstModel.user!.displayName ?? 'N/A',
                                                  style: TextStyle(
                                                      color:
                                                      theme.colorScheme.onBackground,
                                                      fontSize: defaultFontSize,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                if (firstModel.createdAt != null)
                                                  const CustomDotWidget(),
                                                if (firstModel.createdAt != null)
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                Text(
                                                  firstModel.createdAt != null
                                                      ? getTimeAgo(
                                                      firstModel.createdAt!)
                                                      : '',
                                                  style: TextStyle(
                                                      color: theme.colorScheme.onPrimary,
                                                      fontSize: defaultFontSize - 4,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 7,),

                                            SeparatedColumn(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,),
                                              children: [

                                                /// each ChatMessageModel under each user here ----
                                                ...group.map((ChatMessageModel model) {
                                                  if(model == state.rawChatList.last) {
                                                    debugPrint("last chat: $model");
                                                  }
                                                  return SeparatedColumn(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    key: ValueKey("${model.createdAt!}${model.id}"),
                                                    // mainAxisSize: MainAxisSize.min,
                                                    //  crossAxisAlignment: CrossAxisAlignment.start,
                                                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,),
                                                    children: [
                                                      if (model.text != null && model.text != "") ... {
                                                        SelectableAutoLinkText(
                                                          parseHtmlString(model.text!)!,
                                                          style: TextStyle(
                                                              color: theme.colorScheme.onBackground,
                                                              fontSize: defaultFontSize,
                                                              fontWeight: FontWeight.w500),
                                                          linkStyle: const TextStyle(color: kAppBlue),
                                                          highlightedLinkStyle: const TextStyle(
                                                            color: Colors.purpleAccent,
                                                          ),
                                                          linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.defaultLinkRegExpPattern})',
                                                          // onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
                                                          // enableInteractiveSelection: false,
                                                          onTap: (url) async {
                                                            if (url.startsWith('@')) {
                                                              // Navigator.push(
                                                              //   context,
                                                              //   MaterialPageRoute(
                                                              //     builder: (context) => ProfilePage(
                                                              //       username: url.substring(1),
                                                              //     ),
                                                              //   ),
                                                              // );
                                                              return;
                                                            }

                                                            if (isContainingAnyLink(model.text)) {
                                                              await launchBrowser(url, context);
                                                              return;
                                                            }

                                                            if (isPhoneNumber(model.text)) {
                                                              makePhoneCall(model.text!);
                                                              return;
                                                            }

                                                            if (isEmail(model.text)) {
                                                              openEmail(model.text!);
                                                              return;
                                                            }

                                                            if (await canLaunchUrl(Uri.parse(url))) {
                                                              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                                            }

                                                          },
                                                          onLongPress: (url) {
                                                            copyTextToClipBoard(context, url);
                                                          },
                                                          onTapOther: (a,b) {
                                                          },
                                                          onLongPressOther: (a, b) {},
                                                        ),
                                                        if(isContainingAnyLink(model.text)) CustomAnyLinkPreviewWidget(message:model.text!,topPadding: 0,)
                                                      },
                                                      if (model.attachments != null && model.attachments!.isNotEmpty && checksEqual(model.attachments![0].type!, 'image')) ...{
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: CustomImagesWidget(
                                                            images: [model.attachments![0].value!],
                                                            heroTag: model.attachments![0].value!,
                                                            onTap: (index, images) {
                                                              context.push(context.generateRoutePath(subLocation: chatImagesPreviewPage), extra: {
                                                                'chat': model,
                                                                'galleryItems': images,
                                                                'initialPageIndex': index
                                                              });
                                                            },
                                                          ),
                                                        )
                                                      }

                                                    ],
                                                  );
                                                }).toList(),
                                              ],
                                            )

                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }).toList(),

                              ],
                            ),
                          ],
                        );
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                  SendMessage(
                      networkResponse: widget.user,
                      connection: widget.connection),
                ],
              );
            }
            if (state.status == ChatStatus.fetchChatMessagesInProgress) {
              // return const Center(
              //   child: CustomAdaptiveCircularIndicator(),
              // );
            }
            if (state.status == ChatStatus.fetchChatMessagesFailed) {}
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }


}
