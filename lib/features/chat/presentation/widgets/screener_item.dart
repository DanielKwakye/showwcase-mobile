import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_state.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_status.dart';
import 'package:showwcase_v3/features/chat/data/models/incoming_connection_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

class ScreenerItem extends StatefulWidget {
  final IncomingConnectionModel incomingConnectionModel;
  final bool showRejectButton;

  const ScreenerItem({
    super.key,
    required this.incomingConnectionModel,
    this.showRejectButton = true
  });

  @override
  State<ScreenerItem> createState() => _ScreenerItemState();
}

class _ScreenerItemState extends State<ScreenerItem> {
  late ChatCubit _chatCubit;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  @override
  void initState() {
    _chatCubit = context.read<ChatCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ChatCubit, ChatState>(
      bloc: _chatCubit,
      listener: (context, state) {
        if(state.status == ChatStatus.acceptPendingConnectionInProgress){
          _isLoading.value = true ;
        }
        if(state.status == ChatStatus.acceptPendingConnectionFailed){
          _isLoading.value = false ;
        }
        if(state.status == ChatStatus.acceptPendingConnectionSuccessful){
          _isLoading.value = false ;

          // after accepting connection, You wouldn't be able to immediately chat the user cus
          // IncomingConnectionModel is different from the ChatConnectionModel. The ids are different per backend implementation
          // The message page only accepts ChatConnectionModel not the IncomingConnectionModel
          // So the cubit automatically calls requestConnection to receive ChatConnectionModel. Hence you can
          // only navigate to message after the cubit emits requestConnectionWithRecipientSuccessful
          // as implemented below

        }

        //! The code below works fine, but I don't think we have to open the MessagesPage after
        // every user we accept.

        // if(state.status == ChatEvent.requestConnectionWithRecipientSuccessful) {
        //   if(state.selectedRecipient != null) {
        //     final userAsNetworkResponse = state.selectedRecipient!.users?.firstWhere((e) => e.username != AppStorage.currentUserSession!.username);
        //      if(userAsNetworkResponse != null) {
        //        Navigator.push(
        //            context,
        //            MaterialPageRoute(
        //                builder: (context) => MessagesPage(networkResponse: userAsNetworkResponse, connection: state.selectedRecipient!,)));
        //      }
        //
        //   }
        // }

        if(state.status == ChatStatus.rejectPendingConnectionInProgress){
          _isLoading.value = true ;
        }
        if(state.status == ChatStatus.rejectPendingConnectionSuccessful){
          _isLoading.value = false ;
        }
        if(state.status == ChatStatus.rejectPendingConnectionFailed){
          _isLoading.value = false ;
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserProfileIconWidget(
            user: widget.incomingConnectionModel.user!,
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
                  Text(
                    widget.incomingConnectionModel.user!.displayName!,
                    style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontSize: defaultFontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  const CustomDotWidget(),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    getFormattedDateWithIntl(
                        widget.incomingConnectionModel.createdAt!,
                        format: 'MMMd'),
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
              Text(
                widget.incomingConnectionModel.message!.text!,
                maxLines: 2,
                style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: defaultFontSize - 3,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )),
          ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (BuildContext context, bool value, Widget? child) {
              return value ? const CircularProgressIndicator.adaptive(backgroundColor: kAppBlue,strokeWidth: 2,) : Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _chatCubit.acceptPendingConnection(
                          chatId: widget.incomingConnectionModel.chatId!,
                          userId: widget.incomingConnectionModel.user!.userId!);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kAppGreen.withOpacity(0.2)),
                      child: const Icon(Icons.check, size: 15, color: kAppGreen),
                    ),
                  ),
                  if(widget.showRejectButton) ... {
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _chatCubit.rejectPendingConnection(
                            chatId: widget.incomingConnectionModel.chatId!);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: kAppRed.withOpacity(0.2)),
                        child: const Icon(Icons.clear, size: 15, color: kAppRed),
                      ),
                    ),
                  }
                ],
              ) ;
            },
          )
        ],
      ),
    );
  }
}
