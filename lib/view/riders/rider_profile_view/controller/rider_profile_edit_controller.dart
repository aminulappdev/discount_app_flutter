import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../res/res.dart';
import '../../../../utils/utils.dart';
import '../../../view.dart';

class RiderProfileEditController extends GetxController {

  Rx<File> imageFile = File("").obs;
  Rx<File> documentFile = File("").obs;
  RxBool isSubmit = false.obs;
  RxBool isLoading = false.obs;

  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> locationController = TextEditingController().obs;
  RxString image = "".obs;
  RxString document = "".obs;
  RxString contact = "".obs;

  Rx<RiderProfileResponse> riderProfileResponse = RiderProfileResponse().obs;
  BuildContext context;
  Rx<TextEditingController> nameControllerText = TextEditingController().obs;
  RiderProfileEditController({required this.context});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await getRiderProfileController(context: context);
    });
  }


  Future<void> getRiderProfileController({
    required BuildContext context,
  }) async {

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    BaseApiUtils.get(
      url: ApiUtils.riderProfile,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        isLoading.value = false;
        riderProfileResponse.value = RiderProfileResponse.fromJson(data);
        firstNameController.value.text = riderProfileResponse.value.data?.name ?? "";
        emailController.value.text =riderProfileResponse.value.data?.email ?? "";
        locationController.value.text = riderProfileResponse.value.data?.location ?? "";
        contact.value = riderProfileResponse.value.data?.contact ?? "";
        image.value = riderProfileResponse.value.data?.image ?? "";
        document.value = riderProfileResponse.value.data?.drivingLicense ?? "";
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


  Future<void> updateRiderProfileController({
    required BuildContext context,
    required String riderId,
    required String name,
    required String email,
    required String location,
    required String contact,
    required File image,
    required File document,
  }) async {
    isSubmit.value = true;

    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

    final Map<String, dynamic> jsonData = {
      "name": name,
      "email": email,
      "contact": contact,
      "location": location,
    };

    print(jsonData);
    print(image.path);
    print(document.path);

    dio.FormData formData = dio.FormData.fromMap({
      if(image.path != "")
        "image": await dio.MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
          contentType: dio.DioMediaType(
            MimeTypeUtils.getMimeType(image.path).split('/').first,
            MimeTypeUtils.getMimeType(image.path).split('/').last,
          ),
        ),
      if(document.path != "")
        "document": await dio.MultipartFile.fromFile(
          document.path,
          filename: document.path.split('/').last,
          contentType: dio.DioMediaType(
            MimeTypeUtils.getMimeType(document.path).split('/').first,
            MimeTypeUtils.getMimeType(document.path).split('/').last,
          ),
        ),
      "data": jsonEncode(jsonData),  // important → JSON encoded string!
    });

    await BaseApiUtils.put(
      url: ApiUtils.riderProfileUpdate(riderId),
      formData: formData,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        Get.to(()=>RiderDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      onFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
      },
      onExceptionFail: (e,data) {
        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
      },
    );
  }


  static Future<void> updatePasswordResponse({
    required String oldPassword,
    required String newPassword,
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail
  }) async {
    try {

      LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);

      Map<String,dynamic> data = {
        "oldPassword": oldPassword,
        "newPassword": newPassword
      };
      print(jsonEncode(data));

      var response = await dio.Dio().post(
        "${AppApiUrl.serverLinkUrl()}auth/change-password",
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword
        },
        options: dio.Options(headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer, ${loginResponseModel.data?.accessToken}'
        }),
      );
      print(jsonEncode(response.statusCode));
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data["message"]);
      } else {
        onFail(response.data["message"]);
      }
    } on dio.DioException catch (e) {
      print(e.response?.data);
      onExceptionFail(e.response?.data["message"]);
    }
  }

}