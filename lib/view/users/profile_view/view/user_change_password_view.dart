import 'package:flutter/material.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:discount_me_app/utils/utils.dart';
class UserChangePasswordView extends StatelessWidget {
  const UserChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserChangePasswordController userChangePasswordController = Get.put(UserChangePasswordController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop,onPopInvoked) {
        Get.to(()=>UserProfileSettingView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: userChangePasswordController.isLoading.value,
          child: Container(
            height: 926.h(context),
            width: 428.w(context),
            decoration: BoxDecoration(
              color: ColorUtils.whiteColor,
              image: DecorationImage(
                image: AssetImage(ImageUtils.homeBg),
                alignment: Alignment.topRight,
                opacity: 0.5,
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                      child: Column(
                        children: [

                          SpaceHelperWidget.v(12.h(context)),

                          UserProfileAppbarWidget(
                            title: "Change Password",
                            onTap: () async {
                              Get.to(()=>UserProfileSettingView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                            },
                          ),

                          SpaceHelperWidget.v(30.h(context)),


                        ],
                      ),
                    ),
                  ),



                  SliverFillRemaining(
                    child: CustomScrollView(
                      slivers: [

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  TextHelperClass.headingTextWithoutWidth(
                                    context: context,
                                    alignment: Alignment.centerLeft,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    textColor: ColorUtils.black96,
                                    text: "Current Password",
                                  ),

                                  SpaceHelperWidget.v(10.h(context)),


                                  TextFormFieldWidget.build(
                                    context: context,
                                    hintText: "Current Password",
                                    obscureText: userChangePasswordController.isCurrentPasswordVisible.value,
                                    controller: userChangePasswordController.currentPasswordController.value,
                                    fillColor: ColorUtils.white230,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(20.r(context)),
                                      child: InkWell(
                                        onTap: () async {},
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 24.h(context),
                                          width: 24.w(context),
                                          imageString: ImageUtils.blackLockImage,
                                        ),
                                      ),
                                    ),
                                    suffixIcon:  Padding(
                                      padding: EdgeInsets.all(20.r(context)),
                                      child: InkWell(
                                        onTap: () async {
                                          if(userChangePasswordController.isCurrentPasswordVisible.value == false) {
                                            userChangePasswordController.isCurrentPasswordVisible.value = true;
                                          } else {
                                            userChangePasswordController.isCurrentPasswordVisible.value = false;
                                          }
                                        },
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 24.h(context),
                                          width: 24.w(context),
                                          imageString: userChangePasswordController.isCurrentPasswordVisible.value == false ?
                                          ImageUtils.blackVisibleImage : ImageUtils.blackUnvisibleImage,
                                        ),
                                      ),
                                    ),
                                  ),



                                  SpaceHelperWidget.v(20.h(context)),



                                  TextHelperClass.headingTextWithoutWidth(
                                    context: context,
                                    alignment: Alignment.centerLeft,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    textColor: ColorUtils.black96,
                                    text: "New Password",
                                  ),

                                  SpaceHelperWidget.v(10.h(context)),


                                  TextFormFieldWidget.build(
                                    context: context,
                                    hintText: "New Password",
                                    obscureText: userChangePasswordController.isNewPasswordVisible.value,
                                    controller: userChangePasswordController.newPasswordController.value,
                                    fillColor: ColorUtils.white230,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(20.r(context)),
                                      child: InkWell(
                                        onTap: () async {},
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 24.h(context),
                                          width: 24.w(context),
                                          imageString: ImageUtils.blackLockImage,
                                        ),
                                      ),
                                    ),
                                    suffixIcon:  Padding(
                                      padding: EdgeInsets.all(20.r(context)),
                                      child: InkWell(
                                        onTap: () async {
                                          if(userChangePasswordController.isNewPasswordVisible.value == false) {
                                            userChangePasswordController.isNewPasswordVisible.value = true;
                                          } else {
                                            userChangePasswordController.isNewPasswordVisible.value = false;
                                          }
                                        },
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 24.h(context),
                                          width: 24.w(context),
                                          imageString: userChangePasswordController.isNewPasswordVisible.value == false ?
                                          ImageUtils.blackVisibleImage : ImageUtils.blackUnvisibleImage,
                                        ),
                                      ),
                                    ),
                                  ),


                                  SpaceHelperWidget.v(20.h(context)),



                                  TextHelperClass.headingTextWithoutWidth(
                                    context: context,
                                    alignment: Alignment.centerLeft,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    textColor: ColorUtils.black96,
                                    text: "Confirm New Password",
                                  ),

                                  SpaceHelperWidget.v(10.h(context)),


                                  TextFormFieldWidget.build(
                                    context: context,
                                    hintText: "Confirm New Password",
                                    obscureText: userChangePasswordController.isConfirmPasswordVisible.value,
                                    controller: userChangePasswordController.confirmPasswordController.value,
                                    fillColor: ColorUtils.white230,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(20.r(context)),
                                      child: InkWell(
                                        onTap: () async {},
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 24.h(context),
                                          width: 24.w(context),
                                          imageString: ImageUtils.blackLockImage,
                                        ),
                                      ),
                                    ),
                                    suffixIcon:  Padding(
                                      padding: EdgeInsets.all(20.r(context)),
                                      child: InkWell(
                                        onTap: () async {
                                          if(userChangePasswordController.isConfirmPasswordVisible.value == false) {
                                            userChangePasswordController.isConfirmPasswordVisible.value = true;
                                          } else {
                                            userChangePasswordController.isConfirmPasswordVisible.value = false;
                                          }
                                        },
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 24.h(context),
                                          width: 24.w(context),
                                          imageString: userChangePasswordController.isConfirmPasswordVisible.value == false ?
                                          ImageUtils.blackVisibleImage : ImageUtils.blackUnvisibleImage,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SpaceHelperWidget.v(20.h(context)),


                                  ButtonHelperWidget.customButtonWidget(
                                    context: context,
                                    height: 44,
                                    onPressed: () async {
                                      await LocalStorageUtils.remove(AppConstantUtils.loginResponse);
                                      Get.to(()=> ForgotPasswordScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                    },
                                    text: "Forgot the password?",
                                    padding: EdgeInsets.symmetric(vertical: 14.5.vpm(context)),
                                    alignment: Alignment.centerLeft,
                                    fontSize: 18,
                                    textColor: ColorUtils.orange125,
                                    fontWeight: FontWeight.w700,
                                    backgroundColor: Colors.transparent,
                                  ),


                                  SpaceHelperWidget.v(20.h(context)),


                                  userChangePasswordController.isSubmit.value == true ?
                                  LoadingHelperWidget.loadingHelperWidget(
                                    context: context,
                                  ) :
                                  ButtonHelperWidget.customButtonWidget(
                                    context: context,
                                    onPressed: () async {
                                      if(userChangePasswordController.currentPasswordController.value.text == "") {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Enter your current password");
                                      } else if(userChangePasswordController.currentPasswordController.value.text.length < 8) {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Please enter 8 character current password");
                                      } else if(userChangePasswordController.newPasswordController.value.text == "") {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Enter your new password");
                                      } else if(userChangePasswordController.newPasswordController.value.text.length < 8 ) {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Please enter 8 character new password");
                                      } else if(userChangePasswordController.confirmPasswordController.value.text == "") {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Enter your confirm password");
                                      } else if(userChangePasswordController.confirmPasswordController.value.text.length < 8 ) {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Please enter 8 character confirm password");
                                      } else if(userChangePasswordController.newPasswordController.value.text != userChangePasswordController.confirmPasswordController.value.text) {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Password is not match");
                                      } else {
                                        userChangePasswordController.isSubmit.value = true;
                                        Map<String,dynamic> data = {
                                          "email": userChangePasswordController.userProfileResponseModel.value.data?.email,
                                          "oldPassword": userChangePasswordController.currentPasswordController.value.text,
                                          "newPassword": userChangePasswordController.newPasswordController.value.text,
                                        };
                                        print(data);
                                        await userChangePasswordController.brokerChangePasswordController(
                                          context: context,
                                          data: data,
                                        );
                                      }
                                    },
                                    text: "Update",
                                    borderRadius: 8,
                                    backgroundColor: ColorUtils.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    textColor: ColorUtils.white255,
                                  ),


                                  SpaceHelperWidget.v(20.h(context)),




                                ],
                              ),
                            ),
                          ),
                        )


                      ],
                    ),
                  )



                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
