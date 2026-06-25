import 'dart:convert';

import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StripeConnectController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHandlingCallback = false.obs;

  Future<void> createOnboardingLink({
    required BuildContext context,
    required String role,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;

    final loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
    );

    await BaseApiUtils.post(
      url: ApiUtils.stripeConnectOnboardingLink,
      authorization: loginResponseModel.data?.accessToken ?? "",
      onSuccess: (message, data) async {
        isLoading.value = false;
        final onboardingUrl = _extractOnboardingUrl(data);

        if (onboardingUrl.isEmpty) {
          MessageSnackBarWidget.errorSnackBarWidget(
            context: context,
            message: "Stripe onboarding url not found",
          );
          return;
        }

        await Get.to(
          () => StripeConnectWebView(
            onboardingUrl: onboardingUrl,
            role: role,
          ),
          duration: const Duration(milliseconds: 100),
          preventDuplicates: false,
        );
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

  bool isStripeConnectCallbackUrl(String url) {
    final lowerUrl = url.toLowerCase();
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? lowerUrl;

    return path.contains("stripe-connect") &&
        !path.contains("onboarding-link") &&
        !path.contains("status");
  }

  Future<void> handleOnboardingCallback({
    required BuildContext context,
    required String callbackUrl,
    required String role,
  }) async {
    if (isHandlingCallback.value) return;
    isHandlingCallback.value = true;

    await BaseApiUtils.get(
      url: callbackUrl,
      onSuccess: (message, data) async {
        await _handleOnboardingResponse(
          context: context,
          data: data,
          role: role,
        );
      },
      onFail: (message, data) {
        isHandlingCallback.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
      onExceptionFail: (message, data) {
        isHandlingCallback.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
    );
  }

  Future<void> handleRenderedOnboardingResponse({
    required BuildContext context,
    required String responseText,
    required String role,
  }) async {
    if (isHandlingCallback.value) return;

    final data = _decodeRenderedJson(responseText);
    if (data == null) return;

    isHandlingCallback.value = true;
    await _handleOnboardingResponse(
      context: context,
      data: data,
      role: role,
    );
  }

  Future<void> _handleOnboardingResponse({
    required BuildContext context,
    required dynamic data,
    required String role,
  }) async {
    final isSuccess = data is Map &&
        data["success"] == true &&
        (data["data"] is! Map || data["data"]["success"] != false);

    if (isSuccess) {
      await checkStripeConnectStatus(
        context: context,
        role: role,
      );
    } else {
      isHandlingCallback.value = false;
      MessageSnackBarWidget.errorSnackBarWidget(
        context: context,
        message: data is Map
            ? data["message"]?.toString() ?? "Stripe account connect failed"
            : "Stripe account connect failed",
      );
    }
  }

  dynamic _decodeRenderedJson(String responseText) {
    var text = responseText.trim();
    if (text.isEmpty || !text.contains('"success"')) return null;

    try {
      final decoded = jsonDecode(text);
      if (decoded is String) {
        return jsonDecode(decoded);
      }
      return decoded;
    } catch (_) {
      try {
        text = text
            .replaceAll(r'\"', '"')
            .replaceAll(r'\n', '')
            .replaceAll(r'\r', '');
        if (text.startsWith('"') && text.endsWith('"')) {
          text = text.substring(1, text.length - 1);
        }
        return jsonDecode(text);
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> checkStripeConnectStatus({
    required BuildContext context,
    required String role,
  }) async {
    final loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
    );

    await BaseApiUtils.get(
      url: ApiUtils.stripeConnectStatus,
      authorization: loginResponseModel.data?.accessToken ?? "",
      onSuccess: (message, data) async {
        final isPayoutReady = data is Map &&
            data["success"] == true &&
            data["data"] is Map &&
            data["data"]["is_payout_ready"] == true;

        if (isPayoutReady) {
          await _showSuccessDialog(context);
          await goToDashboard(role);
        } else {
          isHandlingCallback.value = false;
          MessageSnackBarWidget.errorSnackBarWidget(
            context: context,
            message: data is Map
                ? data["message"]?.toString() ??
                    "Stripe account is not payout ready yet"
                : "Stripe account is not payout ready yet",
          );
        }
      },
      onFail: (message, data) {
        isHandlingCallback.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
      onExceptionFail: (message, data) {
        isHandlingCallback.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
    );
  }

  Future<void> goToDashboard(String role) async {
    if (role == "rider") {
      await Get.offAll(
        () => RiderDashboardView(index: 0),
        duration: const Duration(milliseconds: 100),
      );
    } else if (role == "vendor") {
      await Get.offAll(
        () => VendorDashboardView(index: 0),
        duration: const Duration(milliseconds: 100),
      );
    } else if (role == "broker") {
      await Get.offAll(
        () => BrokerDashboardView(index: 0),
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  String _extractOnboardingUrl(dynamic data) {
    if (data is! Map) return "";
    final nestedData = data["data"];
    if (nestedData is Map && nestedData["url"] != null) {
      return nestedData["url"].toString();
    }
    if (data["url"] != null) return data["url"].toString();
    return "";
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Success",
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "Stripe account connect successful",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
