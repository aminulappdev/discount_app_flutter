// ignore_for_file: prefer_const_constructors

import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/riders/home_view/model/rider_pickup_requests_response_model.dart';
import 'package:discount_me_app/view/riders/home_view/view/rider_home_order_request_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';

class OrderTabViewDetailsWidget extends StatelessWidget {
  const OrderTabViewDetailsWidget({super.key, required this.request});

  final RiderPickupRequest request;

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;
    final order = request.order;
    final storeName = order?.store?.name ?? "N/A";
    final customerName = order?.customer?.name ?? "N/A";
    final customerImage = order?.customer?.image;
    final orderId = order?.orderId ?? "";
    final deliveryLocation = _deliveryLocationText(
      request.deliveryLocation,
      fallback: order?.shippingAddress?.address,
    );

    return Container(
      width: width,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: ColorUtils.whiteNormalHover.withOpacity(0.1),
          border: Border(bottom: BorderSide(color: ColorUtils.whiteNormalHover, width: 1.17))

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CustomText(title: storeName,
            fontSize: 18.sp(context),
            fontWeight: FontWeight.w600,
            color: ColorUtils.secondaryColor,
          ),
          5.heightBox,
          Row(
            children: [
              _customerImage(
                imageUrl: customerImage,
                context: context,
              ),
              8.widthBox,
              Expanded(
                child: CustomText(title: "Recipient: $customerName${orderId.isEmpty ? "" : " ($orderId)"}",
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.blackColor,
                ),
              ),
            ],
          ),
          10.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: ColorUtils.orangeLight,
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Image.asset(ImageUtils.bikeVector, scale: 4,),
              ),
              20.widthBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: ColorUtils.blackColor,),
                      CustomText(title: "Drop off",
                        fontSize: 12.sp(context),
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.blackColor, 
                      ),
                    ],
                  ),
                  5.heightBox,
                  SizedBox(
                    width: width * 0.6,
                    child: CustomText(title: deliveryLocation,
                      fontSize: 14.sp(context),
                      fontWeight: FontWeight.w600,
                      color: ColorUtils.secondaryColor,
                    ),
                  ),

                ],
              ),

            ],
          ),

          20.heightBox,
          Roundbutton(
            title: "View Details",
            padding_vertical: 12,
            buttonColor: ColorUtils.secondaryColor,
            borderRadius: 4,
            onTap: () {
              Get.to(
                RiderHomeOrderRequestDetailsScreen(
                  pickupRequestId: request.sId ?? "",
                ),
              );
            },
          ),
        ],
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
