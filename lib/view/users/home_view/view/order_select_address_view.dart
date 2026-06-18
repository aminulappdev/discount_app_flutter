import 'package:discount_me_app/view/users/home_view/widget/order_select_address_widget/order_billing_address_widget.dart';
import 'package:discount_me_app/view/users/home_view/widget/order_select_address_widget/order_button_widget.dart';
import 'package:discount_me_app/view/users/home_view/widget/order_select_address_widget/order_shipping_address_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../res/res.dart';

class OrderSelectAddressView extends StatelessWidget {
  OrderSelectAddressView({super.key,required this.pickAddress,required this.pointsToRedeem});

  final String pickAddress;
  final double pointsToRedeem;
  @override
  Widget build(BuildContext context) {
    final OrderSelectAddressController orderSelectAddressController = Get.put(OrderSelectAddressController(context: context, pickAddress: pickAddress,));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onOpoInvoked) {
        Get.off(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(ImageUtils.homeBg),
              alignment: Alignment.topRight,
              opacity: 0.5,
            ),
          ),
          child: Obx(()=>Skeletonizer(
            effect: PulseEffect(),
            enabled: orderSelectAddressController.isLoading.value,
            child: CustomScrollView(
              slivers: [


                SliverToBoxAdapter( 
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                    child: Column(
                      children: [

                        CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                        UserProfileAppbarWidget(
                          title: "Order Billing Address",
                          onTap: () {
                            Get.off(()=>CartView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          },
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        // CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                        //   plainTextString: "Payment Type",
                        //   plainTextStringFontSize: 20.sp(context),
                        //   plainTextStringFontWeight: FontWeight.w600,
                        //   plainTextContainerAlignment: Alignment.centerLeft,
                        //   plainTextStringColor: ColorUtils.black29,
                        // ),
                        //
                        // CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),
                        //
                        // Column(
                        //   children: orderSelectAddressController.paymentType.map((option) {
                        //     return RadioListTileHelperWidget<RadioValueClass>(
                        //       title: option.name!,
                        //       value: option,
                        //       groupValue: orderSelectAddressController.selectPaymentType.value,
                        //       onChanged: (value) {
                        //         orderSelectAddressController.selectPaymentType.value = value!;
                        //       },
                        //       activeColor: Color.fromRGBO(0, 176, 71, 1),
                        //       dense: true,
                        //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //       visualDensity: VisualDensity.compact,
                        //       contentPadding: EdgeInsets.zero,
                        //     );
                        //   }).toList(),
                        // ),

                        //CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                        OrderBillingAddressWidget().orderBillingAddressWidget(
                          context: context,
                          orderSelectAddressController: orderSelectAddressController,
                        ),

                        Obx(()=>orderSelectAddressController.isDelivery ? Column(
                          children: [
                            CustomSpaceWidget.spacerWidget(spaceHeight: 50.h(context)),

                            OrderShippingAddressWidget().orderShippingAddressWidget(
                              context: context,
                              orderSelectAddressController: orderSelectAddressController,
                            ),
                          ],
                        ) : const SizedBox.shrink()),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        OrderButtonWidget().orderButtonWidget(context: context, orderSelectAddressController: orderSelectAddressController,pointsToRedeem: pointsToRedeem),


                      ],
                    ),
                  ),
                )




              ],
            ),
          )),
        ),
      ),
    );
  }
}
