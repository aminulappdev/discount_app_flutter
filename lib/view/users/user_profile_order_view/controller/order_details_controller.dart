import 'dart:convert';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/utils.dart';

class OrderDetailsController extends GetxController {

  RxBool isLoading = false.obs;
  BuildContext context;
  String orderId;
  OrderDetailsController({required this.orderId,required this.context});
  Rx<GetOrderDetailsRetrievedResponseModel> getOrderDetailsRetrievedResponseModel = GetOrderDetailsRetrievedResponseModel().obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),).obs;
  Rx<UserProfileResponseModel> userProfileResponseModel = UserProfileResponseModel().obs;
  RxDouble deliveryCharge = 0.0.obs;
  RxDouble discount = 0.0.obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await getUserProfileApiService(
        context: context,
        onSuccess: () async {
          await getOrderDetailsController(context: context, orderId: orderId);
        },
      );
    });
  }


  Color getColor(String status) {
    switch (status) {
      case "Received":
        return Colors.blue.shade100;
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


  Future<void> getUserProfileApiService({
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    await BaseApiUtils.get(
      url: ApiUtils.getUserProfileResponse,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        userProfileResponseModel.value = UserProfileResponseModel.fromJson(data);
        onSuccess();
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



  Future<void> getOrderDetailsController({
    required BuildContext context,
    required String orderId,
  }) async {
    await BaseApiUtils.get(
      url: ApiUtils.getOrderDetails(orderId),
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        getOrderDetailsRetrievedResponseModel.value = GetOrderDetailsRetrievedResponseModel.fromJson(data);
        getOrderDetailsRetrievedResponseModel.value.data?.items?.forEach((value) {
          discount.value = discount.value + value.discount;
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



}
