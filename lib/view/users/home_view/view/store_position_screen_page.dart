import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorePositionScreenPage extends StatelessWidget {
  const StorePositionScreenPage({super.key,required this.long,required this.lat,required this.storeId,required this.isStoreListPage,required this.isHomePage,required this.isVendorHomePage});
  final double long;
  final double lat;
  final String storeId;
  final bool isHomePage;
  final bool isStoreListPage;
  final bool isVendorHomePage;
  @override
  Widget build(BuildContext context) {
    StorePositionScreenWidget storePositionScreenWidget = Get.put(StorePositionScreenWidget(long: long, lat: lat, context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onOpoInvoked) {
        if(isVendorHomePage == true) {
          Get.to(()=>VendorDashboardView(index: 0),preventDuplicates: false,duration: Duration(milliseconds: 100));
        } else {
          Get.to(()=>SingleStoreViewScreen(storeId: storeId,isStoreListPage: isStoreListPage,isHomePage: isHomePage,),preventDuplicates: false,duration: Duration(milliseconds: 100));
        }
      },
      child: Scaffold(
        body: storePositionScreenWidget.storePositionScreenWidget(context: context),
      ),
    );
  }
}
