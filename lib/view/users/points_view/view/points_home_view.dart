import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';


class PointsHomeView extends StatelessWidget {
  const PointsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final PointsHomeController pointsHomeController = Get.put(PointsHomeController(context: context));
    return Scaffold(
      body: Container(
        height: 926.h(context),
        width: 428.w(context),
        decoration: BoxDecoration(
          color: ColorUtils.white253,
          image: DecorationImage(
            image: AssetImage(ImageUtils.homeBg),
            alignment: Alignment.topRight,
            opacity: 0.5,
          ),
        ),
        child: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: pointsHomeController.isLoading.value,
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
            
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                    child: Column(
                      children: [
            
                        SpaceHelperWidget.v(20.h(context)),
            
            
                        Container(
                          width: 428.w(context),
                          decoration: BoxDecoration(
                              color: Colors.transparent
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
            
            
                                    ImageHelperWidget.circleImageHelperWidget(
                                      width: 45,
                                      height: 45,
                                      verticalPadding: 1,
                                      horizontalPadding: 1,
                                      backgroundColor: ColorUtils.orange213,
                                      radius: 25,
                                      context: context,
                                      imageAsset: pointsHomeController.userProfileResponseModel.value.data?.image ==  null ? ImageUtils.noImage : null,
                                      imageUrl: pointsHomeController.userProfileResponseModel.value.data?.image,
                                    ),
            
                                    SpaceHelperWidget.h(20.w(context)),
            
                                    Expanded(
                                      child: Center(
                                        child: ImageHelperWidget.assetImageWidget(
                                          context: context,
                                          height: 64.h(context),
                                          width: 170.w(context),
                                          imageString: ImageUtils.discountMeLogo,
                                        ),
                                      ),
                                    ),
            
            
                                  ],
                                ),
                              ),
            
                              SpaceHelperWidget.h(5.w(context)),
            
            
                              Row(
                                children: [
            
                                  InkWell(
                                    onTap: () {
                                      Get.to(()=>UserNotificationView(),preventDuplicates: false,duration: const Duration(milliseconds: 100));
                                    },
                                    child: Container(
                                      width: 45.w(context),
                                      height: 45.h(context),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorUtils.primaryColor,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: ColorUtils.whiteColor,
                                            blurRadius: 10,
                                            offset: Offset(0, 1),
                                          )
                                        ],
                                      ),
                                      child: Icon(Icons.notifications, color: ColorUtils.whiteColor, size: 25.r(context),),
                                    ),
                                  ),
            
                                  SpaceHelperWidget.h(6.w(context)),
            
            
                                  InkWell(
                                    onTap: () {
                                      Get.to(()=> CartView(),preventDuplicates: false,duration: const Duration(milliseconds: 100));
                                    },
                                    child: Container(
                                      width: 45.w(context),
                                      height: 45.h(context),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorUtils.primaryColor,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: ColorUtils.whiteColor,
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(Icons.shopping_cart, color: ColorUtils.whiteColor,size: 22.r(context),),
                                    ),
                                  ),
            
                                ],
                              )
            
                            ],
                          ),
                        ),
            
            
                        SpaceHelperWidget.v(20.h(context)),
            
            
            
            
            
                      ],
                    ),
                  ),
                ),
            
            
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        
                        _pointsCard(
                          points: pointsHomeController.userProfileResponseModel.value.data?.totalRewardPoints.toString() ?? "0.0",
                          context: context,
                        ),
                        
                        SpaceHelperWidget.v(24.h(context)),
                        
            
                        _sectionLabel(text: 'HOW YOU EARN',context: context),

                        SpaceHelperWidget.v(8.h(context)),


                        Container(
                          padding: EdgeInsets.all(10.r(context)),
                          decoration: BoxDecoration(
                            color: Color(0xFFE6F7ED),
                            borderRadius: BorderRadius.circular(16.r(context)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.attach_money, size: 20.r(context), color: ColorUtils.black29),
                              SpaceHelperWidget.h(10.w(context)),

                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.centerLeft,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                textColor: ColorUtils.black29,
                                text: '\$1 spent = 1 point earned',
                              ),

                            ],
                          ),
                        ),

                        SpaceHelperWidget.v(24.h(context)),

            
                        _sectionLabel(text: 'REWARD TIERS',context: context),

                        SpaceHelperWidget.v(12.h(context)),

                        _tiersTable(tiers: pointsHomeController.tiers,context: context),

                        SpaceHelperWidget.v(24.h(context)),
            
                        _sectionLabel(text: 'YOUR PROGRESS',context: context),

                        SpaceHelperWidget.v(10.h(context)),

                        _progressSection(
                          context: context,
                          point: double.parse(pointsHomeController.userProfileResponseModel.value.data?.totalRewardPoints.toString() ?? "0.0"),
                        ),


                        SpaceHelperWidget.v(28.h(context)),


                        if(double.parse(pointsHomeController.userProfileResponseModel.value.data?.totalRewardPoints.toString() ?? "0.0") > 500)...[
                          ButtonHelperWidget.customButtonWidget(
                            context: context,
                            onPressed: () async {
                              Get.to(()=> CartView(),preventDuplicates: false,duration: const Duration(milliseconds: 100));
                            },
                            text: 'Redeem my points',
                            borderRadius: 8,
                            backgroundColor:  ColorUtils.primaryColor,
                            fontWeight: FontWeight.w600,
                            textColor: ColorUtils.white255,
                          ),

                          SpaceHelperWidget.v(28.h(context)),
                        ],


                      ],
                    ),
                  ),
                ),
                
                
              ],
            ),
          ),
        )),
      ),
    );
  }


  Widget _pointsCard({required String points,required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(10.r(context)),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7ED),
        borderRadius: BorderRadius.circular(16.r(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextHelperClass.headingTextWithoutWidth(
                context: context,
                alignment: Alignment.centerLeft,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: Color(0xFF6B7280),
                text: 'Your current points',
              ),


              SpaceHelperWidget.v(6.h(context)),


              TextHelperClass.headingTextWithoutWidth(
                context: context,
                alignment: Alignment.centerLeft,
                fontSize: 34,
                fontWeight: FontWeight.w700,
                textColor: ColorUtils.black21,
                text: '${points}',
              ),

              SpaceHelperWidget.v(6.h(context)),

              TextHelperClass.headingTextWithoutWidth(
                context: context,
                alignment: Alignment.centerLeft,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: Color(0xFF6B7280),
                text: 'pts',
              ),
              
            ],
          ),
          Container(
            width: 66.w(context),
            height: 66.h(context),
            decoration: const BoxDecoration(
              color: ColorUtils.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.star_outline, color: Colors.white, size: 36.r(context)),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel({
    required String text,
    required BuildContext context,
  }) {
    return TextHelperClass.headingTextWithoutWidth(
      context: context,
      alignment: Alignment.centerLeft,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      textColor: Color(0xFF6B7280),
      text: text,
      letterSpacing: 0.6,
    );
  }


  Widget _tiersTable({
    required BuildContext context,
    required List<Map<String, String>> tiers,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFE6F7ED),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(16.r(context)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: Color(0xFFE6F7ED),
            padding: EdgeInsets.all(10.r(context)),
            child: Row(
              children: [
                Expanded(
                  child: TextHelperClass.headingTextWithoutWidth(
                    context: context,
                    alignment: Alignment.centerLeft,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: ColorUtils.black29,
                    text: 'Points',
                  ),
                ),


                Expanded(
                  child: TextHelperClass.headingTextWithoutWidth(
                    context: context,
                    alignment: Alignment.centerLeft,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: ColorUtils.black29,
                    text: 'Reward',
                  ),
                ),

              ],
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE5E7EB)),
          ...List.generate(tiers.length, (i) {
            final tier = tiers[i];
            final isLast = i == tiers.length - 1;
            return Column(
              children: [
                Container(
                  color: i.isOdd ?
                  Color(0xFFE6F7ED) : Colors.white,
                  padding: EdgeInsets.all(10.r(context)),
                  child: Row(
                    children: [

                      Expanded(
                        child: TextHelperClass.headingTextWithoutWidth(
                          context: context,
                          padding: EdgeInsets.symmetric(horizontal: 10.hpm(context), vertical: 4.vpm(context),),
                          alignment: Alignment.centerLeft,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          borderRadius: BorderRadius.circular(8.r(context)),
                          textColor: ColorUtils.black29,
                          text: tier['points']!,
                        ),
                      ),


                      Expanded(
                        child: TextHelperClass.headingTextWithoutWidth(
                          context: context,
                          alignment: Alignment.centerLeft,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          textColor: ColorUtils.black29,
                          text: tier['reward']!,
                        ),
                      ),

                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: Color(0xFFF3F4F6),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }


  Widget _progressSection({
    required BuildContext context,
    required double point,
  }) {

    /// Reward Tiers
    final List<Map<String, dynamic>> rewardTiers = [
      {
        "point": 100,
        "reward": "1% off",
      },
      {
        "point": 500,
        "reward": "5% off",
      },
      {
        "point": 1000,
        "reward": "10% off",
      },
      {
        "point": 2000,
        "reward": "20% off",
      },
    ];

    /// Get Current Next Reward
    Map<String, dynamic>? nextReward;

    for (var tier in rewardTiers) {
      if (point < tier["point"]) {
        nextReward = tier;
        break;
      }
    }

    /// If user completed all rewards
    nextReward ??= rewardTiers.last;

    final double targetPoint = nextReward["point"].toDouble();
    final String rewardText = nextReward["reward"];

    /// Progress Value
    final double progressValue =
    point >= targetPoint ? 1 : (point / targetPoint);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Next Reward Text
        RichTextHelperWidget.headingRichText(
          context: context,
          alignment: Alignment.centerLeft,
          textAlign: TextAlign.left,
          textSpans: [
            CustomTextSpan(
              text: "Next reward: ",
              fontSize: 20,
              color: ColorUtils.black64,
              fontWeight: FontWeight.w500,
            ).toTextSpan(),
            CustomTextSpan(
              text: "${point.toStringAsFixed(0)} pts",
              fontSize: 20,
              color: ColorUtils.black21,
              fontWeight: FontWeight.w700,
            ).toTextSpan(),
            CustomTextSpan(
              text: " — $rewardText",
              fontSize: 20,
              color: ColorUtils.black21,
              fontWeight: FontWeight.w500,
            ).toTextSpan(),
          ],
        ),

        SpaceHelperWidget.v(8.h(context)),

        /// Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(99.r(context)),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 8.h(context),
            backgroundColor: const Color(0xFFE6F7ED),
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorUtils.primaryColor,
            ),
          ),
        ),

        SpaceHelperWidget.v(8.h(context)),

        /// Bottom Points Info
        Row(
          children: [

            Expanded(
              child: TextHelperClass.headingTextWithoutWidth(
                context: context,
                alignment: Alignment.centerLeft,
                textAlign: TextAlign.left,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                textColor: ColorUtils.black64,
                text: '${point.toStringAsFixed(1)} pts',
              ),
            ),

            Expanded(
              child: TextHelperClass.headingTextWithoutWidth(
                context: context,
                alignment: Alignment.centerRight,
                textAlign: TextAlign.right,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                textColor: ColorUtils.black64,
                text:
                '${(targetPoint - point).clamp(0, targetPoint).toStringAsFixed(1)} pts needed',
              ),
            ),
          ],
        ),
      ],
    );
  }


}

