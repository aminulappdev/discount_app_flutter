class MessageModel {
  MessageModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({required this.data, required this.meta});

  final List<MessageItemModel> data;
  final Meta? meta;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      data: json["data"] == null
          ? []
          : List<MessageItemModel>.from(
              json["data"]!.map((x) => MessageItemModel.fromJson(x)),
            ),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );
  }
}

class MessageItemModel {
  MessageItemModel({
    required this.id,
    required this.conversation,
    required this.senderEmail,
    required this.senderRole,
    required this.receiverEmail,
    required this.text,
    required this.isRead,
    required this.readAt,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? conversation;
  final String? senderEmail;
  final String? senderRole;
  final String? receiverEmail;
  final String? text;
  final bool? isRead;
  final dynamic readAt;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory MessageItemModel.fromJson(Map<String, dynamic> json) {
    return MessageItemModel(
      id: json["_id"],
      conversation: json["conversation"],
      senderEmail: json["sender_email"],
      senderRole: json["sender_role"],
      receiverEmail: json["receiver_email"],
      text: json["text"],
      isRead: json["is_read"],
      readAt: json["read_at"],
      isDeleted: json["is_deleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}

class Meta {
  Meta({required this.total});

  final int? total;

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(total: json["total"]);
  }
}
