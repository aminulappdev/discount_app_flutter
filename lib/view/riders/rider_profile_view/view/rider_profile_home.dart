import 'dart:io';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/riders/rider_earning_view/view/rider_profile_earing_home_screen.dart';
import 'package:discount_me_app/view/riders/rider_profile_view/view/rider_profile_edit_screen.dart';
import 'package:discount_me_app/view/riders/rider_profile_view/widget/rider_profile_dialog_box.dart';
import 'package:discount_me_app/view/users/chat_view/view/user_chat_vendor_list_screen.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../res/app_const/import_list.dart';
import '../../../../res/res.dart';

class RiderProfileHome extends StatelessWidget {
  const RiderProfileHome({super.key});

  @override
  Widget build(BuildContext context) {
    final RiderProfileController riderProfileController = Get.put(
      RiderProfileController(context: context),
    );
    return Scaffold(
      body: Container(
        height: 926.h(context),
        width: 428.w(context),
        decoration: BoxDecoration(color: Colors.white),
        child: Obx(
          () => Skeletonizer(
            effect: PulseEffect(),
            enabled: riderProfileController.isLoading.value,
            child: RefreshIndicator(
              onRefresh: () async {
                Get.to(
                  () => RiderDashboardView(index: 3),
                  duration: const Duration(milliseconds: 100),
                  preventDuplicates: false,
                );
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.hpm(context),
                        vertical: 16.vpm(context),
                      ),
                      child: Column(
                        children: [
                          // appBar
                          CustomSpaceWidget.spacerWidget(
                            spaceHeight: 40.h(context),
                          ),

                          UserProfileAppbarWidget(
                            title: " Profile",
                            widget: SizedBox(),
                          ),

                          // Profile image
                          CustomSpaceWidget.spacerWidget(
                            spaceHeight: 20.h(context),
                          ),

                          Center(
                            child: Stack(
                              children: [
                                riderProfileController
                                            .riderProfileResponse
                                            .value
                                            .data
                                            ?.image !=
                                        null
                                    ? CustomImageContainer.networkImageContainer(
                                        height: 220.h(context),
                                        width: 220.w(context),
                                        networkImage: riderProfileController
                                            .riderProfileResponse
                                            .value
                                            .data
                                            ?.image,
                                        boxFit: BoxFit.fitWidth,
                                        boxShape: BoxShape.circle,
                                      )
                                    : CustomImageContainer.assetImageContainer(
                                        height: 220.h(context),
                                        width: 220.w(context),
                                        assetImage: ImageUtils.profileImage,
                                        boxFit: BoxFit.fitWidth,
                                        boxShape: BoxShape.circle,
                                      ),
                                Positioned(
                                  bottom: 24.h(context),
                                  right: 17.w(context),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 34.w(context),
                                    height: 34.h(context),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.secondaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.r(context)),
                                        topRight: Radius.circular(
                                          10.r(context),
                                        ),
                                        bottomRight: Radius.circular(
                                          10.r(context),
                                        ),
                                      ),
                                    ),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () async {
                                        RiderProfileDialogBox()
                                            .imageUpdateDialogBox(
                                              context: context,
                                              riderProfileController:
                                                  riderProfileController,
                                              name: riderProfileController
                                                  .riderProfileResponse
                                                  .value
                                                  .data
                                                  ?.name,
                                              riderId: riderProfileController
                                                  .riderProfileResponse
                                                  .value
                                                  .data
                                                  ?.sId,
                                            );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 16.r(context),
                                        color: ColorUtils.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // name section
                          CustomSpaceWidget.spacerWidget(
                            spaceHeight: 20.h(context),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                plainTextString:
                                    riderProfileController
                                        .riderProfileResponse
                                        .value
                                        .data
                                        ?.name ??
                                    "",
                                plainTextStringFontSize: 20.sp(context),
                                plainTextStringFontWeight: FontWeight.w700,
                                plainTextContainerAlignment: Alignment.center,
                                plainTextStringTextAlign: TextAlign.center,
                                plainTextStringColor: ColorUtils.black29,
                              ),

                              TextButton(
                                onPressed: () {
                                  RiderProfileDialogBox().nameUpdateDialogBox(
                                    context: context,
                                    riderProfileController:
                                        riderProfileController,
                                    name:
                                        riderProfileController
                                            .riderProfileResponse
                                            .value
                                            .data
                                            ?.name ??
                                        "",
                                    nameControllerText: riderProfileController
                                        .nameControllerText
                                        .value,
                                    riderId: riderProfileController
                                        .riderProfileResponse
                                        .value
                                        .data
                                        ?.sId,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7.r(context)),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18.r(context),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // profile item
                          CustomSpaceWidget.spacerWidget(
                            spaceHeight: 15.h(context),
                          ),

                          // profile item
                          ProfileItemWidget(
                            title: "Edit Profile",
                            icon: Image.asset(ImageUtils.userEdite, scale: 5),
                            navigateIcon: Icon(
                              Icons.navigate_next,
                              size: 24.r(context),
                              color: Colors.black54,
                            ),
                            onTap: () {
                              Get.to(
                                () => RiderProfileEditScreen(),
                                preventDuplicates: false,
                                duration: Duration(milliseconds: 100),
                              );
                            },
                          ),

                          //CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),
                          ProfileItemWidget(
                            title: "Support Chat",
                            icon: Image.asset(ImageUtils.chat, scale: 5),
                            navigateIcon: Icon(
                              Icons.navigate_next,
                              size: 24.r(context),
                              color: Colors.black54,
                            ),
                            onTap: () {
                              Get.to(ChatListScreen());
                            },
                          ),

                          ProfileItemWidget(
                            title: "Earnings",
                            icon: Image.asset(ImageUtils.earnIcon, scale: 5),
                            navigateIcon: Icon(
                              Icons.navigate_next,
                              size: 24.r(context),
                              color: Colors.black54,
                            ),
                            onTap: () {
                              Get.to(RiderProfileEarningHomeScreen());
                            },
                          ),

                          //CustomSpaceWidget.spacerWidget(spaceHeight: 15.h(context)),
                          ProfileItemWidget(
                            title: "Settings",
                            icon: Image.asset(ImageUtils.settingIcon, scale: 5),
                            navigateIcon: Icon(
                              Icons.navigate_next,
                              size: 24.r(context),
                              color: Colors.black54,
                            ),
                            onTap: () {
                              Get.to(
                                () => RiderSettingScreen(),
                                preventDuplicates: false,
                                duration: Duration(milliseconds: 100),
                              );
                            },
                          ),

                          //CustomSpaceWidget.spacerWidget(spaceHeight: 15.h(context)),
                          ProfileItemWidget(
                            widget: CustomSpaceWidget.spacerWidget(),
                            title: "Logout",
                            icon: Image.asset(ImageUtils.logout, scale: 5),
                            onTap: () {
                              CustomAlertDialog().customAlert(
                                context: context,
                                title: 'Logout',
                                message: 'Are you sure you want to logout?',
                                NegativebuttonText: 'Cancel',
                                PositivvebuttonText: 'Logout',
                                onPositiveButtonPressed: () async {
                                  await LocalStorageUtils.remove(
                                    AppConstantUtils.loginResponse,
                                  );
                                  await LocalStorageUtils.remove(
                                    AppConstantUtils.loginCredentialResponse,
                                  );
                                  await Get.offAll(
                                    () => SignInView(),
                                    duration: Duration(milliseconds: 100),
                                  );
                                },
                                onNegativeButtonPressed: () =>
                                    Navigator.of(context).pop(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
