import 'package:discount_me_app/view/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../utils/utils.dart';

class ForgotPasswordController extends GetxController{

  Rx<TextEditingController> emailController = TextEditingController().obs;
  RxBool isSubmit = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(const Duration(milliseconds: 100),() async {
      await resetFunction();
    });
  }

  Future<void> resetFunction() async {
    emailController.value = TextEditingController();
    isSubmit.value = false;
  }


  Future<void> getForgotPasswordResponse({
    required BuildContext context,
    required Map<String,dynamic> data,
    required String email,
  }) async {
    await BaseApiUtils.post(
      url: ApiUtils.forgotEmailOtp,
      data: data,
      onSuccess: (e,data) async {
        MessageSnackBarWidget.successSnackBarWidget(context: context, message: e);
        isSubmit.value = false;
        Get.to(()=>OtpVerifyScreen(email: email,isSignUp: false,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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