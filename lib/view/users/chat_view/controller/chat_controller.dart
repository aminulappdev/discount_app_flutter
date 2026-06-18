import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:discount_me_app/socket/socket_service.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/users/model/chat_model.dart' as chat_model;
import 'package:discount_me_app/view/users/model/message_model.dart'
    as message_model;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final SocketService socketService = Get.put(SocketService());
  final dio.Dio _dio = dio.Dio();

  final RxBool isConversationLoading = false.obs;
  final RxBool isMessageLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchTerm = ''.obs;
  final Rxn<chat_model.ChatItemModel> selectedConversation =
      Rxn<chat_model.ChatItemModel>();
  final RxList<chat_model.ChatItemModel> conversations =
      <chat_model.ChatItemModel>[].obs;
  final RxList<message_model.MessageItemModel> messages =
      <message_model.MessageItemModel>[].obs;

  String _accessToken = '';
  String currentEmail = '';
  String currentRole = '';
  String? _joinedConversationId;

  @override
  void onInit() {
    super.onInit();
    _prepareSession();
    fetchConversations();
  }

  Future<void> _prepareSession() async {
    _accessToken = _readAccessToken();
    if (_accessToken.isEmpty) return;

    final payload = _parseJwt(_accessToken);
    currentEmail = payload['email']?.toString() ?? '';
    currentRole = payload['role']?.toString() ?? '';

    await socketService.init(token: _accessToken);
    socketService.bindChatEvents(
      onConnected: (_) {},
      onJoinedRoom: (_) {},
      onLeftRoom: (_) {},
      onNewMessage: _handleNewMessage,
      onConversationUpdated: _handleConversationUpdated,
      onMessagesRead: _handleMessagesRead,
      onChatError: (message) => errorMessage.value = message,
    );
  }

  Future<void> fetchConversations({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    await _ensureSession();
    if (_accessToken.isEmpty) return;

    isConversationLoading.value = true;
    errorMessage.value = '';
 
    try {
      final response = await _dio.get(
        ApiUtils.chats,
        queryParameters: {
          'page': page,
          'limit': limit,
          if ((search ?? searchTerm.value).trim().isNotEmpty)
            'searchTerm': (search ?? searchTerm.value).trim(),
        },
        options: _authOptions,
      );

      conversations.assignAll(_parseConversationList(response.data));
    } on dio.DioException catch (e) {
      errorMessage.value = _responseMessage(e.response?.data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isConversationLoading.value = false;
    }
  }

  Future<chat_model.ChatItemModel?> createConversation(String vendorId) async {
    await _ensureSession();
    if (_accessToken.isEmpty || vendorId.isEmpty) return null;

    try {
      final response = await _dio.post(
        ApiUtils.chats,
        data: {'vendorId': vendorId},
        options: _authOptions,
      );
      final conversation = _parseSingleConversation(response.data['data']);
      if (conversation != null) {
        _upsertConversation(conversation);
      }
      return conversation;
    } on dio.DioException catch (e) {
      errorMessage.value = _responseMessage(e.response?.data);
    } catch (e) {
      errorMessage.value = e.toString();
    }
    return null;
  }

  Future<void> openConversation(chat_model.ChatItemModel conversation) async {
    final previousId = _joinedConversationId;
    if (previousId != null && previousId != conversation.id) {
      socketService.leaveRoom(previousId);
    }

    selectedConversation.value = conversation;
    messages.clear();

    if (conversation.id == null) return;

    _joinedConversationId = conversation.id;
    socketService.joinRoom(conversation.id!);
    await fetchMessages(conversation.id!);
    await markConversationAsRead(conversation.id!);
  }

  Future<void> fetchMessages(
    String conversationId, {
    int page = 1,
    int limit = 50,
  }) async {
    await _ensureSession();
    if (_accessToken.isEmpty || conversationId.isEmpty) return;

    isMessageLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _dio.get(
        ApiUtils.chatMessages(conversationId),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
        options: _authOptions,
      );
      messages.assignAll(_parseMessageList(response.data));
    } on dio.DioException catch (e) {
      errorMessage.value = _responseMessage(e.response?.data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isMessageLoading.value = false;
    }
  }

  Future<void> sendMessage(String text) async {
    final conversationId = selectedConversation.value?.id;
    final messageText = text.trim();
    if (conversationId == null || messageText.isEmpty) return;

    isSending.value = true;
    socketService.sendMessage(
      conversationId: conversationId,
      text: messageText,
    );
    isSending.value = false;
  }

  Future<void> markConversationAsRead(String conversationId) async {
    await _ensureSession();
    if (_accessToken.isEmpty || conversationId.isEmpty) return;

    socketService.markAsRead(conversationId);

    try {
      await _dio.patch(
        ApiUtils.chatRead(conversationId),
        options: _authOptions,
      );
      _setConversationUnread(conversationId, 0);
    } catch (e) {
      if (kDebugMode) {
        print('Mark chat read failed: $e');
      }
    }
  }

  bool isSentByMe(message_model.MessageItemModel message) {
    if (currentEmail.isNotEmpty && message.senderEmail == currentEmail) {
      return true;
    }
    if (currentRole.isNotEmpty && message.senderRole == currentRole) {
      return true;
    }
    return false;
  }

  String conversationTitle(chat_model.ChatItemModel conversation) {
    return conversation.displayName ??
        conversation.vendor?.store?.name ??
        conversation.customer?.name ??
        'Chat';
  }

  String conversationImage(chat_model.ChatItemModel conversation) {
    final image = conversation.displayImage;
    if (image is String && image.isNotEmpty) return image;
    final coverImages = conversation.vendor?.store?.coverImages ?? [];
    final storeImage = coverImages.isEmpty ? null : coverImages.first;
    if (storeImage != null && storeImage.isNotEmpty) return storeImage;
    return conversation.customer?.image ?? '';
  }

  String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final local = dateTime.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _ensureSession() async {
    if (_accessToken.isNotEmpty) return;
    await _prepareSession();
  }

  dio.Options get _authOptions => dio.Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

  String _readAccessToken() {
    final cachedLogin = LocalStorageUtils.getString(AppConstantUtils.loginResponse);
    if (cachedLogin == null || cachedLogin.isEmpty) return '';

    try {
      final decoded = jsonDecode(cachedLogin);
      return decoded['data']?['accessToken']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  Map<String, dynamic> _parseJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};
      final normalized = base64Url.normalize(parts[1]);
      final payload = utf8.decode(base64Url.decode(normalized));
      return Map<String, dynamic>.from(jsonDecode(payload));
    } catch (_) {
      return {};
    }
  }

  List<chat_model.ChatItemModel> _parseConversationList(dynamic responseData) {
    final root = _asMap(responseData);
    final rawData = root['data'];
    final list = rawData is List
        ? rawData
        : rawData is Map && rawData['data'] is List
            ? rawData['data'] as List
            : <dynamic>[];

    return list
        .whereType<Map>()
        .map((item) => chat_model.ChatItemModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }

  chat_model.ChatItemModel? _parseSingleConversation(dynamic data) {
    if (data is Map) {
      return chat_model.ChatItemModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  List<message_model.MessageItemModel> _parseMessageList(dynamic responseData) {
    final root = _asMap(responseData);
    final rawData = root['data'];
    final list = rawData is List
        ? rawData
        : rawData is Map && rawData['data'] is List
            ? rawData['data'] as List
            : <dynamic>[];

    return list
        .whereType<Map>()
        .map((item) => message_model.MessageItemModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }

  String _responseMessage(dynamic data) {
    final map = _asMap(data);
    return map['message']?.toString() ?? 'Something went wrong';
  }

  void _handleNewMessage(Map<String, dynamic> data) {
    final conversationId = data['conversationId']?.toString();
    final rawMessage = data['message'];
    if (rawMessage is! Map) return;

    final message = message_model.MessageItemModel.fromJson(
      Map<String, dynamic>.from(rawMessage),
    );

    if (selectedConversation.value?.id == conversationId ||
        message.conversation == selectedConversation.value?.id) {
      final exists = messages.any((item) => item.id == message.id);
      if (!exists) {
        messages.add(message);
      }
      if (conversationId != null) {
        markConversationAsRead(conversationId);
      }
    }

    _updateConversationPreview(
      conversationId ?? message.conversation,
      message.text,
      message.createdAt,
      message.senderRole,
    );
  }

  void _handleConversationUpdated(Map<String, dynamic> data) {
    final rawConversation = data['conversation'] ?? data['data'] ?? data;
    final conversation = _parseSingleConversation(rawConversation);
    if (conversation != null) {
      _upsertConversation(conversation);
    }
  }

  void _handleMessagesRead(Map<String, dynamic> data) {
    final conversationId = data['conversationId']?.toString();
    if (conversationId != null) {
      _setConversationUnread(conversationId, 0);
    }
  }

  void _upsertConversation(chat_model.ChatItemModel conversation) {
    final index = conversations.indexWhere((item) => item.id == conversation.id);
    if (index == -1) {
      conversations.insert(0, conversation);
    } else {
      conversations[index] = conversation;
      conversations.refresh();
    }
  }

  void _setConversationUnread(String conversationId, int count) {
    final index = conversations.indexWhere((item) => item.id == conversationId);
    if (index == -1) return;

    final old = conversations[index];
    conversations[index] = chat_model.ChatItemModel(
      id: old.id,
      customer: old.customer,
      vendor: old.vendor,
      displayName: old.displayName,
      displayImage: old.displayImage,
      lastMessage: old.lastMessage,
      lastMessageAt: old.lastMessageAt,
      lastMessageSenderRole: old.lastMessageSenderRole,
      unreadCount: count,
      createdAt: old.createdAt,
      updatedAt: old.updatedAt,
    );
  }

  void _updateConversationPreview(
    String? conversationId,
    String? text,
    DateTime? createdAt,
    String? senderRole,
  ) {
    if (conversationId == null) return;
    final index = conversations.indexWhere((item) => item.id == conversationId);
    if (index == -1) return;

    final old = conversations[index];
    final isActive = selectedConversation.value?.id == conversationId;
    conversations[index] = chat_model.ChatItemModel(
      id: old.id,
      customer: old.customer,
      vendor: old.vendor,
      displayName: old.displayName,
      displayImage: old.displayImage,
      lastMessage: text ?? old.lastMessage,
      lastMessageAt: createdAt?.toIso8601String() ?? old.lastMessageAt,
      lastMessageSenderRole: senderRole ?? old.lastMessageSenderRole,
      unreadCount: isActive ? 0 : (old.unreadCount ?? 0) + 1,
      createdAt: old.createdAt,
      updatedAt: old.updatedAt,
    );

    final updated = conversations.removeAt(index);
    conversations.insert(0, updated);
  }

  @override
  void onClose() {
    if (_joinedConversationId != null) {
      socketService.leaveRoom(_joinedConversationId!);
    }
    super.onClose();
  }
}
