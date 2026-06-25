import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProfileOrderView extends StatelessWidget {
  const UserProfileOrderView({
    super.key,
    this.title = "Order",
    this.emptyMessage = "No Order Available",
    this.fulfillmentType = "delivery",
    this.showTabs = true,
    this.fixedStatus,
  });

  final String title;
  final String emptyMessage;
  final String fulfillmentType;
  final bool showTabs;
  final String? fixedStatus;

  @override
  Widget build(BuildContext context) {
    final OrderStatusController orderStatusController = Get.put(
      OrderStatusController(
        context: context,
        fulfillmentType: fulfillmentType,
      ),
      tag: fulfillmentType,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onOpoInvoked) {
        Get.off(()=>UserDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: orderStatusController.isLoading.value,
          child: RefreshIndicator(
            onRefresh: () async {
              Get.delete<OrderStatusController>(tag: fulfillmentType, force: true);
              Get.off(
                ()=>UserProfileOrderView(
                  title: title,
                  emptyMessage: emptyMessage,
                  fulfillmentType: fulfillmentType,
                  showTabs: showTabs,
                  fixedStatus: fixedStatus,
                ),
                duration: const Duration(milliseconds: 100),
                preventDuplicates: false,
              );
            },
            child: Container(
              height: 926.h(context),
              width: 428.w(context),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(ImageUtils.homeBg),
                  alignment: Alignment.topRight,
                  opacity: 0.5,
                ),
              ),
              child: SafeArea(
                child: CustomScrollView(
                    slivers: [


                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                          child: Column(
                            children: [

                              SpaceHelperWidget.v(20.h(context)),


                              UserProfileAppbarWidget(
                                title: title,
                                onTap: () {
                                  Get.off(()=>UserDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                },
                              ),

                              SpaceHelperWidget.v(40.h(context)),


                            ],
                          ),
                        ),
                      ),


                      SliverFillRemaining(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                          child: Column(
                            children: [

                              if (showTabs) ...[
                                /// Tabs
                                Obx(() => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: List.generate(orderStatusController.tabs.length, (i) {
                                    return GestureDetector(
                                      onTap: () => orderStatusController.changeTab(i),
                                      child: Column(
                                        children: [
                                          TextHelperClass.headingTextWithoutWidth(
                                            context: context,
                                            text: orderStatusController.tabs[i],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            textColor:  orderStatusController.selectedTab.value == i ? orderStatusController.getTextColor(orderStatusController.tabs[i]) : Colors.black,
                                          ),
                                          SpaceHelperWidget.v(5.h(context)),

                                          Container(
                                            height: 2.h(context),
                                            width: 50.w(context),
                                            color: orderStatusController.selectedTab.value == i
                                                ? orderStatusController.getColor(orderStatusController.tabs[i])
                                                : Colors.transparent,
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                )),


                                SpaceHelperWidget.v(20.h(context)),
                              ],



                              Expanded(
                                child: Obx(() {
                                  final list = fixedStatus == null
                                      ? orderStatusController.filteredOrders
                                      : orderStatusController.orders.where((e) => e.status == fixedStatus).toList();

                                  if (list.isEmpty) {
                                    return Center(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                          context: context,
                                          text: emptyMessage,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          textColor: ColorUtils.black21,
                                          alignment: Alignment.center
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    itemCount: list.length,
                                    itemBuilder: (_, i) => OrderCardWidget(
                                      order: list[i],
                                      controller: orderStatusController,
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
