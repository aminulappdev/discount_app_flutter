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

class RiderPickupRequestDetailsResponseModel {
  bool? success;
  String? message;
  RiderPickupRequest? data;

  RiderPickupRequestDetailsResponseModel({this.success, this.message, this.data});

  RiderPickupRequestDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? RiderPickupRequest.fromJson(json['data']) : null;
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
  RiderPickupCoordinates? deliveryCoordinates;
  RiderPickupCoordinates? storeCoordinates;
  String? sId;
  RiderPickupOrder? order;
  String? deliveryLocation;
  String? status;
  List<dynamic>? rejections;
  String? deliveryProofImage;
  bool? isCancelled;

  RiderPickupRequest({
    this.deliveryCoordinates,
    this.storeCoordinates,
    this.sId,
    this.order,
    this.deliveryLocation,
    this.status,
    this.rejections,
    this.deliveryProofImage,
    this.isCancelled,
  });

  RiderPickupRequest.fromJson(Map<String, dynamic> json) {
    deliveryCoordinates = _coordinatesFromJson(json['delivery_coordinates']);
    storeCoordinates = _coordinatesFromJson(json['store_coordinates']);
    sId = json['_id'];
    order =
        json['order'] != null ? RiderPickupOrder.fromJson(json['order']) : null;
    deliveryLocation = json['delivery_location'];
    status = json['status'];
    rejections = json['rejections'] != null
        ? List<dynamic>.from(json['rejections'])
        : null;
    deliveryProofImage = json['delivery_proof_image'];
    isCancelled = json['isCancelled'];
  }

  RiderPickupCoordinates? _coordinatesFromJson(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return RiderPickupCoordinates.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
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
  RiderPickupAddress? billingAddress;
  RiderPickupAddress? shippingAddress;
  String? fulfillmentType;
  dynamic firstResponderType;
  num? firstResponderDiscountPercentage;
  num? rewardPointsDiscountPercentage;
  num? appliedDiscountPercentage;
  String? stripeCheckoutSessionId;
  String? createdAt;
  String? updatedAt;
  num? iV;

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
    this.firstResponderType,
    this.firstResponderDiscountPercentage,
    this.rewardPointsDiscountPercentage,
    this.appliedDiscountPercentage,
    this.stripeCheckoutSessionId,
    this.createdAt,
    this.updatedAt,
    this.iV,
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
    billingAddress = _addressFromJson(json['billing_address']);
    shippingAddress = _addressFromJson(json['shipping_address']);
    fulfillmentType = json['fulfillment_type'];
    firstResponderType = json['first_responder_type'];
    firstResponderDiscountPercentage =
        json['first_responder_discount_percentage'];
    rewardPointsDiscountPercentage =
        json['reward_points_discount_percentage'];
    appliedDiscountPercentage = json['applied_discount_percentage'];
    stripeCheckoutSessionId = json['stripe_checkout_session_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  RiderPickupAddress? _addressFromJson(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) {
      return RiderPickupAddress.fromJson(value);
    }
    return RiderPickupAddress(sId: value.toString());
  }
}

class RiderPickupCustomer {
  String? sId;
  String? name;
  String? image;
  String? contact;

  RiderPickupCustomer({this.sId, this.name, this.image, this.contact});

  RiderPickupCustomer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
    contact = json['contact'];
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

class RiderPickupCoordinates {
  num? latitude;
  num? longitude;

  RiderPickupCoordinates({this.latitude, this.longitude});

  RiderPickupCoordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
}

class RiderPickupOrderItem {
  RiderPickupProduct? product;
  num? quantity;
  num? discount;
  String? sId;

  RiderPickupOrderItem({this.product, this.quantity, this.discount, this.sId});

  RiderPickupOrderItem.fromJson(Map<String, dynamic> json) {
    product = _productFromJson(json['product']);
    quantity = json['quantity'];
    discount = json['discount'];
    sId = json['_id'];
  }

  RiderPickupProduct? _productFromJson(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) {
      return RiderPickupProduct.fromJson(value);
    }
    return RiderPickupProduct(sId: value.toString());
  }
}

class RiderPickupProduct {
  String? sId;
  String? name;
  List<String>? images;

  RiderPickupProduct({this.sId, this.name, this.images});

  RiderPickupProduct.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
  }
}

class RiderPickupAddress {
  RiderPickupCoordinates? locationCoordinates;
  String? sId;
  String? user;
  String? name;
  String? email;
  String? phone;
  String? companyName;
  String? streetAddress;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? houseNo;
  String? address;
  String? createdAt;
  String? updatedAt;
  num? iV;

  RiderPickupAddress({
    this.locationCoordinates,
    this.sId,
    this.user,
    this.name,
    this.email,
    this.phone,
    this.companyName,
    this.streetAddress,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.houseNo,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  RiderPickupAddress.fromJson(Map<String, dynamic> json) {
    locationCoordinates = _coordinatesFromJson(json['location_coordinates']);
    sId = json['_id'];
    user = json['user'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    companyName = json['company_name'];
    streetAddress = json['street_address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    zipCode = json['zip_code'];
    houseNo = json['house_no'];
    address = json['address'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  RiderPickupCoordinates? _coordinatesFromJson(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return RiderPickupCoordinates.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
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
