import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/vendors/vendor_home_view/controller/vendor_order_details_controller.dart';
import 'package:discount_me_app/view/vendors/vendor_home_view/view/vendor_view_rider_location.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorOrderOngoingStatusScreen extends StatelessWidget {
  const VendorOrderOngoingStatusScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final VendorOrderDetailsController vendorOrderDetailsController = Get.put(
      VendorOrderDetailsController(context: context, orderId: orderId),
    );
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(ImageUtils.homeBg),
          alignment: Alignment.topRight,
          opacity: 0.5,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(
          () => SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: vendorOrderDetailsController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          10.heightBox,
                          Row(
                            children: [
                              SizedBox(
                                height: 40.h(context),
                                width: 40.w(context),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: ColorUtils.blackColor,
                                    size: 20.r(context),
                                  ),
                                  onPressed: () => Get.back(),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    ImageUtils.discountMeLogo,
                                    scale: 10,
                                  ),
                                ),
                              ),
                              SizedBox(width: 40.w(context)),
                            ],
                          ),

                          // add order.......
                          20.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                title: "Order details",
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: ColorUtils.blackColor,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: vendorOrderDetailsController
                                      .getStatusBackgroundColor(
                                        vendorOrderDetailsController
                                            .orderDetails
                                            .value
                                            .data
                                            ?.status,
                                      ),
                                  borderRadius: BorderRadius.circular(
                                    5.r(context),
                                  ),
                                ),
                                child: CustomText(
                                  title: vendorOrderDetailsController
                                      .statusLabel(
                                        vendorOrderDetailsController
                                            .orderDetails
                                            .value
                                            .data
                                            ?.status,
                                      ),
                                  color: vendorOrderDetailsController
                                      .getStatusTextColor(
                                        vendorOrderDetailsController
                                            .orderDetails
                                            .value
                                            .data
                                            ?.status,
                                      ),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          20.heightBox,
                          ListView.builder(
                            itemCount:
                                vendorOrderDetailsController
                                    .orderDetails
                                    .value
                                    .data
                                    ?.items
                                    ?.length ??
                                0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = vendorOrderDetailsController
                                  .orderDetails
                                  .value
                                  .data!
                                  .items![index];
                              final image =
                                  item.product?.images?.isNotEmpty == true
                                  ? item.product!.images!.first
                                  : "";
                              return Container(
                                padding: EdgeInsets.all(8.w(context)),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    8.r(context),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Product Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        8.r(context),
                                      ),
                                      child: image.isEmpty
                                          ? Image.asset(
                                              ImageUtils.burgerCard,
                                              scale: 4,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              image,
                                              height: 80.h(context),
                                              width: 80.w(context),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    SizedBox(width: 12.w(context)),

                                    // Product details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.product?.name ?? "N/A",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 17.sp(context),
                                              fontWeight: FontWeight.w600,
                                              color: ColorUtils.blackColor,
                                            ),
                                          ),
                                          SizedBox(height: 4.h(context)),
                                          Text(
                                            item.product?.description ??
                                                vendorOrderDetailsController
                                                    .orderDetails
                                                    .value
                                                    .data
                                                    ?.orderId ??
                                                "",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14.sp(context),
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.blackColor,
                                            ),
                                          ),
                                          SizedBox(height: 4.h(context)),
                                          Text(
                                            '\$${item.product?.price ?? 0}',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 21.sp(context),
                                              fontWeight: FontWeight.w700,
                                              color: ColorUtils.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Quantity Selector
                                    Row(
                                      children: [
                                        // Minus Button
                                        Container(
                                          height: 32.h(context),
                                          width: 32.w(context),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.r(context),
                                            ),
                                            color: ColorUtils.greenLightHover,
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              Icons.remove,
                                              color: ColorUtils.primaryColor,
                                            ),
                                            onPressed: () {
                                              // Reduce item quantity logic here
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8.w(context)),
                                        // Quantity
                                        Text(
                                          '${item.quantity ?? 0}',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 16.sp(context),
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8.w(context)),

                                        // Plus Button
                                        Container(
                                          height: 32.h(context),
                                          width: 32.w(context),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.r(context),
                                            ),
                                            color: ColorUtils.primaryColor,
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              // Increase item quantity logic here
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          10.heightBox,

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     CustomText(
                          //       title: "Request to Rider",
                          //       color: ColorUtils.secondaryColor,
                          //       fontSize: 18.sp(context),
                          //       fontWeight: FontWeight.w500,
                          //       decoration: TextDecoration.underline,
                          //       decorationColor: ColorUtils.secondaryColor ,
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {
                          //         Get.to(VendorViewRiderLocation());
                          //       },
                          //       child: CustomText(
                          //         title: "View Rider Location",
                          //         color: ColorUtils.secondaryColor,
                          //         fontSize: 18.sp(context),
                          //         fontWeight: FontWeight.w500,
                          //         decoration: TextDecoration.underline,
                          //         decorationColor: ColorUtils.secondaryColor,
                          //       ),
                          //     )
                          //   ],
                          // ),
                          30.heightBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Sub-Total, Delivery Charge, Discount, Total
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Sub-Total',
                                        style: GoogleFonts.manrope(
                                          fontSize: 16.sp(context),
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils
                                              .blackColor, // Set text color to #fefeff
                                        ),
                                      ),
                                      Text(
                                        '\$${vendorOrderDetailsController.subTotal.toStringAsFixed(2)}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 16.sp(context),
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils
                                              .blackColor, // Set text color to #fefeff
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h(context)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delivery Charge',
                                        style: GoogleFonts.manrope(
                                          fontSize: 16.sp(context),
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils
                                              .blackColor, // Set text color to #fefeff
                                        ),
                                      ),
                                      Text(
                                        '\$0.00',
                                        style: GoogleFonts.manrope(
                                          fontSize: 16.sp(context),
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h(context)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Discount',
                                        style: GoogleFonts.manrope(
                                          fontSize: 16.sp(context),
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils.blackColor,
                                        ),
                                      ),
                                      Text(
                                        '\$${vendorOrderDetailsController.discount.value.toStringAsFixed(2)}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 16.sp(context),
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h(context)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: GoogleFonts.manrope(
                                          fontSize: 20.sp(context),
                                          fontWeight: FontWeight.w800,
                                          color: ColorUtils.blackColor,
                                        ),
                                      ),
                                      Text(
                                        '\$${double.tryParse((vendorOrderDetailsController.orderDetails.value.data?.total ?? 0).toString())?.toStringAsFixed(2) ?? "0.00"}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 18.sp(context),
                                          fontWeight: FontWeight.bold,
                                          color: ColorUtils.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
