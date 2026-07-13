import 'dart:ui';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPreviewScreen extends StatelessWidget {
  SignUpPreviewScreen({super.key});

  SignUpVerifyScreenController signUpPreviewScreenController = Get.put(SignUpVerifyScreenController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        Get.to(()=> SignInView(), duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Container(
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


                              SpaceHelperWidget.v(213.h(context)),


                              ImageHelperWidget.assetImageWidget(
                                context: context,
                                height: 376.h(context),
                                width: 376.w(context),
                                imageString: ImageUtils.signUpPreviewImg,
                              ),


                              SpaceHelperWidget.v(80.h(context)),


                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.center,
                                fontSize: 22,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                                textColor: ColorUtils.orange125,
                                text: "Your application is under review",
                              ),


                              SpaceHelperWidget.v(30.h(context)),


                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.center,
                                fontSize: 18,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w500,
                                textColor: ColorUtils.white253,
                                text: "We will notify you as soon as your account has been approved",
                              ),


                              SpaceHelperWidget.v(30.h(context)),

                            ],
                          ),
                        ),
                      ),
                  
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
