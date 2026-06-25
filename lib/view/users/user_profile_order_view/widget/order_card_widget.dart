import 'package:discount_me_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/view/view.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderStatusModel order;
  final OrderStatusController controller;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.bpm(context)),
      decoration: BoxDecoration(
        color: ColorUtils.white253,
        borderRadius: BorderRadius.circular(9.r(context)),
        border: Border.all(
          color: ColorUtils.white221,
          width: 1.11
        )
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          overlayColor: Colors.transparent,
          padding: EdgeInsets.all(10.r(context)),
        ),
        onPressed: () async {
          controller.selectOrder(order);
        },
        child: Row(
          children: [

            SizedBox(
              height: 90.h(context),
              width: 90.w(context),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                  order.image,
                  height: 90.h(context),
                  width: 90.w(context),
                ),
              ),
            ),


            SpaceHelperWidget.h(5.w(context)),


            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Row(
                    children: [
                      Expanded(
                        child: TextHelperClass.headingTextWithoutWidth(
                          context: context,
                          text: "Order Id: ${order.orderId}",
                          fontSize: 20,
                          textAlign: TextAlign.start,
                          alignment: Alignment.centerLeft,
                          fontWeight: FontWeight.w700,
                          textColor: ColorUtils.black21,
                        ),
                      ),
 


                      TextHelperClass.headingTextWithoutWidth(
                          context: context,
                          text: order.status == "received" ? "Received" :
                          order.status == "ongoing" ? "Ongoing" :
                          order.status == "delivered" ? "Delivered" :
                          "Canceled",
                          fontSize: 18,
                          borderRadius: BorderRadius.circular(7.r(context)),
                          fontWeight: FontWeight.w700,
                          textColor: controller.getTextColor(order.status == "received" ? "Received" :
                          order.status == "ongoing" ? "Ongoing" :
                          order.status == "delivered" ? "Delivered" :
                          "Canceled"),
                          containerColor: controller.getColor(order.status == "received" ? "Received" :
                          order.status == "ongoing" ? "Ongoing" :
                          order.status == "delivered" ? "Delivered" :
                          "Canceled"),
                          padding: EdgeInsets.symmetric(vertical: 5.vpm(context),horizontal: 12.33.hpm(context))
                      ),


                    ],
                  ),

                  SpaceHelperWidget.v(7.h(context)),

                  TextHelperClass.headingTextWithoutWidth(
                    context: context,
                    text: 'Amount : Rs ${order.amount}',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    textColor: ColorUtils.black29,
                  ),

                  SpaceHelperWidget.v(7.h(context)),


                  Row(
                    children: [
                      Expanded(
                        child: RichTextHelperWidget.headingRichText(
                          context: context,
                          alignment: Alignment.centerLeft,
                          textAlign: TextAlign.start,
                          textSpans: [
                            CustomTextSpan(
                              text: "Date: ",
                              fontSize: 18,
                              color: ColorUtils.primaryColor,
                              fontWeight: FontWeight.w600,
                            ).toTextSpan(),
                            CustomTextSpan(
                              text: order.date,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.black29,
                            ).toTextSpan(),
                          ],
                        ),
                      ),


                      Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 28.r(context),
                          color: ColorUtils.black21,
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),


            Column(
              children: [




                SpaceHelperWidget.v(28.h(context)),







              ],
            )


          ],
        ),
      ),
    );
  }
}
