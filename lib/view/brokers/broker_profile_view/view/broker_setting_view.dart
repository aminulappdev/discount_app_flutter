import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:discount_me_app/view/brokers/broker_profile_view/view/broker_change_password_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BrokerSettingView extends StatelessWidget {
  const BrokerSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final BrokerSettingController brokerSettingController = Get.put(BrokerSettingController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop,onPopInvoked) {
        Get.to(()=>BrokerDashboardView(index: 3,),preventDuplicates: false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(()=> Skeletonizer(
          effect: PulseEffect(),
          enabled: brokerSettingController.isLoading.value,
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
                physics: NeverScrollableScrollPhysics(),
                slivers: [

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                      child: Column(
                        children: [

                          SpaceHelperWidget.v(12.h(context)),

                          UserProfileAppbarWidget(
                            title: "Setting",
                            onTap: () async {
                              Get.to(()=>BrokerDashboardView(index: 3,),preventDuplicates: false);
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

                                  _buildTile(
                                    rightIcon: ImageUtils.lockImage,
                                    title: "Change Password",
                                    onPressed: () async {
                                      Get.to(()=>BrokerChangePasswordView(),preventDuplicates: false);
                                    },
                                    trailing: true,
                                    context: context,
                                  ),


                                  SpaceHelperWidget.v(20.h(context)),


                                  _buildTile(
                                    rightIcon: ImageUtils.deleteImage,
                                    title: "Delete Account",
                                    onPressed: () async {
                                      ProfileDialogBox().deleteAccountDialogBox(
                                        context: context,
                                        brokerSettingController: brokerSettingController,
                                        cancelFunction: () async {
                                          Navigator.pop(context);
                                        },
                                        logoutFunction: () async {
                                          brokerSettingController.isDelete.value = true;
                                          await brokerSettingController.deleteVendorProfileController(
                                            context: context,
                                            brokerId: brokerSettingController.getBrokerProfileResponseModel.value.data?.sId ?? "",
                                          );
                                        },
                                      );
                                    },
                                    context: context,
                                  ),




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

  Widget _buildTile({
    required String rightIcon,
    required String title,
    bool trailing = false,
    required Function() onPressed,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.white230,
        borderRadius: BorderRadius.circular(12.r(context)),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20.hpm(context), vertical: 18.vpm(context)),
          overlayColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Row(
          children: [

            ImageHelperWidget.assetImageWidget(
              context: context,
              height: 27.h(context),
              width: 27.w(context),
              imageString: rightIcon,
            ),

            SpaceHelperWidget.h(12.w(context)),

            Expanded(
              child: TextHelperClass.headingTextWithoutWidth(
                context: context,
                alignment: Alignment.centerLeft,
                fontSize: 15,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w500,
                textColor: ColorUtils.black29,
                text: "${title}",
              ),
            ),

            SpaceHelperWidget.h(12.w(context)),


            if (trailing)...[
              ImageHelperWidget.assetImageWidget(
                context: context,
                height: 27.h(context),
                width: 27.w(context),
                imageString: ImageUtils.arrowRight,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
