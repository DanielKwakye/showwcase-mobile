import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_status.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_connection_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_message_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_notifications_totals_model.dart';
import 'package:showwcase_v3/features/chat/data/models/incoming_connection_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'chat_state.g.dart';

@CopyWith()
class ChatState extends Equatable {

  final ChatStatus status;
  final String message;
  final List<UserModel> filteredUsers;
  final List<UserModel> suggestedUsers;
  final bool hasConnectedRecipientsReachMax;
  final bool hasPendingConnectionsReachMax;
  final bool hasRejectedConnectionsReachMax;
  final List<ChatConnectionModel> connectedRecipients;
  final List<IncomingConnectionModel> pendingConnections;
  final List<IncomingConnectionModel> rejectedConnections;
  final Map<DateTime, List<List<ChatMessageModel>>> chats;
  final List<ChatMessageModel> rawChatList;
  final ChatConnectionModel? selectedRecipient;
  final ChatNotificationsTotalModel notificationTotals;

  const ChatState({
    this.status = ChatStatus.initial,
    this.message = '',
    this.filteredUsers = const [],
    this.suggestedUsers = const [],
    this.connectedRecipients = const [],
    this.pendingConnections = const [],
    this.rejectedConnections = const [],
    this.hasConnectedRecipientsReachMax = false,
    this.hasPendingConnectionsReachMax = false,
    this.hasRejectedConnectionsReachMax = false,
    this.chats = const {},
    this.rawChatList = const [],
    this.selectedRecipient,
    this.notificationTotals = const ChatNotificationsTotalModel(),
  });

  @override
  List<Object?> get props => [status, notificationTotals];

}