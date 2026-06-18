import 'package:discount_me_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:discount_me_app/view/view.dart';
import '../../../../res/res.dart';

class OrderPickLocationView extends StatelessWidget {
  OrderPickLocationView({super.key,required this.pointsToRedeem});
  final double pointsToRedeem;
  final OrderPickLocationController orderPickLocationController = Get.put(OrderPickLocationController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onOpoInvoked) {
        Get.back();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: 428.w(context),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          child: Obx(()=>Skeletonizer(
            effect: PulseEffect(),
            enabled: orderPickLocationController.isLoading.value,
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
 
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                    child: Column(
                      children: [

                        CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                        UserProfileAppbarWidget(
                          title: "Pick Location",
                          onTap: () {
                            Get.back();
                          },
                        ),

                      ],
                    ),
                  ),
                ),

                SliverFillRemaining(
                  child: Column(
                    children: [

                      CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                      Expanded(
                        child: Obx(() => GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: orderPickLocationController.initialPosition.value,
                            zoom: 15,
                          ),
                          onMapCreated: orderPickLocationController.onMapCreated,
                          markers: orderPickLocationController.markers,
                          onTap: orderPickLocationController.pickLocationFromMap,
                          onCameraMove: orderPickLocationController.onCameraMove,
                          onCameraIdle: orderPickLocationController.pickCameraCenterLocation,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),),
                      ),


                      Obx(()=>Padding(
                        padding: EdgeInsets.all(16.r(context)),
                        child: Column(
                          children: [
                            if (orderPickLocationController.locationPicker.value.isNotEmpty) ...[
                              CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                plainTextString: orderPickLocationController.locationPicker.value,
                                plainTextStringFontSize: 14.sp(context),
                                plainTextStringFontWeight: FontWeight.w500,
                                plainTextContainerAlignment: Alignment.centerLeft,
                                plainTextStringColor: ColorUtils.black29,
                              ),
                              CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),
                            ],
                            CustomButtonContainer.plainButtonContainer(
                              plainButtonHeight: 64.h(context),
                              plainButtonWidth: 428.w(context),
                              plainButtonRadius: 8.r(context),
                              plainButtonOnPress:  () async {
                                if(orderPickLocationController.locationPicker.value == "") {
                                  MessageSnackBarWidget.errorSnackBarWidget(context: context,message: "Address is not pick.");
                                } else {
                                  Get.back(result: orderPickLocationController.locationPicker.value);
                                }
                              },
                              plainButtonHint: "Complete Order",
                              plainButtonHintFontSize: 22.sp(context),
                              plainButtonColor: ColorUtils.green176,
                              plainButtonHintFontColor: ColorUtils.white255,
                            ),
                          ],
                        ),
                      ))


                    ],
                  ),
                )

              ],
            ),
          )),
          ),
        ),
      ),
    );
  }
}
