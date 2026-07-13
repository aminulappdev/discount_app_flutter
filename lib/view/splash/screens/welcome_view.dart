import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/utils/utils.dart';

class WelcomeView extends StatelessWidget {
  WelcomeView({super.key});

  final WelcomeController welcomeController = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 926.h(context),
        width: 428.w(context),
        decoration: const BoxDecoration(
          color: ColorUtils.white253,
        ),
        child: Stack(
          children: [


            Align(
              alignment: Alignment.bottomCenter,
              child: ImageHelperWidget.assetImageWidget(
                height: 313.h(context),
                width: 428.w(context),
                imageString: ImageUtils.welcomeBgMain,
                context: context,
              ),
            ),

            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 21.hpm(context)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ImageHelperWidget.assetImageWidget(
                      height: 93.h(context),
                      width: 339.04.w(context),
                      imageString: ImageUtils.discountMeLogo,
                      context: context,
                    ),

                    SpaceHelperWidget.v(20.h(context)),

                    TextHelperClass.headingTextWithoutWidth(
                      context: context,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      textColor: ColorUtils.black29,
                      text: "Let’s get started!",
                    ),


                    SpaceHelperWidget.v(8.h(context)),


                    TextHelperClass.headingTextWithoutWidth(
                      context: context,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      textColor: ColorUtils.black43,
                      text: "Login to Stay healthy and fit ",
                    ),


                    SpaceHelperWidget.v(20.h(context)),


                    ButtonHelperWidget.customButtonWidget(
                      context: context,
                      onPressed: () async {
                        Get.to(()=>SignInView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                      },
                      text: "Log in",
                      borderRadius: 8,
                      backgroundColor: ColorUtils.green176,
                      fontWeight: FontWeight.w700,
                      textColor: ColorUtils.white255,
                    ),

                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                    ButtonHelperWidget.customIconButtonWidget(
                      context: context,
                      onPressed: () async {
                        await LocalStorageUtils.setBool(AppConstantUtils.getStart, true);
                        Get.to(()=>SignUpView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                      },
                      text: "Sign Up",
                      borderRadius: 8,
                      borderColor: ColorUtils.orange125,
                      fontWeight: FontWeight.w700,
                      textColor: ColorUtils.orange125,
                      borderWidth: 1,
                      iconPath: '',
                      isIcon: false,
                    ),


                    CustomSpaceWidget.spacerWidget(spaceHeight: 34.h(context)),
                  ],
                ),
              ),
            ),

            /// ✅ Animated Bike using GetX controller
            AnimatedBuilder(
              animation: welcomeController.animation,
              builder: (context, child) {
                bool isMovingLeft = welcomeController.animationController.status == AnimationStatus.reverse;
                String imagePath = isMovingLeft ? ImageUtils.discountMeBikeRight : ImageUtils.discountMeBike;
                return Positioned(
                  bottom: 0,
                  left: welcomeController.animation.value * (MediaQuery.of(context).size.width - 100),
                  child: Image.asset(imagePath, scale: 4),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}