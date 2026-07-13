import 'dart:ui';
import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  CreateNewPasswordScreen({super.key,required this.email});

  final String email;
  final CreatePasswordController createPasswordController = Get.put(CreatePasswordController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        Get.to(()=> OtpVerifyScreen(email: email,isSignUp: false,),duration: const Duration(milliseconds: 100),preventDuplicates: false,);
      },
      child: Scaffold(
        body: Obx(()=>Container(
          height: 926.h(context),
          width: 428.w(context),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [

              Container(
                height: 926.h(context),
                width: 428.w(context),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageUtils.authBg),
                    fit: BoxFit.fill,
                  ),
                ),
              ),



              /// Blur Effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  height: 926.h(context),
                  width: 428.w(context),
                  color: ColorUtils.black36,
                ),
              ),


              Container(
                height: 926.h(context),
                width: 428.w(context),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                  
                  
                      CustomAppBarContainer().authScreenAppBar(
                        context: context,
                        title: "Create New Password",
                        onPress: () async {
                          Get.to(()=> OtpVerifyScreen(email: email,isSignUp: false,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                        },
                      ),
                  
                      SliverToBoxAdapter(
                        child: Container(
                          width: 428.w(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: 21.hpm(context),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                  
                              SpaceHelperWidget.v(88.h(context)),
                  
                  
                  
                              ImageHelperWidget.assetImageWidget(
                                context: context,
                                height: 308.h(context),
                                width: 302.w(context),
                                imageString: ImageUtils.createPassBg,
                              ),
                  
                  
                              SpaceHelperWidget.v(80.h(context)),
                  
                  
                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.centerLeft,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                textColor: ColorUtils.white253,
                                text: "Enter Password",
                              ),
                  
                              SpaceHelperWidget.v(10.h(context)),
                  
                  
                              TextFormFieldWidget.build(
                                context: context,
                                hintText: "Enter Password",
                                borderColor: ColorUtils.white202,
                                enableBorderColor: ColorUtils.white202,
                                focusedBorderColor: ColorUtils.secondaryColor,
                                obscureText: createPasswordController.isNewPasswordVisible.value,
                                controller: createPasswordController.passwordController.value,
                                fillColor: ColorUtils.white253,
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
                                      if(createPasswordController.isNewPasswordVisible.value == false) {
                                        createPasswordController.isNewPasswordVisible.value = true;
                                      } else {
                                        createPasswordController.isNewPasswordVisible.value = false;
                                      }
                                    },
                                    child: ImageHelperWidget.assetImageWidget(
                                      context: context,
                                      height: 24.h(context),
                                      width: 24.w(context),
                                      imageString: createPasswordController.isNewPasswordVisible.value == false ?
                                      ImageUtils.blackVisibleImage : ImageUtils.blackUnvisibleImage,
                                    ),
                                  ),
                                ),
                              ),
                  
                              SpaceHelperWidget.v(30.h(context)),
                  
                  
                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.centerLeft,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                textColor: ColorUtils.white253,
                                text: "Enter Confirm Password",
                              ),
                  
                              SpaceHelperWidget.v(10.h(context)),
                  
                  
                              TextFormFieldWidget.build(
                                context: context,
                                hintText: "Enter Confirm Password",
                                borderColor: ColorUtils.white202,
                                enableBorderColor: ColorUtils.white202,
                                focusedBorderColor: ColorUtils.secondaryColor,
                                obscureText: createPasswordController.isNewConfirmPasswordVisible.value,
                                controller: createPasswordController.confirmPasswordController.value,
                                fillColor: ColorUtils.white253,
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
                                      if(createPasswordController.isNewConfirmPasswordVisible.value == false) {
                                        createPasswordController.isNewConfirmPasswordVisible.value = true;
                                      } else {
                                        createPasswordController.isNewConfirmPasswordVisible.value = false;
                                      }
                                    },
                                    child: ImageHelperWidget.assetImageWidget(
                                      context: context,
                                      height: 24.h(context),
                                      width: 24.w(context),
                                      imageString:createPasswordController.isNewConfirmPasswordVisible.value == false ?
                                      ImageUtils.blackVisibleImage : ImageUtils.blackUnvisibleImage,
                                    ),
                                  ),
                                ),
                              ),
                  
                              SpaceHelperWidget.v(30.h(context)),
                  
                  
                              createPasswordController.isSubmit.value == true ?
                              Container(
                                height: 64.h(context),
                                width: 428.h(context),
                                decoration: const BoxDecoration(
                                    color: Colors.transparent
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(color: ColorUtils.white253,),
                                ),
                              ) :
                              CustomButtonContainer.plainButtonContainer(
                                plainButtonHeight: 64.h(context),
                                plainButtonWidth: 428.w(context),
                                plainButtonRadius: 8.r(context),
                                plainButtonOnPress:  () async {
                                  if(createPasswordController.passwordController.value.text == "") {
                                    CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your Password");
                                  }else if(createPasswordController.confirmPasswordController.value.text == "") {
                                    CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your Confirm Password");
                                  }else if(createPasswordController.confirmPasswordController.value.text != createPasswordController.passwordController.value.text) {
                                    CustomSnackBar().errorCustomSnackBar(context: context, message: "Password is Not Matching");
                                  }else{
                                    createPasswordController.isSubmit.value = true;
                                    Map<String,dynamic> data = {
                                      "email": email,
                                      "password": createPasswordController.passwordController.value.text
                                    };
                                    await createPasswordController.getResetPasswordResponse(
                                      data: data,
                                      context: context,
                                    );
                                  }
                  
                                },
                                plainButtonHint: "Confirm",
                                plainButtonHintFontSize: 22.sp(context),
                                plainButtonColor: ColorUtils.green176,
                                plainButtonHintFontColor: ColorUtils.white255,
                              ),
                  
                              CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                  
                  
                  
                  
                  
                            ],
                          ),
                        ),
                      )
                  
                  
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
