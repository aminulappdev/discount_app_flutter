import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:discount_me_app/utils/utils.dart';

class RiderSubscriptionFreeTrailController extends GetxController {

  RxBool isLoading = false.obs;
  RxBool isSubmit = false.obs;
  BuildContext context;
  Rx<GetAllSettingResponseModel> getAllSettingResponseModel = GetAllSettingResponseModel().obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!)).obs;
  RiderSubscriptionFreeTrailController({required this.context});


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await getAllSubscriptionController(context: context);
    });
  }

  Future<void> getAllSubscriptionController({
    required BuildContext context,
  }) async {
    BaseApiUtils.get(
      url: ApiUtils.getAllSetting,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        getAllSettingResponseModel.value = GetAllSettingResponseModel.fromJson(data);
      },
      onFail: (e,data) {
        isLoading.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
      },
      onExceptionFail: (e,data) {
        isLoading.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
      },
    );
  }


  Future<void> createPaymentController({
    required BuildContext context,
  }) async {
    BaseApiUtils.post(
      url: ApiUtils.createCheckoutSession,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        Get.to(()=>RiderPaymentFreeTrailView(paymentUrl: data["data"]["url"]),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
      },
      onExceptionFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
      },
    );
  }



}