dynamic _readJsonValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key)) {
      return json[key];
    }
  }
  return null;
}

class LoginResponseModel {
  var success;
  var message;
  LoginResponse? data;

  LoginResponseModel({this.success, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new LoginResponse.fromJson(json['data']) : null;
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

class LoginResponse {
  var accessToken;
  var refreshToken;
  LoginResponseSubscription? subscription;
  var hasFreeTrial;

  LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.subscription,
    this.hasFreeTrial,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    subscription = json['subscription'] != null
        ? new LoginResponseSubscription.fromJson(json['subscription'])
        : null;
    hasFreeTrial = _readJsonValue(json, [
      'hasFreeTrial',
      'has_free_trial',
      'has_freeTrial',
    ]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    data['hasFreeTrial'] = this.hasFreeTrial;
    return data;
  }
}

class LoginResponseSubscription {
  var role;
  var monthlyFee;
  var hasActiveSubscription;
  var subscriptionStatus;
  var currentPeriodStart;
  var currentPeriodEnd;
  var cancelAtPeriodEnd;
  LoginResponseUserSubscription? subscription;

  LoginResponseSubscription({
    this.role,
    this.monthlyFee,
    this.hasActiveSubscription,
    this.subscriptionStatus,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.cancelAtPeriodEnd,
    this.subscription,
  });

  LoginResponseSubscription.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    monthlyFee = _readJsonValue(json, ['monthly_fee', 'monthlyFee']);
    hasActiveSubscription = _readJsonValue(json, [
      'has_active_subscription',
      'hasActiveSubscription',
    ]);
    subscriptionStatus = _readJsonValue(json, [
      'subscription_status',
      'subscriptionStatus',
    ]);
    currentPeriodStart = _readJsonValue(json, [
      'current_period_start',
      'currentPeriodStart',
    ]);
    currentPeriodEnd = _readJsonValue(json, [
      'current_period_end',
      'currentPeriodEnd',
    ]);
    cancelAtPeriodEnd = _readJsonValue(json, [
      'cancel_at_period_end',
      'cancelAtPeriodEnd',
    ]);
    subscription = json['subscription'] != null
        ? new LoginResponseUserSubscription.fromJson(json['subscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['monthly_fee'] = this.monthlyFee;
    data['has_active_subscription'] = this.hasActiveSubscription;
    data['subscription_status'] = this.subscriptionStatus;
    data['current_period_start'] = this.currentPeriodStart;
    data['current_period_end'] = this.currentPeriodEnd;
    data['cancel_at_period_end'] = this.cancelAtPeriodEnd;
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    return data;
  }
}

class LoginResponseUserSubscription {
  var sId;
  var email;
  var role;
  var iV;
  var cancelAtPeriodEnd;
  var createdAt;
  var currentPeriodEnd;
  var currentPeriodStart;
  var isDeleted;
  var ownerId;
  var status;
  var stripeCheckoutSessionId;
  var stripeCustomerId;
  var stripePriceId;
  var stripeProductId;
  var stripeSubscriptionId;
  var updatedAt;

  LoginResponseUserSubscription({
    this.sId,
    this.email,
    this.role,
    this.iV,
    this.cancelAtPeriodEnd,
    this.createdAt,
    this.currentPeriodEnd,
    this.currentPeriodStart,
    this.isDeleted,
    this.ownerId,
    this.status,
    this.stripeCheckoutSessionId,
    this.stripeCustomerId,
    this.stripePriceId,
    this.stripeProductId,
    this.stripeSubscriptionId,
    this.updatedAt,
  });

  LoginResponseUserSubscription.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
    iV = json['__v'];
    cancelAtPeriodEnd = json['cancel_at_period_end'];
    createdAt = json['createdAt'];
    currentPeriodEnd = json['current_period_end'];
    currentPeriodStart = json['current_period_start'];
    isDeleted = json['is_deleted'];
    ownerId = json['owner_id'];
    status = json['status'];
    stripeCheckoutSessionId = json['stripe_checkout_session_id'];
    stripeCustomerId = json['stripe_customer_id'];
    stripePriceId = json['stripe_price_id'];
    stripeProductId = json['stripe_product_id'];
    stripeSubscriptionId = json['stripe_subscription_id'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['role'] = this.role;
    data['__v'] = this.iV;
    data['cancel_at_period_end'] = this.cancelAtPeriodEnd;
    data['createdAt'] = this.createdAt;
    data['current_period_end'] = this.currentPeriodEnd;
    data['current_period_start'] = this.currentPeriodStart;
    data['is_deleted'] = this.isDeleted;
    data['owner_id'] = this.ownerId;
    data['status'] = this.status;
    data['stripe_checkout_session_id'] = this.stripeCheckoutSessionId;
    data['stripe_customer_id'] = this.stripeCustomerId;
    data['stripe_price_id'] = this.stripePriceId;
    data['stripe_product_id'] = this.stripeProductId;
    data['stripe_subscription_id'] = this.stripeSubscriptionId;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
