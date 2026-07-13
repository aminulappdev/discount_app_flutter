import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import '../../../res/res.dart';
import '../../../utils/utils.dart';

class OtpVerifyController extends GetxController {

  RxInt timeCounter = 120.obs;
  RxBool isReset = false.obs;
  RxBool isSubmit = false.obs;

  Rx<TextEditingController> pinController = TextEditingController().obs;

  Future<void> otpTimer() async {
    Future.delayed(Duration(seconds: 1), () async {
      if(timeCounter > 0) {
        timeCounter.value = timeCounter.value - 1;
        otpTimer();
      } else {
        timeCounter.value = 0;
      }
    });
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration(seconds: 1),() async {
      await otpTimer();
    });
  }


  Future<void> getResetOtpResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
    required String email,
    required bool isSignUp,
  }) async {
    await BaseApiUtils.post(
      url: ApiUtils.sendOtp,
      data: data,
      onSuccess: (e,data) async {
        CustomSnackBar().successCustomSnackBar(context: context, message: "${e}");
        isReset.value = false;
        Get.to(()=>OtpVerifyScreen(email: email,isSignUp: isSignUp,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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


  Future<void> getVerifyOtpResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
    required String email
  }) async {
    await BaseApiUtils.post(
      url: ApiUtils.verifyOtp,
      data: data,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        Get.to(()=>CreateNewPasswordScreen(email: email,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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



  Future<void> getVerifyOtpEmailResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
    required String email
  }) async {
    await BaseApiUtils.post(
      url: ApiUtils.verifyOtp,
      data: data,
      onSuccess: (e,data) async {
        CustomSnackBar().successCustomSnackBar(context: context, message: "${e}");
        isSubmit.value = false;
        Get.to(()=>SignUpPreviewScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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