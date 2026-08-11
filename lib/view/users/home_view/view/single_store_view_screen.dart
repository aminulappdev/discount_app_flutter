import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/res/res.dart';
import '../../../view.dart';
import 'package:discount_me_app/utils/utils.dart';

class SingleStoreViewScreen extends StatelessWidget {
  const SingleStoreViewScreen({super.key,required this.storeId,required this.isHomePage,required this.isStoreListPage});
  final bool isHomePage;
  final bool isStoreListPage;
  final String storeId; 
  @override
  Widget build(BuildContext context) {
    final SingleStoreViewScreenWidget singleStoreViewScreenWidget = Get.put(
      SingleStoreViewScreenWidget(context: context, storeId: storeId),
      tag: storeId,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onOpoInvoked) {
        if(isHomePage == true) {
          Get.to(()=>UserDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
        } else if (isStoreListPage == true){
          Get.to(()=>StoreListViewScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
        } else {
          Get.to(()=>UserDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
        }
        if (Get.isRegistered<SingleStoreViewScreenWidget>(tag: storeId)) {
          Get.delete<SingleStoreViewScreenWidget>(tag: storeId, force: true);
        }
      },
      child: Scaffold(
        body: singleStoreViewScreenWidget.singleStoreViewScreenWidget(context: context,isHomePage: isHomePage,isStorePage: isStoreListPage),
        floatingActionButton: Obx(
          () => FloatingActionButton(
            backgroundColor: ColorUtils.primaryColor,
            elevation: 0,
            onPressed: singleStoreViewScreenWidget.isChatOpening.value
                ? null
                : singleStoreViewScreenWidget.openSupportChat,
            child: singleStoreViewScreenWidget.isChatOpening.value
                ? SizedBox(
                    height: 24.h(context),
                    width: 24.w(context),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(ImageUtils.supportChatIcon, scale: 4,),
                      SizedBox(height: 5.h(context),),
                      CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                        plainTextString: "support",
                        plainTextStringFontSize: 10.sp(context),
                        plainTextStringFontWeight: FontWeight.w600,
                        plainTextContainerAlignment: Alignment.center, 
                        plainTextStringColor: Colors.white,
                        plainTextStringTextAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
