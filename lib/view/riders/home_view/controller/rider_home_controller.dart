import 'dart:convert';
import 'package:discount_me_app/view/riders/rider_profile_view/model/rider_profile_response.dart';
import 'package:discount_me_app/view/riders/home_view/model/rider_pickup_requests_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../res/res.dart';
import '../../../../utils/utils.dart';
import 'package:discount_me_app/view/view.dart';

class RiderHomeController extends GetxController {

  RxBool isLoading = false.obs;
  Rx<RiderProfileResponse> riderProfileResponse = RiderProfileResponse().obs;
  Rx<RiderPickupRequestsResponseModel> riderPickupRequestsResponseModel =
      RiderPickupRequestsResponseModel().obs;
  RxList<RiderPickupRequest> pickupRequests = <RiderPickupRequest>[].obs;
  List<RiderPickupRequest> get requestingPickupRequests => pickupRequests;
  BuildContext context;
  Rx<TextEditingController> whereToControllerText = TextEditingController().obs;
  RiderHomeController({required this.context});


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await getHomeData(context: context);
    });
  }

  Future<void> getHomeData({
    required BuildContext context,
  }) async {
    isLoading.value = true;
    await getRiderProfileApiService(context: context);
    await getPickupRequestsController(context: context);
    isLoading.value = false;
  }


  Future<void> getRiderProfileApiService({
    required BuildContext context,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    await BaseApiUtils.get(
      url: ApiUtils.riderProfile,
      authorization: loginResponseModel.data?.accessToken ?? "",
      onSuccess: (e,data) async {
        riderProfileResponse.value = RiderProfileResponse.fromJson(data);
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

  Future<void> getPickupRequestsController({
    required BuildContext context,
  }) async {
    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
    );

    await BaseApiUtils.get(
      url: ApiUtils.pickupRequestsByStatus("requesting"),
      authorization: loginResponseModel.data?.accessToken ?? "",
      onSuccess: (e, data) async {
        riderPickupRequestsResponseModel.value =
            RiderPickupRequestsResponseModel.fromJson(data);
        pickupRequests.value = (riderPickupRequestsResponseModel
                    .value.data?.data ??
                [])
            .where((request) => request.status?.toLowerCase() == "requesting")
            .toList();
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
