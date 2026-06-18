import 'dart:convert';
import 'dart:ui';
import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});

  final SignInController signInController = Get.put(SignInController());

  @override
   Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        Get.off(()=> WelcomeView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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
                          title: "Login Account",
                          onPress: () async {
                            Get.off(()=> WelcomeView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          }
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
                  
                              SpaceHelperWidget.v(30.h(context)),
                  
                  
                              ImageHelperWidget.assetImageWidget(
                                context: context,
                                height: 365.h(context),
                                width: 364.w(context),
                                imageString: ImageUtils.loginBg,
                              ),
                  
                  
                              SpaceHelperWidget.v(20.h(context)),
                  
                  
                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.center,
                                fontSize: 27,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                                textColor: ColorUtils.white253,
                                text: "Glad to meet  you again!",
                              ),
                  
                  
                              SpaceHelperWidget.v(20.h(context)),
                  
                  
                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.centerLeft,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                textColor: ColorUtils.white253,
                                text: "Email Address",
                              ),
                  
                              SpaceHelperWidget.v(10.h(context)),
                  
                  
                              TextFormFieldWidget.build(
                                context: context,
                                hintText: "Enter Email Address",
                                controller: signInController.emailController.value,
                                keyboardType: TextInputType.emailAddress,
                                fillColor: ColorUtils.white253,
                                borderColor: ColorUtils.white202,
                                enableBorderColor: ColorUtils.white202,
                                focusedBorderColor: ColorUtils.secondaryColor,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(20.r(context)),
                                  child: InkWell(
                                    onTap: () async {},
                                    child: ImageHelperWidget.assetImageWidget(
                                      context: context,
                                      height: 24.h(context),
                                      width: 24.w(context),
                                      imageString: ImageUtils.emailImage,
                                    ),
                                  ),
                                ),
                              ),
                  
                  
                              SpaceHelperWidget.v(20.h(context)),
                  
                  
                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.centerLeft,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                textColor: ColorUtils.white253,
                                text: "Password",
                              ),
                  
                              SpaceHelperWidget.v(10.h(context)),
                  
                  
                              TextFormFieldWidget.build(
                                context: context,
                                hintText: "Enter Password",
                                borderColor: ColorUtils.white202,
                                enableBorderColor: ColorUtils.white202,
                                focusedBorderColor: ColorUtils.secondaryColor,
                                obscureText: signInController.isPasswordVisible.value,
                                controller: signInController.passwordController.value,
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
                                      if(signInController.isPasswordVisible.value == false) {
                                        signInController.isPasswordVisible.value = true;
                                      } else {
                                        signInController.isPasswordVisible.value = false;
                                      }
                                    },
                                    child: ImageHelperWidget.assetImageWidget(
                                      context: context,
                                      height: 24.h(context),
                                      width: 24.w(context),
                                      imageString: signInController.isPasswordVisible.value == false ?
                                      ImageUtils.blackVisibleImage : ImageUtils.blackUnvisibleImage,
                                    ),
                                  ),
                                ),
                              ),
                  
                  
                              ButtonHelperWidget.customButtonWidget(
                                context: context,
                                onPressed: () async {
                                  Get.off(()=> ForgotPasswordScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                },
                                text: "Forgot the password?",
                                padding: EdgeInsets.symmetric(vertical: 14.5.vpm(context)),
                                alignment: Alignment.centerRight,
                                fontSize: 18,
                                textColor: ColorUtils.orange125,
                                fontWeight: FontWeight.w700,
                                backgroundColor: Colors.transparent,
                              ),
                  
                  
                              signInController.isSubmit.value == true ?
                              LoadingHelperWidget.loadingHelperWidget(
                                context: context,
                              ) :
                              ButtonHelperWidget.customButtonWidget(
                                context: context,
                                onPressed: () async {
                                  if(signInController.emailController.value.text == "") {
                                    CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your Email");
                                  } else if(signInController.passwordController.value.text == "") {
                                    CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Your Password");
                                  } else {
                                    signInController.isSubmit.value = true;
                                    print(signInController.emailController.value.text);
                                    print(signInController.passwordController.value.text);
                                    Map<String,dynamic> data = {
                                      "email": signInController.emailController.value.text,
                                      "password": signInController.passwordController.value.text,
                                    };
                                    await LocalStorageUtils.setString(AppConstantUtils.loginCredentialResponse, jsonEncode(data));
                                    print(jsonEncode(data));
                                    await signInController.getUserLoginResponse(
                                      data: data,
                                      context: context,
                                      onSuccess: (decodedToken) async {
                                        print(decodedToken['role']);
                                        if(decodedToken['role'] == "user") {
                                          Get.off(()=>UserDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                          signInController.isSubmit.value = false;
                                        } else if (decodedToken['role'] == "rider") {
                                          if(signInController.loginResponseModel.value.data?.hasFreeTrial == false && signInController.loginResponseModel.value.data?.subscription?.hasActiveSubscription == false) {
                                            Get.off(()=>RiderSubscriptionFreeTrailView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                          } else {
                                            Get.off(()=>RiderDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                          }
                                          signInController.isSubmit.value = false;
                                        } else if (decodedToken['role'] == "vendor") {
                                          if(signInController.loginResponseModel.value.data?.hasFreeTrial == false && signInController.loginResponseModel.value.data?.subscription?.hasActiveSubscription == false) {
                                            Get.off(()=>VendorSubscriptionFreeTrailView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                          } else {
                                            Get.off(()=>VendorDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                          }
                                          signInController.isSubmit.value = false;
                                        } else if (decodedToken['role'] == "broker") {
                                          if(signInController.loginResponseModel.value.data?.hasFreeTrial == false && signInController.loginResponseModel.value.data?.subscription?.hasActiveSubscription == false) {
                                            Get.off(()=>BrokerSubscriptionFreeTrailView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                          } else {
                                            Get.off(()=>BrokerDashboardView(index: 0),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                          }
                                          signInController.isSubmit.value = false;
                                        }
                                      }
                                    );
                                  }
                                },
                                text: "Log in",
                                borderRadius: 8,
                                backgroundColor: ColorUtils.primaryColor,
                                fontWeight: FontWeight.w700,
                                textColor: ColorUtils.white255,
                              ),
                  
                              SpaceHelperWidget.v(20.h(context)),
                  
                  
                              RichTextHelperWidget.headingRichText(
                                context: context,
                                alignment: Alignment.center,
                                textAlign: TextAlign.center,
                                textSpans: [
                                  CustomTextSpan(
                                    text: "Don't have an account? ",
                                    fontSize: 20,
                                    color: ColorUtils.white253,
                                    fontWeight: FontWeight.w500,
                                  ).toTextSpan(),
                                  CustomTextSpan(
                                    text: "Sign up",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.orange125,
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      Get.off(()=>SignUpView(), duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                    },
                                  ).toTextSpan(),
                                ],
                              ),
                  
                              SpaceHelperWidget.v(20.h(context)),
                  
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

