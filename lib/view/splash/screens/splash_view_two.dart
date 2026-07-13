import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashViewTwo extends StatelessWidget {
  const SplashViewTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 926.h(context),
        width: 428.w(context),
        decoration: const BoxDecoration(
          color: ColorUtils.white253,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 21.hpm(context),
        ),
        child: CustomScrollView(
          physics: MediaQuery.of(context).orientation.name == "portrait" ?
          const NeverScrollableScrollPhysics() :
          const AlwaysScrollableScrollPhysics(),
          slivers: [


            SliverToBoxAdapter(
              child: Column(
                children: [

                  SpaceHelperWidget.v(125.h(context)),


                  ImageHelperWidget.assetImageWidget(
                    context: context,
                    height: 93.h(context),
                    width: 357.w(context),
                    imageString: ImageUtils.discountMeLogo,
                  ),


                  SpaceHelperWidget.v(51.6.h(context)),


                  ImageHelperWidget.assetImageWidget(
                    context: context,
                    height: 428.h(context),
                    width: 428.w(context),
                    imageString: ImageUtils.eatingDonutBro,
                  ),


                  SpaceHelperWidget.v(173.5.h(context)),


                  ButtonHelperWidget.customButtonWidget(
                    context: context,
                    onPressed: () async {
                      await LocalStorageUtils.setBool(AppConstantUtils.getStart, true);
                      Get.to(()=> WelcomeView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                    },
                    text: "Let's Go",
                    borderRadius: 8,
                    backgroundColor: ColorUtils.orange41,
                    fontWeight: FontWeight.w700,
                    textColor: ColorUtils.white255,
                  ),


                  SpaceHelperWidget.v(20.h(context)),



                ],
              ),
            )








          ],
        ),
      ),
    );
  }
}



