import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/users/profile_view/widget/profile_item_widget.dart';
import 'package:discount_me_app/view/vendors/vendor_coupon_management/view/vendor_created_coupon_screen.dart';
import 'package:discount_me_app/view/vendors/vendor_profile_view/controller/vendor_profile_controller.dart';
import 'package:discount_me_app/view/vendors/vendor_profile_view/widget/vendor_profile_dialog_box.dart';
import 'package:discount_me_app/view/vendors/vendor_suppor_chat_view/view/vendor_chat_user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../res/res.dart';

class VendorProfileHomeView extends StatelessWidget {
  VendorProfileHomeView({super.key});

  String username = 'Foods King Resturant';
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final VendorProfileController vendorProfileController = Get.put(
      VendorProfileController(context: context),
    );
    return Scaffold(
      body: Obx(
        () => Container(
          height: 926.h(context),
          width: 428.w(context),
          decoration: BoxDecoration(color: Colors.white),
          child: Skeletonizer(
            effect: PulseEffect(),
            enabled: vendorProfileController.isLoading.value,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
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

                        vendorProfileController
                                    .vendorProfileResponseModel
                                    .value
                                    .data
                                    ?.store
                                    ?.coverImages
                                    ?.isNotEmpty ==
                                true
                            ? Container(
                                height: 250.h(context),
                                width: 428.w(context),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () async {
                                    await vendorProfileController
                                        .updateCoverPhoto(
                                          vendorId: vendorProfileController
                                              .vendorProfileResponseModel
                                              .value
                                              .data
                                              ?.sId,
                                          storeName: vendorProfileController
                                              .vendorProfileResponseModel
                                              .value
                                              .data
                                              ?.store
                                              ?.name,
                                        );
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10.r(context),
                                          ),
                                          child: PageView.builder(
                                            onPageChanged: (value) {
                                              vendorProfileController
                                                  .onPageChanged(value);
                                            },
                                            controller: vendorProfileController
                                                .pageController
                                                .value,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: vendorProfileController
                                                .vendorProfileResponseModel
                                                .value
                                                .data
                                                ?.store
                                                ?.coverImages
                                                ?.length,
                                            itemBuilder: (context, index) {
                                              return _buildScalingTransition(
                                                vendorProfileController
                                                    .vendorProfileResponseModel
                                                    .value
                                                    .data!
                                                    .store!
                                                    .coverImages![index],
                                                index,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : CustomDottedWidget(
                                dottedColor: Colors.black,
                                textColor: Colors.black,
                                buttonColor: Colors.black,
                                lable: vendorProfileController
                                    .imageFile
                                    .value
                                    .path
                                    .split('/')
                                    .last,
                                onPress: () async {
                                  await vendorProfileController
                                      .updateCoverPhoto(
                                        vendorId: vendorProfileController
                                            .vendorProfileResponseModel
                                            .value
                                            .data
                                            ?.sId,
                                        storeName: vendorProfileController
                                            .vendorProfileResponseModel
                                            .value
                                            .data
                                            ?.store
                                            ?.name,
                                      );
                                },
                              ),

                        CustomSpaceWidget.spacerWidget(
                          spaceHeight: 20.h(context),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString:
                                  vendorProfileController
                                      .vendorProfileResponseModel
                                      .value
                                      .data
                                      ?.store
                                      ?.name ??
                                  "",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w700,
                              plainTextContainerAlignment: Alignment.center,
                              plainTextStringTextAlign: TextAlign.center,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(
                              spaceWidth: 10.w(context),
                            ),

                            Container(
                              height: 35.h(context),
                              width: 35.w(context),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(7.r(context)),
                                ),
                                onPressed: () async {
                                  VendorProfileDialogBox().nameUpdateDialogBox(
                                    context: context,
                                    vendorProfileController:
                                        vendorProfileController,
                                    name:
                                        vendorProfileController
                                            .vendorProfileResponseModel
                                            .value
                                            .data
                                            ?.store
                                            ?.name ??
                                        "",
                                    nameControllerText: vendorProfileController
                                        .nameControllerText
                                        .value,
                                    vendorId: vendorProfileController
                                        .vendorProfileResponseModel
                                        .value
                                        .data
                                        ?.sId,
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18.r(context),
                                ),
                              ),
                            ),
                          ],
                        ),

                        CustomSpaceWidget.spacerWidget(
                          spaceHeight: 30.h(context),
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
                              () => VendorProfileEditView(),
                              preventDuplicates: false,
                              duration: Duration(milliseconds: 100),
                            );
                          },
                        ),

                        // earnings
                        ProfileItemWidget(
                          title: "Earnings",
                          icon: Image.asset(ImageUtils.earnIcon, scale: 5),
                          navigateIcon: Icon(
                            Icons.navigate_next,
                            size: 24.r(context),
                            color: Colors.black54,
                          ),
                          onTap: () {
                            Get.to(
                              () => VendorEaringHomeScreen(),
                              preventDuplicates: false,
                              duration: Duration(milliseconds: 100),
                            );
                          },
                        ),

                        // // earnings
                        // ProfileItemWidget(
                        //   title: "Coupon Management ",
                        //   icon: Image.asset(
                        //     ImageUtils.couponManagementIcon,
                        //     scale: 5,
                        //   ),
                        //   navigateIcon: Icon(
                        //     Icons.navigate_next,
                        //     size: 24.r(context),
                        //     color: Colors.black54,
                        //   ),
                        //   onTap: () {
                        //     Get.to(()=>VendorCreatedCouponScreen(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                        //   }, 
                        // ),
                        ProfileItemWidget(
                          title: "Scan Coupon",
                          icon: Icon(
                            Icons.qr_code_scanner,
                            size: 24.r(context),
                            color: ColorUtils.black29,
                          ),
                          navigateIcon: Icon(
                            Icons.navigate_next,
                            size: 24.r(context),
                            color: Colors.black54,
                          ),
                          onTap: () {
                            Get.to(
                              () => ScanCouponScreen(),
                              preventDuplicates: false,
                              duration: Duration(milliseconds: 100),
                            );
                          },
                        ),

                        // support chat
                        ProfileItemWidget(
                          title: "Support Chat",
                          icon: Image.asset(ImageUtils.chat, scale: 5),
                          navigateIcon: Icon(
                            Icons.navigate_next,
                            size: 24.r(context),
                            color: Colors.black54,
                          ),
                          onTap: () {
                            Get.to(
                              () => VendorChatUserListScreen(),
                              preventDuplicates: false,
                              duration: Duration(milliseconds: 100),
                            );
                          },
                        ),

                        // support chat
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
                              () => VendorSettingView(),
                              preventDuplicates: false,
                              duration: Duration(milliseconds: 100),
                            );
                          },
                        ),

                        ProfileItemWidget(
                          title: "Logout",
                          icon: Image.asset(ImageUtils.userEdite, scale: 5),
                          navigateIcon: Icon(
                            Icons.navigate_next,
                            size: 24.r(context),
                            color: Colors.black54,
                          ),
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
    );
  }

  Widget _buildScalingTransition(String image, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0), // Scaling from 50% to 100%
      duration: const Duration(milliseconds: 600),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale, // Scale the image
          child: Image.network(image, fit: BoxFit.fill),
        );
      },
    );
  }
}
