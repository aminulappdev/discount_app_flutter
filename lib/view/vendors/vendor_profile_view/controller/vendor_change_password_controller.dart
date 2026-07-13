import 'dart:convert';

import 'package:discount_me_app/view/authenticaion/view/sign_in_view.dart';
import 'package:discount_me_app/view/vendors/vendor_profile_view/model/vendor_profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import '../../../../res/res.dart';
import '../../../../utils/utils.dart';

class VendorChangePasswordController extends GetxController {

  RxBool isSubmit = false.obs;
  RxBool isLoading = false.obs;
  Rx<VendorProfileResponseModel> vendorProfileResponseModel = VendorProfileResponseModel().obs;
  Rx<TextEditingController> currentPasswordController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;


  RxBool isCurrentPasswordVisible = false.obs;
  RxBool isNewPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  // Toggle functions
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  BuildContext context;
  VendorChangePasswordController({required this.context});


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await getVendorProfileController(context: context);
    });
  }


  Future<void> getVendorProfileController({
    required BuildContext context,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.vendorsProfile,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        vendorProfileResponseModel.value = VendorProfileResponseModel.fromJson(data);
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


  Future<void> changePasswordVendorProfileController({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
    required String email,
  }) async {

    isSubmit.value = true;

    String accessToken = "";
    await AppLocalStorage.getString(key: "Login").then((value) {
      accessToken = jsonDecode(value!)["data"]["accessToken"];
    });
    print(accessToken);


    Map<String,dynamic> data = {
      "email": email,
      "oldPassword": oldPassword,
      "newPassword": newPassword
    };
    print(jsonEncode(data));

    BaseApiUtils.post(
      url: ApiUtils.riderChangePassword,
      authorization: accessToken,
      data: data,
      onSuccess: (e,data) async {
        isSubmit.value = false;
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        await AppLocalStorage.removeKey(key: "Login");
        await Get.to(()=>SignInView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
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


}