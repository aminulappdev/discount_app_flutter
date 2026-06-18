import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScanCouponScreen extends StatelessWidget {
  const ScanCouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScanCouponController scanCouponController =
        Get.put(ScanCouponController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, onOpoInvoked) {
        Get.off(()=>VendorDashboardView(index: 3),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: scanCouponController.isLoading.value,
          child: Container(
            height: 926.h(context),
            width: 428.w(context),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                          UserProfileAppbarWidget(
                            title: "Scan Coupon",
                            onTap: () {
                              Get.off(()=>VendorDashboardView(index: 3),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                            },
                          ),
                          CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r(context)),
                            child: SizedBox(
                              height: 330.h(context),
                              width: double.infinity,
                              child: MobileScanner(
                                controller: scanCouponController.scannerController,
                                onDetect: scanCouponController.onDetectBarcode,
                              ),
                            ),
                          ),
                          CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                          CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                            plainTextString: "Coupon Code",
                            plainTextStringFontSize: 18.sp(context),
                            plainTextStringFontWeight: FontWeight.w600,
                            plainTextContainerAlignment: Alignment.centerLeft,
                            plainTextStringColor: ColorUtils.black29,
                          ),
                          CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),
                          TextFormFieldWidget.build(
                            context: context,
                            hintText: "Enter coupon code",
                            controller: scanCouponController.codeController.value,
                            keyboardType: TextInputType.text,
                            borderColor: const Color.fromRGBO(29, 36, 45, 1),
                            enableBorderColor: const Color.fromRGBO(29, 36, 45, 1),
                            focusedBorderColor: ColorUtils.orange125,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.vpm(context),
                              horizontal: 16.hpm(context),
                            ),
                          ),
                          CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                          Obx(()=>scanCouponController.isLoading.value
                              ? SizedBox(
                                  height: 54.h(context),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : CustomButtonContainer.plainButtonContainer(
                                  plainButtonHeight: 54.h(context),
                                  plainButtonWidth: 428.w(context),
                                  plainButtonRadius: 8.r(context),
                                  plainButtonOnPress: () async {
                                    await scanCouponController.validateManualCode(
                                      context: context,
                                    );
                                  },
                                  plainButtonHint: "Validate",
                                  plainButtonHintFontSize: 18.sp(context),
                                  plainButtonColor: ColorUtils.green176,
                                  plainButtonHintFontColor: ColorUtils.white255,
                                )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
