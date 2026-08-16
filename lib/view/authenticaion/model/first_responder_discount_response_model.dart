class FirstResponderDiscountResponseModel {
  bool? success;
  String? message;
  FirstResponderDiscountData? data;

  FirstResponderDiscountResponseModel({this.success, this.message, this.data});

  FirstResponderDiscountResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    data = json['data'] != null
        ? FirstResponderDiscountData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['success'] = success;
    json['message'] = message;
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

class FirstResponderDiscountData {
  String? id;
  String? key;
  int? v;
  String? createdAt;
  String? updatedAt;
  Map<String, num> discounts;

  FirstResponderDiscountData({
    this.id,
    this.key,
    this.v,
    this.createdAt,
    this.updatedAt,
    Map<String, num>? discounts,
  }) : discounts = discounts ?? <String, num>{};

  FirstResponderDiscountData.fromJson(Map<String, dynamic> json)
      : id = (json['_id'] ?? json['id'])?.toString(),
        key = json['key']?.toString(),
        v = json['__v'] is num ? (json['__v'] as num).toInt() : null,
        createdAt = json['createdAt']?.toString(),
        updatedAt = json['updatedAt']?.toString(),
        discounts = <String, num>{} {
    for (final entry in json.entries) {
      if (_isDiscountField(entry.key) && entry.value is num) {
        discounts[entry.key] = entry.value as num;
      }
    }
  }

  static bool _isDiscountField(String key) {
    const ignoredKeys = <String>{
      '_id',
      'key',
      '__v',
      'createdAt',
      'updatedAt',
    };
    return !ignoredKeys.contains(key);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      '_id': id,
      'id': id,
      'key': key,
      '__v': v,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
    json.addAll(discounts);
    return json;
  }

  List<String> get roles => discounts.keys.toList();
}
