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
              Get.to(()=>OrderCompleteView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
              MessageSnackBarWidget.successSnackBarWidget(context: context, message: data["message"]?.toString() ?? "Payment successful");
            }
          } else {
            isHandlingPayment.value = false;
            Get.to(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
            MessageSnackBarWidget.errorSnackBarWidget(context: context, message: data is Map ? data["message"]?.toString() ?? "Payment failed" : "Payment failed");
          }
        },
        onFail: (message, data) {
          _printPaymentResponse("PAYMENT SUCCESS FAILED RESPONSE", data);
          isHandlingPayment.value = false;
          Get.to(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          MessageSnackBarWidget.errorSnackBarWidget(context: context, message: message);
        },
        onExceptionFail: (message, data) {
          _printPaymentResponse("PAYMENT SUCCESS EXCEPTION RESPONSE", data);
          isHandlingPayment.value = false;
          Get.to(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          MessageSnackBarWidget.errorSnackBarWidget(context: context, message: message);
        },
      );
    } else {
      debugPrint("PAYMENT CANCEL/FAILURE URL => $paymentUrl");
      Get.to(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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
      onSuccess: (message, data) {
        debugPrint("Pickup request created for orderId: $orderId");
        Get.to(()=>OrderCompleteView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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

  String _extractOrderId(dynamic data) {
    final directOrder = _findValueByKeys(
      data,
      const ["order", "orderId", "order_id"],
      ignoreKeys: const ["paymentSession", "payment_session"],
    );
    if (directOrder is String && directOrder.isNotEmpty) {
      return _isObjectId(directOrder) ? directOrder : "";
    }

    if (directOrder is Map) {
      final nestedId = directOrder["_id"] ?? directOrder["id"] ?? directOrder["sId"];
      if (nestedId != null && _isObjectId(nestedId.toString())) {
        return nestedId.toString();
      }
    }

    final orderIds = _findValueByKeys(
      data,
      const ["orderIds", "order_ids"],
      ignoreKeys: const ["paymentSession", "payment_session"],
    );
    if (orderIds is List && orderIds.isNotEmpty) {
      final firstOrderId = orderIds.first?.toString() ?? "";
      if (_isObjectId(firstOrderId)) {
        return firstOrderId;
      }
    }

    final orders = _findValueByKeys(
      data,
      const ["orders"],
      ignoreKeys: const ["paymentSession", "payment_session"],
    );
    if (orders is List && orders.isNotEmpty) {
      final firstOrder = orders.first;
      if (firstOrder is Map) {
        final orderId = firstOrder["_id"] ?? firstOrder["id"] ?? firstOrder["sId"];
        if (orderId != null && _isObjectId(orderId.toString())) {
          return orderId.toString();
        }
      }
    }

    final id = _findValueByKeys(
      data,
      const ["_id", "id", "sId"],
      ignoreKeys: const ["paymentSession", "payment_session"],
    );
    final value = id == null ? "" : id.toString();
    return _isObjectId(value) ? value : "";
  }

  String _extractOrderIdFromPaymentUrl(String paymentUrl) {
    final uri = Uri.tryParse(paymentUrl);
    if (uri == null) return "";

    final orderKeys = uri.queryParameters.keys
        .where((key) => key.toLowerCase().startsWith("order"))
        .toList()
      ..sort();

    if (orderKeys.isEmpty) return "";

    final orderId = uri.queryParameters[orderKeys.first]?.toString() ?? "";
    return _isObjectId(orderId) ? orderId : "";
  }

  String _extractStringValue(dynamic data, String key) {
    final value = _findValueByKeys(data, [key]);
    return value == null ? "" : value.toString().toLowerCase();
  }

  bool _isObjectId(String value) {
    return RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(value);
  }

  dynamic _findValueByKeys(
    dynamic data,
    List<String> keys, {
    List<String> ignoreKeys = const [],
  }) {
    if (data is Map) {
      for (final key in keys) {
        if (data.containsKey(key) && data[key] != null) {
          return data[key];
        }
      }

      for (final entry in data.entries) {
        if (ignoreKeys.contains(entry.key.toString())) {
          continue;
        }
        final nestedValue = _findValueByKeys(
          entry.value,
          keys,
          ignoreKeys: ignoreKeys,
        );
        if (nestedValue != null) {
          return nestedValue;
        }
      }
    }

    if (data is List) {
      for (final item in data) {
        final nestedValue = _findValueByKeys(
          item,
          keys,
          ignoreKeys: ignoreKeys,
        );
        if (nestedValue != null) {
          return nestedValue;
        }
      }
    }

    return null;
  }
}
