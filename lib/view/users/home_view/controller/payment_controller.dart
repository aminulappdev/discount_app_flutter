import 'dart:convert';

import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/utils.dart';
import 'package:discount_me_app/view/view.dart';

class PaymentController extends GetxController {
  RxBool isHandlingPayment = false.obs;

  bool isPaymentCallbackUrl(String paymentUrl) {
    final lowerUrl = paymentUrl.toLowerCase();
    final path = Uri.tryParse(paymentUrl)?.path.toLowerCase() ?? lowerUrl;
    return path.contains("handle-payment-success") ||
        path.contains("payment-success") ||
        path.contains("payment-cancel") ||
        path.contains("handle-payment-cancel") ||
        path.contains("failure");
  }

  Future<void> getPaymentController({
    required BuildContext context,
    required String paymentUrl,
    required String fulfillmentType,
  }) async {
    if (isHandlingPayment.value) return;

    final lowerUrl = paymentUrl.toLowerCase();
    final path = Uri.tryParse(paymentUrl)?.path.toLowerCase() ?? lowerUrl;
    final isSuccessCallback =
        path.contains("handle-payment-success") || path.contains("payment-success");

    isHandlingPayment.value = true;

    if (isSuccessCallback) {
      await BaseApiUtils.get(
        url: paymentUrl,
        onSuccess: (message, data) async {
          _printPaymentResponse("PAYMENT SUCCESS RESPONSE", data);

          final isSuccess = data is Map && data["success"] == true;
          if (isSuccess) {
            final orderStatus = _extractStringValue(data, "status");
            final orderId = _extractOrderIdFromPaymentUrl(paymentUrl).isNotEmpty
                ? _extractOrderIdFromPaymentUrl(paymentUrl)
                : _extractOrderId(data);

            debugPrint(
              "PAYMENT SUCCESS PICKUP CHECK => fulfillmentType: $fulfillmentType, orderStatus: $orderStatus, orderId: $orderId",
              wrapWidth: 1024,
            );

            if (fulfillmentType == "delivery") {
              if (orderId.isEmpty) {
                isHandlingPayment.value = false;
                MessageSnackBarWidget.errorSnackBarWidget(
                  context: context,
                  message: "Order id not found",
                );
                return;
              }

              await _createPickupRequestController(
                context: context,
                orderId: orderId,
              );
            } else {
              Get.off(()=>OrderCompleteView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
              MessageSnackBarWidget.successSnackBarWidget(context: context, message: data["message"]?.toString() ?? "Payment successful");
            }
          } else {
            isHandlingPayment.value = false;
            Get.off(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
            MessageSnackBarWidget.errorSnackBarWidget(context: context, message: data is Map ? data["message"]?.toString() ?? "Payment failed" : "Payment failed");
          }
        },
        onFail: (message, data) {
          _printPaymentResponse("PAYMENT SUCCESS FAILED RESPONSE", data);
          isHandlingPayment.value = false;
          Get.off(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          MessageSnackBarWidget.errorSnackBarWidget(context: context, message: message);
        },
        onExceptionFail: (message, data) {
          _printPaymentResponse("PAYMENT SUCCESS EXCEPTION RESPONSE", data);
          isHandlingPayment.value = false;
          Get.off(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          MessageSnackBarWidget.errorSnackBarWidget(context: context, message: message);
        },
      );
    } else {
      debugPrint("PAYMENT CANCEL/FAILURE URL => $paymentUrl");
      Get.off(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Payment failed");
    }
  }

  void _printPaymentResponse(String label, dynamic data) {
    try {
      debugPrint("$label => ${jsonEncode(data)}", wrapWidth: 1024);
    } catch (_) {
      debugPrint("$label => $data", wrapWidth: 1024);
    }
  }

  Future<void> _createPickupRequestController({
    required BuildContext context,
    required String orderId,
  }) async {
    debugPrint("Creating pickup request for orderId: $orderId");
    final loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
    );

    await BaseApiUtils.post(
      url: ApiUtils.pickupRequests,
      data: {
        "order": orderId,
      },
      authorization: loginResponseModel.data?.accessToken ?? "",
      onSuccess: (message, data) async {
        debugPrint("Pickup request created for orderId: $orderId");
        await _showPickupRequestSuccessDialog(
          context: context,
          message: message,
        );
        Get.off(()=>OrderCompleteView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      onFail: (message, data) {
        isHandlingPayment.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: message);
      },
      onExceptionFail: (message, data) {
        isHandlingPayment.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: message);
      },
    );

  }

  Future<void> _showPickupRequestSuccessDialog({
    required BuildContext context,
    required String message,
  }) async {
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
          content: Text(
            message.isEmpty ? "Pickup request created successfully" : message,
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

  String _extractOrderId(dynamic data) {
    final directOrder = _findValueByKeys(data, const ["order"]);
    if (directOrder is String && directOrder.isNotEmpty) {
      return directOrder;
    }

    if (directOrder is Map) {
      final nestedId = directOrder["_id"] ?? directOrder["id"] ?? directOrder["sId"];
      if (nestedId != null && nestedId.toString().isNotEmpty) {
        return nestedId.toString();
      }
    }

    final id = _findValueByKeys(data, const ["_id", "id", "sId", "order_id", "orderId"]);
    return id == null ? "" : id.toString();
  }

  String _extractOrderIdFromPaymentUrl(String paymentUrl) {
    final uri = Uri.tryParse(paymentUrl);
    if (uri == null) return "";

    final orderKeys = uri.queryParameters.keys
        .where((key) => key.toLowerCase().startsWith("order"))
        .toList()
      ..sort();

    if (orderKeys.isEmpty) return "";

    return uri.queryParameters[orderKeys.first]?.toString() ?? "";
  }

  String _extractStringValue(dynamic data, String key) {
    final value = _findValueByKeys(data, [key]);
    return value == null ? "" : value.toString().toLowerCase();
  }

  dynamic _findValueByKeys(dynamic data, List<String> keys) {
    if (data is Map) {
      for (final key in keys) {
        if (data.containsKey(key) && data[key] != null) {
          return data[key];
        }
      }

      for (final value in data.values) {
        final nestedValue = _findValueByKeys(value, keys);
        if (nestedValue != null) {
          return nestedValue;
        }
      }
    }

    if (data is List) {
      for (final item in data) {
        final nestedValue = _findValueByKeys(item, keys);
        if (nestedValue != null) {
          return nestedValue;
        }
      }
    }

    return null;
  }
}
