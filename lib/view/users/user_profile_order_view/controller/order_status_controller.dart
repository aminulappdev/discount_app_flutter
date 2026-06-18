import 'dart:convert';
import 'package:discount_me_app/view/users/user_profile_order_view/view/user_order_delivered_status_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:intl/intl.dart';
import '../../../../utils/utils.dart';



class OrderStatusController extends GetxController {

  RxBool isLoading = false.obs;
  RxInt selectedTab = 0.obs;
  Rx<SingleProductResponseModel> singleProductResponseModel = SingleProductResponseModel().obs;

  RxList<String> tabs = ["Received", "Processing", "Ongoing", "Delivered", "Canceled"].obs;

  RxList<OrderStatusModel> orders = <OrderStatusModel>[].obs;
  Rx<GetAllOrderRetrievedResponseModel> getAllOrderRetrievedResponseModel = GetAllOrderRetrievedResponseModel().obs;
  Rxn<OrderStatusModel> selectedOrder = Rxn<OrderStatusModel>();
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),).obs;
  BuildContext context;
  OrderStatusController({required this.context});
  var rating = 0.0.obs;
  var reviewText = "".obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      getAllOrderController(context: context);
    });
  }


  Future<void> getAllOrderController({ 
    required BuildContext context,
  }) async { 
    await BaseApiUtils.get(
      
      url: ApiUtils.getAllOrdersResponse,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        getAllOrderRetrievedResponseModel.value = GetAllOrderRetrievedResponseModel.fromJson(data);
        getAllOrderRetrievedResponseModel.value.data?.data?.forEach((value) async {
          await getSingleProductViewController(
            context: context,
            productId: value.items?.first.product,
            onComplete: (SingleProductResponseModel singleProductResponseModel) async {
              orders.add(
                OrderStatusModel(
                  image: singleProductResponseModel.data?.images?.first ?? "",
                  id: value.sId,
                  orderId: value.orderId,
                  amount: double.parse(value.subtotal.toString()),
                  date: value.createdAt == null ? "" : DateFormat("dd/MM/yyyy").format(DateTime.parse(value.createdAt)),
                  status: value.status,
                ),
              );
            },
          );
        });
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


  Future<void> getSingleProductViewController({
    required BuildContext context,
    required String productId,
    required Function onComplete,
  }) async {
    BaseApiUtils.get(
      url: ApiUtils.productDetails(productId),
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        singleProductResponseModel.value = SingleProductResponseModel.fromJson(data);
        onComplete(singleProductResponseModel.value);
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
      },
      onExceptionFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
      },
    );

  }


  Color getColor(String status) {
    switch (status) {
      case "Received":
        return Colors.blue.shade100;
      case "Processing":
        return Colors.orange.shade100;
      case "Ongoing":
        return Colors.deepOrange.shade100;
      case "Delivered":
        return Colors.green.shade100;
      case "Canceled":
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }


  Color getTextColor(String status) {
    switch (status) {
      case "Received":
        return Colors.blue;
      case "Processing":
        return Colors.orange;
      case "Ongoing":
        return Colors.deepOrange;
      case "Delivered":
        return Colors.green;
      case "Canceled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<OrderStatusModel> get filteredOrders => orders.where((e) => e.status == tabs[selectedTab.value].toLowerCase()).toList();

  void changeTab(int index) => selectedTab.value = index;

  void selectOrder(OrderStatusModel order) {
    selectedOrder.value = order;
    Get.to(()=> UserOrderDeliveredStatusView(orderId: selectedOrder.value!.id),duration: const Duration(milliseconds: 100),preventDuplicates: false);
  }

  void updateStatus(String id, String status) {
    int i = orders.indexWhere((e) => e.id == id);
    if (i != -1) {
      orders[i] = orders[i].copyWith(status: status);
      orders.refresh();
    }
  }

  void submitReview() {
    Get.snackbar("Success", "Review Submitted");
  }


}



