import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/vendors/vendor_profile_view/controller/vendor_setting_controller.dart';
import 'package:discount_me_app/view/vendors/vendor_profile_view/view/vendor_change_password_view.dart';
import 'package:discount_me_app/view/vendors/vendor_profile_view/widget/vendor_account_delete_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../res/res.dart';
import 'package:discount_me_app/view/view.dart';


class VendorSettingView extends StatelessWidget {
  const VendorSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final VendorSettingController vendorSettingController = Get.put(VendorSettingController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onPopInvoked) {
        Get.to(()=>VendorDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Obx(()=>Container(
          height: 928.h(context),
          width: 428.w(context),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(ImageUtils.homeBg),
              alignment: Alignment.topRight,
              opacity: 0.5,
            ),
          ),
          child: Skeletonizer(
            effect: PulseEffect(),
            enabled: vendorSettingController.isLoading.value,
            child: CustomScrollView(
              slivers: [


                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                    child: Column(
                      children: [


                        CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                        UserProfileAppbarWidget(
                          title: "Setting",
                          onTap: () {
                            Get.to(()=>VendorDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          },
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                        Container(
                          width: 428.w(context),
                          height: 80.h(context),
                          padding: EdgeInsets.symmetric(
                            vertical: 15.vpm(context),
                            horizontal: 15.hpm(context),
                          ),
                          decoration: BoxDecoration(
                            color: ColorUtils.greenLight,
                            borderRadius: BorderRadius.circular(4.r(context)),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              Get.to(()=>VendorChangePasswordView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                            },
                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.lock_outline, color: Colors.black,size: 30.r(context),),

                                      CustomSpaceWidget.spacerWidget(spaceWidth: 15.w(context)),

                                      CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                        plainTextString: "Change Password",
                                        plainTextStringFontSize: 20.sp(context),
                                        plainTextStringFontWeight: FontWeight.w500,
                                        plainTextContainerAlignment: Alignment.centerLeft,
                                        plainTextStringTextAlign: TextAlign.start,
                                        plainTextStringColor: Color(0xff727272),
                                      ),

                                    ],
                                  ),
                                ),

                                Icon(Icons.navigate_next, size: 30.r(context),)

                              ],
                            ),
                          ),
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                        Container(
                          width: 428.w(context),
                          height: 80.h(context),
                          padding: EdgeInsets.symmetric(
                            vertical: 15.vpm(context),
                            horizontal: 15.hpm(context),
                          ),
                          decoration: BoxDecoration(
                            color: ColorUtils.greenLight,
                            borderRadius: BorderRadius.circular(4.r(context)),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              VendorAccountDeleteDialogBox().vendorAccountDeleteDialogBox(
                                context: context,
                                vendorSettingController: vendorSettingController,
                              );
                            },
                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_forever_sharp, color: Colors.black,size: 30.r(context),),

                                      CustomSpaceWidget.spacerWidget(spaceWidth: 15.w(context)),

                                      CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                        plainTextString: "Delete Account",
                                        plainTextStringFontSize: 20.sp(context),
                                        plainTextStringFontWeight: FontWeight.w500,
                                        plainTextContainerAlignment: Alignment.centerLeft,
                                        plainTextStringTextAlign: TextAlign.start,
                                        plainTextStringColor: Color(0xff727272),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                )


              ],
            ),
          ),
        )),
      ),
    );
  }
}
