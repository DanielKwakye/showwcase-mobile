import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class ChatSocketRepository {

  late IO.Socket socket;

  Future<void> establishSocketConnection()async {

    String? token = await AppStorage.getAuthTokenVal();

    socket = IO.io(
        ApiConfig.apiBaseUrl,
        OptionBuilder()
            .disableAutoConnect()
            .enableReconnection()
            .setPath("/chat/socket")
            .setAuth({ 'token': token })
            .setTransports(['websocket', 'polling']) // for Flutter or Dart VM
            .build());

      if(socket.connected) {
        return;
      }

      socket.onConnect((_) {debugPrint('chat-socket: connected'); });
      socket.onDisconnect((_) => debugPrint('chat-socket: disconnected'));
      socket.onConnectError((data) {
        if(data is WebSocketException){
          debugPrint('chat-socket: connectionErrorMessage -> ${data.message}');
        }
      });
      socket.onerror((data) => debugPrint('chat-socket: error -> $data'));
      socket.connect();

  }

  void disposeSocket() {
    socket.disconnect();
    socket.destroy();
    socket.dispose();
  }

}