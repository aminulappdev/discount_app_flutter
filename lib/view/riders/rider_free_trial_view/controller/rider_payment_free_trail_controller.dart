import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';

class RiderPaymentFreeTrailController extends GetxController {
  RxBool isHandlingPayment = false.obs;

  Future<void> getPaymentController({
    required BuildContext context,
    required String paymentUrl
  }) async {
    if (isHandlingPayment.value) return;
    isHandlingPayment.value = true;

    BaseApiUtils.get(
      url: paymentUrl,
      onSuccess: (e,data) async {
        _printPaymentResponse("RIDER FREE TRIAL PAYMENT RESPONSE", data);
        if (_isSuccessfulPaymentResponse(data)) {
          MessageSnackBarWidget.successSnackBarWidget(context: context, message: _messageFromData(data, e));
          await _goToLogin();
        } else {
          isHandlingPayment.value = false;
          MessageSnackBarWidget.errorSnackBarWidget(context: context, message: _messageFromData(data, "Payment failed"));
          await Get.to(()=>RiderSubscriptionFreeTrailView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
        }
      },
      onFail: (e,data) async {
        _printPaymentResponse("RIDER FREE TRIAL PAYMENT FAILED RESPONSE", data);
        isHandlingPayment.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        await Get.to(()=>RiderSubscriptionFreeTrailView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      onExceptionFail: (e,data) async {
        _printPaymentResponse("RIDER FREE TRIAL PAYMENT EXCEPTION RESPONSE", data);
        isHandlingPayment.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        await Get.to(()=>RiderSubscriptionFreeTrailView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
    );

  }

  bool _isSuccessfulPaymentResponse(dynamic data) {
    if (data is! Map) return false;
    final nestedData = data["data"];
    return data["success"] == true &&
        (nestedData is! Map || nestedData["success"] != false);
  }

  String _messageFromData(dynamic data, String fallback) {
    if (data is Map) {
      final nestedData = data["data"];
      if (nestedData is Map && nestedData["message"] != null) {
        return nestedData["message"].toString();
      }
      if (data["message"] != null) return data["message"].toString();
    }
    return fallback;
  }

  Future<void> _goToLogin() async {
    await LocalStorageUtils.remove(AppConstantUtils.loginResponse);
    await LocalStorageUtils.remove(AppConstantUtils.loginCredentialResponse);
    await Get.offAll(()=>SignInView(),duration: const Duration(milliseconds: 100));
  }

  void _printPaymentResponse(String label, dynamic data) {
    try {
      debugPrint("$label => ${jsonEncode(data)}", wrapWidth: 1024);
    } catch (_) {
      debugPrint("$label => $data", wrapWidth: 1024);
    }
  }


}
