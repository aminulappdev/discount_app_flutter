import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import '../../../../utils/utils.dart';

class GetVoucherController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(
    jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
  ).obs;
  Rx<GetMyVouchersResponseModel> getMyVouchersResponseModel =
      GetMyVouchersResponseModel().obs;

  BuildContext context;
  GetVoucherController({required this.context});

  @override
  void onInit() {
    super.onInit();
    getMyVouchersController(context: context);
  }

  Future<void> getMyVouchersController({
    required BuildContext context,
  }) async {
    isLoading.value = true;
    await BaseApiUtils.get(
      url: ApiUtils.myVouchers,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e, data) async {
        getMyVouchersResponseModel.value =
            GetMyVouchersResponseModel.fromJson(data);
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

}
