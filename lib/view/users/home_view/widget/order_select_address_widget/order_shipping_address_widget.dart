import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/users/home_view/controller/order_select_address_controller.dart';
import 'package:discount_me_app/view/users/home_view/view/order_pick_location_view.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/widget_utils/text_form_field_widget.dart';
import 'package:get/get.dart';
import '../../../../../res/res.dart';

class OrderShippingAddressWidget {

  Widget orderShippingAddressWidget({
    required BuildContext context,
    required OrderSelectAddressController orderSelectAddressController,
  }) {
    return Column(
      children: [


        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Shipping Address",
          plainTextStringFontSize: 35.sp(context),
          plainTextStringFontWeight: FontWeight.w700,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Name",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter Shipping Name",
          controller: orderSelectAddressController.shippingNameController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
        ),


        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Address",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        CustomButtonContainer.plainButtonContainer(
          plainButtonHeight: 50.h(context),
          plainButtonWidth: 428.w(context),
          plainButtonRadius: 8.r(context),
          plainButtonOnPress: () async {
            final pickedAddress = await Get.to<String>(
              ()=>OrderPickLocationView(pointsToRedeem: 0.0),
              duration: const Duration(milliseconds: 100),
              preventDuplicates: false,
            );
            if (pickedAddress != null && pickedAddress.isNotEmpty) {
              orderSelectAddressController.setPickedShippingAddress(pickedAddress);
            }
          },
          plainButtonHint: "Pick Location",
          plainButtonHintFontSize: 18.sp(context),
          plainButtonColor: ColorUtils.green176,
          plainButtonHintFontColor: ColorUtils.white255,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.textFiledWithMaxLineBuild(
          context: context,
          hintText: "Enter Address...",
          controller: orderSelectAddressController.shippingAddressController.value,
          keyboardType: TextInputType.text,
          maxLines: 5,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Email",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter Email",
          controller: orderSelectAddressController.shippingEmailController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
        ),



        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Phone",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter Phone",
          controller: orderSelectAddressController.shippingPhoneController.value,
          keyboardType: TextInputType.number,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
        ),



      ],
    );
  }


}
