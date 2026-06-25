// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/riders/rider_earning_view/controller/rider_earnings_controller.dart';
import 'package:discount_me_app/view/riders/rider_earning_view/view/rider_payment_withdraw_screen.dart';
import 'package:discount_me_app/view/riders/rider_earning_view/widget/recent_transactions_widget.dart';
import 'package:discount_me_app/view/riders/rider_earning_view/widget/transaction_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RiderProfileEarningHomeScreen extends StatelessWidget {
  const RiderProfileEarningHomeScreen({super.key});

  @override 
  Widget build(BuildContext context) {
    final RiderEarningsController riderEarningsController = Get.put(
      RiderEarningsController(context: context),
    );
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          title: "Earnings",
          color: ColorUtils.blackColor,
          fontSize: 24.sp(context),
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => Skeletonizer(
          enabled: riderEarningsController.isLoading.value,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // wallet
                  Container(
                    padding: EdgeInsets.all(15),
                    width: width,
                    height: 200.h(context),
                    decoration: BoxDecoration(
                      color: ColorUtils.greenLightHover,
                      image: DecorationImage(
                        image: AssetImage(ImageUtils.walletBg),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CustomText(
                              title: "Your Balance",
                              color: ColorUtils.blackColor,
                              fontSize: 14.sp(context),
                              fontWeight: FontWeight.w400,
                            ),
                            CustomText(
                              title:
                                  "\$${riderEarningsController.totalBalance.toStringAsFixed(2)}",
                              color: ColorUtils.blackColor,
                              fontSize: 40.sp(context),
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                        Roundbutton(
                          title: "Withdraw",
                          buttonColor: ColorUtils.primaryColor,
                          borderRadius: 8.r(context),
                          onTap: () {
                            Get.to(RiderPaymentWithdrawScreen());
                          },
                        )
                      ],
                    ),
                  ),

                  // divider
                  20.heightBox,
                  RecentTransactionsWidget(),

                  // transaction table
                  20.heightBox,
                  TransactionTableWidget(
                    earnings: riderEarningsController.earnings,
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
