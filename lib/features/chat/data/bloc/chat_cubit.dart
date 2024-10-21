import 'dart:async';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nanoid/nanoid.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_broadcast_repository.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_status.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_attachment_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_connection_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_message_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_notifications_totals_model.dart';
import 'package:showwcase_v3/features/chat/data/models/incoming_connection_model.dart';
import 'package:showwcase_v3/features/chat/data/repositories/chat_repository.dart';
import 'package:showwcase_v3/features/chat/data/repositories/chat_socket_repository.dart';
import 'package:showwcase_v3/features/search/data/repositories/search_respository.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'chat_state.dart';



class ChatCubit extends Cubit<ChatState> {

    final ChatRepository chatRepository ;
    final SearchRepository searchRepository ;
    late final ChatSocketRepository chatSocket ;
    final Box<ChatMessageModel> chatMessagesBox = Hive.box<ChatMessageModel>(kChatMessages);
    final Box<ChatConnectionModel> chatConnectionsBox = Hive.box<ChatConnectionModel>(kChatConnections);

    StreamSubscription? authBroadcastRepositoryStreamListener;
    final AuthBroadcastRepository authBroadcastRepository;

    ChatCubit({required this.chatRepository,
        required this.searchRepository,
        required this.chatSocket,
        required this.authBroadcastRepository,
    }) : super(const ChatState()) {
        listenToAuthLogout();
    }



    void listenToAuthLogout() async {
        // listen to authCubit changes
        await authBroadcastRepositoryStreamListener?.cancel();

        authBroadcastRepositoryStreamListener =
            authBroadcastRepository.authBroadcastStream.listen((data) {
                if (data.action == AuthBroadcastAction.logout) {
                    emit(state.copyWith(status: ChatStatus.resetChatStateInProgress));
                    emit(const ChatState(status: ChatStatus.initial));
                    // clear chat cache
                    clearChatMessagesCache();
                    clearConnectedRecipientCache();
                }
            });
    }


    initializeChatSocket() async {
        await chatSocket.establishSocketConnection();
        chatSocket.socket.on('message', (data) {
            debugPrint("chat-socket-status: message: $data ");
            if(data is Map<String, dynamic>){
                onMessageReceived(ChatMessageModel.fromJson(data));
            }
        });
        chatSocket.socket.on('totals', (data) {
            debugPrint("chat-socket-status: totals: $data ");
            if(data is Map<String, dynamic>){
                _onTotalsReceived(ChatNotificationsTotalModel.fromJson(data));
            }
        });
    }

    void closeSocketConnection(){
        chatSocket.disposeSocket();
    }

    @override
  Future<void> close() {
    closeSocketConnection();
    chatConnectionsBox.close();
    chatMessagesBox.close();
    return super.close();
  }

    /// call this method to display all initially suggested users to chat
    void fetchSuggestedFollowers() async {

        try{

            emit(state.copyWith(
                status: ChatStatus.fetchSuggestedFollowersInProgress,
            ));

            final user = AppStorage.currentUserSession!;
            final either = await chatRepository.fetchSuggestedChatAccounts(userId: user.id!);

            either.fold((l) {

                emit(state.copyWith(
                    status: ChatStatus.fetchSuggestedFollowersFailed,
                    message: l.errorDescription
                ));

            }, (r) {

                r = r.where((suggested) => !state.connectedRecipients.any((connected) {
                    UserModel? networkResponse = connected.users
                        ?.firstWhere((e) =>
                    e.username !=
                        AppStorage.currentUserSession!.username);
                  return suggested.username == networkResponse?.username;
                })).toList();

                emit(state.copyWith(
                    status: ChatStatus.fetchSuggestedFollowersSuccessful,
                    filteredUsers: r,
                    suggestedUsers: r
                    // message: l.errorDescription
                ));

            });

        }catch(e) {
            emit(state.copyWith(
                status: ChatStatus.fetchSuggestedFollowersFailed,
                message: e.toString()
            ));
        }

    }

    /// call this method to search for the user to chat
    void searchPeopleToChat({ required String searchText }) async {

        try {
            emit(state.copyWith(status: ChatStatus.searchPeopleLoading));

            //!! return suggested users if search keyword is empty
            if(searchText.isEmpty) {
                emit(state.copyWith(status: ChatStatus.searchPeopleLoaded, filteredUsers: state.suggestedUsers,));
                return;
            }

            final either = await chatRepository.searchPeopleToChat(text: searchText, limit:  defaultPageSize, skip: 0);

            either.fold((l) {
                emit(state.copyWith(status: ChatStatus.searchPeopleError, message: l.errorDescription));
            }, (r) {
                emit(state.copyWith(status: ChatStatus.searchPeopleLoaded, filteredUsers: r,));
            });
        } catch (e) {
            emit(state.copyWith(status: ChatStatus.searchPeopleError, message: e.toString()));
        }


    }

    /// Call this method to connect with the user to chat
    /// This creates a connection Id between the sender and recipient
    void requestConnectionToRecipient({required int suggestedUserId}) async {

        try {
            emit(state.copyWith(
                status: ChatStatus.requestConnectionWithRecipientInProgress,
                message: suggestedUserId.toString()
            ));

            final either = await chatRepository.requestConnectionWithRecipient(recipientUserId: suggestedUserId);

            either.fold((l) {
                emit(state.copyWith(
                    status: ChatStatus.requestConnectionWithRecipientFailed,
                    message: l.errorDescription
                ));
            }, (r) {

                // add this person to connected users
                final existingConnectedUsers = [...state.connectedRecipients];
                final suggestedUsers = [...state.suggestedUsers];
                suggestedUsers.removeWhere((element) => element.id == suggestedUserId);
                final index = existingConnectedUsers.indexWhere((element) => element.id == r.id);
                if(index < 0) {
                    existingConnectedUsers.insert(0, r);
                }

                emit(state.copyWith(
                    status: ChatStatus.requestConnectionWithRecipientSuccessful,
                    selectedRecipient: r,
                    connectedRecipients: existingConnectedUsers,
                    suggestedUsers: suggestedUsers
                ));



            });
        } catch (e) {
            emit(state.copyWith(
                status: ChatStatus.requestConnectionWithRecipientFailed,
                message: e.toString()
            ));
        }


    }

    void setChatConnectedRecipients() async {
        final cachedList = chatConnectionsBox.values.toList();
        emit(state.copyWith(status: ChatStatus.setChatConnectedRecipientsInProgress));
        emit(state.copyWith(status: ChatStatus.setChatConnectedRecipientsCompleted,
            connectedRecipients: cachedList
        ));
    }


    /// retrieve connected from cache
    List<ChatConnectionModel> getConnectedRecipientsFromCache(){
        final connectedRecipients = state.connectedRecipients;
        return connectedRecipients;
    }

    // This is stateless and only returns data to the caller. No data is kept in state
    Future<Either<String, ChatConnectionModel>> getConnectedRecipientById({required String connectedRecipientId}) async {
        try {

            final either = await chatRepository.getConnectedRecipient(connectionId: connectedRecipientId);

            if(either.isLeft()){
                final l = either.asLeft();
                return Left(l.errorDescription);
            }

            // successful
            final r = either.asRight();
            return Right(r);

        }catch(e) {
            return Left(e.toString());
        }
    }


    /// This method returns all previously connected users
    Future<Either<String, List<ChatConnectionModel>>> fetchConnectedRecipients({required int pageKey}) async {

        try {

            emit(state.copyWith(status: ChatStatus.fetchConnectedRecipientsInProgress));

            // we request for the default page size on the first call and subsequently we skip by the length of shows available
            final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey;  // even if previous page returned items less than defaultPageSize, still skip by defaultPageSize
            final either = await chatRepository.fetchConnectedRecipients(limit: defaultPageSize, skip: skip);

            if(either.isLeft()){
                final l = either.asLeft();
                emit(state.copyWith(status: ChatStatus.fetchConnectedRecipientsFailed, message: l.errorDescription));
                return Left(l.errorDescription);
            }

            // successful
            List<ChatConnectionModel> r = either.asRight();
            final List<ChatConnectionModel> connections = [...state.connectedRecipients];
            if(pageKey == 0){
                // if its first page request remove all existing threads
                connections.clear();
            }

            connections.addAll(r);

            // just to make sure the update from the server is emitted to the UI
            emit(state.copyWith(status: ChatStatus.fetchConnectedRecipientsInProgress));
            emit(state.copyWith(status: ChatStatus.fetchConnectedRecipientsSuccessful,
                connectedRecipients: connections,
            ));

            /// save recipients in local cache
            updateConnectedRecipientCache(connections);

            return Right(r);


        }catch(e) {
            emit(state.copyWith(status: ChatStatus.fetchConnectedRecipientsFailed, message: e.toString()));
            return Left(e.toString());
        }

    }

    void clearConnectedRecipientCache() async {
         chatConnectionsBox.clear();
    }

    void clearChatMessagesCache() async {
        chatMessagesBox.clear();
    }


    void updateConnectedRecipientCache(List<ChatConnectionModel> recipients) async {
        await chatConnectionsBox.clear();
        chatConnectionsBox.addAll(recipients);
    }
    void updateChatMessagesCache({required String connectionId, required List<ChatMessageModel> chatMessages}) async {
        // final chatsKeys = box.keys;
        final keysToDelete = <int>[];
        for (var entry in chatMessagesBox.toMap().entries) {
            if(entry.value.chatId == connectionId){
                keysToDelete.add(entry.key);
            }
        }
        chatMessagesBox.deleteAll(keysToDelete);
        chatMessagesBox.addAll(chatMessages);

    }

    /// Call this method to send message to recipient
    void sendMessage({required ChatConnectionModel connection, required String text, String? attachment}) async{

        try{
            emit(state.copyWith(
                status: ChatStatus.sendMessageToRecipientInProgress
            ));

            final proposedId = nanoid();
            final currentUser = AppStorage.currentUserSession!;


            final message = ChatMessageModel(
                id: proposedId,
                chatId: connection.id,
                userId: currentUser.id,
                text: text,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                user: UserModel.fromJson(currentUser.toJson()),
                sentFromMobile: true,
                attachments: attachment != null ? [
                    ChatAttachmentModel(
                        type: 'image',
                        value: attachment,
                        meta: ChatAttachmentMetaModel(
                            url: attachment
                        ),
                    )
                ]: null,
            );

            // optimistic update
            final chats = [...state.rawChatList ];
            chats.insert(0,message);
            _refreshChatMessages(connection: connection, chats: chats);

            final either = await chatRepository.sendMessageToRecipient(message: message);

            either.fold((l) {

                emit(state.copyWith(
                    status: ChatStatus.sendMessageToRecipientFailed,
                    message: message.id
                ));

            },
                    (r) {

                    // if sending of message is successful update the list with the right Id from the server
                    final chats = [...state.rawChatList ];
                    final indexFound = chats.indexWhere((element) => element.id == proposedId);
                    if(indexFound > -1) {
                        final ChatMessageModel chat = chats[indexFound];
                        final updateChat = chat.copyWith(
                            id: r.id
                        );
                        chats[indexFound] = updateChat;
                        _refreshChatMessages(connection: connection, chats: chats);
                    }

                    // update the connected user's last message
                    final connectedRecipients = [...state.connectedRecipients];
                    final indexOfConnection = connectedRecipients.indexWhere((element) => element.id == connection.id);
                    if(indexOfConnection > -1) {
                        final ChatConnectionModel selectedConnection = connectedRecipients[indexOfConnection];
                        connectedRecipients[indexOfConnection] = selectedConnection.copyWith(
                            totalUnreadMessages: 0,
                        );
                    }
                    emit(state.copyWith(
                        status: ChatStatus.sendMessageToRecipientSuccessful,
                        connectedRecipients: connectedRecipients
                    ));

                });
        }catch(e){
            emit(state.copyWith(
                status: ChatStatus.sendMessageToRecipientFailed,
                message: e.toString()
            ));
        }

    }

    // get data from cache
    void fetchChatMessagesFromCache({required ChatConnectionModel connection}) async {
        // Retrieve data from cache first
        final cachedMessagesList = chatMessagesBox.values.where((element) => element.chatId == connection.id).toList();
        _refreshChatMessages(connection: connection, chats: cachedMessagesList, savInCache: false);

    }

    // get data from server
    void fetchChatMessages({required ChatConnectionModel connection}) async {

        try{

            emit(state.copyWith(status: ChatStatus.fetchChatMessagesInProgress,));

            final either = await chatRepository.fetchChatMessages(connectionId: connection.id!);

            if(either.isLeft()){
                final l = either.asLeft();
                emit(state.copyWith(status: ChatStatus.fetchChatMessagesFailed,
                    message: l.errorDescription
                ));
                return;
            }

            // successful
            final r = either.asRight();

            emit(state.copyWith(
                status: ChatStatus.fetchChatMessagesSuccessful,
                rawChatList: r
            ));

            _refreshChatMessages(connection: connection, chats: r);
        //
        }catch(e) {

            emit(state.copyWith(
                status: ChatStatus.fetchChatMessagesFailed,
                message: e.toString()
            ));

        }

    }

    void onMessageReceived(ChatMessageModel message) {

        final currentUser = AppStorage.currentUserSession;
        if(message.user?.username == null || currentUser?.username == null) {
            return;
        }
        final currentUsername = currentUser!.username;

        // if the message was sent by this current user (perhaps from web)
        // we want to update our chats here as well
        if(message.user?.username == currentUsername) {

            // reFetch the chat connections
            // make sure this message isn't already added to the last chat message
            final connectedRecipients = [...state.connectedRecipients];
            final recipientIndexFound = connectedRecipients.indexWhere((element) => element.id == message.chatId);
            if(recipientIndexFound < 0) {
                // we're refreshing the whole list cus the recipient has not reflected on mobile yet
                fetchConnectedRecipients(pageKey: 0);
            }else {
                final foundRecipient = connectedRecipients[recipientIndexFound];
                // if last message is not same as message then it means its from the web
                // so we update it locally
                if(foundRecipient.lastMessage?.id != message.id) {
                    connectedRecipients.removeAt(recipientIndexFound);
                    connectedRecipients.insert(0, foundRecipient.copyWith(
                        lastMessage: message
                    ));
                    emit(state.copyWith(status: ChatStatus.updateConnectedRecipientsInProgress));
                    emit(state.copyWith(
                        status: ChatStatus.updateConnectedRecipientsSuccessful,
                        connectedRecipients: connectedRecipients
                    ));
                }

            }

            // if user has selected any chat refresh the messages
            // so the chat on web reflect on mobile

            // undo this if nanoId is sent back to us from the server
            if(state.selectedRecipient != null) {
                final rawChatList = [...state.rawChatList];
                final indexFound = rawChatList.indexWhere((element) => element.id == message.id || element.id == message.matchId);
                if(indexFound < 0) {
                    rawChatList.insert(0, message);
                    _refreshChatMessages(connection: state.selectedRecipient!, chats: rawChatList);
                }

            }

        }
        // add to chat list if only the chat is coming from a recipient
        else if(message.user?.username != currentUsername) {

            // message page is already opened and this tarted towards that message, update the chats
            if(state.selectedRecipient != null && message.chatId == state.selectedRecipient?.id){
                final List<ChatMessageModel> chats = [];
                chats.addAll(state.rawChatList);
                chats.insert(0, message);
                _refreshChatMessages(connection: state.selectedRecipient!, chats: chats);
            }

            //update the message count on the connection, if the user is not on the selected chat
            if (message.chatId != state.selectedRecipient?.id) {
                final connectedRecipients = [...state.connectedRecipients];
                final indexOfConnection = connectedRecipients.indexWhere((
                    element) => element.id == message.chatId);
                if (indexOfConnection > -1) {
                    final ChatConnectionModel selectedConnection = connectedRecipients[indexOfConnection];
                    connectedRecipients[indexOfConnection] =
                        selectedConnection.copyWith(
                            totalUnreadMessages: (selectedConnection
                                .totalUnreadMessages ?? 0) + 1,
                        );
                }
                emit(state.copyWith(
                    status: ChatStatus
                        .updatingTotalUnreadMessagesOnASelectedChatInProgress
                ));

                emit(state.copyWith(
                    status: ChatStatus
                        .updatingTotalUnreadMessagesOnASelectedChatSuccessful,
                    connectedRecipients: connectedRecipients
                ));
            }

            // message page is already opened and this tarted towards that message, mark as read
            if(state.selectedRecipient != null && message.chatId == state.selectedRecipient?.id){
                markChatMessagesAsRead(connectionId: state.selectedRecipient!.id!);
            }


        }

    }

    void _onTotalsReceived(ChatNotificationsTotalModel totals) {

        emit(state.copyWith(
            status: ChatStatus.updatingChatNotificationTotalsInProgress
        ));

        emit(state.copyWith(
            status: ChatStatus.updatingChatNotificationTotalsSuccessful,
            notificationTotals: totals
        ));

    }


    /// This method here will help the state management know which chat is currently active
    void setActiveChat({ChatConnectionModel? connection}) {
        emit(state.copyWith(status: ChatStatus.updateSelectedConnectionInProgress,));
        emit(state.copyWith(
            status: ChatStatus.updateSelectedConnectionSuccessful,
            selectedRecipient: connection
        ));
    }

    void markChatMessagesAsRead({required String connectionId}) async {

        try{

            emit(state.copyWith(
                status: ChatStatus.markChatMessagesAsReadInProgress,
            ));

            final either = await chatRepository.markChatMessagesAsRead(connectionId: connectionId);

            either.fold((l) {
                emit(state.copyWith(
                    status: ChatStatus.markChatMessagesAsReadFailed,
                    message: l.errorDescription
                ));
            },
                (r) {

                emit(state.copyWith(
                    status: ChatStatus.markChatMessagesAsReadSuccessful,
                    // connectedRecipients: connectedRecipients
                ));

               // update last message on chat connections
                final connectedRecipients = [...state.connectedRecipients];
                final indexOfConnection = connectedRecipients.indexWhere((element) => element.id == connectionId);
                if(indexOfConnection > -1) {
                    final ChatConnectionModel selectedConnection = connectedRecipients[indexOfConnection];
                    connectedRecipients[indexOfConnection] = selectedConnection.copyWith(
                        totalUnreadMessages: 0,
                    );
                }
                emit(state.copyWith(status: ChatStatus.updatingTotalUnreadMessagesOnASelectedChatInProgress));

               emit(state.copyWith(
                   status: ChatStatus.updatingTotalUnreadMessagesOnASelectedChatSuccessful,
                   connectedRecipients: connectedRecipients
               ));

            });

        }catch(e) {

            emit(state.copyWith(
                status: ChatStatus.markChatMessagesAsReadFailed,
                message: e.toString()
            ));

        }

    }


    /// This method returns connections yet to be accepted
    void fetchPendingConnections({bool replaceFirstPage = false}) async {

        if (!replaceFirstPage && state.hasPendingConnectionsReachMax) return;

        try {

            emit(state.copyWith(status: ChatStatus.fetchPendingConnectionsInProgress));


            final either = await chatRepository.fetchPendingConnections(limit: defaultPageSize, skip: replaceFirstPage ? 0 : state.pendingConnections.length);

            either.fold(
                    (l) => emit(state.copyWith(
                    status: ChatStatus.fetchPendingConnectionsFailed,
                    message: l.errorDescription)),
                    (r) {

                    if (replaceFirstPage) {
                        emit(state.copyWith(
                            status: ChatStatus.fetchPendingConnectionsSuccess,
                            hasPendingConnectionsReachMax: r.isEmpty,
                            pendingConnections: r));

                        return;
                    }

                    if (r.isEmpty) {
                        emit(state.copyWith(
                            status: ChatStatus.fetchPendingConnectionsSuccess,
                            hasPendingConnectionsReachMax: true,));
                        return;
                    }

                    emit(state.copyWith(
                        pendingConnections: List.of(state.pendingConnections)..addAll(r),
                        status: ChatStatus.fetchPendingConnectionsSuccess,
                        hasPendingConnectionsReachMax: r.isEmpty
                    ));

                });

        }catch(e) {
            emit(state.copyWith(
                status: ChatStatus.fetchPendingConnectionsFailed,
                message: e.toString()
            ));
        }

    }

    /// This method returns connections previously
    void fetchRejectedConnections({bool replaceFirstPage = false}) async {

        if (!replaceFirstPage && state.hasRejectedConnectionsReachMax) return;

        try {

            emit(state.copyWith(status: ChatStatus.fetchRejectedConnectionsInProgress));


            final either = await chatRepository.fetchRejectedConnections(limit: defaultPageSize, skip: replaceFirstPage ? 0 : state.rejectedConnections.length);

            either.fold(
                    (l) => emit(state.copyWith(
                    status: ChatStatus.fetchRejectedConnectionsFailed,
                    message: l.errorDescription)),
                    (r) {

                    if (replaceFirstPage) {
                        emit(state.copyWith(
                            status: ChatStatus.fetchRejectedConnectionsSuccess,
                            hasRejectedConnectionsReachMax: r.isEmpty,
                            rejectedConnections: r));

                        return;
                    }

                    if (r.isEmpty) {
                        emit(state.copyWith(
                            status: ChatStatus.fetchRejectedConnectionsSuccess,
                            hasRejectedConnectionsReachMax: true,));
                        return;
                    }

                    emit(state.copyWith(
                        rejectedConnections: List.of(state.rejectedConnections)..addAll(r),
                        status: ChatStatus.fetchRejectedConnectionsSuccess,
                        hasRejectedConnectionsReachMax: r.isEmpty
                    ));

                });

        }catch(e) {
            emit(state.copyWith(
                status: ChatStatus.fetchRejectedConnectionsFailed,
                message: e.toString()
            ));
        }

    }

    /// Call this method to accept connection
    /// it automatically adds this user to list of connected users
    void acceptPendingConnection({required String chatId, required int userId}) async {

        // from

        emit(state.copyWith(
            status: ChatStatus.acceptPendingConnectionInProgress,
        ));

        final pendingConnections = [...state.pendingConnections];
        final rejectedHistoryConnections = [...state.rejectedConnections];

        final indexOfConnectionToBeRejected = pendingConnections.indexWhere((element) => element.chatId == chatId);
        final indexOfConnectionAlreadyRejected = rejectedHistoryConnections.indexWhere((element) => element.chatId == chatId);

        // with all things being equal, the condition below will not be met
        if(indexOfConnectionToBeRejected < 0 && indexOfConnectionAlreadyRejected < 0) {
            emit(state.copyWith(
                status: ChatStatus.acceptPendingConnectionFailed,
                message: 'Unable to find chatId'
            ));
            return;
        }

        IncomingConnectionModel? selectedPendingConnection;
        IncomingConnectionModel? selectedRejectedHistoryConnection;

        if(indexOfConnectionToBeRejected >= 0) {
            selectedPendingConnection = pendingConnections[indexOfConnectionToBeRejected];
        }
        if(indexOfConnectionAlreadyRejected >= 0) {
            selectedRejectedHistoryConnection = rejectedHistoryConnections[indexOfConnectionAlreadyRejected];
        }


        update() {

            // remove user from pending / history connections

            if(selectedPendingConnection != null) {
                pendingConnections.remove(selectedPendingConnection);
            }
            if(selectedRejectedHistoryConnection != null) {
                rejectedHistoryConnections.remove(selectedRejectedHistoryConnection);
            }

            // and update the state with remaining pending / history connections
            emit(state.copyWith(
                status: ChatStatus.acceptPendingConnectionSuccessful,
                pendingConnections: selectedPendingConnection != null ? pendingConnections : state.pendingConnections,
                rejectedConnections: selectedRejectedHistoryConnection != null ? rejectedHistoryConnections : state.rejectedConnections
            ));
        }

        reverse(String reason) {
            // add user back to pending / history connection if access the server fails

            if(selectedPendingConnection != null) {
                pendingConnections.add(selectedPendingConnection);
            }
            if(selectedRejectedHistoryConnection != null) {
                rejectedHistoryConnections.add(selectedRejectedHistoryConnection);
            }

            emit(state.copyWith(
                status: ChatStatus.acceptPendingConnectionFailed,
                pendingConnections: selectedPendingConnection != null ? pendingConnections : state.pendingConnections,
                rejectedConnections: selectedRejectedHistoryConnection != null ? rejectedHistoryConnections : state.rejectedConnections
            ));
        }


        /// Execution starts here ----

        try{


            //  STEP 1. is to call update so that the UI gets updated immediately
            update();


            final either = await chatRepository.acceptPendingConnections(connectionId: chatId);

            either.fold((l) {
                reverse(l.errorDescription);
            },
                    (r) {

                // optimistic update has already handled the success state

                 // This method will add the user to the connected users.
                 requestConnectionToRecipient(suggestedUserId: userId);
           });

        }catch(e) {

            reverse(e.toString());

        }

    }

    /// Call this method to reject connection
    /// it automatically adds this user to list of rejected connections
    void rejectPendingConnection({required String chatId}) async {

        emit(state.copyWith(
            status: ChatStatus.rejectPendingConnectionInProgress,
        ));

        final pendingConnections = [...state.pendingConnections];
        final rejectedConnections = [...state.rejectedConnections];

        final indexOfConnectionToBeRejected = pendingConnections.indexWhere((element) => element.chatId == chatId);
        // with all things being equal, the condition below will not be met
        if(indexOfConnectionToBeRejected < 0) {
            emit(state.copyWith(
                status: ChatStatus.rejectPendingConnectionFailed,
                message: 'Unable to find chatId in pending connections'
            ));
            return;
        }

        final connectionToBeRejected = pendingConnections[indexOfConnectionToBeRejected];


        // optimistic update
        update() {

            // remove the user from pending connection
            pendingConnections.remove(connectionToBeRejected);

            // add user to rejected connections
            rejectedConnections.insert(0, connectionToBeRejected);

            emit(state.copyWith(
                status: ChatStatus.rejectPendingConnectionSuccessful,
                pendingConnections: pendingConnections,
                rejectedConnections: rejectedConnections
            ));
        }

        // reverse optimistic update if call to server fails
        reverse(String reason) {
            // add the user back to the pending connection
            pendingConnections.add(connectionToBeRejected);

            // remove the user from the rejected connections
            rejectedConnections.remove(connectionToBeRejected);

            emit(state.copyWith(
                status: ChatStatus.rejectPendingConnectionFailed,
                pendingConnections: pendingConnections,
                rejectedConnections: rejectedConnections
            ));

        }

        try{


           /// Execution starts here -----

            //  STEP 1. is to call update so that the UI gets updated immediately
           update();

            final either = await chatRepository.rejectPendingConnections(connectionId: chatId);

            either.fold((l) {
                reverse(l.errorDescription);
            },
                    (r) {

                    // optimistic update has already handled the success state

                });

        }catch(e) {
            reverse(e.toString());
        }

    }


    void fetchChatNotificationTotals() async {
        try{

            emit(state.copyWith(
                status: ChatStatus.fetchChatNotificationTotalsInProgress,
            ));

            final either = await chatRepository.fetchChatNotificationTotals();

            either.fold((l) {
                emit(state.copyWith(
                    status: ChatStatus.fetchChatNotificationTotalsFailed,
                    message: l.errorDescription
                ));
            },
                    (r) {

                    emit(state.copyWith(
                        status: ChatStatus.fetchChatNotificationTotalsSuccessful,
                        notificationTotals: r
                    ));

                });

        }catch(e) {

            emit(state.copyWith(
                status: ChatStatus.fetchChatNotificationTotalsFailed,
                message: e.toString()
            ));

        }
    }

    void updateChatNotificationTotals({int? totalUnreadMessages, int? totalPendingRequests, int? totalUnreadChats}) async {
        try{

            totalUnreadMessages = totalUnreadMessages ?? state.notificationTotals.totalUnreadMessages;
            totalPendingRequests = totalPendingRequests ?? state.notificationTotals.totalPendingRequests;
            totalUnreadChats = totalUnreadChats ?? state.notificationTotals.totalUnreadChats;

            emit(state.copyWith(
                status: ChatStatus.updateChatNotificationTotalsInProgress,
            ));

            emit(state.copyWith(
                status: ChatStatus.updateChatNotificationTotalsSuccessful,
                notificationTotals: ChatNotificationsTotalModel(
                    totalPendingRequests: totalPendingRequests,
                    totalUnreadChats: totalUnreadChats,
                    totalUnreadMessages: totalUnreadMessages
                )
            ));

        }catch(e) {

            emit(state.copyWith(
                status: ChatStatus.updateChatNotificationTotalsFailed,
                message: e.toString()
            ));

        }
    }


    /// This method modifies the chatList and updates the UI
    /// Its NOT called directly from the UI
    void _refreshChatMessages({required ChatConnectionModel connection, required List<ChatMessageModel> chats, bool savInCache = true}) {

        emit(state.copyWith(status: ChatStatus.refreshChatMessagesInProgress,
            rawChatList: chats
        ));

        // update the last chat message on the appropriate user
        final connectedRecipients = [...state.connectedRecipients];

        if(chats.isNotEmpty) {
            final lastChat = chats.first;
            final connectionIndex = connectedRecipients.indexWhere((connection) => connection.id == lastChat.chatId);
            if(connectionIndex > -1) {
                final connection = connectedRecipients[connectionIndex];
                connectedRecipients[connectionIndex] = connection.copyWith(
                    lastMessage: lastChat
                );

                // re-arrange the connection to show the last chat first
                connectedRecipients.sort((ChatConnectionModel a, ChatConnectionModel b) {
                    if (a.lastMessage?.createdAt == null && b.lastMessage?.createdAt == null) {
                        return 0;
                    } else if (a.lastMessage?.createdAt == null) {
                        return 1;
                    } else if (b.lastMessage?.createdAt == null) {
                        return -1;
                    } else {
                        return b.lastMessage!.createdAt!.compareTo(a.lastMessage!.createdAt!);
                    }
                });

                // update the local cache with the new sort
                // chatConnectionsBox.clear();
                // chatConnectionsBox.putAll({ for (var model in connectedRecipients) model.id! : model });

            }
        }


        // group the chats by date, time and userId
        final groupedModelsByDate = groupMessagesByDateAndTimeWindow(chats);

        // // group the models by time within each date group
        // final groupedModelsByDateTime = <DateTime, Map<TimeOfDay, List<ChatMessageModel>>>{};
        // groupedModelsByDate.forEach((date, models) {
        //     final groupedModelsByTime = groupBy(models, (ChatMessageModel model) => TimeOfDay.fromDateTime(model.createdAt!));
        //     groupedModelsByDateTime[date] = groupedModelsByTime;
        // });

        emit(state.copyWith(
            status: ChatStatus.refreshChatMessagesSuccessful,
            chats: groupedModelsByDate,
            connectedRecipients: connectedRecipients

        ));

        // update messages in local cache
        if(savInCache){
            updateChatMessagesCache(connectionId: connection.id!, chatMessages: chats);
        }



    }


    Map<DateTime, List<List<ChatMessageModel>>> groupMessagesByDateAndTimeWindow(List<ChatMessageModel> models) {
        // Sort models by date in descending order
        models.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        // Group models by date
        Map<DateTime, List<ChatMessageModel>> groupedByDate = groupBy(
            models,
                (ChatMessageModel model) => DateTime(model.createdAt!.year, model.createdAt!.month, model.createdAt!.day),
        );

        // Sort models within each date by time and group by userId within a 5-minute window
        Map<DateTime, List<List<ChatMessageModel>>> finalGroupedModels = {};

        groupedByDate.forEach((date, dateModels) {
            dateModels.sort((a, b) => a.createdAt!.compareTo(b.createdAt!)); // Sort models by time in ascending order

            List<List<ChatMessageModel>> groups = [];
            String? lastUser;
            List<ChatMessageModel>? currentUserGroup;

            for (var model in dateModels) {
                if (lastUser != model.user?.username) {
                    if (currentUserGroup != null && currentUserGroup.isNotEmpty) {
                        groups.add(currentUserGroup);
                    }
                    currentUserGroup = [];
                    lastUser = model.user?.username;
                } else if (currentUserGroup != null && currentUserGroup.isNotEmpty && model.createdAt != null && currentUserGroup.last.createdAt != null &&
                    model.createdAt!.difference(currentUserGroup.last.createdAt!).inMinutes > 5
                ) {
                    groups.add(currentUserGroup);
                    currentUserGroup = [];
                }

                if (currentUserGroup != null) {
                    currentUserGroup.add(model);
                }
            }

            if (currentUserGroup != null && currentUserGroup.isNotEmpty) {
                groups.add(currentUserGroup);
            }

            finalGroupedModels[date] = groups;
        });

        return finalGroupedModels;
    }


}