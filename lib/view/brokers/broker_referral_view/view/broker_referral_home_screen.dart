// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/brokers/broker_home_view/controller/broker_home_controller.dart';
import 'package:discount_me_app/view/brokers/broker_home_view/widget/broker_transaction_table_widget.dart';
import 'package:discount_me_app/view/brokers/broker_home_view/widget/custom_borker_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BrokerReferralHomeScreen extends StatefulWidget {
  const BrokerReferralHomeScreen({super.key});

  @override
  State<BrokerReferralHomeScreen> createState() => _BrokerReferralHomeScreenState();
}

class _BrokerReferralHomeScreenState extends State<BrokerReferralHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final BrokerHomeController brokerHomeController =
        Get.isRegistered<BrokerHomeController>()
            ? Get.find<BrokerHomeController>()
            : Get.put(BrokerHomeController(context: context));

    return Scaffold(
      backgroundColor: ColorUtils.whiteColor,
      body: SafeArea(
        child: Obx(
          () => Skeletonizer(
            enabled: brokerHomeController.isLoading.value,
            child: RefreshIndicator(
              onRefresh: () => brokerHomeController.getBrokerHomeData(
                context: context,
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomBrokerAppBar(
                      brokerHomeController: brokerHomeController,
                    ),

                    20.heightBox,
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: const Color(0xffe4e4e4),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          alignment: Alignment.center,
                          child: CustomText(
                            title: "Referral earnings",
                            color: ColorUtils.blackColor,
                            fontSize: 16.sp(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: const Color(0xffe4e4e4),
                          ),
                        ),
                      ],
                    ),

                    20.heightBox,
                    BrokerTransactionTableWidget(
                      earnings: brokerHomeController.earnings,
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

