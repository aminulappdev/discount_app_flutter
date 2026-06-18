import 'dart:convert';

import 'package:discount_me_app/view/users/home_view/controller/order_select_address_controller.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';

import '../../../../../res/res.dart';

class OrderButtonWidget {

  Widget orderButtonWidget({
    required BuildContext context,
    required double pointsToRedeem,
    required OrderSelectAddressController orderSelectAddressController,
  }) {
    return Obx(()=>orderSelectAddressController.isSubmit.value == true ?
    Container(
      height: 64.h(context),
      width: 428.h(context),
      decoration: const BoxDecoration(
          color: Colors.transparent
      ),
      child: const Center(
        child: CircularProgressIndicator(color: ColorUtils.green139,),
      ),
    ) :
    CustomButtonContainer.plainButtonContainer(
      plainButtonHeight: 64.h(context),
      plainButtonWidth: 428.w(context),
      plainButtonRadius: 8.r(context),
      plainButtonOnPress:  () async {
       if(orderSelectAddressController.billingNameController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing name");
        } else if(orderSelectAddressController.billingCompanyNameController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing company name");
        } else if(orderSelectAddressController.billingStreetAddressController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing address");
        } else if(orderSelectAddressController.billingCountryController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing country");
        } else if(orderSelectAddressController.billingStateController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing state");
        } else if(orderSelectAddressController.billingCityController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing city");
        } else if(orderSelectAddressController.billingZipCodeController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing zip code");
        } else if(orderSelectAddressController.billingHouseNoController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing house no");
        } else if(orderSelectAddressController.billingEmailController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing email");
        } else if(orderSelectAddressController.billingPhoneController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter billing phone");
        } else if(orderSelectAddressController.isDelivery && orderSelectAddressController.shippingNameController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter shipping name");
        } else if(orderSelectAddressController.isDelivery && orderSelectAddressController.shippingAddressController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter address name");
        } else if(orderSelectAddressController.isDelivery && orderSelectAddressController.shippingEmailController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter shipping email");
        } else if(orderSelectAddressController.isDelivery && orderSelectAddressController.shippingPhoneController.value.text == "") {
          CustomSnackBar().errorCustomSnackBar(context: context, message: "Please enter shipping phone");
        } else {
          await orderSelectAddressController.createPaymentController(
            context: context,
            pointsToRedeem: pointsToRedeem,
          );
        }
      },
      plainButtonHint: "Complete Order",
      plainButtonHintFontSize: 22.sp(context),
      plainButtonColor: ColorUtils.green176,
      plainButtonHintFontColor: ColorUtils.white255,
    ));
  }



}
