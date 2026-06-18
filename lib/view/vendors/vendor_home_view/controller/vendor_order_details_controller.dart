import 'dart:convert';

import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorOrderDetailsController extends GetxController {
  VendorOrderDetailsController({
    required this.context,
    required this.orderId,
  });

  final BuildContext context;
  final String orderId;

  RxBool isLoading = false.obs;
  Rx<GetOrderDetailsRetrievedResponseModel> orderDetails =
      GetOrderDetailsRetrievedResponseModel().obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(
    jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
  ).obs;
  RxDouble discount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getVendorOrderDetailsController(context: context, orderId: orderId);
  }

  Future<void> getVendorOrderDetailsController({
    required BuildContext context,
    required String orderId,
  }) async {
    isLoading.value = true;
    discount.value = 0.0;

    await BaseApiUtils.get(
      url: ApiUtils.getOrderDetails(orderId),
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e, data) async {
        orderDetails.value = GetOrderDetailsRetrievedResponseModel.fromJson(data);
        orderDetails.value.data?.items?.forEach((value) {
          discount.value +=
              double.tryParse((value.discount ?? 0).toString()) ?? 0.0;
        });
        isLoading.value = false;
      },
      onFail: (e, data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isLoading.value = false;
      },
      onExceptionFail: (e, data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isLoading.value = false;
      },
    );
  }

  double get subTotal {
    double value = 0.0;
    orderDetails.value.data?.items?.forEach((item) {
      final price = double.tryParse((item.product?.price ?? 0).toString()) ?? 0.0;
      final quantity = double.tryParse((item.quantity ?? 0).toString()) ?? 0.0;
      value += price * quantity;
    });
    return value;
  }

  String statusLabel(String? status) {
    if (status == null || status.isEmpty) return "N/A";
    return status[0].toUpperCase() + status.substring(1);
  }

  Color getStatusBackgroundColor(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case "delivered":
        return ColorUtils.greenLightHover;
      case "canceled":
      case "cancelled":
        return const Color(0xffFFE5E5);
      default:
        return const Color(0xfffff9e7);
    }
  }

  Color getStatusTextColor(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case "delivered":
        return ColorUtils.primaryColor;
      case "canceled":
      case "cancelled":
        return const Color(0xffff0000);
      default:
        return const Color(0xffFFC60B);
    }
  }
}
