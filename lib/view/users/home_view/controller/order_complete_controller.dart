import 'package:discount_me_app/view/users/user_profile_order_view/view/user_profile_order_view.dart';
import 'package:get/get.dart';

class OrderCompleteController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration(seconds: 3),() async {
      Get.to(()=>UserProfileOrderView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
    });
  }



}