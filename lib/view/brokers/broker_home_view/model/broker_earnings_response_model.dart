class BrokerEarningsResponseModel {
  var success;
  var message;
  BrokerEarningsData? data;

  BrokerEarningsResponseModel({this.success, this.message, this.data});

  BrokerEarningsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? BrokerEarningsData.fromJson(json['data']) : null;
  }
}

class BrokerEarningsData {
  List<BrokerEarningItem>? data;
  BrokerEarningsMeta? meta;

  BrokerEarningsData({this.data, this.meta});

  BrokerEarningsData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BrokerEarningItem>[];
      for (final item in json['data']) {
        data!.add(BrokerEarningItem.fromJson(item));
      }
    }
    meta = json['meta'] != null ? BrokerEarningsMeta.fromJson(json['meta']) : null;
  }
}

class BrokerEarningItem {
  var payerName;
  var payerImage;
  var transactionId;
  var date;
  var amount;
  var companyFee;

  BrokerEarningItem({
    this.payerName,
    this.payerImage,
    this.transactionId,
    this.date,
    this.amount,
    this.companyFee,
  });

  BrokerEarningItem.fromJson(Map<String, dynamic> json) {
    payerName = json['payer_name'];
    payerImage = json['payer_image'];
    transactionId = json['transaction_id'];
    date = json['date'];
    amount = json['amount'];
    companyFee = json['company_fee'];
  }
}

class BrokerEarningsMeta {
  var total;
  var page;
  var limit;
  var totalPages;

  BrokerEarningsMeta({this.total, this.page, this.limit, this.totalPages});

  BrokerEarningsMeta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }
}
