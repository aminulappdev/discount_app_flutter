import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/riders/rider_earning_view/widget/recent_transactions_widget.dart';
import 'package:discount_me_app/view/vendors/vendor_earning_view/view/vendor_payment_withdraw_screen.dart';
import 'package:discount_me_app/view/vendors/vendor_earning_view/widget/vendor_transaction_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';

class VendorEaringHomeScreen extends StatelessWidget {
  const VendorEaringHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorUtils.blackColor,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          title: "Earnings",
          color: ColorUtils.blackColor,
          fontSize: 24.sp(context),
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: Padding(
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
                          title: "\$1000",
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
                        Get.to(VendorPaymentWithdrawScreen());
                      },
                    ),
                  ],
                ),
              ),

              // divider
              20.heightBox,
              RecentTransactionsWidget(),

              // transaction table
              20.heightBox,
              VendorTransactionTableWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
