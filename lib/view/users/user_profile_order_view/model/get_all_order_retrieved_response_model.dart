class GetAllOrderRetrievedResponseModel {
  var success;
  var message;
  GetAllOrderRetrievedResponseData? data;

  GetAllOrderRetrievedResponseModel({this.success, this.message, this.data});

  GetAllOrderRetrievedResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new GetAllOrderRetrievedResponseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetAllOrderRetrievedResponseData {
  List<GetAllOrderRetrievedResponse>? data;
  GetAllOrderRetrievedResponseMeta? meta;

  GetAllOrderRetrievedResponseData({this.data, this.meta});

  GetAllOrderRetrievedResponseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetAllOrderRetrievedResponse>[];
      json['data'].forEach((v) {
        data!.add(new GetAllOrderRetrievedResponse.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new GetAllOrderRetrievedResponseMeta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class GetAllOrderRetrievedResponse {
  var sId;
  var customer;
  var store;
  var orderId;
  var paymentMethod;
  var subtotal;
  var shippingFee;
  var total;
  var status;
  var paymentStatus;
  var fulfillmentType;
  List<GetAllOrderRetrievedResponseItems>? items;
  var billingAddress;
  var shippingAddress;
  var createdAt;
  var updatedAt;
  var iV;

  GetAllOrderRetrievedResponse({
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
    this.fulfillmentType,
    this.items,
    this.billingAddress,
    this.shippingAddress,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  GetAllOrderRetrievedResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customer = json['customer'];
    store = json['store'];
    orderId = json['order_id'];
    paymentMethod = json['payment_method'];
    subtotal = json['subtotal'];
    shippingFee = json['shipping_fee'];
    total = json['total'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    fulfillmentType = json['fulfillment_type'];
    if (json['items'] != null) {
      items = <GetAllOrderRetrievedResponseItems>[];
      json['items'].forEach((v) {
        items!.add(new GetAllOrderRetrievedResponseItems.fromJson(v));
      });
    }
    billingAddress = json['billing_address'];
    shippingAddress = json['shipping_address'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['customer'] = this.customer;
    data['store'] = this.store;
    data['order_id'] = this.orderId;
    data['payment_method'] = this.paymentMethod;
    data['subtotal'] = this.subtotal;
    data['shipping_fee'] = this.shippingFee;
    data['total'] = this.total;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['fulfillment_type'] = this.fulfillmentType;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['billing_address'] = this.billingAddress;
    data['shipping_address'] = this.shippingAddress;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class GetAllOrderRetrievedResponseItems {
  var product;
  var quantity;
  var discount;
  var sId;

  GetAllOrderRetrievedResponseItems({this.product, this.quantity, this.discount, this.sId});

  GetAllOrderRetrievedResponseItems.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    quantity = json['quantity'];
    discount = json['discount'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['_id'] = this.sId;
    return data;
  }
}

class GetAllOrderRetrievedResponseMeta {
  var total;

  GetAllOrderRetrievedResponseMeta({this.total});

  GetAllOrderRetrievedResponseMeta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    return data;
  }
}
