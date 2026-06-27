import 'dart:convert';
import 'package:discount_me_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:discount_me_app/view/brokers/broker_home_view/model/broker_earnings_response_model.dart';

class BrokerHomeController extends GetxController {

  Rx<GetBrokerProfileResponseModel> getBrokerProfileResponseModel = GetBrokerProfileResponseModel().obs;
  Rx<BrokerEarningsResponseModel> brokerEarningsResponseModel =
      BrokerEarningsResponseModel().obs;
  RxBool isLoading = false.obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!)).obs;
  BuildContext context;
  BrokerHomeController({required this.context});

  List<BrokerEarningItem> get earnings =>
      brokerEarningsResponseModel.value.data?.data ?? [];

  double get totalBalance {
    return earnings.fold(0.0, (total, item) {
      final amount = double.tryParse(item.amount?.toString() ?? "0") ?? 0;
      return total + amount;
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration(seconds: 1),() async {
      await getBrokerHomeData(context: context);
    });
  }

  Future<void> getBrokerHomeData({required BuildContext context}) async {
    isLoading.value = true;
    await Future.wait([
      getVendorProfileController(context: context),
      getBrokerEarningsController(context: context),
    ]);
    isLoading.value = false;
  }

  Future<void> getVendorProfileController({
    required BuildContext context,
  }) async {
    await BaseApiUtils.get(
      url: ApiUtils.brokersProfile,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        getBrokerProfileResponseModel.value = GetBrokerProfileResponseModel.fromJson(data);
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
      },
      onExceptionFail: (e,data) {
        print(data);
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
      },
    );
  }

  Future<void> getBrokerEarningsController({
    required BuildContext context,
  }) async {
    await BaseApiUtils.get(
      url: ApiUtils.brokerEarnings,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (message, data) async {
        brokerEarningsResponseModel.value =
            BrokerEarningsResponseModel.fromJson(data);
      },
      onFail: (message, data) {
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
      onExceptionFail: (message, data) {
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
    );
  }


}
