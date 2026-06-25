class VendorEarningsResponseModel {
  var success;
  var message;
  VendorEarningsData? data;

  VendorEarningsResponseModel({this.success, this.message, this.data});

  VendorEarningsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? VendorEarningsData.fromJson(json['data']) : null;
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

class VendorEarningsData {
  List<VendorEarningItem>? data;
  VendorEarningsMeta? meta;

  VendorEarningsData({this.data, this.meta});

  VendorEarningsData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VendorEarningItem>[];
      json['data'].forEach((v) {
        data!.add(VendorEarningItem.fromJson(v));
      });
    }
    meta = json['meta'] != null ? VendorEarningsMeta.fromJson(json['meta']) : null;
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

class VendorEarningItem {
  var payerName;
  var payerImage;
  var transactionId;
  var date;
  var amount;
  var companyFee;

  VendorEarningItem({
    this.payerName,
    this.payerImage,
    this.transactionId,
    this.date,
    this.amount,
    this.companyFee,
  });

  VendorEarningItem.fromJson(Map<String, dynamic> json) {
    payerName = json['payer_name'];
    payerImage = json['payer_image'];
    transactionId = json['transaction_id'];
    date = json['date'];
    amount = json['amount'];
    companyFee = json['company_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payer_name'] = this.payerName;
    data['payer_image'] = this.payerImage;
    data['transaction_id'] = this.transactionId;
    data['date'] = this.date;
    data['amount'] = this.amount;
    data['company_fee'] = this.companyFee;
    return data;
  }
}

class VendorEarningsMeta {
  var total;
  var page;
  var limit;
  var totalPages;

  VendorEarningsMeta({this.total, this.page, this.limit, this.totalPages});

  VendorEarningsMeta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    return data;
  }
}
