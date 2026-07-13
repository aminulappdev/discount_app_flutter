import 'dart:convert';
import 'package:discount_me_app/view/vendors/vendor_profile_view/model/vendor_profile_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import '../../../../res/res.dart';
import '../../../../utils/utils.dart';

class VendorSettingController extends GetxController {

  RxBool isLoading = false.obs;
  RxBool isSubmit = false.obs;
  BuildContext context;
  VendorSettingController({required this.context});
  Rx<VendorProfileResponseModel> vendorProfileResponseModel = VendorProfileResponseModel().obs;


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


  Future<void> deleteRiderProfileController({
    required BuildContext context,
    required String riderId,
  }) async {

    isSubmit.value = true;

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.delete(
      url: ApiUtils.vendorProfileDelete(riderId),
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        isSubmit.value = false;
        await AppLocalStorage.removeKey(key: "Login");
        await Get.to(()=>SignInView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
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