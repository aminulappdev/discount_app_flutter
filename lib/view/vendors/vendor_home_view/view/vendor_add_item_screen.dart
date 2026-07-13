import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorAddItemScreen extends StatelessWidget {
  const VendorAddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VendorAddItemScreenWidget vendorAddItemScreenWidget = Get.put(VendorAddItemScreenWidget(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onPopInvoked) {
        Get.to(()=>VendorDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: vendorAddItemScreenWidget.vendorAddItemScreenWidget(context: context),
      ),
    );
  }
}
