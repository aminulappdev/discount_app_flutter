class UserProfileResponseModel {
  var success;
  var message;
  UserProfileResponse? data;

  UserProfileResponseModel({this.success, this.message, this.data});

  UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserProfileResponse.fromJson(json['data']) : null;
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

class UserProfileResponse {
  var sId;
  var name;
  var image;
  var email;
  var location;
  var contact;
  var isCbtHolder;
  var document;
  var firstResponderType;
  var firstResponderStatus;
  var isApproved;
  var isBlocked;
  var isDeleted;
  List<UserRewardPoint>? rewardPoints;
  var createdAt;
  var updatedAt;
  var iV;
  var totalRewardPoints;
  var firstResponderDiscountPercentage;

  UserProfileResponse({
    this.sId,
    this.name,
    this.image,
    this.email,
    this.location,
    this.contact,
    this.isCbtHolder,
    this.document,
    this.firstResponderType,
    this.firstResponderStatus,
    this.isApproved,
    this.isBlocked,
    this.isDeleted,
    this.rewardPoints,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.totalRewardPoints,
    this.firstResponderDiscountPercentage,
  });

  UserProfileResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    location = json['location'];
    contact = json['contact'];
    isCbtHolder = json['isCbtHolder'];
    document = json['document'];
    firstResponderType = json['first_responder_type'];
    firstResponderStatus = json['first_responder_status'];
    isApproved = json['is_approved'];
    isBlocked = json['is_blocked'];
    isDeleted = json['is_deleted'];
    if (json['rewardPoints'] != null) {
      rewardPoints = <UserRewardPoint>[];
      json['rewardPoints'].forEach((v) {
        rewardPoints!.add(UserRewardPoint.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    totalRewardPoints = json['totalRewardPoints'];
    firstResponderDiscountPercentage = json['firstResponderDiscountPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['location'] = this.location;
    data['contact'] = this.contact;
    data['isCbtHolder'] = this.isCbtHolder;
    data['document'] = this.document;
    data['first_responder_type'] = this.firstResponderType;
    data['first_responder_status'] = this.firstResponderStatus;
    data['is_approved'] = this.isApproved;
    data['is_blocked'] = this.isBlocked;
    data['is_deleted'] = this.isDeleted;
    if (this.rewardPoints != null) {
      data['rewardPoints'] = this.rewardPoints!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['totalRewardPoints'] = this.totalRewardPoints;
    data['firstResponderDiscountPercentage'] =
        this.firstResponderDiscountPercentage;
    return data;
  }
}

class UserRewardPoint {
  var points;
  var remainingPoints;
  var earnedAt;
  var expiresAt;

  UserRewardPoint({
    this.points,
    this.remainingPoints,
    this.earnedAt,
    this.expiresAt,
  });

  UserRewardPoint.fromJson(Map<String, dynamic> json) {
    points = json['points'];
    remainingPoints = json['remainingPoints'];
    earnedAt = json['earnedAt'];
    expiresAt = json['expiresAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points'] = this.points;
    data['remainingPoints'] = this.remainingPoints;
    data['earnedAt'] = this.earnedAt;
    data['expiresAt'] = this.expiresAt;
    return data;
  }
}
