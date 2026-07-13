import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/riders/rider_profile_view/controller/rider_profile_change_password_controller.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../res/res.dart';

class RiderChangePasswordScreen extends StatelessWidget {
  const RiderChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RiderProfileChangePasswordController riderProfileChangePasswordController = Get.put(RiderProfileChangePasswordController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onPopInvoked) {
        Get.to(()=>RiderSettingScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: riderProfileChangePasswordController.isLoading.value,
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
                            Get.to(()=>RiderSettingScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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
                                  controller: riderProfileChangePasswordController.currentPasswordController.value,
                                  obscureText: !riderProfileChangePasswordController.isCurrentPasswordVisible.value,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Current Password',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  riderProfileChangePasswordController.isCurrentPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                                onPressed: riderProfileChangePasswordController.toggleCurrentPasswordVisibility,
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
                                  controller: riderProfileChangePasswordController.newPasswordController.value,
                                  obscureText: !riderProfileChangePasswordController.isNewPasswordVisible.value,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'New Password',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  riderProfileChangePasswordController.isNewPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                                onPressed: riderProfileChangePasswordController.toggleNewPasswordVisibility,
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
                                  controller: riderProfileChangePasswordController.confirmPasswordController.value,
                                  obscureText: !riderProfileChangePasswordController.isConfirmPasswordVisible.value,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Confirm New Password',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  riderProfileChangePasswordController.isConfirmPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                                onPressed: riderProfileChangePasswordController.toggleConfirmPasswordVisibility,
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


                        riderProfileChangePasswordController.isSubmit.value == true ?
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
                            if(riderProfileChangePasswordController.currentPasswordController.value.text == "") {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your Current Password");
                            }else if(riderProfileChangePasswordController.newPasswordController.value.text == "") {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your New Password");
                            }else if(riderProfileChangePasswordController.confirmPasswordController.value.text == "") {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your Confirm Password");
                            }else if(riderProfileChangePasswordController.newPasswordController.value.text != riderProfileChangePasswordController.confirmPasswordController.value.text) {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Password is Not Matching");
                            }else{
                              await riderProfileChangePasswordController.changePasswordRiderProfileController(
                                context: context,
                                email: riderProfileChangePasswordController.riderProfileResponse.value.data?.email ?? "",
                                oldPassword: riderProfileChangePasswordController.currentPasswordController.value.text,
                                newPassword: riderProfileChangePasswordController.newPasswordController.value.text,
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
