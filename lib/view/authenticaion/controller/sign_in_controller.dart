import 'dart:convert';
import 'package:discount_me_app/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:discount_me_app/res/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';

class SignInController extends GetxController {

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel().obs;
  RxBool isSubmit = false.obs;

  RxBool isPasswordVisible = true.obs;
  // For first password field

  Future<void> togglePasswordVisibility() async {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(const Duration(milliseconds: 100),() async {
      await resetFunction();
    });
  }


  Future<void> resetFunction() async {
    emailController.value = TextEditingController();
    passwordController.value = TextEditingController();
    isSubmit.value = false;
  }


  Future<void> getUserLoginResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
    required Function onSuccess,
  }) async {
    await BaseApiUtils.post(
      url: ApiUtils.loginResponse,
      data: data,
      onSuccess: (e,data) async {
        isSubmit.value = false;
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        print("===== RAW LOGIN API RESPONSE =====");
        print(jsonEncode(data));
        print("==================================");
        await LocalStorageUtils.setString(AppConstantUtils.loginResponse, jsonEncode(data));
        Map<String, dynamic> decodedToken = parseJwt(data["data"]["accessToken"]);
        loginResponseModel.value = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!));
        print("===== PARSED LOGIN MODEL =====");
        print("role: ${decodedToken['role']}");
        print("hasFreeTrial: ${loginResponseModel.value.data?.hasFreeTrial}");
        print("subscription: ${jsonEncode(loginResponseModel.value.data?.subscription?.toJson())}");
        print("hasActiveSubscription: ${loginResponseModel.value.data?.subscription?.hasActiveSubscription}");
        print("subscriptionStatus: ${loginResponseModel.value.data?.subscription?.subscriptionStatus}");
        print("==============================");
        onSuccess(decodedToken);
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
      },
      onExceptionFail: (e,data) {
        print(data);
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
      },
    );
  }

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
      case 3:
        output += '=' * (4 - output.length % 4);
        break;
    }

    return utf8.decode(base64Url.decode(output));
  }

}


