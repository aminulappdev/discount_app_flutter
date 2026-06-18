import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:discount_me_app/view/users/home_view/model/user_billing_address_response_model.dart';
import 'package:discount_me_app/view/users/home_view/model/user_shipping_address_response_model.dart';
import 'package:discount_me_app/view/users/home_view/view/order_payment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../res/res.dart';
import 'package:discount_me_app/view/view.dart';
import '../../../../utils/utils.dart';


class OrderSelectAddressController extends GetxController {

  Rx<GetAllProductCartResponse> getAllProductCartResponse = GetAllProductCartResponse().obs;
  RxBool isLoading = false.obs;
  RxBool isSubmit = false.obs;
  RxDouble subTotal = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxDouble shippingFee = 0.0.obs;
  RxDouble total = 0.0.obs;
  Rx<UserBillingAddressResponseModel> userBillingAddressResponseModel = UserBillingAddressResponseModel().obs;
  Rx<UserShippingAddressResponseModel> userShippingAddressResponseModel = UserShippingAddressResponseModel().obs;
  RxString fulfillmentType = "delivery".obs;
  final List<String> fulfillmentTypes = ["delivery", "pickup", "dine_in"];

  //Billing Address
  Rx<TextEditingController> billingNameController = TextEditingController().obs;
  Rx<TextEditingController> billingCompanyNameController = TextEditingController().obs;
  Rx<TextEditingController> billingStreetAddressController = TextEditingController().obs;
  Rx<TextEditingController> billingCountryController = TextEditingController().obs;
  Rx<TextEditingController> billingStateController = TextEditingController().obs;
  Rx<TextEditingController> billingCityController = TextEditingController().obs;
  Rx<TextEditingController> billingZipCodeController = TextEditingController().obs;
  Rx<TextEditingController> billingHouseNoController = TextEditingController().obs;
  Rx<TextEditingController> billingEmailController = TextEditingController().obs;
  Rx<TextEditingController> billingPhoneController = TextEditingController().obs;


  //Shipping Address
  Rx<TextEditingController> shippingNameController = TextEditingController().obs;
  Rx<TextEditingController> shippingEmailController = TextEditingController().obs;
  Rx<TextEditingController> shippingPhoneController = TextEditingController().obs;
  Rx<TextEditingController> shippingAddressController = TextEditingController().obs;

  BuildContext context;
  String pickAddress;

  // RxList<RadioValueClass> paymentType = <RadioValueClass>[
  //   RadioValueClass(value: "stripe",name: "Stripe")
  // ].obs;
  //
  // Rx<RadioValueClass> selectPaymentType = RadioValueClass(name: '', value: '').obs;

  OrderSelectAddressController({required this.context,required this.pickAddress});

  bool get isDelivery => fulfillmentType.value == "delivery";

  void setFulfillmentType(String value) {
    fulfillmentType.value = value;
    if (value != "delivery") {
      clearShippingAddress();
    } else {
      shippingNameController.value.text = userShippingAddressResponseModel.value.data?.name ?? "";
      shippingEmailController.value.text = userShippingAddressResponseModel.value.data?.email ?? "";
      shippingPhoneController.value.text = userShippingAddressResponseModel.value.data?.phone ?? "";
      shippingAddressController.value.text = pickAddress;
    }
  }

  void clearShippingAddress() {
    shippingNameController.value.clear();
    shippingEmailController.value.clear();
    shippingPhoneController.value.clear();
    shippingAddressController.value.clear();
  }

  void setPickedShippingAddress(String address) {
    pickAddress = address;
    shippingAddressController.value.text = address;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    shippingAddressController.value.text = pickAddress;
    Future.delayed(Duration(seconds: 1),() async {
      await addToCartResponse(
        onSuccess: (e) async {
          getAllProductCartResponse.value = GetAllProductCartResponse.fromJson(e);
          getAllProductCartResponse.value.data?.carts?.forEach((e){
            total.value = total.value + double.parse(e.subtotal.toString());
            shippingFee.value = shippingFee.value + double.parse(e.shippingFee.toString());
          });
          subTotal.value = total.value + shippingFee.value + discount.value;
        },
        onFail: (e) async {
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
        },
        onExceptionFail: (e) async {
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
          if(e == "jwt expired") {
            await AppLocalStorage.removeKey(key: "Login");
            Get.off(()=>SignInView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
          }
        },
      );
      await getBillingAddressController(context: context);
      await getShippingAddressController(context: context);
    });
  }


  static Future<void> addToCartResponse({
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail
  }) async {
    try{

      LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);


      print("${AppApiUrl.serverLinkUrl()}carts");
      var response = await Dio().get(
        "${AppApiUrl.serverLinkUrl()}carts",
        options: Options(headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${loginResponseModel.data?.accessToken}'
        }),
      );
      print(response.data);
      if(response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data);
      }else {
        onFail(response.data["message"]);
      }
    } on DioException catch (e) {
      onExceptionFail(e.response?.data["message"]);
    }

  }


  Future<void> getBillingAddressController({
    required BuildContext context,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.billingAddress,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        userBillingAddressResponseModel.value = UserBillingAddressResponseModel.fromJson(data);
        billingNameController.value.text = userBillingAddressResponseModel.value.data?.name ?? "";
        billingCompanyNameController.value.text = userBillingAddressResponseModel.value.data?.companyName ?? "";
        billingStreetAddressController.value.text = userBillingAddressResponseModel.value.data?.streetAddress ?? "";
        billingCountryController.value.text = userBillingAddressResponseModel.value.data?.country ?? "";
        billingStateController.value.text = userBillingAddressResponseModel.value.data?.state ?? "";
        billingCityController.value.text = userBillingAddressResponseModel.value.data?.city ?? "";
        billingZipCodeController.value.text = userBillingAddressResponseModel.value.data?.zipCode ?? "";
        billingHouseNoController.value.text = userBillingAddressResponseModel.value.data?.houseNo ?? "";
        billingEmailController.value.text = userBillingAddressResponseModel.value.data?.email ?? "";
        billingPhoneController.value.text =  userBillingAddressResponseModel.value.data?.phone ?? "";
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isLoading.value = false;
      },
      onExceptionFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isLoading.value = false;
      },
    );

  }

  Future<void> getShippingAddressController({
    required BuildContext context,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.shippingAddress,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        userShippingAddressResponseModel.value = UserShippingAddressResponseModel.fromJson(data);
        if (isDelivery) {
          shippingNameController.value.text = userShippingAddressResponseModel.value.data?.name ?? "";
          shippingEmailController.value.text = userShippingAddressResponseModel.value.data?.email ?? "";
          shippingPhoneController.value.text = userShippingAddressResponseModel.value.data?.phone ?? "";
        } else {
          clearShippingAddress();
        }
        isLoading.value = false;
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isLoading.value = false;
      },
      onExceptionFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isLoading.value = false;
      },
    );

  }

  Future<void> createPaymentController({
    required BuildContext context,
    required double pointsToRedeem,
  }) async {

    isSubmit.value = true;

    List<Map<String,dynamic>> items = [];
    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    getAllProductCartResponse.value.data?.carts?.forEach((value) {
      items.add({
        "product": value.product?.sId,
        "store": value.product?.store?.sId,
        "name": value.product?.name,
        "shipping_fee": value.shippingFee,
        "amount": value.product?.price,
        "quantity": value.quantity,
      }); 
    });

    Map<String,dynamic> data = {
      "payment_status": "unpaid",
      "payment_method": "stripe",
      "fulfillment_type": fulfillmentType.value,
      "pointsToRedeem": pointsToRedeem,
      "items": items,
      "billing_address": {
        "name": billingNameController.value.text,
        "company_name": billingCompanyNameController.value.text,
        "street_address": billingStreetAddressController.value.text,
        "country": billingCountryController.value.text,
        "state": billingStateController.value.text,
        "city": billingCityController.value.text,
        "zip_code": billingZipCodeController.value.text,
        "house_no": billingHouseNoController.value.text,
        "email": billingEmailController.value.text,
        "phone": billingPhoneController.value.text,
      }
    };

    if (isDelivery) {
      data["shipping_address"] = {
        "name": shippingNameController.value.text,
        "email": shippingEmailController.value.text,
        "phone": shippingPhoneController.value.text,
        "address": shippingAddressController.value.text,
      };
    }
    debugPrint(jsonEncode(data));

    print(data);

    await BaseApiUtils.post(
      url: ApiUtils.createPaymentResponse,
      data: data,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        final paymentData = data is Map ? data["data"] : null;
        final paymentUrl = paymentData is Map ? paymentData["url"]?.toString() ?? "" : "";

        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        _goToPaymentView(paymentUrl);
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
      },
      onExceptionFail: (e,data) {
        print(data);
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
      },
    );

  }

  void _goToPaymentView(String paymentUrl) {
    if (paymentUrl.isEmpty) {
      MessageSnackBarWidget.errorSnackBarWidget(
        context: context,
        message: "Payment URL not found",
      );
      return;
    }

    Get.off(
      () => OrderPaymentView(
        paymentUrl: paymentUrl,
        fulfillmentType: fulfillmentType.value,
      ),
      duration: const Duration(milliseconds: 100),
      preventDuplicates: false,
    );
  }



}


// class RadioValueClass {
//   String? name;
//   String? value;
//
//   RadioValueClass({required this.name,required this.value});
// }
