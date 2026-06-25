class SingleStoreResponseModel {
  var success;
  var message;
  SingleStoreResponse? data;

  SingleStoreResponseModel({this.success, this.message, this.data});

  SingleStoreResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new SingleStoreResponse.fromJson(json['data']) : null;
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

class SingleStoreResponse {
  var sId;
  var name;
  List<String>? coverImages;
  StoreLocation? location;
  var ratings;
  var description;
  var vendorId;
  List<StoreCategories>? categories;
  var isBlocked;
  var isDeleted;
  var createdAt;
  var updatedAt;
  var iV;

  SingleStoreResponse({
    this.sId,
    this.name,
    this.coverImages,
    this.location,
    this.ratings,
    this.description,
    this.vendorId,
    this.categories,
    this.isBlocked,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV
  });

  SingleStoreResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    coverImages = json['cover_images'].cast<String>();
    location = json['location'] != null
        ? new StoreLocation.fromJson(json['location'])
        : null;
    ratings = json['ratings'];
    description = json['description'];
    vendorId = _readId(json['vendorId']) ??
        _readId(json['vendor_id']) ??
        _readId(json['ownerId']) ??
        _readId(json['owner_id']) ??
        _readId(json['vendor']) ??
        _readId(json['owner']) ??
        _readId(json['createdBy']) ??
        _readId(json['created_by']);
    if (json['categories'] != null) {
      categories = <StoreCategories>[];
      json['categories'].forEach((v) {
        categories!.add(new StoreCategories.fromJson(v));
      });
    }
    isBlocked = json['is_blocked'];
    isDeleted = json['is_deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['cover_images'] = this.coverImages;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['ratings'] = this.ratings;
    data['description'] = this.description;
    data['vendorId'] = this.vendorId;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['is_blocked'] = this.isBlocked;
    data['is_deleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }

  String? _readId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) {
      return value['_id']?.toString() ??
          value['id']?.toString() ??
          value['sId']?.toString();
    }
    return value.toString();
  }
}

class StoreLocation {
  var type;
  List<double>? coordinates;

  StoreLocation({this.type, this.coordinates});

  StoreLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class StoreCategories {
  var sId;
  var name;
  var icon;

  StoreCategories({this.sId, this.name, this.icon});

  StoreCategories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}
