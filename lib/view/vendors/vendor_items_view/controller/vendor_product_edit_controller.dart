import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/utils.dart';
import '';
import '../../../view.dart';

class VendorProductEditController extends GetxController {

  BuildContext context;
  String productId;
  VendorProductEditController({required this.context,required this.productId});
  RxBool isLoading = false.obs;
  RxBool isSubmit = false.obs;
  Rx<SingleProductResponseModel> singleProductResponseModel = SingleProductResponseModel().obs;
  Rx<TextEditingController> itemNameController = TextEditingController().obs;
  Rx<TextEditingController> itemDetailsController = TextEditingController().obs;
  Rx<TextEditingController> itemPriceController = TextEditingController().obs;
  Rx<TextEditingController> itemQuantityController = TextEditingController().obs;
  Rx<CategoriesResponseModel> categoriesResponseModel = CategoriesResponseModel().obs;
  RxList<File> coverImages = <File>[].obs;
  RxList<dio.MultipartFile> filesList = <dio.MultipartFile>[].obs;
  RxList<String> coverScreenSorts = <String>[].obs;
  Rx<Categories> singleCategory = Categories().obs;

  Rx<PageController> pageController = PageController(initialPage: 0).obs; // Start at the first page
  RxInt currentPage = 0.obs;
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await getCategoriesController(
        context: context,
        onComplete: () async {
          await getVendorProductDetailsController(
            context: context,
            productId: productId,
          );
        },
      );
    });
  }




  Future<void> getVendorProductDetailsController({
    required BuildContext context,
    required String productId,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.productDetails(productId),
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        print(data);
        isLoading.value = false;
        singleProductResponseModel.value = SingleProductResponseModel.fromJson(data);
        singleProductResponseModel.value.data?.images?.forEach((value) {
          coverScreenSorts.add(value);
          coverScreenSorts.refresh();
        });
        itemNameController.value.text = singleProductResponseModel.value.data?.name ?? "";
        itemDetailsController.value.text = singleProductResponseModel.value.data?.description ?? "";
        itemPriceController.value.text = singleProductResponseModel.value.data?.price.toString() ?? "";
        itemQuantityController.value.text = singleProductResponseModel.value.data?.quantity.toString() ?? "";
        singleCategory.value = categoriesResponseModel.value.categories!.where((value)=>value.sId == singleProductResponseModel.value.data?.category?.sId).first;
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


  Future<void> getCategoriesController({
  required BuildContext context,
    required Function onComplete,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.categoriesResponse,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        categoriesResponseModel.value = CategoriesResponseModel.fromJson(data);
        print(categoriesResponseModel.value.categories?.length);
        onComplete();
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


  Future<void> editProductController({
    required BuildContext context,
    required String productId,
    required String name,
    required String category,
    required String price,
    required String description,
    required String quantity,
    required List<String> oldImgsToKeep,
    required List<String> imagesToDelete,
    required List<File> pickedImage,
  }) async {
    isSubmit.value = true;

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    // Clear old files
    filesList.clear();

    // Convert selected files to MultipartFile list
    for (final file in pickedImage) {
      final mimeType = MimeTypeUtils.getMimeType(file.path);

      filesList.add(
        await dio.MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: dio.DioMediaType(
            mimeType.split('/')[0],
            mimeType.split('/')[1],
          ),
        ),
      );
    }

    final Map<String, dynamic> jsonData = {
      "name": name,
      "category": category,
      "price": double.parse(price),
      "description": description,
      "quantity": double.parse(quantity),
      "oldImgsToKeep": oldImgsToKeep,
      "imagesToDelete": imagesToDelete,
    };

    print(jsonEncode(jsonData));

    dio.FormData formData = dio.FormData.fromMap({
      if(filesList.isNotEmpty == true)
        "images": filesList,
      "data": jsonEncode(jsonData),  // important → JSON encoded string!
    });

    await BaseApiUtils.put(
      url: ApiUtils.productEdit(productId),
      formData: formData,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        isSubmit.value = false;
        Get.to(()=>VendorDashboardView(index: 2,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
      },
      onExceptionFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        print(data);
      },
    );
  }


}