import 'dart:convert';

import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:discount_me_app/view/vendors/vendor_earning_view/model/vendor_earnings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorEarningsController extends GetxController {
  VendorEarningsController({required this.context});

  final BuildContext context;

  RxBool isLoading = false.obs;
  Rx<VendorEarningsResponseModel> vendorEarningsResponseModel =
      VendorEarningsResponseModel().obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(
    jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
  ).obs;

  List<VendorEarningItem> get earnings =>
      vendorEarningsResponseModel.value.data?.data ?? [];

  double get totalBalance {
    return earnings.fold(0.0, (total, item) {
      final amount = double.tryParse(item.amount?.toString() ?? "0") ?? 0;
      final companyFee = double.tryParse(item.companyFee?.toString() ?? "0") ?? 0;
      return total + (amount - companyFee);
    });
  }

  @override
  void onInit() {
    super.onInit();
    getVendorEarningsController(context: context);
  }

  Future<void> getVendorEarningsController({
    required BuildContext context,
  }) async {
    isLoading.value = true;
    await BaseApiUtils.get(
      url: ApiUtils.vendorEarnings,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (message, data) async {
        vendorEarningsResponseModel.value =
            VendorEarningsResponseModel.fromJson(data);
        isLoading.value = false;
      },
      onFail: (message, data) {
        isLoading.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
      onExceptionFail: (message, data) {
        isLoading.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
    );
  }
}
