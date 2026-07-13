import 'dart:ui';
import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerifyScreen extends StatelessWidget {
  OtpVerifyScreen({super.key,required this.email,required this.isSignUp});

  final String email;
  final bool isSignUp;

  final OtpVerifyController otpVerifyController = Get.put(OtpVerifyController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if(isSignUp == true) {
          Get.to(()=> SignUpView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
        } else {
          Get.to(()=> ForgotPasswordScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
        }
      },
      child: Scaffold(
        body: Obx(()=>Container(
          height: 926.h(context),
          width: 428.w(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageUtils.authBg),
              fit: BoxFit.fill,
              opacity: 0.3,
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.dstATop),
            ),
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
                        title: isSignUp == true ? "Sign Up Otp Verify" : "Otp Verify",
                        onPress: () async {
                          if(isSignUp == true) {
                            Get.to(()=> SignUpView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          } else {
                            Get.to(()=> ForgotPasswordScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          }
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
                              
                              
                              SpaceHelperWidget.v(100.h(context)),



                              ImageHelperWidget.assetImageWidget(
                                context: context,
                                height: 270.4.h(context),
                                width: 274.w(context),
                                imageString: ImageUtils.otpBg,
                              ),


                              SpaceHelperWidget.v(79.h(context)),



                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.center,
                                fontSize: 22,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w500,
                                textColor: ColorUtils.white253,
                                text: "Code has been send to ${email}",
                              ),



                              SpaceHelperWidget.v(30.h(context)),


                              TextFormFieldWidget.otpInputFiledBuild(
                                context: context,
                                onCompleted: (pin) {},
                                pinController: otpVerifyController.pinController.value,
                              ),


                              SpaceHelperWidget.v(30.h(context)),



                              if(otpVerifyController.timeCounter.value != 0)...[
                                TextHelperClass.headingTextWithoutWidth(
                                  context: context,
                                  alignment: Alignment.center,
                                  fontSize: 22,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w500,
                                  textColor: ColorUtils.white253,
                                  text: "Resend code in ${otpVerifyController.timeCounter.value} s",
                                )
                              ] else...[
                                Container(
                                  height: 64.h(context),
                                  width: 428.h(context),
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent
                                  ),
                                  child: otpVerifyController.isReset.value == true ?
                                  LoadingHelperWidget.loadingHelperWidget(
                                    context: context,
                                  ) :
                                  ButtonHelperWidget.customButtonWidget(
                                    context: context,
                                    onPressed:() async {
                                      otpVerifyController.isReset.value = true;
                                      Map<String,dynamic> data = {
                                        "email": email,
                                      };
                                      await otpVerifyController.getResetOtpResponse(
                                        data: data,
                                        email: email,
                                        isSignUp: isSignUp,
                                        context: context,
                                      );
                                    },
                                    text: "Resend Otp",
                                    padding: EdgeInsets.symmetric(vertical: 14.5.vpm(context)),
                                    alignment: Alignment.center,
                                    fontSize: 18,
                                    textColor: ColorUtils.orange125,
                                    fontWeight: FontWeight.w700,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ],


                              SpaceHelperWidget.v(30.h(context)),


                              otpVerifyController.isSubmit.value == true ?
                              LoadingHelperWidget.loadingHelperWidget(
                                context: context,
                              ) :
                              ButtonHelperWidget.customButtonWidget(
                                context: context,
                                onPressed: () async {
                                  if(otpVerifyController.pinController.value.text == "") {
                                    CustomSnackBar().errorCustomSnackBar(context: context, message: "Please fill the otp");
                                  } else {
                                    print(email);
                                    if(isSignUp == false) {
                                      otpVerifyController.isSubmit.value = true;
                                      Map<String,dynamic> data = {
                                        "email": email,
                                        "otp": otpVerifyController.pinController.value.text
                                      };
                                      await otpVerifyController.getVerifyOtpResponse(
                                        data: data,
                                        context: context,
                                        email: email,
                                      );
                                    } else {
                                      otpVerifyController.isSubmit.value = true;
                                      Map<String,dynamic> data = {
                                        "email": email,
                                        "otp": otpVerifyController.pinController.value.text,
                                        "verify_account": true,
                                      };
                                      await otpVerifyController.getVerifyOtpEmailResponse(
                                        data: data,
                                        context: context,
                                        email: email,
                                      );
                                    }
                                  }
                                },
                                text: "Confirm",
                                borderRadius: 8,
                                backgroundColor: ColorUtils.primaryColor,
                                fontWeight: FontWeight.w700,
                                textColor: ColorUtils.white255,
                              ),

                              SpaceHelperWidget.v(30.h(context)),

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
