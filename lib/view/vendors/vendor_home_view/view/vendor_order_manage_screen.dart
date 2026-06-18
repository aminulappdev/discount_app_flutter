import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/vendors/vendor_home_view/controller/vendor_order_manage_controller.dart';
import 'package:discount_me_app/view/vendors/vendor_home_view/model/vendor_orders_response_model.dart';
import 'package:discount_me_app/view/vendors/vendor_home_view/view/vendor_order_ongoing_status_screen.dart';
import 'package:discount_me_app/view/vendors/vendor_home_view/widget/order_order_going_widget.dart';
import 'package:discount_me_app/view/vendors/vendor_home_view/widget/vendor_order_canceled_widget.dart';
import 'package:discount_me_app/view/vendors/vendor_home_view/widget/vendor_order_delivered_widget.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';

class VendorOrderManageScreen extends StatefulWidget {
  const VendorOrderManageScreen({super.key});

  @override
  State<VendorOrderManageScreen> createState() =>
      _VendorOrderManageScreenState(); 
}

class _VendorOrderManageScreenState extends State<VendorOrderManageScreen> {
  late final VendorOrderManageController vendorOrderManageController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    vendorOrderManageController = Get.put(
      VendorOrderManageController(context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                UserProfileAppbarWidget(
                    title: "Order", onTap: () => Get.back()),
                Expanded(
                  child: DefaultTabController(
                    initialIndex: selectedIndex,
                    length: 3,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        toolbarHeight: 20,
                        automaticallyImplyLeading: false,
                        bottom: TabBar(
                          onTap: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                            vendorOrderManageController.changeTab(index);
                          },
                          labelColor:
                              vendorOrderManageController.getTabColor(selectedIndex),
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(text: 'Ongoing'),
                            Tab(text: 'Delivered'),
                            Tab(text: 'Canceled'),
                          ],
                        ),
                      ),
                      body: Obx(() {
                        if (vendorOrderManageController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final orders = vendorOrderManageController.filteredOrders;
                        if (orders.isEmpty) {
                          return Center(
                            child: TextHelperClass.headingTextWithoutWidth(
                              context: context,
                              text: "No Order Available",
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              textColor: ColorUtils.black21,
                              alignment: Alignment.center,
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            await vendorOrderManageController
                                .getVendorOrdersController(context: context);
                          },
                          child: ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    VendorOrderOngoingStatusScreen(
                                      orderId: order.id,
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: _buildOrderCard(order),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(VendorOrderListItem order) {
    final status = vendorOrderManageController.statusLabel(order.status);
    final statusBackgroundColor =
        vendorOrderManageController.getStatusBackgroundColor(order.status);
    final statusTextColor =
        vendorOrderManageController.getStatusTextColor(order.status);
    final subtitle =
        "${order.orderId}  ${order.customerName.isEmpty ? "" : order.customerName}";

    if (vendorOrderManageController.selectedTab.value == 1) {
      return VendorOrderDeliveredWidget(
        title: order.productName,
        subtitle: subtitle,
        image: order.image,
        amount: order.amount,
        date: order.date,
        status: status,
        statusBackgroundColor: statusBackgroundColor,
        statusTextColor: statusTextColor,
      );
    }

    if (vendorOrderManageController.selectedTab.value == 2) {
      return VendorOrderCanceledWidget(
        title: order.productName,
        subtitle: subtitle,
        image: order.image,
        amount: order.amount,
        date: order.date,
        status: status,
        statusBackgroundColor: statusBackgroundColor,
        statusTextColor: statusTextColor,
      );
    }

    return VendorOrderOngoingWidget(
      title: order.productName,
      subtitle: subtitle,
      image: order.image,
      amount: order.amount,
      date: order.date,
      status: status,
      statusBackgroundColor: statusBackgroundColor,
      statusTextColor: statusTextColor,
    );
  }
}
