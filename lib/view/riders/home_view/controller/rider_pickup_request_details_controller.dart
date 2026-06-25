import 'dart:convert';
import 'package:discount_me_app/view/riders/home_view/model/rider_pickup_requests_response_model.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/utils.dart';

class RiderPickupRequestDetailsController extends GetxController {
  RiderPickupRequestDetailsController({
    required this.context,
    required this.pickupRequestId,
  });

  final BuildContext context;
  final String pickupRequestId;
  RxBool isLoading = false.obs;
  Rx<RiderPickupRequestDetailsResponseModel>
      riderPickupRequestDetailsResponseModel =
      RiderPickupRequestDetailsResponseModel().obs;

  RiderPickupRequest? get pickupRequest =>
      riderPickupRequestDetailsResponseModel.value.data;

  void updatePickupRequestStatus(String status) {
    riderPickupRequestDetailsResponseModel.value.data?.status = status;
    riderPickupRequestDetailsResponseModel.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    getPickupRequestDetailsController(context: context);
  }

  Future<void> getPickupRequestDetailsController({
    required BuildContext context,
  }) async {
    isLoading.value = true;
    final loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
    );

    await BaseApiUtils.get(
      url: ApiUtils.pickupRequestDetails(pickupRequestId),
      authorization: loginResponseModel.data?.accessToken ?? "",
      onSuccess: (e, data) async {
        riderPickupRequestDetailsResponseModel.value =
            RiderPickupRequestDetailsResponseModel.fromJson(data);
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
