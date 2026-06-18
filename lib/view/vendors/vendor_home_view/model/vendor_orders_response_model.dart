class VendorOrdersResponseModel {
  bool? success;
  String? message;
  VendorOrdersData? data;

  VendorOrdersResponseModel({this.success, this.message, this.data});

  VendorOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? VendorOrdersData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class VendorOrdersData {
  List<VendorOrderData>? data;
  VendorOrdersMeta? meta;

  VendorOrdersData({this.data, this.meta});

  VendorOrdersData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VendorOrderData>[];
      json['data'].forEach((v) {
        data!.add(VendorOrderData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? VendorOrdersMeta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class VendorOrderData {
  String? sId;
  VendorOrderCustomer? customer;
  String? store;
  String? orderId;
  String? paymentMethod;
  num? subtotal;
  num? shippingFee;
  num? total;
  String? status;
  String? paymentStatus;
  List<VendorOrderItem>? items;
  dynamic billingAddress;
  dynamic shippingAddress;
  String? fulfillmentType;
  String? createdAt;
  String? updatedAt;
  int? iV;

  VendorOrderData({
    this.sId,
    this.customer,
    this.store,
    this.orderId,
    this.paymentMethod,
    this.subtotal,
    this.shippingFee,
    this.total,
    this.status,
    this.paymentStatus,
    this.items,
    this.billingAddress,
    this.shippingAddress,
    this.fulfillmentType,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  VendorOrderData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customer = json['customer'] != null
        ? VendorOrderCustomer.fromJson(json['customer'])
        : null;
    store = json['store'];
    orderId = json['order_id'];
    paymentMethod = json['payment_method'];
    subtotal = json['subtotal'];
    shippingFee = json['shipping_fee'];
    total = json['total'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    if (json['items'] != null) {
      items = <VendorOrderItem>[];
      json['items'].forEach((v) {
        items!.add(VendorOrderItem.fromJson(v));
      });
    }
    billingAddress = json['billing_address'];
    shippingAddress = json['shipping_address'];
    fulfillmentType = json['fulfillment_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['store'] = store;
    data['order_id'] = orderId;
    data['payment_method'] = paymentMethod;
    data['subtotal'] = subtotal;
    data['shipping_fee'] = shippingFee;
    data['total'] = total;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['billing_address'] = billingAddress;
    data['shipping_address'] = shippingAddress;
    data['fulfillment_type'] = fulfillmentType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class VendorOrderCustomer {
  String? sId;
  String? name;
  String? email;

  VendorOrderCustomer({this.sId, this.name, this.email});

  VendorOrderCustomer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}

class VendorOrderItem {
  String? product;
  num? quantity;
  num? discount;
  String? sId;

  VendorOrderItem({this.product, this.quantity, this.discount, this.sId});

  VendorOrderItem.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    quantity = json['quantity'];
    discount = json['discount'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['quantity'] = quantity;
    data['discount'] = discount;
    data['_id'] = sId;
    return data;
  }
}

class VendorOrdersMeta {
  int? total;

  VendorOrdersMeta({this.total});

  VendorOrdersMeta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    return data;
  }
}

class VendorOrderListItem {
  final String id;
  final String orderId;
  final String customerName;
  final String productName;
  final String image;
  final double amount;
  final String date;
  final String status;
  final String paymentStatus;
  final String fulfillmentType;

  VendorOrderListItem({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.productName,
    required this.image,
    required this.amount,
    required this.date,
    required this.status,
    required this.paymentStatus,
    required this.fulfillmentType,
  });
}
