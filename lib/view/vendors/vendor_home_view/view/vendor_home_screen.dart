import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';

class VendorHomeScreen extends StatelessWidget {
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VendorHomeScreenWidget vendorHomeScreenWidget = Get.put(
      VendorHomeScreenWidget(context: context),
    );
    return Scaffold(
      body: vendorHomeScreenWidget.vendorHomeScreenWidget(context: context),
    );
  }
}
