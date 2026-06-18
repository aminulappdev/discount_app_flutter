class ChatModel {
    ChatModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool? success;
    final String? message;
    final Data? data;

    factory ChatModel.fromJson(Map<String, dynamic> json){ 
        return ChatModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.data,
        required this.meta,
    });

    final List<ChatItemModel> data;
    final Meta? meta;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            data: json["data"] == null ? [] : List<ChatItemModel>.from(json["data"]!.map((x) => ChatItemModel.fromJson(x))),
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        );
    }

}

class ChatItemModel {
    ChatItemModel({
        required this.id,
        required this.customer,
        required this.vendor,
        required this.displayName,
        required this.displayImage,
        required this.lastMessage,
        required this.lastMessageAt,
        required this.lastMessageSenderRole,
        required this.unreadCount,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final Customer? customer;
    final Vendor? vendor;
    final String? displayName;
    final String? displayImage;
    final dynamic lastMessage;
    final dynamic lastMessageAt;
    final dynamic lastMessageSenderRole;
    final int? unreadCount;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory ChatItemModel.fromJson(Map<String, dynamic> json){ 
        return ChatItemModel(
            id: json["_id"],
            customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
            vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
            displayName: json["display_name"],
            displayImage: json["display_image"],
            lastMessage: json["last_message"],
            lastMessageAt: json["last_message_at"],
            lastMessageSenderRole: json["last_message_sender_role"],
            unreadCount: json["unread_count"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

}

class Customer {
    Customer({
        required this.id,
        required this.name,
        required this.image,
        required this.email,
    });

    final String? id;
    final String? name;
    final String? image;
    final String? email;

    factory Customer.fromJson(Map<String, dynamic> json){ 
        return Customer(
            id: json["_id"],
            name: json["name"],
            image: json["image"],
            email: json["email"],
        );
    }

}

class Vendor {
    Vendor({
        required this.id,
        required this.email,
        required this.contact,
        required this.store,
    });

    final String? id;
    final String? email;
    final dynamic contact;
    final Store? store;

    factory Vendor.fromJson(Map<String, dynamic> json){ 
        return Vendor(
            id: json["_id"],
            email: json["email"],
            contact: json["contact"],
            store: json["store"] == null ? null : Store.fromJson(json["store"]),
        );
    }

}

class Store {
    Store({
        required this.id,
        required this.name,
        required this.coverImages,
    });

    final String? id;
    final String? name;
    final List<String> coverImages;

    factory Store.fromJson(Map<String, dynamic> json){ 
        return Store(
            id: json["_id"],
            name: json["name"],
            coverImages: json["cover_images"] == null ? [] : List<String>.from(json["cover_images"]!.map((x) => x)),
        );
    }

}

class Meta {
    Meta({
        required this.total,
    });

    final int? total;

    factory Meta.fromJson(Map<String, dynamic> json){ 
        return Meta(
            total: json["total"],
        );
    }

}
