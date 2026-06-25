import 'dart:convert';

import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductReviewsController extends GetxController {
  ProductReviewsController({
    required this.context,
    required this.productId,
  });

  final BuildContext context;
  final String productId;

  RxBool isLoading = false.obs;
  Rx<ProductReviewsResponseModel> productReviewsResponseModel =
      ProductReviewsResponseModel().obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(
    jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getProductReviewsController(context: context);
  }

  Future<void> getProductReviewsController({
    required BuildContext context,
  }) async {
    isLoading.value = true;
    await BaseApiUtils.get(
      url: ApiUtils.productReviews(productId),
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (message, data) async {
        productReviewsResponseModel.value =
            ProductReviewsResponseModel.fromJson(data);
        isLoading.value = false;
      },
      onFail: (message, data) {
        isLoading.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
      onExceptionFail: (message, data) {
        isLoading.value = false;
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
    );
  }
}
