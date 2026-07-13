import 'package:flutter/material.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:get/get.dart';

class SingleProductViewScreen extends StatelessWidget {
  const SingleProductViewScreen({
    super.key,
    required this.storeId,
    required this.productId,
    required this.isHomeScreen,
    required this.isSingleStoreScreen,
    required this.isProductListPage,
    required this.isExplorePage,
    required this.isStoreScreen,
  });
  final String productId;
  final String storeId; 
  final bool isHomeScreen;
  final bool isSingleStoreScreen;
  final bool isProductListPage;
  final bool isExplorePage;
  final bool isStoreScreen;
  @override
  Widget build(BuildContext context) {
    void goBack() {
      if (isHomeScreen == true) {
        Get.to(
          () => UserDashboardView(index: 0),
          duration: const Duration(milliseconds: 100),
          preventDuplicates: false,
        );
      } else if (isSingleStoreScreen == true) {
        Get.to(
          () => SingleStoreViewScreen(
            storeId: storeId,
            isStoreListPage: isStoreScreen,
            isHomePage: isHomeScreen,
          ),
          duration: const Duration(milliseconds: 100),
          preventDuplicates: false,
        );
      } else if (isProductListPage == true) {
        Get.back();
      } else if (isExplorePage == true) {
        Get.to(
          () => UserDashboardView(index: 2),
          duration: const Duration(milliseconds: 100),
          preventDuplicates: false,
        );
      } else if (Get.key.currentState?.canPop() == true) {
        Get.back();
      } else {
        Get.to(
          () => UserDashboardView(index: 0),
          duration: const Duration(milliseconds: 100),
          preventDuplicates: false,
        );
      }
    }

    SingleProductViewScreenWidget singleProductViewScreenWidget = Get.put(
      SingleProductViewScreenWidget(
        context: context,
        productId: productId,
        onBack: goBack,
      ),
      tag: productId,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onOpoInvoked) {
        if (!canPop) {
          goBack();
        }
      },
      child: Scaffold(
        body: singleProductViewScreenWidget.singleProductViewScreenWidget(context: context),
      ),
    );
  }
}
