// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/riders/home_view/model/rider_pickup_requests_response_model.dart';
import 'package:discount_me_app/view/riders/rider_order_view/controller/rider_order_controller.dart';
import 'package:discount_me_app/view/riders/rider_order_view/widget/order_tab_view_details_widget.dart';
import 'package:discount_me_app/view/riders/rider_order_view/widget/requesting_widget.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RiderOrderHomeScreen extends StatelessWidget {
  const RiderOrderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RiderOrderController riderOrderController =
        Get.put(RiderOrderController(context: context));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorUtils.blackColor),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          title: "Order",
          color: ColorUtils.blackColor,
          fontSize: 24.sp(context),
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => Skeletonizer(
          enabled: riderOrderController.isLoading.value,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: DefaultTabController(
              initialIndex: 0,
              length: 4,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  toolbarHeight: 0,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  bottom: TabBar(
                    isScrollable: true,
                    physics: ScrollPhysics(),
                    tabAlignment: TabAlignment.start,
                    indicatorColor: ColorUtils.blackColor,
                    labelColor: ColorUtils.secondaryColor,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: 'Requesting'),
                      Tab(text: 'Ongoing'),
                      Tab(text: 'Delivered'), 
                      Tab(text: 'Canceled'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    _requestList(
                      context: context,
                      requests:
                          riderOrderController.requestsByStatus("requesting"),
                      status: "requesting",
                      isRequestingTab: true,
                    ),
                    _requestList(
                      context: context,
                      requests:
                          riderOrderController.requestsByStatus("ongoing"),
                      status: "ongoing",
                    ),
                    _requestList(
                      context: context,
                      requests:
                          riderOrderController.requestsByStatus("delivered"),
                      status: "delivered",
                    ),
                    _requestList(
                      context: context,
                      requests:
                          riderOrderController.requestsByStatus("cancelled"),
                      status: "cancelled",
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

  Widget _requestList({
    required BuildContext context,
    required List<RiderPickupRequest> requests,
    required String status,
    bool isRequestingTab = false,
  }) {
    if (requests.isEmpty) {
      return Center(
        child: CustomText(
          title: "No orders found",
          color: ColorUtils.blackColor,
          fontSize: 16.sp(context),
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Get.find<RiderOrderController>()
            .getPickupRequestsController(context: context, status: status);
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: isRequestingTab
                ? RequestingWidget(
                    request: requests[index],
                    onRejected: () async {
                      await Get.find<RiderOrderController>()
                          .getPickupRequestsController(
                        context: context,
                        status: "requesting",
                      );
                    },
                  )
                : OrderTabViewDetailsWidget(request: requests[index]),
          );
        },
      ),
    );
  }
}
