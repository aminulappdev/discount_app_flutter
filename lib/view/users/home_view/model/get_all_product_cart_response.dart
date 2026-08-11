class GetAllProductCartResponse {
  var success;
  var message;
  GetAllProductCart? data;

  GetAllProductCartResponse({this.success, this.message, this.data});

  GetAllProductCartResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new GetAllProductCart.fromJson(json['data']) : null;
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

class GetAllProductCart {
  List<Carts>? carts;
  var totalShippingFee;

  GetAllProductCart({this.carts, this.totalShippingFee});

  GetAllProductCart.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      carts = <Carts>[];
      json['result'].forEach((v) {
        carts!.add(new Carts.fromJson(v));
      });
    }
    totalShippingFee = json['totalShippingFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carts != null) {
      data['result'] = this.carts!.map((v) => v.toJson()).toList();
    }
    data['totalShippingFee'] = this.totalShippingFee;
    return data;
  }
}

class Carts {
  var sId;
  var user;
  Product? product;
  var quantity;
  var subtotal;
  var iV;
  var shippingFee;

  Carts(
      {this.sId,
        this.user,
        this.product,
        this.quantity,
        this.subtotal,
        this.iV,
        this.shippingFee});

  Carts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    subtotal = json['subtotal'];
    iV = json['__v'];
    shippingFee = json['shippingFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['quantity'] = this.quantity;
    data['subtotal'] = this.subtotal;
    data['__v'] = this.iV;
    data['shippingFee'] = this.shippingFee;
    return data;
  }
}

class Product {
  var sId;
  var name;
  List<String>? images;
  Store? store;
  var price;
  var discount;

  Product({
    this.sId,
    this.name,
    this.images,
    this.store,
    this.price,
    this.discount,
  });

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    images = json['images'].cast<String>();
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    price = json['price'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['images'] = this.images;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    data['price'] = this.price;
    data['discount'] = this.discount;
    return data;
  }
}

class Store {
  ProductStoreLocation? location;
  var sId;

  Store({this.location, this.sId});

  Store.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new ProductStoreLocation.fromJson(json['location'])
        : null;
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    return data;
  }
}

class ProductStoreLocation {
  var type;
  List<double>? coordinates;

  ProductStoreLocation({this.type, this.coordinates});

  ProductStoreLocation.fromJson(Map<String, dynamic> json) {
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
