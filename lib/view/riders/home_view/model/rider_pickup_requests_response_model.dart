class RiderPickupRequestsResponseModel {
  bool? success;
  String? message;
  RiderPickupRequestsData? data;

  RiderPickupRequestsResponseModel({this.success, this.message, this.data});

  RiderPickupRequestsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? RiderPickupRequestsData.fromJson(json['data'])
        : null;
  }
}

class RiderPickupRequestsData {
  List<RiderPickupRequest>? data;
  RiderPickupRequestsMeta? meta;

  RiderPickupRequestsData({this.data, this.meta});

  RiderPickupRequestsData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RiderPickupRequest>[];
      json['data'].forEach((value) {
        data?.add(RiderPickupRequest.fromJson(value));
      });
    }
    meta = json['meta'] != null
        ? RiderPickupRequestsMeta.fromJson(json['meta'])
        : null;
  }
}

class RiderPickupRequest {
  String? sId;
  RiderPickupOrder? order;
  String? deliveryLocation;
  String? status;

  RiderPickupRequest({
    this.sId,
    this.order,
    this.deliveryLocation,
    this.status,
  });

  RiderPickupRequest.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    order =
        json['order'] != null ? RiderPickupOrder.fromJson(json['order']) : null;
    deliveryLocation = json['delivery_location'];
    status = json['status'];
  }
}

class RiderPickupOrder {
  String? sId;
  RiderPickupCustomer? customer;
  RiderPickupStore? store;
  String? orderId;
  String? paymentMethod;
  num? subtotal;
  num? shippingFee;
  num? total;
  String? status;
  String? paymentStatus;
  List<RiderPickupOrderItem>? items;
  String? billingAddress;
  String? shippingAddress;
  String? fulfillmentType;
  String? createdAt;
  String? updatedAt;

  RiderPickupOrder({
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
  });

  RiderPickupOrder.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customer = json['customer'] != null
        ? RiderPickupCustomer.fromJson(json['customer'])
        : null;
    store =
        json['store'] != null ? RiderPickupStore.fromJson(json['store']) : null;
    orderId = json['order_id'];
    paymentMethod = json['payment_method'];
    subtotal = json['subtotal'];
    shippingFee = json['shipping_fee'];
    total = json['total'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    if (json['items'] != null) {
      items = <RiderPickupOrderItem>[];
      json['items'].forEach((value) {
        items?.add(RiderPickupOrderItem.fromJson(value));
      });
    }
    billingAddress = json['billing_address'];
    shippingAddress = json['shipping_address'];
    fulfillmentType = json['fulfillment_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class RiderPickupCustomer {
  String? sId;
  String? name;

  RiderPickupCustomer({this.sId, this.name});

  RiderPickupCustomer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }
}

class RiderPickupStore {
  RiderPickupLocation? location;
  String? sId;
  String? name;

  RiderPickupStore({this.location, this.sId, this.name});

  RiderPickupStore.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? RiderPickupLocation.fromJson(json['location'])
        : null;
    sId = json['_id'];
    name = json['name'];
  }
}

class RiderPickupLocation {
  String? type;
  List<num>? coordinates;

  RiderPickupLocation({this.type, this.coordinates});

  RiderPickupLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<num>.from(json['coordinates'])
        : null;
  }
}

class RiderPickupOrderItem {
  String? product;
  num? quantity;
  num? discount;
  String? sId;

  RiderPickupOrderItem({this.product, this.quantity, this.discount, this.sId});

  RiderPickupOrderItem.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    quantity = json['quantity'];
    discount = json['discount'];
    sId = json['_id'];
  }
}

class RiderPickupRequestsMeta {
  num? total;
  num? page;
  num? limit;
  num? totalPages;

  RiderPickupRequestsMeta({this.total, this.page, this.limit, this.totalPages});

  RiderPickupRequestsMeta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }
}
