import 'dart:ui';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());
  OtpVerifyController otpVerifyController = Get.put(OtpVerifyController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        Get.to(()=>SignInView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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
                        title: "Forgot Password",
                        onPress: () async {
                          Get.to(()=>SignInView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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


                              SpaceHelperWidget.v(110.h(context)),



                              ImageHelperWidget.assetImageWidget(
                                context: context,
                                height: 277.55.h(context),
                                width: 372.5.w(context),
                                imageString: ImageUtils.forgotBg,
                              ),


                              SpaceHelperWidget.v(30.h(context)),


                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.center,
                                fontSize: 22,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w500,
                                textColor: ColorUtils.white253,
                                text: "Select which contact details should we use to reset your password",
                              ),

                              SpaceHelperWidget.v(30.h(context)),


                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.hpm(context),
                                  vertical: 24.vpm(context),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: ColorUtils.white253,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r(context)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [


                                    ImageHelperWidget.circleImageHelperWidget(
                                      height: 80,
                                      width: 80,
                                      radius: 40,
                                      imageAsset: ImageUtils.forgotPasswordScreenEmailImage,
                                      fit: BoxFit.fitWidth,
                                      context: context,
                                    ),


                                    SpaceHelperWidget.h(20.w(context)),



                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [


                                          TextHelperClass.headingTextWithoutWidth(
                                            context: context,
                                            alignment: Alignment.centerLeft,
                                            fontSize: 17,
                                            textAlign: TextAlign.start,
                                            fontWeight: FontWeight.w400,
                                            textColor: ColorUtils.white253,
                                            text: "via Email:",
                                          ),



                                          TextFormFieldWidget().normalTextFormFiledWidget(
                                            context: context,
                                            controller: forgotPasswordController.emailController.value,
                                            hintText: "example@email.com",
                                          )


                                        ]
                                      ),
                                    ),


                                  ],
                                ),
                              ),


                              SpaceHelperWidget.v(30.h(context)),


                              forgotPasswordController.isSubmit.value == true ?
                              LoadingHelperWidget.loadingHelperWidget(
                                context: context,
                              ) :
                              ButtonHelperWidget.customButtonWidget(
                                context: context,
                                onPressed: () async {
                                  if(forgotPasswordController.emailController.value.text == "") {
                                    CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter email address");
                                  } else {
                                    forgotPasswordController.isSubmit.value = true;
                                    Map<String,dynamic> data = {
                                      "email": forgotPasswordController.emailController.value.text,
                                    };
                                    await forgotPasswordController.getForgotPasswordResponse(
                                      data: data,
                                      context: context,
                                      email: forgotPasswordController.emailController.value.text,
                                    );
                                  }
                                },
                                text: "Verify",
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
