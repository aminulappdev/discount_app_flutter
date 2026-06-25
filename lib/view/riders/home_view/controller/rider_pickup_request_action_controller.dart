import 'dart:convert';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/utils.dart';

class RiderPickupRequestActionController extends GetxController {
  RxBool isAcceptLoading = false.obs;
  RxBool isRejectLoading = false.obs;
  RxBool isStatusUpdateLoading = false.obs;

  Future<void> acceptPickupRequest({
    required BuildContext context,
    required String pickupRequestId,
    required VoidCallback onSuccess,
  }) async {
    if (pickupRequestId.isEmpty) {
      MessageSnackBarWidget.errorSnackBarWidget(
        context: context,
        message: "Pickup request id not found",
      );
      return;
    }

    isAcceptLoading.value = true;
    await _patchPickupRequestStatus(
      context: context,
      url: ApiUtils.acceptPickupRequest(pickupRequestId),
      onSuccess: onSuccess,
      onComplete: () {
        isAcceptLoading.value = false;
      },
    );
  }

  Future<void> rejectPickupRequest({
    required BuildContext context,
    required String pickupRequestId,
    required VoidCallback onSuccess,
  }) async {
    if (pickupRequestId.isEmpty) {
      MessageSnackBarWidget.errorSnackBarWidget(
        context: context,
        message: "Pickup request id not found",
      );
      return;
    }

    isRejectLoading.value = true;
    await _patchPickupRequestStatus(
      context: context,
      url: ApiUtils.rejectPickupRequest(pickupRequestId),
      onSuccess: onSuccess,
      onComplete: () {
        isRejectLoading.value = false;
      },
    );
  }

  Future<void> updatePickupRequestStatus({
    required BuildContext context,
    required String pickupRequestId,
    required String status,
    required VoidCallback onSuccess,
  }) async {
    if (pickupRequestId.isEmpty) {
      MessageSnackBarWidget.errorSnackBarWidget(
        context: context,
        message: "Pickup request id not found",
      );
      return;
    }

    isStatusUpdateLoading.value = true;
    await _patchPickupRequestStatus(
      context: context,
      url: ApiUtils.pickupRequestDetails(pickupRequestId),
      data: {
        "status": status,
      },
      onSuccess: onSuccess,
      onComplete: () {
        isStatusUpdateLoading.value = false;
      },
    );
  }

  Future<void> _patchPickupRequestStatus({
    required BuildContext context,
    required String url,
    required VoidCallback onSuccess,
    required VoidCallback onComplete,
    Map<String, dynamic>? data,
  }) async {
    final loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
    );

    await BaseApiUtils.patch(
      url: url,
      data: data,
      authorization: loginResponseModel.data?.accessToken ?? "",
      onSuccess: (message, data) async {
        MessageSnackBarWidget.successSnackBarWidget(
          context: context,
          message: message,
        );
        onComplete();
        onSuccess();
      },
      onFail: (message, data) {
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
        onComplete();
      },
      onExceptionFail: (message, data) {
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
        onComplete();
      },
    );
  }
}
