import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
class UserProfileSettingView extends StatelessWidget {
  const UserProfileSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserSettingController userSettingController = Get.put(UserSettingController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop,onPopInvoked) {
        Get.to(()=>UserDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(()=> Skeletonizer(
          effect: PulseEffect(),
          enabled: userSettingController.isLoading.value,
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
                              Get.to(()=>UserDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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
                                      Get.to(()=>UserChangePasswordView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                    },
                                    trailing: true,
                                    context: context,
                                  ),


                                  SpaceHelperWidget.v(20.h(context)),


                                  _buildTile(
                                    rightIcon: ImageUtils.deleteImage,
                                    title: "Delete Account",
                                    onPressed: () async {
                                      ProfileDialogBox().userDeleteAccountDialogBox(
                                        context: context,
                                        userSettingController: userSettingController,
                                        cancelFunction: () async {
                                          Navigator.pop(context);
                                        },
                                        logoutFunction: () async {
                                          userSettingController.isDelete.value = true;
                                          await userSettingController.deleteUserProfileController(
                                            context: context,
                                            userId: userSettingController.userProfileResponseModel.value.data?.sId ?? "",
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
