class ApiUtils {

  //static const baseUrl = "http://206.162.244.133:5020/api/v1";
  static const baseUrl = "http://10.10.10.25:5001/api/v1";
  static const socketUrl = "http://10.10.10.25:5001/";
  //static const baseUrl = "http://10.10.10.16:5020/api/v1";


  //user
  static const String loginResponse = "$baseUrl/auth/login";
  static const String createPaymentResponse = "$baseUrl/payments/create-payment-session"; //done
  static const String createCheckoutSession = "$baseUrl/subscriptions/create-checkout-session"; //done
  static const String createOrderResponse = "$baseUrl/orders";//done
  static const String riderProfile = "$baseUrl/riders/profile";//done
  static const String brokersProfile = "$baseUrl/brokers/profile";//done
  static const String brokerSignUp = "$baseUrl/auth/broker-sign-up";//done
  static const String vendorSignUp = "$baseUrl/auth/vendor-sign-up";//done
  static const String riderSignUp = "$baseUrl/auth/rider-sign-up";//done
  static const String userSignUp = "$baseUrl/auth/user-sign-up";//done
  static const String verifyOtp = "$baseUrl/auth/verify-otp";//done
  static const String sendOtp = "$baseUrl/auth/send-otp";//done
  static const String forgotEmailOtp = "$baseUrl/auth/send-otp";//done
  static const String resetForgottenPassword = "$baseUrl/auth/reset-forgotten-password";


  static String riderProfileUpdate(String riderId) {
    return "$baseUrl/riders/$riderId";
  }
  static String riderProfileDelete(String riderId) {
    return "$baseUrl/riders/$riderId";
  }
  static String vendorProfileUpdate(String vendorId) {
    return "$baseUrl/vendors/$vendorId";
  }
  static String vendorProfileDelete(String vendorId) {
    return "$baseUrl/vendors/$vendorId";
  }
  static String productDetails(String productId) {
    return "$baseUrl/products/$productId";
  }
  static String productEdit(String productId) {
    return "$baseUrl/products/$productId";
  }
  static String productDelete(String productId) {
    return "$baseUrl/products/$productId";
  }
  static String storeWiseProduct(String storeId) {
    return "$baseUrl/products?sort=-ratings&store=${storeId}";
  }
  static String categoryWiseProduct(String storeId,String categoryId) {
    return "$baseUrl/products?sort=-ratings&store=${storeId}&category=${categoryId}";
  }
  static String editBrokerProfile(String brokersId) {
    return "$baseUrl/brokers/${brokersId}";
  }
  static String deleteBrokerProfile(String brokersId) {
    return "$baseUrl/brokers/${brokersId}";
  }
  static String deleteUserProfile(String userId) {
    return "$baseUrl/users/${userId}";
  }
  static String getOrderDetails(String orderId) {
    return "$baseUrl/orders/${orderId}";
  }
  static String getCategoryWiseProducts(String categoryId) {
    return "$baseUrl/products?category=${categoryId}";
  }
  static String getIncreaseCartItem(String productId) {
    return "$baseUrl/carts/increase/${productId}";
  }
  static String getDecreaseCartItem(String productId) {
    return "$baseUrl/carts/decrease/${productId}";
  }
  static String getDeleteCart(String cardId) {
    return "$baseUrl/carts/${cardId}";
  }
  static String getProductsByCategoryApiService(String categoryId) {
    return "$baseUrl/products?category=${categoryId}";
  }
  static String getProductsByStoreApiService(String storeId) {
    return "$baseUrl/products?store=${storeId}";
  }








  static const String getAllSetting = "$baseUrl/settings";


  static const String getAllOrdersResponse = "$baseUrl/orders/user";
  static const String riderChangePassword = "$baseUrl/auth/change-password";
  static const String changePassword = "$baseUrl/auth/change-password";
  static const String billingAddress = "$baseUrl/billing-address";
  static const String shippingAddress = "$baseUrl/shipping-address";
  static const String categoriesResponse = "$baseUrl/categories";
  static const String editUserProfile = "$baseUrl/users";
  static const String vendorsProfile = "$baseUrl/vendors/profile"; //done
  static const String getAllProductsResponse = "$baseUrl/products?sort=-ratings"; //done
  static const String getAllExploreProductsResponse = "$baseUrl/products?sort=-ratings"; //done
  static const String getAllStoresResponse = "$baseUrl/stores?sort=-ratings"; //done
  static const String getUserProfileResponse = "$baseUrl/users/profile"; //done
  static const String getAllBannerResponse = "$baseUrl/banners"; //done
  static const String addToCartResponse = "$baseUrl/carts"; //done
  static const String getAddToCartResponse = "$baseUrl/carts"; //done
  static const String getAllProductResponse = "$baseUrl/products"; //done








}