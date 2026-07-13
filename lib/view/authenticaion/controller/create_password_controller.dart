import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import '../../../res/res.dart';
import '../../../utils/utils.dart';

class CreatePasswordController extends GetxController{

  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  RxBool isSubmit = false.obs;

  var isNewPasswordVisible = true.obs;
  var isNewConfirmPasswordVisible = true.obs;


  Future<void> getResetPasswordResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
  }) async {
    await BaseApiUtils.post(
      url: ApiUtils.resetForgottenPassword,
      data: data,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        Get.to(()=>SignInView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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