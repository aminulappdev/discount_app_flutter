import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/utils/utils.dart';
import '../../../../res/res.dart';

class UserHomeController extends GetxController {


  Future<void> determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude);
    print(position.latitude);
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.subAdministrativeArea},${place.administrativeArea}, ${place.country}";
    } catch (e) {
      return "Place in not found";
    }
  }

  RxList<String> imageList = [
    ImageUtils.sliderImg,
    ImageUtils.sliderImg,
    ImageUtils.sliderImg,
  ].obs;

  Rx<PageController> pageController = PageController(initialPage: 0).obs; // Start at the first page
  var currentPage = 0.obs;
  Timer? _timer;



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


  Future<void> checkLocationPermission() async {
    Future.delayed(const Duration(milliseconds: 500),() async {
      LocationPermission permission;
      var checkPermission = await Geolocator.checkPermission();
      permission = await Geolocator.requestPermission();
      print(permission);
      if(permission == LocationPermission.denied){
        await checkLocationPermission();
      }else if(permission == LocationPermission.deniedForever){
        CustomSnackBar().errorCustomSnackBar(context: context, message: "Location Permission need.Please go to app setting or unInstall the app");
      }else {
        await determinePosition();
      }
    });
  }


  RxBool isLoading = false.obs;
  RxString selectProductId = "".obs;
  RxBool isAdd = false.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<CategoriesResponseModel> categoriesResponseModel = CategoriesResponseModel().obs;
  Rx<ProductsResponseModel> productsResponseModel = ProductsResponseModel().obs;
  Rx<StoresResponseModel> storesResponseModel = StoresResponseModel().obs;
  Rx<GetAllBannersResponseModel> getAllBannersResponseModel = GetAllBannersResponseModel().obs;
  Rx<LoginResponseModel> loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),).obs;
  Rx<UserProfileResponseModel> userProfileResponseModel = UserProfileResponseModel().obs;
  BuildContext context;
  UserHomeController({required this.context});




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await getCategoriesApiService(
        context: context,
        onSuccess: () async {
          await getProductsApiService(
            context: context,
            onSuccess: () async {
              await getStoriesApiService(
                context: context,
                onSuccess: () async {
                  await getUserProfileApiService(
                    context: context,
                    onSuccess: () async {
                      await getAllBannerApiService(
                        context: context,
                        onSuccess: () async {
                          await checkLocationPermission();
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    });
  }


  Future<void> getCategoriesApiService({
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    await BaseApiUtils.get(
      url: ApiUtils.categoriesResponse,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        categoriesResponseModel.value = CategoriesResponseModel.fromJson(data);
        onSuccess();
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



  Future<void> getProductsApiService({
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    await BaseApiUtils.get(
      url: ApiUtils.getAllProductsResponse,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        productsResponseModel.value = ProductsResponseModel.fromJson(data);
        onSuccess();
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


  Future<void> getStoriesApiService({
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    await BaseApiUtils.get(
      url: ApiUtils.getAllStoresResponse,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        storesResponseModel.value = StoresResponseModel.fromJson(data);
        onSuccess();
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


  Future<void> getUserProfileApiService({
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    await BaseApiUtils.get(
      url: ApiUtils.getUserProfileResponse,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        userProfileResponseModel.value = UserProfileResponseModel.fromJson(data);
        onSuccess();
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


  Future<void> getAllBannerApiService({
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    await BaseApiUtils.get(
      url: ApiUtils.getAllBannerResponse,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        getAllBannersResponseModel.value = GetAllBannersResponseModel.fromJson(data);
        onSuccess();
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


  Future<void> addProductToCartResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
  }) async {
    await BaseApiUtils.post(
      url: ApiUtils.addToCartResponse,
      data: data,
      authorization: loginResponseModel.value.data?.accessToken,
      onSuccess: (e,data) async {
        isAdd.value = false;
        Get.to(()=>CartView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isAdd.value = false;
      },
      onExceptionFail: (e,data) {
        print(data);
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isAdd.value = false;
      },
    );
  }


}