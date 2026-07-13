import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController(context: context));
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage( 
              image: AssetImage(ImageUtils.homeBg),
              alignment: Alignment.topRight,
              opacity: 0.5,
            ),
          ),
          child: Obx(()=> Skeletonizer(
              effect: PulseEffect(),
              enabled: cartController.isLoading.value,
              child: SafeArea(
                child: CustomScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  slivers: [


                    SliverFillRemaining(
                      child: Column(
                        children: [


                          SpaceHelperWidget.v(20.h(context)),

                          Container( 
                            width: 428.w(context),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: ColorUtils.black29,
                                      size: 24.r(context),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [


                                      ImageHelperWidget.circleImageHelperWidget(
                                        width: 45,
                                        height: 45,
                                        verticalPadding: 1,
                                        horizontalPadding: 1,
                                        backgroundColor: ColorUtils.orange213,
                                        radius: 25,
                                        context: context,
                                        imageAsset: cartController.userProfileResponseModel.value.data?.image ==  null ? ImageUtils.noImage : null,
                                        imageUrl: cartController.userProfileResponseModel.value.data?.image,
                                      ),

                                      SpaceHelperWidget.h(20.w(context)),

                                      Expanded(
                                        child: Center(
                                          child: ImageHelperWidget.assetImageWidget(
                                            context: context,
                                            height: 64.h(context),
                                            width: 170.w(context),
                                            imageString: ImageUtils.discountMeLogo,
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                ),

                                SpaceHelperWidget.h(5.w(context)),


                                InkWell(
                                  onTap: () {
                                    Get.to(()=>UserNotificationView(),preventDuplicates: false,duration: const Duration(milliseconds: 100));
                                  },
                                  child: Container(
                                    width: 45.w(context),
                                    height: 45.h(context),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorUtils.primaryColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: ColorUtils.whiteColor,
                                          blurRadius: 10,
                                          offset: Offset(0, 1),
                                        )
                                      ],
                                    ),
                                    child: Icon(Icons.notifications, color: ColorUtils.whiteColor, size: 25.r(context),),
                                  ),
                                ),

                              ],
                            ),
                          ),


                          SpaceHelperWidget.v(20.h(context)),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(
                                  child: TextHelperClass.headingTextWithoutWidth(
                                    context: context,
                                    alignment: Alignment.centerLeft,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    textColor: ColorUtils.black29,
                                    text: "Order details",
                                  ),
                                ),


                                ButtonHelperWidget.customIconButtonWidget(
                                  context: context,
                                  height: 45,
                                  padding: EdgeInsets.symmetric(vertical: 5.vpm(context),horizontal: 10.hpm(context)),
                                  onPressed: () {
                                    Get.to(()=>UserDashboardView(index: 2,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                  },
                                  isIconLeft: true,
                                  iconData: Icons.add, 
                                  iconColor: ColorUtils.whiteColor,
                                  iconSize: 18,
                                  text: "Add Item",
                                  fontWeight: FontWeight.w600,
                                  textColor: ColorUtils.white253,
                                  textSize: 18,
                                  backgroundColor: ColorUtils.secondaryColor,
                                ),

                              ],
                            ),
                          ),

                          SpaceHelperWidget.v(20.h(context)),


                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                              itemCount: cartController.getAllProductCartResponse.value.data?.carts?.length,
                              itemBuilder: (context, index) {
                                return Obx(()=> Container(
                                  padding: EdgeInsets.all(8.w(context)),
                                  margin: EdgeInsets.only(bottom: 10.bpm(context)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r(context)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.07),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [

                                      cartController.getAllProductCartResponse.value.data?.carts?[index].product?.images?.isEmpty == true ||
                                          cartController.getAllProductCartResponse.value.data?.carts?[index].product?.images == null ?
                                      Container(
                                        height: 120.h(context),
                                        width: 100.w(context),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(ImageUtils.carousel1),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(15.r(context))),
                                          color: Color.fromRGBO(175, 175, 175, 1),
                                        ),
                                      ) :
                                      ImageHelperWidget.styledImage(
                                        context: context,
                                        height: 120.h(context),
                                        width: 100.w(context),
                                        fit: BoxFit.cover,
                                        borderRadius: 13,
                                        imageUrl: cartController.getAllProductCartResponse.value.data?.carts?[index].product?.images?.first,
                                        errorWidget: Container(
                                          height: 120.h(context),
                                          width: 100.w(context),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(ImageUtils.carousel1),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r(context))),
                                            color: Color.fromRGBO(175, 175, 175, 1),
                                          ),
                                        ),
                                      ),


                                      SpaceHelperWidget.h(12.w(context)),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextHelperClass.headingTextWithoutWidth(
                                              context: context,
                                              text: cartController.getAllProductCartResponse.value.data?.carts?[index].product?.name ?? "N/A",
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              textColor: ColorUtils.black29,
                                              alignment: Alignment.centerLeft,
                                            ),

                                            SpaceHelperWidget.v(5.h(context)),

                                            TextHelperClass.headingTextWithoutWidth(
                                              context: context,
                                              text: cartController.storesResponseModel.value.data?.data?.where((e)=> e.sId == cartController.getAllProductCartResponse.value.data?.carts?[index].product?.store?.sId).first.name ?? "N/A",
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              textColor: ColorUtils.black29,
                                              alignment: Alignment.centerLeft,
                                            ),

                                            SpaceHelperWidget.v(5.h(context)),

                                            TextHelperClass.headingTextWithoutWidth(
                                              context: context,
                                              text: "Rs ${cartController.getAllProductCartResponse.value.data?.carts?[index].subtotal.toString() ?? "N/A"}",
                                              fontSize: 21,
                                              fontWeight: FontWeight.w600,
                                              textColor: ColorUtils.primaryColor,
                                              alignment: Alignment.centerLeft,
                                            ),

                                          ],
                                        ),
                                      ),


                                      SpaceHelperWidget.v(12.h(context)),

                                      // Quantity Selector
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 32.h(context),
                                                width: 32.w(context),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.r(context)),
                                                  color: ColorUtils.greenLightHover,
                                                ),
                                                child: cartController.getAllProductCartResponse.value.data?.carts?[index].sId == cartController.productId.value && cartController.isDecrease.value == true ?
                                                Center(
                                                  child: CircularProgressIndicator(),
                                                ) :
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: Icon(
                                                    Icons.remove,
                                                    color: ColorUtils.primaryColor,
                                                  ),
                                                  onPressed: cartController.isDecrease.value == true ? null : () async {
                                                    cartController.isDecrease.value = true;
                                                    cartController.subTotal.value = 0.0;
                                                    cartController.productId.value = cartController.getAllProductCartResponse.value.data?.carts?[index].sId;
                                                    await cartController.decreaseCartItemResponse(
                                                      context: context,
                                                      singleProductId: cartController.getAllProductCartResponse.value.data?.carts?[index].sId,
                                                    );
                                                  },
                                                ),
                                              ),

                                              SpaceHelperWidget.h(8.w(context)),


                                              TextHelperClass.headingTextWithoutWidth(
                                                context: context,
                                                text: cartController.getAllProductCartResponse.value.data?.carts?[index].quantity.toString() ?? "N/A",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                textColor: ColorUtils.black29,
                                                alignment: Alignment.center,
                                                textAlign: TextAlign.center,
                                              ),

                                              SpaceHelperWidget.h(8.w(context)),

                                              Container(
                                                height: 32.h(context),
                                                width: 32.w(context),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.r(context)),
                                                  color: ColorUtils.primaryColor,
                                                ),
                                                child: cartController.getAllProductCartResponse.value.data?.carts?[index].sId == cartController.productId.value && cartController.isIncrease.value == true ?
                                                Center(
                                                  child: CircularProgressIndicator(),
                                                ) :
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: Icon(Icons.add, color: Colors.white),
                                                  onPressed: cartController.isIncrease.value == true ? null : () async {
                                                    cartController.isIncrease.value = true;
                                                    cartController.subTotal.value = 0.0;
                                                    cartController.productId.value = cartController.getAllProductCartResponse.value.data?.carts?[index].sId;
                                                    await cartController.increaseCartItemResponse(
                                                      context: context,
                                                      singleProductId: cartController.getAllProductCartResponse.value.data?.carts?[index].sId,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 15.h(context)),

                                          Container(
                                            height: 32.h(context),
                                            width: 32.w(context),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.r(context)),
                                              color: ColorUtils.greenLightHover,
                                            ),
                                            child: cartController.getAllProductCartResponse.value.data?.carts?[index].sId == cartController.productId.value && cartController.isDelete.value == true ?
                                            Center(
                                              child: CircularProgressIndicator(),
                                            ) :
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.delete_forever,
                                                color: ColorUtils.primaryColor,
                                              ),
                                              onPressed: cartController.isDelete.value == true ? null : () async {
                                                cartController.isDelete.value = true;
                                                cartController.subTotal.value = 0.0;
                                                cartController.productId.value = cartController.getAllProductCartResponse.value.data?.carts?[index].sId;
                                                await cartController.deleteCartResponse(
                                                  context: context,
                                                  cardId: cartController.getAllProductCartResponse.value.data?.carts?[index].sId,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                              },
                            ),
                          ),


                          Container(
                            width: 428.w(context),
                            padding: EdgeInsets.symmetric(vertical: 16.vpm(context), horizontal: 20.hpm(context)),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8.r(context)),
                              image: DecorationImage(
                                image: AssetImage(ImageUtils.orderBg),
                                fit: BoxFit.cover,
                                opacity: 0.3,
                                colorFilter: ColorFilter.mode(
                                    ColorUtils.primaryColor, BlendMode.dstATop),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: 'Sub-Total',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        textColor: Color(0xfffefeff),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),


                                    Expanded(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: "Rs ${cartController.subTotal.floor()}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        textColor: Color(0xfffefeff),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ),

                                  ],
                                ),

                                SpaceHelperWidget.v(5.h(context)),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: 'Delivery Charge',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        textColor: Color(0xfffefeff),
                                        alignment: Alignment.centerLeft, 
                                      ),
                                    ),


                                    Expanded(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: "Rs ${cartController.getAllProductCartResponse.value.data?.totalShippingFee.toString() ?? "N/A"}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        textColor: Color(0xfffefeff),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ),

                                  ],
                                ),


                                SpaceHelperWidget.v(5.h(context)),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: 'Points',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        textColor: Color(0xfffefeff),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),


                                    Expanded(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: "${cartController.userProfileResponseModel.value.data?.totalRewardPoints ?? "N/A"}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        textColor: Color(0xfffefeff),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ),

                                  ],
                                ),


                                SpaceHelperWidget.v(5.h(context)),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: cartController.getFirstResponderDiscountPercentage() > 0 ?
                                        'Discount ${cartController.getFirstResponderDiscountPercentage().toStringAsFixed(0)}% (${cartController.getFirstResponderDiscountLabel()})' :
                                        'Discount',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        textColor: Color(0xfffefeff),
                                        alignment: Alignment.centerLeft,
                                        maxLines: 2,
                                      ),
                                    ),


                                    Expanded(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: cartController.getFirstResponderDiscountPercentage() > 0 ?
                                        "USD ${cartController.getFirstResponderDiscountAmount(
                                          double.parse(cartController.getAllProductCartResponse.value.data?.totalShippingFee.toString() ?? "0") + double.parse(cartController.subTotal.value.toString()),
                                        ).toStringAsFixed(2)}" :
                                        "USD 0.00",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        textColor: Color(0xfffefeff),
                                        alignment: Alignment.centerRight,
                                        textAlign: TextAlign.right,
                                        maxLines: 2,
                                      ),
                                    ),

                                  ],
                                ),


                                SpaceHelperWidget.v(5.h(context)),


                                if(double.parse(cartController.userProfileResponseModel.value.data?.totalRewardPoints.toString() ?? "0") > 500)...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [

                                          /// Discount Text
                                          TextHelperClass.headingTextWithoutWidth(
                                            context: context,
                                            text: "Redeem points",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            textColor: ColorUtils.whiteColor,
                                          ),

                                          SpaceHelperWidget.h(6.w(context)),

                                          TextHelperClass.headingTextWithoutWidth(
                                            context: context,
                                            text: "${cartController.getRewardTier(double.parse(cartController.userProfileResponseModel.value.data?.totalRewardPoints.toString() ?? "0"))} pts",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            textColor: ColorUtils.whiteColor,
                                          ),

                                        ],
                                      ),

                                      /// Right Side Toggle + Value
                                      Row(
                                        children: [

                                          Switch(
                                            value: cartController.isDiscountApplied.value,
                                            activeColor: ColorUtils.secondaryColor,
                                            activeTrackColor: ColorUtils.whiteColor,
                                            inactiveThumbColor: ColorUtils.whiteColor,
                                            inactiveTrackColor: ColorUtils.blue108,
                                            onChanged: (value) {
                                              cartController.isDiscountApplied.value = value;
                                            },
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ],


                                SpaceHelperWidget.v(20.h(context)),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: 'Total',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        textColor: Color(0xfffefeff),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),


                                    TextHelperClass.headingTextWithoutWidth(
                                      context: context,
                                      text: "Rs ${cartController.getCartTotalAmount().toStringAsFixed(2)}",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      textColor: ColorUtils.whiteColor,
                                    ),

                                  ],
                                ),


                                SpaceHelperWidget.v(10.h(context)), 


                                ButtonHelperWidget.customButtonWidget(
                                  context: context,
                                  onPressed: () async {
                                    if(cartController.getAllProductCartResponse.value.data?.carts?.isEmpty == true) {
                                      MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "Please Add At least 1 Product to Cart");
                                    } else {
                                      Get.to(()=>OrderSelectAddressView(
                                        pickAddress: "",
                                        pointsToRedeem: cartController.isDiscountApplied.value == true ?
                                        cartController.getRewardTier(double.parse(cartController.userProfileResponseModel.value.data?.totalRewardPoints.toString() ?? "0")) : 0.0,
                                      ),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                    }
                                  },
                                  text: "Place My Order",
                                  borderRadius: 8,
                                  backgroundColor: ColorUtils.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  textColor: ColorUtils.primaryColor,
                                ),

                                SpaceHelperWidget.v(10.h(context)),

                              ],
                            ),
                          ),


                        ],
                      ),
                    )

                  ],
                ),
              )
          )),
        ),
    );
  }
}
