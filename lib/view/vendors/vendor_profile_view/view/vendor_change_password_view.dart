import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/vendors/vendor_profile_view/controller/vendor_change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../res/res.dart';


class VendorChangePasswordView extends StatelessWidget {
  const VendorChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final VendorChangePasswordController vendorChangePasswordController = Get.put(VendorChangePasswordController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onPopInvoked) {
        Get.to(()=>VendorSettingView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: vendorChangePasswordController.isLoading.value,
          child: Container(
            height: 928.h(context),
            width: 428.w(context),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(ImageUtils.homeBg),
                alignment: Alignment.topRight,
                opacity: 0.5,
              ),
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                    child: Column(
                      children: [

                        CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                        UserProfileAppbarWidget(
                          title: "Change Password",
                          onTap: () {
                            Get.to(()=>VendorSettingView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          },
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 50.h(context)),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.hpm(context),
                            vertical: 8.vpm(context),
                          ),
                          decoration: BoxDecoration(
                            color: ColorUtils.greenLight,
                            borderRadius: BorderRadius.circular(8.r(context)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lock_outline, color: Colors.black54),
                              SizedBox(width: 16.w(context)),
                              Expanded(
                                child: TextField(
                                  controller: vendorChangePasswordController.currentPasswordController.value,
                                  obscureText: !vendorChangePasswordController.isCurrentPasswordVisible.value,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Current Password',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  vendorChangePasswordController.isCurrentPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                                onPressed: vendorChangePasswordController.toggleCurrentPasswordVisibility,
                              ),
                            ],
                          ),
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 8.vpm(context)),
                          decoration: BoxDecoration(
                            color: ColorUtils.greenLight,
                            borderRadius: BorderRadius.circular(8.r(context)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lock_outline, color: Colors.black54),
                              SizedBox(width: 16.w(context)),
                              Expanded(
                                child: TextField(
                                  controller: vendorChangePasswordController.newPasswordController.value,
                                  obscureText: !vendorChangePasswordController.isNewPasswordVisible.value,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'New Password',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  vendorChangePasswordController.isNewPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                                onPressed: vendorChangePasswordController.toggleNewPasswordVisibility,
                              ),
                            ],
                          ),
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 8.vpm(context)),
                          decoration: BoxDecoration(
                            color: ColorUtils.greenLight,
                            borderRadius: BorderRadius.circular(8.r(context)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lock_outline, color: Colors.black54),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: vendorChangePasswordController.confirmPasswordController.value,
                                  obscureText: !vendorChangePasswordController.isConfirmPasswordVisible.value,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Confirm New Password',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  vendorChangePasswordController.isConfirmPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                                onPressed: vendorChangePasswordController.toggleConfirmPasswordVisibility,
                              ),
                            ],
                          ),
                        ),

                        CustomButtonContainer.plainButtonContainer(
                            plainButtonHeight: 64.h(context),
                            plainButtonWidth: 428.w(context),
                            plainButtonRadius: 8.r(context),
                            plainButtonOnPress:  () async {
                              await AppLocalStorage.removeKey(key: "Login");
                              Get.to(()=>ForgotPasswordScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                            },
                            plainButtonHint: "Forgot the password?",
                            plainButtonHintAlign: Alignment.centerLeft,
                            plainButtonHintTextAlign: TextAlign.start,
                            plainButtonHintFontSize: 18.sp(context),
                            plainButtonColor: Colors.transparent,
                            plainButtonHintFontColor: ColorUtils.orange125
                        ),


                        vendorChangePasswordController.isSubmit.value == true ?
                        Container(
                          height: 64.h(context),
                          width: 428.h(context),
                          decoration: const BoxDecoration(
                              color: Colors.transparent
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(color: ColorUtils.green176,),
                          ),
                        ) :
                        CustomButtonContainer.plainButtonContainer(
                          plainButtonHeight: 64.h(context),
                          plainButtonWidth: 428.w(context),
                          plainButtonRadius: 8.r(context),
                          plainButtonOnPress:  () async {
                            if(vendorChangePasswordController.currentPasswordController.value.text == "") {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your Current Password");
                            } else if(vendorChangePasswordController.newPasswordController.value.text == "") {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your New Password");
                            } else if(vendorChangePasswordController.confirmPasswordController.value.text == "") {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your Confirm Password");
                            } else if(vendorChangePasswordController.newPasswordController.value.text != vendorChangePasswordController.confirmPasswordController.value.text) {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Password is Not Matching");
                            } else {
                              await vendorChangePasswordController.changePasswordVendorProfileController(
                                context: context,
                                email: vendorChangePasswordController.vendorProfileResponseModel.value.data?.email ?? "",
                                oldPassword: vendorChangePasswordController.currentPasswordController.value.text,
                                newPassword: vendorChangePasswordController.newPasswordController.value.text,
                              );
                            }
                          },
                          plainButtonHint: "Confirm",
                          plainButtonHintFontSize: 22.sp(context),
                          plainButtonColor: ColorUtils.green176,
                          plainButtonHintFontColor: ColorUtils.white255,
                        ),

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
