import 'package:discount_me_app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService extends GetxService {
  io.Socket? _socket;
  String? _activeToken;

  final RxBool isConnected = false.obs;
  final RxString socketId = ''.obs;
  final RxString errorMessage = ''.obs;

  bool get isInitialized => _socket != null;

  Future<SocketService> init({required String token}) async {
    if (token.isEmpty) return this;

    if (_socket != null && _activeToken == token) {
      if (_socket?.connected == false) {
        _socket?.connect();
      }
      return this;
    }

    disconnect();
    _activeToken = token;

    _socket = io.io(
      ApiUtils.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': 'Bearer $token'})
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket?.onConnect((_) {
      isConnected.value = true;
      socketId.value = _socket?.id ?? '';
      errorMessage.value = '';
      if (kDebugMode) {
        print('Socket connected: ${socketId.value}');
      }
    });

    _socket?.onDisconnect((_) {
      isConnected.value = false;
      socketId.value = '';
      if (kDebugMode) {
        print('Socket disconnected');
      }
    });

    _socket?.onConnectError((error) {
      isConnected.value = false;
      errorMessage.value = error.toString();
      if (kDebugMode) {
        print('Socket connect error: $error');
      }
    });

    _socket?.onError((error) {
      errorMessage.value = error.toString();
      if (kDebugMode) {
        print('Socket error: $error');
      }
    });

    _socket?.connect();
    return this;
  }

  void bindChatEvents({
    required void Function(Map<String, dynamic> data) onConnected,
    required void Function(Map<String, dynamic> data) onJoinedRoom,
    required void Function(Map<String, dynamic> data) onLeftRoom,
    required void Function(Map<String, dynamic> data) onNewMessage,
    required void Function(Map<String, dynamic> data) onConversationUpdated,
    required void Function(Map<String, dynamic> data) onMessagesRead,
    required void Function(String message) onChatError,
  }) {
    final socket = _socket;
    if (socket == null) return;

    socket.off('chat:connected');
    socket.off('chat:joined-room');
    socket.off('chat:left-room');
    socket.off('chat:new-message');
    socket.off('chat:conversation-updated');
    socket.off('chat:messages-read');
    socket.off('chat:error');

    socket.on('chat:connected', (data) => onConnected(_asMap(data)));
    socket.on('chat:joined-room', (data) => onJoinedRoom(_asMap(data)));
    socket.on('chat:left-room', (data) => onLeftRoom(_asMap(data)));
    socket.on('chat:new-message', (data) => onNewMessage(_asMap(data)));
    socket.on(
      'chat:conversation-updated',
      (data) => onConversationUpdated(_asMap(data)),
    );
    socket.on('chat:messages-read', (data) => onMessagesRead(_asMap(data)));
    socket.on('chat:error', (data) {
      final map = _asMap(data);
      onChatError(map['message']?.toString() ?? 'Socket error occurred');
    });
  }

  void joinRoom(String conversationId) {
    _emit('chat:join-room', {'conversationId': conversationId});
  }

  void leaveRoom(String conversationId) {
    _emit('chat:leave-room', {'conversationId': conversationId});
  }

  void sendMessage({
    required String conversationId,
    required String text,
  }) {
    _emit('chat:send-message', {
      'conversationId': conversationId,
      'text': text,
    });
  }

  void markAsRead(String conversationId) {
    _emit('chat:mark-as-read', {'conversationId': conversationId});
  }

  void _emit(String event, Map<String, dynamic> payload) {
    final socket = _socket;
    if (socket == null) return;

    if (socket.connected) {
      socket.emit(event, payload);
    } else {
      socket.connect();
      socket.once('connect', (_) => socket.emit(event, payload));
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }

  void disconnect() {
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    isConnected.value = false;
    socketId.value = '';
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
