class GetMyVouchersResponseModel {
  bool? success;
  String? message;
  List<VoucherData>? data;

  GetMyVouchersResponseModel({this.success, this.message, this.data});

  GetMyVouchersResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VoucherData>[];
      json['data'].forEach((v) {
        data!.add(VoucherData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VoucherData {
  String? sId;
  VoucherOrder? order;
  String? code;
  String? barcodeUrl;
  String? status;
  String? expiresAt;
  String? usedAt;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  VoucherData({
    this.sId,
    this.order,
    this.code,
    this.barcodeUrl,
    this.status,
    this.expiresAt,
    this.usedAt,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  VoucherData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    order = json['order'] != null ? VoucherOrder.fromJson(json['order']) : null;
    code = json['code'];
    barcodeUrl = json['barcode_url'];
    status = json['status'];
    expiresAt = json['expires_at'];
    usedAt = json['used_at'];
    isDeleted = json['is_deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    data['code'] = code;
    data['barcode_url'] = barcodeUrl;
    data['status'] = status;
    data['expires_at'] = expiresAt;
    data['used_at'] = usedAt;
    data['is_deleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class VoucherOrder {
  String? sId;
  VoucherStore? store;
  String? orderId;
  num? total;
  String? status;
  String? createdAt;

  VoucherOrder({
    this.sId,
    this.store,
    this.orderId,
    this.total,
    this.status,
    this.createdAt,
  });

  VoucherOrder.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    store = json['store'] != null ? VoucherStore.fromJson(json['store']) : null;
    orderId = json['order_id'];
    total = json['total'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    data['order_id'] = orderId;
    data['total'] = total;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}

class VoucherStore {
  String? sId;
  String? name;

  VoucherStore({this.sId, this.name});

  VoucherStore.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}
