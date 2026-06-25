import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/riders/home_view/controller/rider_home_controller.dart';
import 'package:discount_me_app/view/riders/home_view/controller/rider_pickup_request_action_controller.dart';
import 'package:discount_me_app/view/riders/home_view/model/rider_pickup_requests_response_model.dart';
import 'package:discount_me_app/view/riders/home_view/view/rider_home_order_request_details_screen.dart';
import 'package:discount_me_app/view/riders/rider_order_view/view/rider_order_home_screen.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../res/res.dart';


class RiderHomeView extends StatelessWidget {
  const RiderHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final RiderHomeController riderHomeController = Get.put(RiderHomeController(context: context));
    final RiderPickupRequestActionController actionController =
        Get.put(RiderPickupRequestActionController());
    return Scaffold(
      body: Obx(()=>Container(
        height: 926.h(context),
        width: 428.w(context),
        decoration: BoxDecoration(
          color: ColorUtils.whiteColor,
        ),
        child: Skeletonizer(
          effect: PulseEffect(),
          enabled: riderHomeController.isLoading.value,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                child: Column(
                  children: [

                          // appBar
                          CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                          Row(
                            children: [

                              Expanded(
                                child: Column(
                                  children: [

                                    CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                      plainTextString: "Welcome Back",
                                      plainTextStringFontSize: 15.sp(context),
                                      plainTextStringFontWeight: FontWeight.w400,
                                      plainTextContainerAlignment: Alignment.centerLeft,
                                      plainTextStringColor: ColorUtils.black29,
                                    ),

                                    CustomSpaceWidget.spacerWidget(spaceHeight: 5.h(context)),


                                    CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                      plainTextString: riderHomeController.riderProfileResponse.value.data?.name ?? "",
                                      plainTextStringFontSize: 20.sp(context),
                                      plainTextStringFontWeight: FontWeight.w700,
                                      plainTextContainerAlignment: Alignment.centerLeft,
                                      plainTextStringColor: ColorUtils.black29,
                                    ),

                                  ],
                                ),
                              ),


                              riderHomeController.riderProfileResponse.value.data?.image != null ?
                              CustomImageContainer.networkImageContainer(
                                height: 50.h(context),
                                width: 50.w(context),
                                networkImage: riderHomeController.riderProfileResponse.value.data?.image,
                                boxFit: BoxFit.fitWidth,
                                boxShape: BoxShape.circle,
                              ) :
                              CustomImageContainer.assetImageContainer(
                                height: 50.h(context),
                                width: 50.w(context),
                                assetImage: ImageUtils.homeProfileAvatar,
                                boxFit: BoxFit.fitWidth,
                                boxShape: BoxShape.circle,
                              ),

                            ],
                          ),

                          //;;;;;;;;;;;;;;;;;;;; balance section;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                          CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                          Container(
                            width: 428.w(context),
                            padding: EdgeInsets.symmetric(horizontal: 10.hpm(context), vertical: 15.vpm(context)),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8.r(context)),
                            ),
                            child: Row(
                              children: [


                                Expanded(
                                  child: Column(
                                    children: [

                                      CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                        plainTextString: "Available balance",
                                        plainTextStringFontSize: 17.sp(context),
                                        plainTextStringFontWeight: FontWeight.w600,
                                        plainTextContainerAlignment: Alignment.centerLeft,
                                        plainTextStringColor: ColorUtils.whiteColor,
                                      ),

                                      CustomSpaceWidget.spacerWidget(spaceHeight: 5.h(context)),


                                      CustomRichTextContainer.plainRichTextContainerWidgetWithoutWidthHeight(
                                          context: context,
                                          plainRichTextContainerAlignment: Alignment.centerLeft,
                                          plainPrimaryTextStringAlign: TextAlign.start,
                                          plainPrimaryTextString: "\$ ",
                                          plainRichTextStringFontSize: 20.sp(context),
                                          plainRichTextStringColor: ColorUtils.whiteColor,
                                          plainRichTextStringFontWeight: FontWeight.w700,
                                          textSpanList: [
                                            TextSpan(
                                              text: riderHomeController.riderProfileResponse.value.data?.balance.toString() ?? "0.0",
                                              style: CustomRichTextContainer.plainRichTextStringStyle(
                                                context: context,
                                                plainRichTextStringFontSize: 32.sp(context),
                                                plainRichTextStringColor: ColorUtils.whiteColor,
                                                plainRichTextStringFontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ]
                                      ),
                                    ],
                                  ),
                                ),

                                CustomSpaceWidget.spacerWidget(spaceWidth: 5.h(context)),


                                CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                  plainTextString: "Withdrawal",
                                  plainTextStringFontSize: 18.sp(context),
                                  plainTextStringFontWeight: FontWeight.w700,
                                  plainTextContainerAlignment: Alignment.centerRight,
                                  plainTextStringColor: ColorUtils.whiteColor,
                                ),

                              ],
                            ),
                          ),

                          // where to

                          CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                          
                          
                          
                          Container(
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: Color(0xffe5e5e5), width: 1.17.w(context))),
                            ),


                            child: Column(
                              children: [

                                CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                                CustomTextContainer.plainTextContainerWidgetWithoutHeightWidthInconsolata(
                                  plainTextString: "Would you like to specify direction for deliveries?",
                                  plainTextStringFontSize: 16.sp(context),
                                  plainTextStringFontWeight: FontWeight.w600,
                                  plainTextContainerAlignment: Alignment.center,
                                  plainTextStringColor: ColorUtils.blackColor,
                                ),

                                CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                                TextFormFieldWidget.build(
                                  context: context,
                                  hintText: "Where to?",
                                  fillColor: Color(0xfff0f5f5),
                                  prefixIcon: Icon(Icons.circle_outlined, color: Colors.green),
                                  controller: riderHomeController.whereToControllerText.value,
                                  keyboardType: TextInputType.text,
                                  borderColor: Colors.transparent,
                                  enableBorderColor: Colors.transparent,
                                  focusedBorderColor: Colors.transparent,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                                ),

                              ],
                            ),
                          ),

                          // request section
                          CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Expanded(
                                child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                  plainTextString: "Available Requests",
                                  plainTextStringFontSize: 18.sp(context),
                                  plainTextStringFontWeight: FontWeight.w700,
                                  plainTextContainerAlignment: Alignment.centerLeft,
                                  plainTextStringColor: ColorUtils.black29,
                                ),
                              ),

                              CustomSpaceWidget.spacerWidget(spaceWidth: 10.w(context)),


                              Expanded(
                                child: CustomButtonContainer.plainButtonContainer(
                                  plainButtonHeight: 34.h(context),
                                  plainButtonWidth: 428.w(context),
                                  plainButtonRadius: 8.r(context),
                                  plainButtonOnPress: () async {
                                    Get.to(()=>RiderOrderHomeScreen());
                                  },
                                  plainButtonHint: "View all",
                                  plainButtonHintAlign: Alignment.centerRight,
                                  plainButtonHintTextAlign: TextAlign.end,
                                  plainButtonHintFontSize: 18.sp(context),
                                  plainButtonColor: Colors.transparent,
                                  plainButtonHintFontColor: ColorUtils.black29,
                                ),
                              ),


                            ],
                          ),

                  ],
                ),
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await riderHomeController.getHomeData(context: context);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: riderHomeController.requestingPickupRequests.isEmpty
                        ? 1
                        : riderHomeController.requestingPickupRequests.length,
                    itemBuilder: (context,int index) {
                        if (riderHomeController.requestingPickupRequests.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(16.r(context)),
                            child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "No available requests",
                              plainTextStringFontSize: 16.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.center,
                              plainTextStringColor: ColorUtils.black29,
                            ),
                          );
                        }

                        return _requestWidget(
                          context: context,
                          request: riderHomeController.requestingPickupRequests[index],
                          actionController: actionController,
                          onRejected: () async {
                            await riderHomeController.getPickupRequestsController(
                              context: context,
                            );
                          },
                        );
                      },
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _requestWidget({
    required BuildContext context,
    required RiderPickupRequest request,
    required RiderPickupRequestActionController actionController,
    required Future<void> Function() onRejected,
  }){
    final order = request.order;
    final storeName = order?.store?.name ?? "N/A";
    final customerName = order?.customer?.name ?? "N/A";
    final customerImage = order?.customer?.image;
    final deliveryLocation = _deliveryLocationText(
      request.deliveryLocation,
      fallback: order?.shippingAddress?.address,
    );
    final orderId = order?.orderId ?? "";
    final requestStatus = request.status ?? "N/A";

    return Padding(
      padding: EdgeInsets.all(16.r(context)),
      child: Container(
        width: 428.w(context),
        padding: EdgeInsets.symmetric(vertical: 16.vpm(context)),
        decoration: BoxDecoration(
            color: ColorUtils.whiteNormalHover.withOpacity(0.1),
            border: Border(bottom: BorderSide(color: ColorUtils.whiteNormalHover, width: 1.17))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
              plainTextString: storeName,
              plainTextStringFontSize: 20.sp(context),
              plainTextStringFontWeight: FontWeight.w600,
              plainTextContainerAlignment: Alignment.centerLeft,
              plainTextStringColor:ColorUtils.secondaryColor,
            ),

            CustomSpaceWidget.spacerWidget(spaceHeight: 6.h(context)),

            Row(
              children: [
                _customerImage(
                  imageUrl: customerImage,
                  context: context,
                ),
                CustomSpaceWidget.spacerWidget(spaceWidth: 8.w(context)),
                Expanded(
                  child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                    plainTextString: "Recipient: $customerName${orderId.isEmpty ? "" : " ($orderId)"}",
                    plainTextStringFontSize: 15.sp(context),
                    plainTextStringFontWeight: FontWeight.w600,
                    plainTextContainerAlignment: Alignment.centerLeft,
                    plainTextStringColor: ColorUtils.blackColor,
                  ),
                ),
              ],
            ),

            CustomSpaceWidget.spacerWidget(spaceHeight: 6.h(context)),

            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
              plainTextString: "Status: ${requestStatus.capitalizeFirst ?? requestStatus}",
              plainTextStringFontSize: 14.sp(context),
              plainTextStringFontWeight: FontWeight.w600,
              plainTextContainerAlignment: Alignment.centerLeft,
              plainTextStringColor: ColorUtils.secondaryColor,
            ),


            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r(context)),
                  decoration: BoxDecoration(
                      color: ColorUtils.orangeLight,
                      borderRadius: BorderRadius.circular(6.r(context))
                  ),
                  child: Image.asset(ImageUtils.bikeVector, scale: 5,),
                ),
                CustomSpaceWidget.spacerWidget(spaceWidth: 15.w(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(ImageUtils.locationSmallIcon, scale: 6,),

                          CustomSpaceWidget.spacerWidget(spaceWidth: 5.w(context)),

                          CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                            plainTextString: "Drop off",
                            plainTextStringFontSize: 15.sp(context),
                            plainTextStringFontWeight: FontWeight.w400,
                            plainTextContainerAlignment: Alignment.centerLeft,
                            plainTextStringColor: ColorUtils.blackColor,
                          ),

                        ],
                      ),

                      CustomSpaceWidget.spacerWidget(spaceHeight: 6.h(context)),


                      CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                        plainTextString: deliveryLocation,
                        plainTextStringFontSize: 15.sp(context),
                        plainTextStringFontWeight: FontWeight.w600,
                        plainTextContainerAlignment: Alignment.centerLeft,
                        plainTextStringColor:  ColorUtils.secondaryColor,
                      ),


                    ],
                  ),
                ),

              ],
            ),

            CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               
                Expanded(
                  child: Obx(
                    () => actionController.isRejectLoading.value
                        ? Container(
                            height: 50.h(context),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              color: ColorUtils.red255,
                            ),
                          )
                        : CustomButtonContainer.plainButtonContainer(
                            plainButtonHeight: 50.h(context),
                            plainButtonWidth: 428.w(context),
                            plainButtonRadius: 8.r(context),
                            plainButtonOnPress:  () async {
                              CustomAlertDialog().customAlert(
                                context: context,
                                title: 'Alert',
                                message: 'Are you sure you want to reject this request?',
                                NegativebuttonText: 'Cancel',
                                PositivvebuttonText: 'Confirm',
                                onPositiveButtonPressed: () {
                                  Navigator.of(context).pop();
                                  actionController.rejectPickupRequest(
                                    context: context,
                                    pickupRequestId: request.sId ?? "",
                                    onSuccess: () async {
                                      await onRejected();
                                    },
                                  );
                                },
                                onNegativeButtonPressed: () => Navigator.of(context).pop(),
                              );
                            },
                            plainButtonHint: "Reject",
                            plainButtonHintFontSize: 17.sp(context),
                            plainButtonColor: Colors.transparent,
                            plainButtonBorderColor: ColorUtils.red255,
                            plainButtonBorderWidth: 1.w(context),
                            plainButtonHintFontColor: ColorUtils.red255,
                          ),
                  ),
                ),


                CustomSpaceWidget.spacerWidget(spaceWidth: 15.w(context)),


                Expanded(
                  child: CustomButtonContainer.plainButtonContainer(
                    plainButtonHeight: 50.h(context),
                    plainButtonWidth: 428.w(context),
                    plainButtonRadius: 8.r(context),
                    plainButtonOnPress:  () async {
                      Get.to(
                        RiderHomeOrderRequestDetailsScreen(
                          pickupRequestId: request.sId ?? "",
                        ),
                      );
                    },
                    plainButtonHint: "View Details",
                    plainButtonHintFontSize: 17.sp(context),
                    plainButtonColor: ColorUtils.secondaryColor,
                    plainButtonHintFontColor: ColorUtils.whiteColor,
                  ),
                ),


              ],
            )

          ],
        ),
      ),
    );
  }

  Widget _customerImage({
    required String? imageUrl,
    required BuildContext context,
  }) {
    return ClipOval(
      child: SizedBox(
        height: 36.h(context),
        width: 36.w(context),
        child: imageUrl == null || imageUrl.trim().isEmpty
            ? Image.asset(ImageUtils.homeProfileAvatar, fit: BoxFit.cover)
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    ImageUtils.homeProfileAvatar,
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }

  String _deliveryLocationText(String? value, {String? fallback}) {
    if (value == null || value.trim().isEmpty) {
      return fallback?.trim().isNotEmpty == true
          ? fallback!.trim()
          : "Delivery location not available";
    }

    final parts = value
        .split(",")
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty && part.toLowerCase() != "null")
        .toList();

    if (parts.isEmpty) {
      return fallback?.trim().isNotEmpty == true
          ? fallback!.trim()
          : "Delivery location not available";
    }

    return parts.join(", ");
  }


}
