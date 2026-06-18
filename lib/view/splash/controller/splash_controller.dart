import 'dart:convert';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/utils/utils.dart';

class SplashController extends GetxController{

  RxBool isSubmit = false.obs;
  BuildContext context;
  SplashController({required this.context});
  RxBool getStart = LocalStorageUtils.getBool(AppConstantUtils.getStart) == null ? false.obs : LocalStorageUtils.getBool(AppConstantUtils.getStart)!.obs;
  Rx<LoginResponseModel> loginResponseModel = LocalStorageUtils.getString(AppConstantUtils.loginResponse) == null ?
  LoginResponseModel().obs : LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!)).obs;
  Rx<LoginCredentialResponse> loginCredentialResponse = LocalStorageUtils.getString(AppConstantUtils.loginCredentialResponse) == null ?
  LoginCredentialResponse().obs : LoginCredentialResponse.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginCredentialResponse)!)).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isSubmit.value = true;
    Future.delayed(Duration(milliseconds: 100),() async {
      if(loginCredentialResponse.value.email != null) {
        Map<String,dynamic> data = {
          "email": loginCredentialResponse.value.email,
          "password": loginCredentialResponse.value.password,
        };
        await getUserLoginResponse(
          context: context,
          data: data,
          onSuccess: (data) async {
            await redirectionFunction();
          },
        );
      } else {
        await redirectionFunction();
        isSubmit.value = false;
      }
    });
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
        print("===== SPLASH RAW LOGIN API RESPONSE =====");
        print(jsonEncode(data));
        print("=========================================");
        await LocalStorageUtils.setString(AppConstantUtils.loginResponse, jsonEncode(data));
        Map<String, dynamic> decodedToken = parseJwt(data["data"]["accessToken"]);
        loginResponseModel.value = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!));
        print("===== SPLASH PARSED LOGIN MODEL =====");
        print("role: ${decodedToken['role']}");
        print("hasFreeTrial: ${loginResponseModel.value.data?.hasFreeTrial}");
        print("subscription: ${jsonEncode(loginResponseModel.value.data?.subscription?.toJson())}");
        print("hasActiveSubscription: ${loginResponseModel.value.data?.subscription?.hasActiveSubscription}");
        print("subscriptionStatus: ${loginResponseModel.value.data?.subscription?.subscriptionStatus}");
        print("=====================================");
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

  Future<void> redirectionFunction() async {
    if(getStart.value == true) {
      if(loginResponseModel.value.data != null) {
        Map<String, dynamic> decodedToken = parseJwt(loginResponseModel.value.data!.accessToken);
        if(decodedToken['role'] == "user") {
          Get.off(()=>UserDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          isSubmit.value = false;
        } else if (decodedToken['role'] == "rider") {
          if(loginResponseModel.value.data?.hasFreeTrial == false && loginResponseModel.value.data?.subscription?.hasActiveSubscription == false) {
            Get.off(()=>RiderSubscriptionFreeTrailView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          } else {
            Get.off(()=>RiderDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          }
          isSubmit.value = false;
        } else if (decodedToken['role'] == "vendor") {
          if(loginResponseModel.value.data?.hasFreeTrial == false && loginResponseModel.value.data?.subscription?.hasActiveSubscription == false) {
            Get.off(()=>VendorSubscriptionFreeTrailView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          } else {
            Get.off(()=>VendorDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          }
          isSubmit.value = false;
        } else if (decodedToken['role'] == "broker") {
          if(loginResponseModel.value.data?.hasFreeTrial == false && loginResponseModel.value.data?.subscription?.hasActiveSubscription == false) {
            Get.off(()=>BrokerSubscriptionFreeTrailView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          } else {
            Get.off(()=>BrokerDashboardView(index: 0),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          }
          isSubmit.value = false;
        }
      } else {
        Get.off(()=> WelcomeView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
        isSubmit.value = false;
      }
    }
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
