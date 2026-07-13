import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';


class BrokerChangePasswordView extends StatelessWidget {
  const BrokerChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final BrokerChangePasswordController brokerChangePasswordController = Get.put(BrokerChangePasswordController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop,onPopInvoked) {
        Get.to(()=>BrokerSettingView(),preventDuplicates: false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: brokerChangePasswordController.isLoading.value,
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
                              Get.to(()=>BrokerSettingView(),preventDuplicates: false);
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
                                    obscureText: brokerChangePasswordController.isCurrentPasswordVisible.value,
                                    controller: brokerChangePasswordController.currentPasswordController.value,
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
                                          if(brokerChangePasswordController.isCurrentPasswordVisible.value == false) {
                                            brokerChangePasswordController.isCurrentPasswordVisible.value = true;
                                          } else {
                                            brokerChangePasswordController.isCurrentPasswordVisible.value = false;
                                          }
                                        },
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 24.h(context),
                                          width: 24.w(context),
                                          imageString: brokerChangePasswordController.isCurrentPasswordVisible.value == false ?
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
                                    obscureText: brokerChangePasswordController.isNewPasswordVisible.value,
                                    controller: brokerChangePasswordController.newPasswordController.value,
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
                                          if(brokerChangePasswordController.isNewPasswordVisible.value == false) {
                                            brokerChangePasswordController.isNewPasswordVisible.value = true;
                                          } else {
                                            brokerChangePasswordController.isNewPasswordVisible.value = false;
                                          }
                                        },
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 24.h(context),
                                          width: 24.w(context),
                                          imageString: brokerChangePasswordController.isNewPasswordVisible.value == false ?
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
                                    obscureText: brokerChangePasswordController.isConfirmPasswordVisible.value,
                                    controller: brokerChangePasswordController.confirmPasswordController.value,
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
                                          if(brokerChangePasswordController.isConfirmPasswordVisible.value == false) {
                                            brokerChangePasswordController.isConfirmPasswordVisible.value = true;
                                          } else {
                                            brokerChangePasswordController.isConfirmPasswordVisible.value = false;
                                          }
                                        },
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 24.h(context),
                                          width: 24.w(context),
                                          imageString: brokerChangePasswordController.isConfirmPasswordVisible.value == false ?
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


                                  brokerChangePasswordController.isSubmit.value == true ?
                                  LoadingHelperWidget.loadingHelperWidget(
                                    context: context,
                                  ) :
                                  ButtonHelperWidget.customButtonWidget(
                                    context: context,
                                    onPressed: () async {
                                      if(brokerChangePasswordController.currentPasswordController.value.text == "") {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Enter your current password");
                                      } else if(brokerChangePasswordController.currentPasswordController.value.text.length < 8) {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Please enter 8 character current password");
                                      } else if(brokerChangePasswordController.newPasswordController.value.text == "") {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Enter your new password");
                                      } else if(brokerChangePasswordController.newPasswordController.value.text.length < 8 ) {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Please enter 8 character new password");
                                      } else if(brokerChangePasswordController.confirmPasswordController.value.text == "") {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Enter your confirm password");
                                      } else if(brokerChangePasswordController.confirmPasswordController.value.text.length < 8 ) {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Please enter 8 character confirm password");
                                      } else if(brokerChangePasswordController.newPasswordController.value.text != brokerChangePasswordController.confirmPasswordController.value.text) {
                                        MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Password is not match");
                                      } else {
                                        brokerChangePasswordController.isSubmit.value = true;
                                        Map<String,dynamic> data = {
                                          "email": brokerChangePasswordController.getBrokerProfileResponseModel.value.data?.email,
                                          "oldPassword": brokerChangePasswordController.currentPasswordController.value.text,
                                          "newPassword": brokerChangePasswordController.newPasswordController.value.text,
                                        };
                                        print(data);
                                        await brokerChangePasswordController.brokerChangePasswordController(
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
