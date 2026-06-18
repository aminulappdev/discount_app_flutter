import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../utils/utils.dart';
import 'package:discount_me_app/view/view.dart';

class ScanCouponController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHandlingScan = false.obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  MobileScannerController scannerController = MobileScannerController();
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(
    jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
  ).obs;

  BuildContext context;
  ScanCouponController({required this.context});

  Future<void> onDetectBarcode(BarcodeCapture capture) async {
    if (isHandlingScan.value) return;

    String code = "";
    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
        code = barcode.rawValue!;
        break;
      }
    }
    if (code.isEmpty) return;

    codeController.value.text = code;
    await validateCouponController(context: context, code: code);
  }

  Future<void> validateManualCode({
    required BuildContext context,
  }) async {
    final code = codeController.value.text.trim();
    if (code.isEmpty) {
      MessageSnackBarWidget.errorSnackBarWidget(
        context: context,
        message: "Please enter coupon code",
      );
      return;
    }
    await validateCouponController(context: context, code: code);
  }

  Future<void> validateCouponController({
    required BuildContext context,
    required String code,
  }) async {
    isHandlingScan.value = true;
    isLoading.value = true;
    await scannerController.stop();

    await BaseApiUtils.post(
      url: ApiUtils.validateVoucher(Uri.encodeComponent(code)),
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e, data) async {
        isLoading.value = false;
        _showSuccessDialog(context: context, responseData: data);
      },
      onFail: (e, data) async {
        isLoading.value = false;
        isHandlingScan.value = false;
        await scannerController.start();
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
      },
      onExceptionFail: (e, data) async {
        isLoading.value = false;
        isHandlingScan.value = false;
        await scannerController.start();
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
      },
    );
  }

  void _showSuccessDialog({
    required BuildContext context,
    required dynamic responseData,
  }) {
    final details = _voucherDetails(responseData);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.75, end: 1),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    height: 66,
                    width: 66,
                    decoration: const BoxDecoration(
                      color: ColorUtils.green139,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Coupon Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorUtils.black29,
                  ),
                ),
                const SizedBox(height: 14),
                ...details.map((detail) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 92,
                          child: Text(
                            detail["title"] ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.black29,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            detail["value"] ?? "N/A",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.black29,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 12 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: const Text(
                    "Success",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: ColorUtils.green139,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorUtils.green139,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      isHandlingScan.value = false;
                      await scannerController.start();
                    },
                    child: const Text("OK"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, String>> _voucherDetails(dynamic responseData) {
    final root = _asMap(responseData);
    final data = _asMap(root["data"]);
    final voucher = _asMap(data["voucher"]);
    final order = _asMap(voucher["order"]);
    final store = _asMap(order["store"]);
    final products = _productText(data: data, voucher: voucher, order: order);

    return [
      if (products.isNotEmpty) {"title": "Product", "value": products},
      {"title": "Store", "value": _text(store["name"])},
      {"title": "Order", "value": _text(order["order_id"])},
      {"title": "Code", "value": _text(voucher["code"])},
      {"title": "Payment", "value": _capitalized(order["payment_status"])},
      {"title": "Order Type", "value": _capitalized(order["fulfillment_type"])},
      {"title": "Status", "value": _capitalized(order["status"])},
    ].where((detail) => detail["value"] != "N/A").toList();
  }

  String _productText({
    required Map<String, dynamic> data,
    required Map<String, dynamic> voucher,
    required Map<String, dynamic> order,
  }) {
    final candidates = [
      data["items"],
      voucher["items"],
      order["items"],
      data["products"],
      voucher["products"],
      order["products"],
    ];

    for (final candidate in candidates) {
      if (candidate is List && candidate.isNotEmpty) {
        return candidate.map((item) {
          final itemMap = _asMap(item);
          final product = _asMap(itemMap["product"]);
          final name = _text(product["name"] ?? itemMap["name"]);
          final quantity = _text(itemMap["quantity"]);
          final amount = _text(itemMap["amount"] ?? product["price"]);
          final parts = <String>[name];
          if (quantity != "N/A") parts.add("Qty: $quantity");
          if (amount != "N/A") parts.add("Rs $amount");
          return parts.join(" | ");
        }).join("\n");
      }
    }

    final product = _asMap(data["product"] ?? voucher["product"] ?? order["product"]);
    return _text(product["name"]);
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  String _text(dynamic value) {
    if (value == null || value.toString().isEmpty) return "N/A";
    return value.toString();
  }

  String _capitalized(dynamic value) {
    final text = _text(value).replaceAll("_", " ");
    if (text == "N/A") return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  void onClose() {
    codeController.value.dispose();
    scannerController.dispose();
    super.onClose();
  }
}
