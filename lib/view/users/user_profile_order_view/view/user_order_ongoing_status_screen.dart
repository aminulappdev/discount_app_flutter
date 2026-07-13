import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/users/user_profile_order_view/view/user_rider_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserOrderOngoingStatusScreen extends StatelessWidget {
  const UserOrderOngoingStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(ImageUtils.homeBg),
            alignment: Alignment.topRight,
            opacity: 0.5),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  10.heightBox,
                  HomeResturantAppBar(),

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
                      GestureDetector(
                          onTap: () {

                          },
                          child: GestureDetector(
                            onTap: () {
                              Get.to(RecipesScreen());
                            },
                            child: Container(
                              padding:EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Color(0xfffff9e7),
                                borderRadius: BorderRadius.circular(5.r(context)),
                              ),
                              child: CustomText(
                                title: "Ongoing",
                                color: Color(0xffFFC60B),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                      )
                    ],
                  ),

                  20.heightBox,
                  ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(8.w(context)),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r(context)),
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
                              borderRadius: BorderRadius.circular(8.r(context)),
                              child: Image.asset(
                                ImageUtils.burgerCard, // Replace with your image path
                                scale: 4,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12.w(context)),

                            // Product details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chicken Burger',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp(context),
                                      fontWeight: FontWeight.w600,
                                      color: ColorUtils.blackColor,
                                    ),
                                  ),
                                  SizedBox(height: 4.h(context)),
                                  Text(
                                    'Burger Factory LTD',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14.sp(context),
                                      fontWeight: FontWeight.w400,
                                      color: ColorUtils.blackColor,
                                    ),
                                  ),
                                  SizedBox(height: 4.h(context)),
                                  Text(
                                    'Rs 200',
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
                                    borderRadius: BorderRadius.circular(8.r(context)),
                                    color: ColorUtils.greenLightHover,
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.remove, color: ColorUtils.primaryColor),
                                    onPressed: () {
                                      // Reduce item quantity logic here
                                    },
                                  ),
                                ),
                                SizedBox(width: 8.w(context)),
                                // Quantity
                                Text(
                                  '1', // Quantity value (replace with dynamic value)
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
                                    borderRadius: BorderRadius.circular(8.r(context)),
                                    color: ColorUtils.primaryColor,
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.add, color: Colors.white),
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
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         Get.to(UserRiderLocationScreen());
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

                  50.heightBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sub-Total, Delivery Charge, Discount, Total
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sub-Total',
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp(context),
                                  fontWeight: FontWeight.w500,
                                  color: ColorUtils.blackColor, // Set text color to #fefeff
                                ),
                              ),
                              Text(
                                'Rs 950',
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp(context),
                                  fontWeight: FontWeight.w500,
                                  color: ColorUtils.blackColor, // Set text color to #fefeff
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h(context)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Charge',
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp(context),
                                  fontWeight: FontWeight.w500,
                                  color: ColorUtils.blackColor, // Set text color to #fefeff
                                ),
                              ),
                              Text(
                                'Rs 50',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount',
                                style: GoogleFonts.manrope(
                                    fontSize: 16.sp(context),
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.blackColor
                                ),
                              ),
                              Text(
                                'Rs 0',
                                style: GoogleFonts.manrope(
                                    fontSize: 16.sp(context),
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.blackColor
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h(context)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.manrope(
                                    fontSize: 20.sp(context),
                                    fontWeight: FontWeight.w800,
                                    color: ColorUtils.blackColor
                                ),
                              ),
                              Text(
                                'Rs 1,000',
                                style: GoogleFonts.manrope(
                                    fontSize: 18.sp(context),
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.blackColor
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
