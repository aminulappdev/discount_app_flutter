import 'dart:convert';
import 'package:discount_me_app/view/vendors/vendor_profile_view/model/vendor_profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import '../../../../res/res.dart';
import '../../../../utils/utils.dart';

class VendorItemsController extends GetxController {

  BuildContext context;
  VendorItemsController({required this.context});
  RxBool isLoading = false.obs;
  Rx<CategoriesResponseModel> categoriesResponseModel = CategoriesResponseModel().obs;
  Rx<ProductsResponseModel> productsResponseModel = ProductsResponseModel().obs;
  RxList<Products> products = <Products>[].obs;
  Rx<VendorProfileResponseModel> vendorProfileResponseModel = VendorProfileResponseModel().obs;
  RxString updatedCategoryId = "".obs;
  RxString selectProductID = "".obs;
  RxBool isDelete = false.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await getCategoriesController(context: context);
      await getVendorProfileController(context: context);
    });
  }


  Future<void> getCategoriesController({
    required BuildContext context,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.categoriesResponse,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        categoriesResponseModel.value = CategoriesResponseModel.fromJson(data);
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


  Future<void> getVendorProfileController({
    required BuildContext context,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.vendorsProfile,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        vendorProfileResponseModel.value = VendorProfileResponseModel.fromJson(data);
        await getProductsByStoreController(context: context, storeId: vendorProfileResponseModel.value.data?.store?.sId ?? "");
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


  Future<void> getProductsByStoreController({
    required BuildContext context,
    required String storeId,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.storeWiseProduct(storeId),
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        productsResponseModel.value = ProductsResponseModel.fromJson(data);
        products.value = productsResponseModel.value.data!.data!;
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


  Future<void> getVendorCategoryWiseProductController({
    required BuildContext context,
    required String categoryId,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.vendorsProfile,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        vendorProfileResponseModel.value = VendorProfileResponseModel.fromJson(data);
        await getProductsByCategoryController(
          context: context,
          storeId: vendorProfileResponseModel.value.data?.store?.sId ?? "",
          categoryId: categoryId,
        );
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



  Future<void> getProductsByCategoryController({
    required String categoryId,
    required String storeId,
    required BuildContext context,
  }) async {

    String accessToken = "";
    await AppLocalStorage.getString(key: "Login").then((value) {
      accessToken = jsonDecode(value!)["data"]["accessToken"];
    });
    print(accessToken);

    BaseApiUtils.get(
      url: ApiUtils.categoryWiseProduct(storeId, categoryId),
      authorization: accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        productsResponseModel.value = ProductsResponseModel.fromJson(data);
        products.value = productsResponseModel.value.data!.data!;
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

    final loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(
        LocalStorageUtils.getString(AppConstantUtils.loginResponse)!,
      ),
    );

    BaseApiUtils.delete(
      url: ApiUtils.productDelete(productId),
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        Get.back();
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isDelete.value = false;
        products.removeWhere((product) => product.sId == productId);
        isLoading.value = true;
        await getVendorProfileController(context: context);
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
