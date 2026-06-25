// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:discount_me_app/view/users/user_profile_order_view/view/user_share_review_screen.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserOrderDeliveredStatusView extends StatelessWidget {
  const UserOrderDeliveredStatusView({
    super.key,
    required this.orderId,
    this.sourceFulfillmentType = "delivery",
  });

  final String orderId;
  final String sourceFulfillmentType;

  @override
  Widget build(BuildContext context) {
    final OrderDetailsController orderDetailsController = Get.put(OrderDetailsController(context: context,orderId: orderId));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onOpoInvoked) {
        Get.off(()=>_sourceOrderView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: orderDetailsController.isLoading.value,
          child: Container(
            height: 926.h(context),
            width: 428.w(context),
            decoration: BoxDecoration(
              color: ColorUtils.white253,
              image: DecorationImage(
                image: AssetImage(ImageUtils.homeBg),
                alignment: Alignment.topRight,
                opacity: 0.5,
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [

                  SliverFillRemaining(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                      child: Column(
                        children: [


                          SpaceHelperWidget.v(20.h(context)),

                          Container(
                            width: 428.w(context),
                            decoration: BoxDecoration(
                                color: Colors.transparent
                            ),
                            child: Row(
                              children: [
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
                                        imageAsset: orderDetailsController.userProfileResponseModel.value.data?.image ==  null ? ImageUtils.noImage : null,
                                        imageUrl: orderDetailsController.userProfileResponseModel.value.data?.image,
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


                                Row(
                                  children: [

                                    InkWell(
                                      onTap: () {
                                        Get.off(()=>UserNotificationView(),preventDuplicates: false,duration: const Duration(milliseconds: 100));
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

                                    SpaceHelperWidget.h(6.w(context)),


                                    InkWell(
                                      onTap: () {
                                        Get.off(()=>CartView(),preventDuplicates: false,duration: const Duration(milliseconds: 100));
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
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(Icons.shopping_cart, color: ColorUtils.whiteColor,size: 22.r(context),),
                                      ),
                                    ),

                                  ],
                                )

                              ],
                            ),
                          ),


                          SpaceHelperWidget.v(20.h(context)),



                          Row(
                            children: [


                              Expanded(
                                child: TextHelperClass.headingTextWithoutWidth(
                                  context: context,
                                  text: "Order details",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  textColor: ColorUtils.black21,
                                  alignment: Alignment.centerLeft,
                                ),
                              ),


                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                text: orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.status == "received" ? "Received" :
                                orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.status  == "ongoing" ? "Ongoing" :
                                orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.status  == "delivered" ? "Delivered" :
                                "Canceled",
                                fontSize: 18,
                                borderRadius: BorderRadius.circular(7.r(context)),
                                fontWeight: FontWeight.w700,
                                textColor: orderDetailsController.getTextColor( orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.status == "received" ? "Received" :
                                orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.status  == "ongoing" ? "Ongoing" :
                                orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.status  == "delivered" ? "Delivered" :
                                "Canceled"),
                                containerColor: orderDetailsController.getColor( orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.status == "received" ? "Received" :
                                orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.status  == "ongoing" ? "Ongoing" :
                                orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.status  == "delivered" ? "Delivered" :
                                "Canceled"),
                                padding: EdgeInsets.symmetric(vertical: 5.vpm(context),horizontal: 12.33.hpm(context)),
                              ),


                            ],
                          ),


                          SpaceHelperWidget.v(20.h(context)),



                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.items?.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 13.vpm(context),horizontal: 13.hpm(context)),
                                  margin: EdgeInsets.only(bottom: 10.bpm(context)),
                                  decoration: BoxDecoration(
                                    color: ColorUtils.white255,
                                    borderRadius: BorderRadius.circular(8.r(context)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorUtils.blue108,
                                        blurRadius: 54.76,
                                        spreadRadius: 0,
                                        offset: Offset(13.14, 28.47),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [

                                      orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.items?[index].product?.images?.isEmpty == true ?
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
                                        imageUrl: orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.items?[index].product?.images?.first,
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
                                              text: orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.items?[index].product?.name ?? "",
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              textColor: ColorUtils.black29,
                                              alignment: Alignment.centerLeft,
                                            ),

                                            SpaceHelperWidget.v(5.h(context)),

                                            TextHelperClass.headingTextWithoutWidth(
                                              context: context,
                                              text: "Quantity : ${orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.items?[index].quantity ?? ""}",
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              textColor: ColorUtils.black29,
                                              alignment: Alignment.centerLeft,
                                            ),

                                            SpaceHelperWidget.v(5.h(context)),

                                            TextHelperClass.headingTextWithoutWidth(
                                              context: context,
                                              text: "Rs ${orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.items?[index].product?.price ?? "N/A"}",
                                              fontSize: 21,
                                              fontWeight: FontWeight.w600,
                                              textColor: ColorUtils.primaryColor,
                                              alignment: Alignment.centerLeft,
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          SpaceHelperWidget.v(10.h(context)),


                          ButtonHelperWidget.customButtonWidget(
                            context: context,
                            height: 44,
                            onPressed: () async {
                              final productId = orderDetailsController
                                      .getOrderDetailsRetrievedResponseModel
                                      .value
                                      .data
                                      ?.items
                                      ?.first
                                      .product
                                      ?.sId
                                      ?.toString() ??
                                  "";

                              if (productId.isEmpty) {
                                MessageSnackBarWidget.errorSnackBarWidget(
                                  context: context,
                                  message: "Product not found",
                                );
                                return;
                              }

                              Get.to(
                                () => UserShareReviewScreen(
                                  productId: productId,
                                ),
                              );
                            },
                            text: "Share Review",
                            padding: EdgeInsets.symmetric(vertical: 14.5.vpm(context)),
                            alignment: Alignment.center,
                            fontSize: 18,
                            textColor: ColorUtils.orange125,
                            fontWeight: FontWeight.w700,
                            backgroundColor: Colors.transparent,
                          ),



                          SpaceHelperWidget.v(50.h(context)),


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Sub-Total, Delivery Charge, Discount, Total
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextHelperClass.headingTextWithoutWidth(
                                          context: context,
                                          text: 'Sub-Total',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          textColor: ColorUtils.black21,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),


                                      Expanded(
                                        child: TextHelperClass.headingTextWithoutWidth(
                                          context: context,
                                          text: 'Rs ${orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.total}',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          textColor: ColorUtils.black21,
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          textColor: ColorUtils.black21,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),



                                      Expanded(
                                        child: TextHelperClass.headingTextWithoutWidth(
                                          context: context,
                                          text: 'Rs ${orderDetailsController.deliveryCharge}',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          textColor: ColorUtils.black21,
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
                                          text: 'Discount',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          textColor: ColorUtils.black21,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),


                                      Expanded(
                                        child: TextHelperClass.headingTextWithoutWidth(
                                          context: context,
                                          text: 'Rs ${orderDetailsController.discount}',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          textColor: ColorUtils.black21,
                                          alignment: Alignment.centerRight,
                                        ),
                                      ),

                                    ],
                                  ),

                                  SizedBox(height: 20.h(context)),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextHelperClass.headingTextWithoutWidth(
                                          context: context,
                                          text: 'Total',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          textColor: ColorUtils.black21,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),



                                      Expanded(
                                        child: TextHelperClass.headingTextWithoutWidth(
                                          context: context,
                                          text: 'Rs ${orderDetailsController.getOrderDetailsRetrievedResponseModel.value.data?.total}',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          textColor: ColorUtils.black21,
                                          alignment: Alignment.centerRight,
                                        ),
                                      ),
                                    ],
                                  ),


                                  SizedBox(height: 20.h(context)),


                                ],
                              ),
                            ],
                          )


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget _sourceOrderView() {
    if (sourceFulfillmentType == "pickup") {
      return const UserProfilePickedOrderView();
    }

    return const UserProfileOrderView();
  }
}




