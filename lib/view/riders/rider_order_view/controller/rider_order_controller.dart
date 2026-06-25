import 'dart:convert';
import 'package:discount_me_app/view/riders/home_view/model/rider_pickup_requests_response_model.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/utils.dart';

class RiderOrderController extends GetxController {
  RiderOrderController({required this.context});

  final BuildContext context;
  RxBool isLoading = false.obs;
  Rx<RiderPickupRequestsResponseModel> riderPickupRequestsResponseModel =
      RiderPickupRequestsResponseModel().obs;
  RxList<RiderPickupRequest> pickupRequests = <RiderPickupRequest>[].obs;
  RxList<RiderPickupRequest> requestingRequests = <RiderPickupRequest>[].obs;
  RxList<RiderPickupRequest> ongoingRequests = <RiderPickupRequest>[].obs;
  RxList<RiderPickupRequest> deliveredRequests = <RiderPickupRequest>[].obs;
  RxList<RiderPickupRequest> canceledRequests = <RiderPickupRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllStatusPickupRequestsController(context: context);
  }

  List<RiderPickupRequest> requestsByStatus(String status) {
    switch (status) {
      case "requesting":
        return requestingRequests;
      case "ongoing":
        return ongoingRequests;
      case "delivered":
        return deliveredRequests;
      case "canceled":
      case "cancele":
      case "cancelled":
        return canceledRequests;
      default:
        return [];
    }
  }

  Future<void> getAllStatusPickupRequestsController({
    required BuildContext context,
  }) async {
    isLoading.value = true;
    await getPickupRequestsController(context: context, status: "requesting");
    await getPickupRequestsController(context: context, status: "ongoing");
    await getPickupRequestsController(context: context, status: "delivered");
    await getPickupRequestsController(context: context, status: "cancelled");
    isLoading.value = false;
  }

  Future<void> getPickupRequestsController({
    required BuildContext context,
    required String status,
  }) async {
    final loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),
    );

    await BaseApiUtils.get(
      url: ApiUtils.pickupRequestsByStatus(status),
      authorization: loginResponseModel.data?.accessToken ?? "",
      onSuccess: (e, data) async {
        riderPickupRequestsResponseModel.value =
            RiderPickupRequestsResponseModel.fromJson(data);
        _setRequestsByStatus(
          status,
          _requestsForStatus(
            status,
            riderPickupRequestsResponseModel.value.data?.data ?? [],
          ),
        );
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

  void _setRequestsByStatus(String status, List<RiderPickupRequest> requests) {
    switch (status) {
      case "requesting":
        requestingRequests.value = requests;
        break;
      case "ongoing":
        ongoingRequests.value = requests;
        break;
      case "delivered":
        deliveredRequests.value = requests;
        break;
      case "canceled":
      case "cancele":
      case "cancelled":
        canceledRequests.value = requests;
        break;
    }
  }

  List<RiderPickupRequest> _requestsForStatus(
    String status,
    List<RiderPickupRequest> requests,
  ) {
    return requests.where((request) {
      final requestStatus = request.status?.toLowerCase();
      if (status == "cancele" || status == "canceled" || status == "cancelled") {
        return requestStatus == "cancele" ||
            requestStatus == "canceled" ||
            requestStatus == "cancelled";
      }
      return requestStatus == status;
    }).toList();
  }
}
