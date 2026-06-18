import 'package:discount_me_app/view/users/home_view/controller/order_select_address_controller.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import '../../../../../res/res.dart';

class OrderBillingAddressWidget {
  Widget orderBillingAddressWidget({
    required BuildContext context,
    required OrderSelectAddressController orderSelectAddressController,
  }) {
    return Column(
      children: [
        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Billing Address",
          plainTextStringFontSize: 35.sp(context),
          plainTextStringFontWeight: FontWeight.w700,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ), 

        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

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
          hintText: "Enter Billing Name",
          controller: orderSelectAddressController.billingNameController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Company Name",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter Company Name",
          controller:
              orderSelectAddressController.billingCompanyNameController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Street Address",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.textFiledWithMaxLineBuild(
          context: context,
          hintText: "Enter Street Address...",
          controller:
              orderSelectAddressController.billingStreetAddressController.value,
          keyboardType: TextInputType.text,
          maxLines: 5,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Country",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter Country",
          controller:
              orderSelectAddressController.billingCountryController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "State",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter State",
          controller: orderSelectAddressController.billingStateController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "City",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter City",
          controller: orderSelectAddressController.billingCityController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Zip Code",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter Zip Code",
          controller:
              orderSelectAddressController.billingZipCodeController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "House No",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter House No",
          controller:
              orderSelectAddressController.billingHouseNoController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
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
          controller: orderSelectAddressController.billingEmailController.value,
          keyboardType: TextInputType.text,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
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
          controller: orderSelectAddressController.billingPhoneController.value,
          keyboardType: TextInputType.number,
          borderColor: Color.fromRGBO(29, 36, 45, 1),
          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
          focusedBorderColor: ColorUtils.orange125,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8.vpm(context),
            horizontal: 16.hpm(context),
          ),
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
          plainTextString: "Order Type",
          plainTextStringFontSize: 20.sp(context),
          plainTextStringFontWeight: FontWeight.w600,
          plainTextContainerAlignment: Alignment.centerLeft,
          plainTextStringColor: ColorUtils.black29,
        ),

        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

        Obx(
          () => DropdownButtonFormField<String>(
            value: orderSelectAddressController.fulfillmentType.value,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 8.vpm(context),
                horizontal: 16.hpm(context),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(29, 36, 45, 1),
                ),
                borderRadius: BorderRadius.circular(8.r(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorUtils.orange125),
                borderRadius: BorderRadius.circular(8.r(context)),
              ),
            ),
            items: orderSelectAddressController.fulfillmentTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type.replaceAll("_", " ").capitalizeFirst ?? type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                orderSelectAddressController.setFulfillmentType(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
