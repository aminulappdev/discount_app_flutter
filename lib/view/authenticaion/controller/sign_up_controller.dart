import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:discount_me_app/view/authenticaion/view/otp_verify_screen.dart';
import 'package:discount_me_app/view/authenticaion/model/first_responder_discount_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:discount_me_app/utils/utils.dart';

class SignUpController extends GetxController {


  static Future<void> _handlePermission({required BuildContext context}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    } 

    if (permission == LocationPermission.deniedForever) {
      LocationPermissionDeniedBox().locationPermissionDeniedBox(context: context);
    }
  }

  /// Get current position
  static Future<Position> getCurrentPosition({required BuildContext context}) async {
    await _handlePermission(context: context);
    return await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
  }

  /// Get address from latitude & longitude
  Future<void> userGetAddressFromLatLng({required BuildContext context}) async {
    await getCurrentPosition(context: context).then((position) async {
      lat.value = position.latitude.toString();
      long.value = position.longitude.toString();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      locationController.value.text = "${place.street} ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
    });
  }



  Future<void> checkLocationPermission({required BuildContext context}) async {
    Future.delayed(const Duration(milliseconds: 500),() async {
      LocationPermission permission;
      var checkPermission = await Geolocator.checkPermission();
      permission = await Geolocator.requestPermission();
      print(permission);
      if(permission == LocationPermission.denied){
        await checkLocationPermission(context: context);
      }else {
        await userGetAddressFromLatLng(context: context);
      }
    });
  }



  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 100),() async {
      await resetFunction();
      await getFirstResponderDiscounts();
    });
  }

  Rx<File> imageFile = File("").obs;
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> restaurantNameController = TextEditingController().obs;
  Rx<TextEditingController> referralCodeController = TextEditingController().obs;
  Rx<TextEditingController> restaurantDescriptionController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> locationController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<String> lat = "".obs;
  Rx<String> long = "".obs;
  Rx<File> documentFile = File("").obs;
  Rx<File> drivingLicenceFile = File("").obs;
  Rx<File> coverFile = File("").obs;
  Rx<File> taxFile = File("").obs;
  RxString selectedRole = "User".obs;
  RxBool isSubmit = false.obs;
  RxBool isFirstResponderDiscountLoading = false.obs;
  Rx<FirstResponderDiscountResponseModel> firstResponderDiscountResponseModel =
      FirstResponderDiscountResponseModel().obs;
  RxList<String> positions = [
    'Federal Government Official',
    'State Government Official',
    'City Council Member',
    'Mayor',
    'Senator',
    'Congressperson',
    'Police Officer',
    'Firefighter',
    'Public School Teacher',
    'Healthcare Worker',
    'Other'
  ].obs;
  RxString selectedPosition = "".obs;
  RxList<String> firstResponderTypes = <String>[].obs;
  RxString selectedFirstResponderType = "".obs;

  Future<void> changeRole(String value) async {
    selectedRole.value = value;
  }

  RxBool isPasswordVisible = true.obs;   // For first password field
  RxBool isConfirmPasswordVisible = true.obs; // For confirm password field

  Future<void> togglePasswordVisibility() async {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> toggleConfirmPasswordVisibility() async {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }


  Future<void> resetFunction() async {
    imageFile = File("").obs;
    firstNameController = TextEditingController().obs;
    lastNameController = TextEditingController().obs;
    restaurantNameController = TextEditingController().obs;
    restaurantDescriptionController = TextEditingController().obs;
    emailController = TextEditingController().obs;
    locationController = TextEditingController().obs;
    phoneNumberController = TextEditingController().obs;
    referralCodeController = TextEditingController().obs;
    selectedPosition = "".obs;
    selectedFirstResponderType = "".obs;
    passwordController = TextEditingController().obs;
    confirmPasswordController = TextEditingController().obs;
    documentFile = File("").obs;
    phoneNumber.value = "";
    lat.value = "";
    long.value = "";
    initialCountryCode.value = "BD";
    drivingLicenceFile = File("").obs;
    coverFile = File("").obs;
    taxFile = File("").obs;
    isPasswordVisible = true.obs;
    isConfirmPasswordVisible = true.obs;
    isSubmit = false.obs;
    matchedCountry.value = Country(
      name: '',
      flag: '',
      code: '',
      dialCode: '',
      nameTranslations: {},
      maxLength: 0,
      minLength: 0,
    );
  }

  void setPickedLocation({
    required String address,
    required double latitude,
    required double longitude,
  }) {
    locationController.value.text = address;
    lat.value = latitude.toString();
    long.value = longitude.toString();
  }

  Future<void> getFirstResponderDiscounts() async {
    isFirstResponderDiscountLoading.value = true;

    await BaseApiUtils.get(
      url: ApiUtils.firstResponderDiscounts,
      onSuccess: (e, data) {
        firstResponderDiscountResponseModel.value =
            FirstResponderDiscountResponseModel.fromJson(data);
        firstResponderTypes.value =
            firstResponderDiscountResponseModel.value.data?.roles ?? <String>[];
        isFirstResponderDiscountLoading.value = false;
      },
      onFail: (e, data) {
        isFirstResponderDiscountLoading.value = false;
      },
      onExceptionFail: (e, data) {
        isFirstResponderDiscountLoading.value = false;
      },
    );
  }


  RxString phoneNumber = "".obs;
  RxString initialCountryCode = "BD".obs;

  Rx<Country> matchedCountry = Country(
    name: '',
    flag: '',
    code: '',
    dialCode: '',
    nameTranslations: {},
    maxLength: 0,
    minLength: 0,
  ).obs;


  Future<void> pickProfileImage({
    required ImageSource source,
    required BuildContext context,
  }) async {
    ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      Navigator.pop(context); // close dialog after selection
      imageFile.value = File(pickedFile.path);
    }
  }


  Future<void> pickCoverImage({
    required ImageSource source,
    required BuildContext context,
  }) async {
    ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      Navigator.pop(context); // close dialog after selection
      coverFile.value = File(pickedFile.path);
    }
  }


  Future<void> getUserSignUpResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
    File? image,
    File? document,
  }) async {

    print(data);

    dio.FormData formData = dio.FormData.fromMap({
      if(image != null && image.path != "")
        "image": await dio.MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
          contentType: dio.DioMediaType(
            MimeTypeUtils.getMimeType(image.path).split('/').first,
            MimeTypeUtils.getMimeType(image.path).split('/').last,
          ),
        ),
      if(document != null && document.path != "")
        "document": await dio.MultipartFile.fromFile(
          document.path,
          filename: document.path.split('/').last,
          contentType: dio.DioMediaType(
            MimeTypeUtils.getMimeType(document.path).split('/').first,
            MimeTypeUtils.getMimeType(document.path).split('/').last,
          ),
        ),
      "data": jsonEncode(data),  // important → JSON encoded string!
    });

    await BaseApiUtils.post(
      url: ApiUtils.userSignUp,
      formData: formData,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        Get.to(()=>OtpVerifyScreen(email: emailController.value.text, isSignUp: true),duration: const Duration(milliseconds: 100),preventDuplicates: false);
        isSubmit.value = false;
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


  Future<void> getRiderSignUpResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
    File? image,
    File? document,
  }) async {

    dio.FormData formData = dio.FormData.fromMap({
      if(image != null && image.path != "")
        "image": await dio.MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
          contentType: dio.DioMediaType(
            MimeTypeUtils.getMimeType(image.path).split('/').first,
            MimeTypeUtils.getMimeType(image.path).split('/').last,
          ),
        ),
      if(document != null && document.path != "")
        "document": await dio.MultipartFile.fromFile(
          document.path,
          filename: document.path.split('/').last,
          contentType: dio.DioMediaType(
            MimeTypeUtils.getMimeType(document.path).split('/').first,
            MimeTypeUtils.getMimeType(document.path).split('/').last,
          ),
        ),
      "data": jsonEncode(data),  // important → JSON encoded string!
    });

    await BaseApiUtils.post(
      url: ApiUtils.riderSignUp,
      formData: formData,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        Get.to(()=>OtpVerifyScreen(email: emailController.value.text, isSignUp: true),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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



  Future<void> getVendorSignUpResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
    File? coverImage,
    File? taxFile,
  }) async {

    dio.FormData formData = dio.FormData.fromMap({
      if(coverImage != null && coverImage.path != "")
        "images": await dio.MultipartFile.fromFile(
          coverImage.path,
          filename: coverImage.path.split('/').last,
          contentType: dio.DioMediaType(
            MimeTypeUtils.getMimeType(coverImage.path).split('/').first,
            MimeTypeUtils.getMimeType(coverImage.path).split('/').last,
          ),
        ),
      if(taxFile != null && taxFile.path != "")
        "document": await dio.MultipartFile.fromFile(
          taxFile.path,
          filename: taxFile.path.split('/').last,
          contentType: dio.DioMediaType(
            MimeTypeUtils.getMimeType(taxFile.path).split('/').first,
            MimeTypeUtils.getMimeType(taxFile.path).split('/').last,
          ),
        ),
      "data": jsonEncode(data),  // important → JSON encoded string!
    });

    await BaseApiUtils.post(
      url: ApiUtils.vendorSignUp,
      formData: formData,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        Get.to(()=>OtpVerifyScreen(email: emailController.value.text, isSignUp: true),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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


  Future<void> getBrokerSignUpResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
    File? profileImageFile,
  }) async {

    dio.FormData formData = dio.FormData.fromMap({
      if(profileImageFile != null && profileImageFile.path != "")
        "image": await dio.MultipartFile.fromFile(
          profileImageFile.path,
          filename: profileImageFile.path.split('/').last,
          contentType: dio.DioMediaType(
            MimeTypeUtils.getMimeType(profileImageFile.path).split('/').first,
            MimeTypeUtils.getMimeType(profileImageFile.path).split('/').last,
          ),
        ),
      "data": jsonEncode(data),  // important → JSON encoded string!
    });

    await BaseApiUtils.post(
      url: ApiUtils.brokerSignUp,
      formData: formData,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        Get.to(()=>OtpVerifyScreen(email: emailController.value.text, isSignUp: true),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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


}
