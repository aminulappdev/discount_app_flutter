import 'dart:async';
import 'dart:convert';

import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:discount_me_app/view/vendors/vendor_home_view/model/vendor_orders_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VendorOrderManageController extends GetxController {
  VendorOrderManageController({required this.context});

  final BuildContext context;

  RxBool isLoading = false.obs;
  RxInt selectedTab = 0.obs;
  RxList<String> tabs = ["Ongoing", "Delivered", "Canceled"].obs;
  RxList<VendorOrderListItem> orders = <VendorOrderListItem>[].obs;
  Rx<VendorOrdersResponseModel> vendorOrdersResponseModel =
      VendorOrdersResponseModel().obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(
    jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getVendorOrdersController(context: context);
  }

  Future<void> getVendorOrdersController({
    required BuildContext context,
  }) async {
    isLoading.value = true;
    orders.clear();

    await BaseApiUtils.get(
      url: ApiUtils.getVendorOrdersResponse,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e, data) async {
        vendorOrdersResponseModel.value = VendorOrdersResponseModel.fromJson(data);
        final apiOrders = vendorOrdersResponseModel.value.data?.data ?? [];

        final mappedOrders = await Future.wait(
          apiOrders.map((order) => _mapOrder(order)),
        );

        orders.assignAll(mappedOrders);
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

  Future<VendorOrderListItem> _mapOrder(VendorOrderData order) async {
    final productId = order.items?.isNotEmpty == true
        ? order.items!.first.product?.toString() ?? ""
        : "";
    final product = productId.isNotEmpty
        ? await _getSingleProductViewController(productId: productId)
        : null;

    return VendorOrderListItem(
      id: order.sId ?? "",
      orderId: order.orderId ?? "N/A",
      customerName: _formatName(order.customer?.name ?? "N/A"),
      productName: product?.data?.name ?? order.orderId ?? "Order",
      image: product?.data?.images?.isNotEmpty == true
          ? product!.data!.images!.first
          : "",
      amount: double.tryParse((order.total ?? order.subtotal ?? 0).toString()) ?? 0,
      date: _formatDate(order.createdAt),
      status: order.status ?? "",
      paymentStatus: order.paymentStatus ?? "",
      fulfillmentType: order.fulfillmentType ?? "",
    );
  }

  Future<SingleProductResponseModel?> _getSingleProductViewController({
    required String productId,
  }) async {
    final completer = Completer<SingleProductResponseModel?>();

    BaseApiUtils.get(
      url: ApiUtils.productDetails(productId),
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e, data) {
        completer.complete(SingleProductResponseModel.fromJson(data));
      },
      onFail: (e, data) {
        completer.complete(null);
      },
      onExceptionFail: (e, data) {
        completer.complete(null);
      },
    );

    return completer.future;
  }

  List<VendorOrderListItem> get filteredOrders {
    final tab = tabs[selectedTab.value].toLowerCase();

    return orders.where((order) {
      final status = order.status.toLowerCase();
      if (tab == "ongoing") {
        return status == "received" ||
            status == "processing" ||
            status == "ongoing";
      }
      if (tab == "canceled") {
        return status == "canceled" || status == "cancelled";
      }
      return status == tab;
    }).toList();
  }

  void changeTab(int index) => selectedTab.value = index;

  Color getTabColor(int index) {
    switch (index) {
      case 0:
        return ColorUtils.secondaryColor;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return ColorUtils.primaryColor;
    }
  }

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case "delivered":
        return ColorUtils.greenLightHover;
      case "canceled":
      case "cancelled":
        return const Color(0xffFFE5E5);
      default:
        return const Color(0xffFFF9E7);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case "delivered":
        return ColorUtils.primaryColor;
      case "canceled":
      case "cancelled":
        return const Color(0xffff0000);
      default:
        return const Color(0xffFFC60B);
    }
  }

  String statusLabel(String status) {
    if (status.isEmpty) return "N/A";
    return status[0].toUpperCase() + status.substring(1);
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return "";
    final parsedDate = DateTime.tryParse(value);
    if (parsedDate == null) return "";
    return DateFormat("dd/MM/yyyy").format(parsedDate);
  }

  String _formatName(String value) {
    return value.replaceAll(RegExp(r'\s*,\s*'), ' ').trim();
  }
}
