import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import '../../../../utils/utils.dart';

class VendorProductDetailsController extends GetxController {

  RxBool isLoading = false.obs;
  RxBool isDelete = false.obs;
  RxBool isAdd = false.obs;
  Rx<SingleProductResponseModel> singleProductResponseModel = SingleProductResponseModel().obs;
  final BuildContext context;
  final String productId;
  Rx<PageController> pageController = PageController(initialPage: 0).obs; // Start at the first page
  var currentPage = 0.obs;
  Timer? _timer;

  VendorProductDetailsController({required this.productId,required this.context});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await getSingleProductViewController(context: context, productId: productId);
    });
  }



  void onPageChanged(int page) {
    currentPage.value = page;
  }

  Future<void> startAutoPlay() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage.value < 2) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }
      if (pageController.value.hasClients) {
        pageController.value.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 350),
          curve: Curves.linearToEaseOut, // Swapping-like effect
        );
      }
    });
  }


  Future<void> getSingleProductViewController({
    required BuildContext context,
    required String productId,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.productDetails(productId),
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        singleProductResponseModel.value = SingleProductResponseModel.fromJson(data);
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


  Future<void> getProductDeleteController({
    required BuildContext context,
    required String productId,
  }) async {

    isDelete.value = true;

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.delete(
      url: ApiUtils.productDelete(productId),
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        Get.back();
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isDelete.value = false;
        Get.to(()=>VendorDashboardView(index: 2,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isDelete.value = false;
      },
      onExceptionFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isDelete.value = false;
      },
    );

  }

}