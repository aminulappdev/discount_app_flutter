import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/vendors/vendor_items_view/controller/vendor_product_details_controller.dart';
import 'package:discount_me_app/view/vendors/vendor_items_view/view/vendor_product_edit_view.dart';
import 'package:discount_me_app/view/vendors/vendor_items_view/widget/vendor_product_delete_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../res/res.dart';
import '../../../view.dart';
 
class VendorItemDetailsView extends StatelessWidget {
  const VendorItemDetailsView({super.key,required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    VendorProductDetailsController vendorProductDetailsController = Get.put(VendorProductDetailsController(productId: productId, context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onPopInvoked) {
        Get.to(()=>VendorDashboardView(index: 2,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Container(
          height: 928.h(context),
          width: 428.w(context),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Obx(()=>Skeletonizer(
            effect: PulseEffect(),
            enabled: vendorProductDetailsController.isLoading.value,
            child: CustomScrollView(
              slivers: [


                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                    child: Column(
                      children: [

                        CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                        UserProfileAppbarWidget(
                          title: "Items Details",
                          onTap: () {
                            Get.to(()=>VendorDashboardView(index: 2,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          },
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),


                        Container(
                          height: 250.h(context),
                          width: 428.w(context),
                          child: vendorProductDetailsController.singleProductResponseModel.value.data?.images != null ?
                          Column(
                            children: [
                              Expanded(
                                child: PageView.builder(
                                  onPageChanged: (value) {
                                    vendorProductDetailsController.onPageChanged(value);
                                  },
                                  controller: vendorProductDetailsController.pageController.value,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: vendorProductDetailsController.singleProductResponseModel.value.data!.images!.length,
                                  itemBuilder: (context, index) {
                                    return _buildScalingTransition(vendorProductDetailsController.singleProductResponseModel.value.data!.images![index], index);
                                  },
                                ),
                              ),
                              CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),
                              SmoothPageIndicator(
                                controller: vendorProductDetailsController.pageController.value,
                                count: vendorProductDetailsController.singleProductResponseModel.value.data!.images!.length,
                                effect: ExpandingDotsEffect(
                                  activeDotColor: Colors.deepPurple,
                                  dotColor: Colors.deepPurple.shade100,
                                  dotHeight: 10,
                                  dotWidth: 10,
                                ),
                              ),
                            ],
                          ) :
                          CustomSpaceWidget.spacerWidget(),
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Expanded(
                              child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                plainTextString: vendorProductDetailsController.singleProductResponseModel.value.data?.name ?? "N/A",
                                plainTextStringFontSize: 18.sp(context),
                                plainTextStringFontWeight: FontWeight.w700,
                                plainTextContainerAlignment: Alignment.centerLeft,
                                plainTextStringColor: ColorUtils.black29,
                                plainTextStringTextAlign: TextAlign.start,
                              ),
                            ),

                            CustomSpaceWidget.spacerWidget(spaceWidth: 40.w(context)),

                            // Rating
                            vendorProductDetailsController.singleProductResponseModel.value.data?.ratings != null ?
                            Row(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (Index) {
                                    // Calculate the fill amount for each star
                                    double starValue = double.parse(vendorProductDetailsController.singleProductResponseModel.value.data!.ratings.toString()) - Index;
                                    bool isFilled = starValue >= 1.0;
                                    bool isHalfFilled = starValue > 0.0 && starValue < 1.0;

                                    return Icon(
                                      isFilled
                                          ? Icons.star
                                          : isHalfFilled
                                          ? Icons.star_half
                                          : Icons.star_border,
                                      size: 18.r(context),
                                      color: isFilled || isHalfFilled ? Colors.amber : Colors.grey.shade600,
                                    );
                                  }),
                                ),
                                SizedBox(width: 5.w(context)),
                                CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                  plainTextString: vendorProductDetailsController.singleProductResponseModel.value.data!.ratings.toStringAsFixed(1).toString(),
                                  plainTextStringFontSize: 18.sp(context),
                                  plainTextStringFontWeight: FontWeight.w600,
                                  plainTextContainerAlignment: Alignment.center,
                                  plainTextStringColor: ColorUtils.black29,
                                  plainTextStringTextAlign: TextAlign.start,
                                ),
                              ],
                            ) :  CustomSpaceWidget.spacerWidget(),

                          ],
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icons with labels (Time estimate and rating)
                            Expanded(
                              child: Row(
                                children: [
                                  // Time icon and label
                                  Icon(Icons.ac_unit, size: 18.r(context), color: Colors.orange),
                                  SizedBox(width: 4.w(context)),
                                  CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: vendorProductDetailsController.singleProductResponseModel.value.data?.quantity != null ?
                                    "${vendorProductDetailsController.singleProductResponseModel.value.data?.quantity} pics" : "N/A",
                                    plainTextStringFontSize: 18.sp(context),
                                    plainTextStringFontWeight: FontWeight.w500,
                                    plainTextContainerAlignment: Alignment.centerLeft,
                                    plainTextStringColor: Colors.grey.shade700,
                                    plainTextStringTextAlign: TextAlign.start,
                                  ),

                                  SizedBox(width: 10.w(context)),

                                  CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: vendorProductDetailsController.singleProductResponseModel.value.data?.quantity != null && vendorProductDetailsController.singleProductResponseModel.value.data?.quantity != 0 ?
                                    "Available" : "Not AvailAble",
                                    plainTextStringFontSize: 18.sp(context),
                                    plainTextStringFontWeight: FontWeight.w500,
                                    plainTextContainerAlignment: Alignment.centerLeft,
                                    plainTextStringColor: vendorProductDetailsController.singleProductResponseModel.value.data?.quantity != null && vendorProductDetailsController.singleProductResponseModel.value.data?.quantity != 0?
                                    ColorUtils.green176 : ColorUtils.red191,
                                    plainTextStringTextAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),


                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: vendorProductDetailsController.singleProductResponseModel.value.data?.price != null ?
                              "${"\$"}${vendorProductDetailsController.singleProductResponseModel.value.data?.price.toString()}" : "N/A",
                              plainTextStringFontSize: 22.sp(context),
                              plainTextStringFontWeight: FontWeight.w700,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                              plainTextStringTextAlign: TextAlign.start,
                            ),


                          ],
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Description",
                          plainTextStringFontSize: 18.sp(context),
                          plainTextStringFontWeight: FontWeight.w800,
                          plainTextContainerAlignment: Alignment.centerLeft,
                          plainTextStringColor: Colors.grey.shade700,
                          plainTextStringTextAlign: TextAlign.start,
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: vendorProductDetailsController.singleProductResponseModel.value.data?.description != null ?
                          "${vendorProductDetailsController.singleProductResponseModel.value.data?.description}" : "N/A",
                          plainTextStringFontSize: 18.sp(context),
                          plainTextStringFontWeight: FontWeight.w500,
                          plainTextContainerAlignment: Alignment.centerLeft,
                          plainTextStringColor: Colors.grey.shade700,
                          plainTextStringTextAlign: TextAlign.start,
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Category",
                          plainTextStringFontSize: 18.sp(context),
                          plainTextStringFontWeight: FontWeight.w800,
                          plainTextContainerAlignment: Alignment.centerLeft,
                          plainTextStringColor: Colors.grey.shade700,
                          plainTextStringTextAlign: TextAlign.start,
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                        vendorProductDetailsController.singleProductResponseModel.value.data?.category != null ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 90.w(context),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.hpm(context),
                                vertical: 10.vpm(context),
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white, // Color of the container
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08), // Shadow color with opacity
                                      spreadRadius: 0, // Spread radius of the shadow
                                      blurRadius: 8, // Blur radius of the shadow
                                      offset: Offset(0, 2), // Offset of the shadow (x, y)
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8.r(context))
                              ),
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomImageContainer.networkImageContainer(
                                    height: 40.h(context),
                                    width: 40.w(context),
                                    networkImage: vendorProductDetailsController.singleProductResponseModel.value.data!.category!.icon,
                                  ),
                                  CustomSpaceWidget.spacerWidget(spaceHeight: 6.h(context)),
                                  CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: vendorProductDetailsController.singleProductResponseModel.value.data!.category!.name,
                                    plainTextStringFontSize: 14.sp(context),
                                    plainTextStringFontWeight: FontWeight.w500,
                                    plainTextContainerAlignment: Alignment.center,
                                    plainTextStringColor: ColorUtils.black29,
                                    plainTextStringTextAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ) :
                        CustomSpaceWidget.spacerWidget(),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),



                        Container(
                          height: 55.h(context),
                          width: 428.w(context),
                          decoration: BoxDecoration(
                            color: ColorUtils.green176,
                            borderRadius: BorderRadius.circular(12.r(context)),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              Get.to(()=>VendorProductEditView(
                                  productId: vendorProductDetailsController.singleProductResponseModel.value.data?.sId ?? ""),
                                  duration: Duration(milliseconds: 100),
                                  preventDuplicates: false,
                              );
                            },
                            child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "Edit item",
                              plainTextStringFontSize: 18.sp(context),
                              plainTextStringFontWeight: FontWeight.w700,
                              plainTextContainerAlignment: Alignment.center,
                              plainTextStringColor: ColorUtils.white246,
                              plainTextStringTextAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 18.h(context)),

                        Container(
                          height: 55.h(context),
                          width: 428.w(context),
                          decoration: BoxDecoration(
                            color: ColorUtils.red191,
                            borderRadius: BorderRadius.circular(12.r(context)),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              VendorProductDeleteDialogBox().vendorProductDetailsDeleteDialogBox(
                                context: context,
                                vendorProductDetailsController: vendorProductDetailsController,
                                onPressed: () async {
                                  await vendorProductDetailsController.getProductDeleteController(
                                    context: context,
                                    productId: vendorProductDetailsController.singleProductResponseModel.value.data?.sId ?? "",
                                  );
                                },
                              );
                            },
                            child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "Delete item",
                              plainTextStringFontSize: 18.sp(context),
                              plainTextStringFontWeight: FontWeight.w700,
                              plainTextContainerAlignment: Alignment.center,
                              plainTextStringColor: ColorUtils.white246,
                              plainTextStringTextAlign: TextAlign.center,
                            ),
                          ),
                        ),






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


  Widget _buildScalingTransition(String image, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0), // Scaling from 50% to 100%
      duration: const Duration(milliseconds: 600),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale, // Scale the image
          child: Image.network(
            image,
            fit: BoxFit.fill,
          ),
        );
      },
    );
  }


}
