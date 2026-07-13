// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/riders/home_view/controller/rider_home_controller.dart';
import 'package:discount_me_app/view/riders/home_view/controller/rider_pickup_request_details_controller.dart';
import 'package:discount_me_app/view/riders/home_view/controller/rider_pickup_request_action_controller.dart';
import 'package:discount_me_app/view/riders/rider_order_view/controller/rider_order_controller.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/riders/home_view/view/view_home_map_route_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RiderHomeOrderRequestDetailsScreen extends StatelessWidget {
  const RiderHomeOrderRequestDetailsScreen({
    super.key,
    required this.pickupRequestId,
  });

  final String pickupRequestId;

  @override
  Widget build(BuildContext context) {
    // Set the status bar style here
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set the status bar color
      statusBarIconBrightness:
      Brightness.dark, // Use Brightness.light for dark icons
    ));

    final RiderPickupRequestDetailsController controller = Get.put(
      RiderPickupRequestDetailsController(
        context: context,
        pickupRequestId: pickupRequestId,
      ),
      tag: pickupRequestId,
    );
    final RiderPickupRequestActionController actionController = Get.put(
      RiderPickupRequestActionController(),
      tag: pickupRequestId,
    );

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorUtils.whiteColor,
      appBar: AppBar(
      title: CustomText(title: "Order Details", fontWeight: FontWeight.w700, fontSize: 24.sp(context),),
        centerTitle: true,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        final request = controller.pickupRequest;
        final order = request?.order;
        final customer = order?.customer;
        final productNames = order?.items
                ?.map((item) => item.product?.name ?? "N/A")
                .where((name) => name.isNotEmpty)
                .join(", ") ??
            "N/A";
        final productImages = order?.items
                ?.expand((item) => item.product?.images ?? <String>[])
                .toList() ??
            <String>[];
        final pickupLocation = order?.store?.name ?? "Pickup location not available";
        final deliveryLocation = _deliveryLocationText(
          request?.deliveryLocation,
          fallback: order?.shippingAddress?.address,
        );
        final requestStatus = request?.status?.toLowerCase() ?? "";

        return Skeletonizer(
          enabled: controller.isLoading.value,
          child: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60.w(context),
                        height: 60.h(context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.lightBlueAccent),
                        clipBehavior: Clip.antiAlias,
                        child: _customerImage(
                          imageUrl: customer?.image,
                          context: context,
                        ),
                      ),
                      10.widthBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: customer?.name ?? "N/A",
                            fontSize: 18.sp(context),
                            fontWeight: FontWeight.w600,
                            color: ColorUtils.secondaryColor,
                          ),
                          CustomText(
                            title: order?.orderId ?? "N/A",
                            fontSize: 14.sp(context),
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.primaryColor,
                          ),
                          Row(
                            children: [
                              // 5-star rating icons
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < 4 ? Icons.star : Icons.star_half,
                                    size: 16.r(context), // Full star for 4, half star for 0.5
                                    color: ColorUtils.secondaryColor,
                                  );
                                }),
                              ),
                              SizedBox(
                                  width:
                                  8), // Small space between stars and the text
                              // Rating text
                              Text(
                                '4.5',
                                style: TextStyle(
                                    fontSize: 12.sp(context),
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.primaryColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Image.asset(
                    ImageUtils.bikeVector,
                    scale: 4,
                    fit: BoxFit.cover,
                  ),
                ],
              ),


              30.heightBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.orange,
                      ),
                      _dashedLineWidget(),
                      const Icon(
                        Icons.circle_outlined,
                        color: Colors.green,
                      ),
                      _dashedLineWidget(),
                      const Icon(
                        Icons.circle_outlined,
                        color: Colors.greenAccent,
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pickup Location',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(pickupLocation),
                      const SizedBox(height: 20),
                      Text(
                        'Delivery Location',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(deliveryLocation),
                    ],
                    ),
                  )
                ],
              ),
              30.heightBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: "What you are sending",
                            color: ColorUtils.whiteDarkHover,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp(context),
                          ),
                          CustomText(
                            title: productNames,
                            color: ColorUtils.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp(context),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: "Receipient",
                            color: ColorUtils.whiteDarkHover,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp(context),
                          ),
                          CustomText(
                            title: customer?.name ?? "N/A",
                            color: ColorUtils.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp(context),
                          )
                        ],
                      )
                    ],
                  ),
                  20.heightBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: "Receipient contact number",
                        color: ColorUtils.whiteDarkHover,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp(context),
                      ),
                      CustomText(
                        title: customer?.contact ??
                            order?.shippingAddress?.phone ??
                            "N/A",
                        color: ColorUtils.blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp(context),
                      )
                    ],
                  ),
                  20.heightBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: "Fee:",
                        color: ColorUtils.whiteDarkHover,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp(context),
                      ),
                      CustomText(
                        title: "\$${order?.shippingFee ?? 0}",
                        color: ColorUtils.blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp(context),
                      )
                    ],
                  ),
                  20.heightBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: "Pickup image(s)",
                        color: ColorUtils.whiteDarkHover,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp(context),
                      ),
                      10.heightBox,
                      Row(
                        children: productImages.isEmpty
                            ? [
                                Image.asset(
                                  ImageUtils.burger,
                                  scale: 4,
                                ),
                              ]
                            : List.generate(
                          productImages.length,
                          (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Image.network(
                                productImages[index],
                                height: 60.h(context),
                                width: 60.w(context),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    ImageUtils.burger,
                                    scale: 4,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  if (request?.deliveryProofImage?.trim().isNotEmpty == true) ...[
                    20.heightBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: "Delivery proof image",
                          color: ColorUtils.whiteDarkHover,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp(context),
                        ),
                        10.heightBox,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r(context)),
                          child: Image.network(
                            request!.deliveryProofImage!,
                            height: 220.h(context),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120.h(context),
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.grey.shade200,
                                child: const Text(
                                  "Delivery proof image unavailable",
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              20.heightBox,
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.to(ViewHomeMapRouteScreen());
                  },
                  child: Text(
                   "View Map Route", 
                    style: GoogleFonts.urbanist(
                      color: ColorUtils.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 22.sp(context),
                      decoration: TextDecoration.underline,
                      decorationColor: ColorUtils.secondaryColor,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 2.0,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ), 

              if (requestStatus == "requesting" || requestStatus == "ongoing")
                40.heightBox,
              _bottomActionWidget(
                context: context,
                requestStatus: requestStatus,
                pickupRequestId: pickupRequestId,
                detailsController: controller,
                actionController: actionController,
              )
            ],
          ),
        ),
      )
      ),
        );
      }),
    );
  }

  Widget _bottomActionWidget({
    required BuildContext context,
    required String requestStatus,
    required String pickupRequestId,
    required RiderPickupRequestDetailsController detailsController, 
    required RiderPickupRequestActionController actionController,
  }) {
    if (requestStatus == "ongoing") {
      return Obx(
        () => Roundbutton(
          borderRadius: 10.r(context), 
          buttonColor: ColorUtils.secondaryColor,
          title: "Success to Delivery",
          isLoading: actionController.isStatusUpdateLoading.value,
          onTap: actionController.isStatusUpdateLoading.value
              ? null
              : () async {
                  await _selectAndConfirmDeliveryImage(
                    context: context,
                    pickupRequestId: pickupRequestId,
                    detailsController: detailsController,
                    actionController: actionController,
                  );
                },
        ),
      );
    }

    if (requestStatus == "requesting") {
      return Row(
        children: [
          Expanded(
            child: Obx(
              () => Roundbutton(
                borderRadius: 10.r(context),
                titleColor: ColorUtils.secondaryColor,
                buttonColor: Color(0xff086634).withOpacity(0.05),
                title: "Reject",
                isLoading: actionController.isRejectLoading.value,
                onTap: actionController.isRejectLoading.value ||
                        actionController.isAcceptLoading.value
                    ? null
                    : () {
                        actionController.rejectPickupRequest(
                          context: context,
                          pickupRequestId: pickupRequestId,
                          onSuccess: () async {
                            detailsController.updatePickupRequestStatus("cancelled");
                            await _refreshPickupRequestLists(context);
                            Get.back();
                          },
                        );
                      },
              ),
            ),
          ),
          10.widthBox,
          Expanded(
            child: Obx(
              () => Roundbutton(
                borderRadius: 10.r(context),
                buttonColor: ColorUtils.secondaryColor,
                title: "Accept",
                isLoading: actionController.isAcceptLoading.value,
                onTap: actionController.isAcceptLoading.value ||
                        actionController.isRejectLoading.value
                    ? null
                    : () {
                        actionController.acceptPickupRequest(
                          context: context,
                          pickupRequestId: pickupRequestId,
                          onSuccess: () async {
                            detailsController.updatePickupRequestStatus("ongoing");
                            await _refreshPickupRequestLists(context);
                            Get.back();
                          },
                        );
                      },
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _selectAndConfirmDeliveryImage({
    required BuildContext context,
    required String pickupRequestId,
    required RiderPickupRequestDetailsController detailsController,
    required RiderPickupRequestActionController actionController,
  }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (pickedImage == null || !context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delivery image preview'),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(pickedImage.path),
            height: 260,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: actionController.isStatusUpdateLoading.value
                  ? null
                  : () {
                      actionController.updatePickupRequestStatus(
                        context: context,
                        pickupRequestId: pickupRequestId,
                        status: "delivered",
                        imagePath: pickedImage.path,
                        onSuccess: () async {
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }
                          detailsController.updatePickupRequestStatus(
                            "delivered",
                          );
                          await _refreshPickupRequestLists(context);
                        },
                      );
                    },
              child: actionController.isStatusUpdateLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshPickupRequestLists(BuildContext context) async {
    if (Get.isRegistered<RiderOrderController>()) {
      await Get.find<RiderOrderController>()
          .getAllStatusPickupRequestsController(context: context);
    }

    if (Get.isRegistered<RiderHomeController>()) {
      await Get.find<RiderHomeController>()
          .getPickupRequestsController(context: context);
    }
  }

  Widget _dashedLineWidget() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.green.shade200,
          ),
        );
      }),
    );
  }

  Widget _customerImage({
    required String? imageUrl,
    required BuildContext context,
  }) {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return Image.asset(
        ImageUtils.homeProfileAvatar,
        scale: 4,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          ImageUtils.homeProfileAvatar,
          scale: 4,
          fit: BoxFit.cover,
        );
      },
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
