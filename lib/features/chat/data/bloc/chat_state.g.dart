// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatStateCWProxy {
  ChatState status(ChatStatus status);

  ChatState message(String message);

  ChatState filteredUsers(List<UserModel> filteredUsers);

  ChatState suggestedUsers(List<UserModel> suggestedUsers);

  ChatState connectedRecipients(List<ChatConnectionModel> connectedRecipients);

  ChatState pendingConnections(
      List<IncomingConnectionModel> pendingConnections);

  ChatState rejectedConnections(
      List<IncomingConnectionModel> rejectedConnections);

  ChatState hasConnectedRecipientsReachMax(bool hasConnectedRecipientsReachMax);

  ChatState hasPendingConnectionsReachMax(bool hasPendingConnectionsReachMax);

  ChatState hasRejectedConnectionsReachMax(bool hasRejectedConnectionsReachMax);

  ChatState chats(Map<DateTime, List<List<ChatMessageModel>>> chats);

  ChatState rawChatList(List<ChatMessageModel> rawChatList);

  ChatState selectedRecipient(ChatConnectionModel? selectedRecipient);

  ChatState notificationTotals(ChatNotificationsTotalModel notificationTotals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatState call({
    ChatStatus? status,
    String? message,
    List<UserModel>? filteredUsers,
    List<UserModel>? suggestedUsers,
    List<ChatConnectionModel>? connectedRecipients,
    List<IncomingConnectionModel>? pendingConnections,
    List<IncomingConnectionModel>? rejectedConnections,
    bool? hasConnectedRecipientsReachMax,
    bool? hasPendingConnectionsReachMax,
    bool? hasRejectedConnectionsReachMax,
    Map<DateTime, List<List<ChatMessageModel>>>? chats,
    List<ChatMessageModel>? rawChatList,
    ChatConnectionModel? selectedRecipient,
    ChatNotificationsTotalModel? notificationTotals,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatState.copyWith.fieldName(...)`
class _$ChatStateCWProxyImpl implements _$ChatStateCWProxy {
  const _$ChatStateCWProxyImpl(this._value);

  final ChatState _value;

  @override
  ChatState status(ChatStatus status) => this(status: status);

  @override
  ChatState message(String message) => this(message: message);

  @override
  ChatState filteredUsers(List<UserModel> filteredUsers) =>
      this(filteredUsers: filteredUsers);

  @override
  ChatState suggestedUsers(List<UserModel> suggestedUsers) =>
      this(suggestedUsers: suggestedUsers);

  @override
  ChatState connectedRecipients(
          List<ChatConnectionModel> connectedRecipients) =>
      this(connectedRecipients: connectedRecipients);

  @override
  ChatState pendingConnections(
          List<IncomingConnectionModel> pendingConnections) =>
      this(pendingConnections: pendingConnections);

  @override
  ChatState rejectedConnections(
          List<IncomingConnectionModel> rejectedConnections) =>
      this(rejectedConnections: rejectedConnections);

  @override
  ChatState hasConnectedRecipientsReachMax(
          bool hasConnectedRecipientsReachMax) =>
      this(hasConnectedRecipientsReachMax: hasConnectedRecipientsReachMax);

  @override
  ChatState hasPendingConnectionsReachMax(bool hasPendingConnectionsReachMax) =>
      this(hasPendingConnectionsReachMax: hasPendingConnectionsReachMax);

  @override
  ChatState hasRejectedConnectionsReachMax(
          bool hasRejectedConnectionsReachMax) =>
      this(hasRejectedConnectionsReachMax: hasRejectedConnectionsReachMax);

  @override
  ChatState chats(Map<DateTime, List<List<ChatMessageModel>>> chats) =>
      this(chats: chats);

  @override
  ChatState rawChatList(List<ChatMessageModel> rawChatList) =>
      this(rawChatList: rawChatList);

  @override
  ChatState selectedRecipient(ChatConnectionModel? selectedRecipient) =>
      this(selectedRecipient: selectedRecipient);

  @override
  ChatState notificationTotals(
          ChatNotificationsTotalModel notificationTotals) =>
      this(notificationTotals: notificationTotals);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? filteredUsers = const $CopyWithPlaceholder(),
    Object? suggestedUsers = const $CopyWithPlaceholder(),
    Object? connectedRecipients = const $CopyWithPlaceholder(),
    Object? pendingConnections = const $CopyWithPlaceholder(),
    Object? rejectedConnections = const $CopyWithPlaceholder(),
    Object? hasConnectedRecipientsReachMax = const $CopyWithPlaceholder(),
    Object? hasPendingConnectionsReachMax = const $CopyWithPlaceholder(),
    Object? hasRejectedConnectionsReachMax = const $CopyWithPlaceholder(),
    Object? chats = const $CopyWithPlaceholder(),
    Object? rawChatList = const $CopyWithPlaceholder(),
    Object? selectedRecipient = const $CopyWithPlaceholder(),
    Object? notificationTotals = const $CopyWithPlaceholder(),
  }) {
    return ChatState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ChatStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      filteredUsers:
          filteredUsers == const $CopyWithPlaceholder() || filteredUsers == null
              ? _value.filteredUsers
              // ignore: cast_nullable_to_non_nullable
              : filteredUsers as List<UserModel>,
      suggestedUsers: suggestedUsers == const $CopyWithPlaceholder() ||
              suggestedUsers == null
          ? _value.suggestedUsers
          // ignore: cast_nullable_to_non_nullable
          : suggestedUsers as List<UserModel>,
      connectedRecipients:
          connectedRecipients == const $CopyWithPlaceholder() ||
                  connectedRecipients == null
              ? _value.connectedRecipients
              // ignore: cast_nullable_to_non_nullable
              : connectedRecipients as List<ChatConnectionModel>,
      pendingConnections: pendingConnections == const $CopyWithPlaceholder() ||
              pendingConnections == null
          ? _value.pendingConnections
          // ignore: cast_nullable_to_non_nullable
          : pendingConnections as List<IncomingConnectionModel>,
      rejectedConnections:
          rejectedConnections == const $CopyWithPlaceholder() ||
                  rejectedConnections == null
              ? _value.rejectedConnections
              // ignore: cast_nullable_to_non_nullable
              : rejectedConnections as List<IncomingConnectionModel>,
      hasConnectedRecipientsReachMax:
          hasConnectedRecipientsReachMax == const $CopyWithPlaceholder() ||
                  hasConnectedRecipientsReachMax == null
              ? _value.hasConnectedRecipientsReachMax
              // ignore: cast_nullable_to_non_nullable
              : hasConnectedRecipientsReachMax as bool,
      hasPendingConnectionsReachMax:
          hasPendingConnectionsReachMax == const $CopyWithPlaceholder() ||
                  hasPendingConnectionsReachMax == null
              ? _value.hasPendingConnectionsReachMax
              // ignore: cast_nullable_to_non_nullable
              : hasPendingConnectionsReachMax as bool,
      hasRejectedConnectionsReachMax:
          hasRejectedConnectionsReachMax == const $CopyWithPlaceholder() ||
                  hasRejectedConnectionsReachMax == null
              ? _value.hasRejectedConnectionsReachMax
              // ignore: cast_nullable_to_non_nullable
              : hasRejectedConnectionsReachMax as bool,
      chats: chats == const $CopyWithPlaceholder() || chats == null
          ? _value.chats
          // ignore: cast_nullable_to_non_nullable
          : chats as Map<DateTime, List<List<ChatMessageModel>>>,
      rawChatList:
          rawChatList == const $CopyWithPlaceholder() || rawChatList == null
              ? _value.rawChatList
              // ignore: cast_nullable_to_non_nullable
              : rawChatList as List<ChatMessageModel>,
      selectedRecipient: selectedRecipient == const $CopyWithPlaceholder()
          ? _value.selectedRecipient
          // ignore: cast_nullable_to_non_nullable
          : selectedRecipient as ChatConnectionModel?,
      notificationTotals: notificationTotals == const $CopyWithPlaceholder() ||
              notificationTotals == null
          ? _value.notificationTotals
          // ignore: cast_nullable_to_non_nullable
          : notificationTotals as ChatNotificationsTotalModel,
    );
  }
}

extension $ChatStateCopyWith on ChatState {
  /// Returns a callable class that can be used as follows: `instanceOfChatState.copyWith(...)` or like so:`instanceOfChatState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatStateCWProxy get copyWith => _$ChatStateCWProxyImpl(this);
}
