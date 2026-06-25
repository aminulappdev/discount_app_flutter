import 'package:discount_me_app/view/vendors/vendor_items_view/controller/vendor_items_controller.dart';
import 'package:discount_me_app/view/vendors/vendor_items_view/view/vendor_product_edit_view.dart';
import 'package:discount_me_app/view/vendors/vendor_items_view/widget/vendor_product_delete_dialog_box.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:discount_me_app/utils/utils.dart';
import '../../../../res/res.dart';

class VendorItemView extends StatelessWidget {
  const VendorItemView({super.key}); 

  @override
  Widget build(BuildContext context) {
    VendorItemsController vendorItemsController = Get.put(VendorItemsController(context: context));
    return Scaffold(
      body: Obx(()=>Container(
        height: 928.h(context),
        width: 428.w(context),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Skeletonizer(
          effect: PulseEffect(),
          enabled: vendorItemsController.isLoading.value,
          child: RefreshIndicator(
            onRefresh: () async {
              Get.off(()=>VendorDashboardView(index: 2),duration: const Duration(milliseconds: 100),preventDuplicates: false);
            },
            child: CustomScrollView(
              slivers: [



                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                    child: Column(
                      children: [

                        CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                        UserProfileAppbarWidget(
                          title: "Items",
                          onTap: () {
                            Get.off(()=>VendorDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          },
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Container(
                          width: 428.w(context),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r(context)),
                            border:Border.all(width: 1, color: ColorUtils.whiteDark),
                          ),
                          child: TextField(
                            onTap: () async {
                              vendorItemsController.updatedCategoryId.value = "";
                              await vendorItemsController.getVendorProfileController(context: context);
                            },
                            onChanged: (search) async {
                              vendorItemsController.products.value = vendorItemsController.productsResponseModel.value.data!.data!.where((e)=>e.name.toString().toLowerCase().contains(search.toLowerCase())).toList();
                            },
                            decoration: InputDecoration(
                              hintText: "Search",
                              prefixIcon: Icon(
                                Icons.search_outlined,
                                color: Colors.grey,
                                size: 32.r(context),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10.r(context),
                                ),
                              ),
                            ),
                          ),
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        vendorItemsController.categoriesResponseModel.value.categories?.isNotEmpty == true || vendorItemsController.categoriesResponseModel.value.categories != null ?
                        Container(
                          height: 120.h(context),
                          width: 428.w(context),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: vendorItemsController.categoriesResponseModel.value.categories?.length,
                            padding: EdgeInsets.all(5),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Obx(()=>Container(
                                height: 90.h(context),
                                width: 90.w(context),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.hpm(context),
                                  vertical: 10.vpm(context),
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: vendorItemsController.categoriesResponseModel.value.categories![index].sId == vendorItemsController.updatedCategoryId.value ? Colors.blueGrey : Colors.white, // Color of the container
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
                                child: TextButton(
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  onPressed: () async {
                                    vendorItemsController.products.value = [];
                                    vendorItemsController.updatedCategoryId.value = vendorItemsController.categoriesResponseModel.value.categories![index].sId;
                                    vendorItemsController.isLoading.value = true;
                                    vendorItemsController.getVendorCategoryWiseProductController(
                                      context: context,
                                      categoryId: vendorItemsController.categoriesResponseModel.value.categories?[index].sId ?? "",
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomImageContainer.networkImageContainer(
                                          height: 40.h(context),
                                          width: 40.w(context),
                                          networkImage: vendorItemsController.categoriesResponseModel.value.categories?[index].icon
                                      ),
                                      CustomSpaceWidget.spacerWidget(spaceHeight: 6.h(context)),
                                      CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                        plainTextString: vendorItemsController.categoriesResponseModel.value.categories?[index].name,
                                        plainTextStringFontSize: 14.sp(context),
                                        plainTextStringFontWeight: FontWeight.w500,
                                        plainTextContainerAlignment: Alignment.center,
                                        plainTextStringColor: ColorUtils.black29,
                                        plainTextStringTextAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                            },
                          ),
                        ) :
                        Container(
                          height: 120.h(context),
                          width: 428.w(context),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        vendorItemsController.products != [] && vendorItemsController.products.isNotEmpty == true ?
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: vendorItemsController.products.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.h(context),
                            crossAxisSpacing: 10.w(context),
                            childAspectRatio: 186.w(context) / 320.h(context),
                          ),
                          itemBuilder: (context, index) {
                            return TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () async {
                                Get.off(()=>VendorItemDetailsView(productId: vendorItemsController.products[index].sId,),duration: Duration(milliseconds: 100),preventDuplicates: false);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10.bpm(context)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r(context)), // Responsive border radius
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1), // Subtle shadow for elevation
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: Offset(0, 2), // Slight shadow for depth
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Top Image with rounded corners
                                    vendorItemsController.products[index].images?.isNotEmpty == false ?
                                    SizedBox.shrink() :
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(15.r(context))),
                                      child: Image.network(
                                        vendorItemsController.products[index].images!.first,
                                        height: 180.h(context), // Responsive height
                                        width: 428.w(context), // Full width
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    // Padding around the text and details
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.hpm(context),
                                        vertical: 8.vpm(context),
                                      ), // Responsive padding
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          // Title

                                          CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                            plainTextString: vendorItemsController.products[index].name != null ?
                                            "${vendorItemsController.products[index].name.toString().length > 80 ?
                                            vendorItemsController.products[index].name.toString().substring(0,80) :
                                            vendorItemsController.products[index].name.toString()}...." : "N/A",
                                            plainTextStringFontSize: 22.sp(context),
                                            plainTextStringFontWeight: FontWeight.w700,
                                            plainTextContainerAlignment: Alignment.centerLeft,
                                            plainTextStringColor: ColorUtils.black29,
                                            plainTextStringTextAlign: TextAlign.start,
                                          ),

                                          CustomSpaceWidget.spacerWidget(spaceHeight: 5.h(context)),

                                          // Description
                                          CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                            plainTextString: vendorItemsController.products[index].description != null ?
                                            "${vendorItemsController.products[index].description.toString().length > 80 ?
                                            vendorItemsController.products[index].description.toString().substring(0,80) :
                                            vendorItemsController.products[index].description.toString()}...." : "N/A",
                                            plainTextStringFontSize: 14.sp(context),
                                            plainTextStringFontWeight: FontWeight.w700,
                                            plainTextContainerAlignment: Alignment.centerLeft,
                                            plainTextStringColor: Colors.grey.shade600,
                                            plainTextStringTextAlign: TextAlign.start,
                                          ),

                                          CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                                          // Bottom section with icons, labels, and price
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Icons with labels (Time estimate and rating)
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    // Time icon and label
                                                    Container(
                                                      height: 30.h(context),
                                                      width: 30.w(context),
                                                      decoration: BoxDecoration(
                                                          color: Colors.transparent
                                                      ),
                                                      child: IconButton(
                                                        padding:EdgeInsets.zero,
                                                        color: Colors.orange,
                                                        onPressed: () {
                                                          Get.off(()=>VendorProductEditView(productId: vendorItemsController.products[index].sId),duration: Duration(milliseconds: 100),preventDuplicates: false);
                                                        },
                                                        icon: Icon(Icons.edit,size: 20.r(context),
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width: 10.w(context)),

                                                    // Rating icon and label
                                                    Container(
                                                      height: 30.h(context),
                                                      width: 30.w(context),
                                                      decoration: BoxDecoration(
                                                          color: Colors.transparent
                                                      ),
                                                      child: IconButton(
                                                        padding:EdgeInsets.zero,
                                                        color: Colors.orange,
                                                        onPressed: () async {
                                                          VendorProductDeleteDialogBox().vendorProductDeleteDialogBox(
                                                            context: context,
                                                            vendorItemsController: vendorItemsController,
                                                            onPressed: () async {
                                                              await vendorItemsController.getProductDeleteController(
                                                                context: context,
                                                                productId: vendorItemsController.products[index].sId,
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: Icon(Icons.delete,size: 20.r(context),),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                              CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                                plainTextString: vendorItemsController.productsResponseModel.value.data?.data?[index].price != null ?
                                                "${"\$"}${vendorItemsController.productsResponseModel.value.data!.data![index].price.toString()}" : "N/A",
                                                plainTextStringFontSize: 22.sp(context),
                                                plainTextStringFontWeight: FontWeight.w700,
                                                plainTextContainerAlignment: Alignment.centerLeft,
                                                plainTextStringColor: ColorUtils.black29,
                                                plainTextStringTextAlign: TextAlign.start,
                                              ),


                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ) :
                        vendorItemsController.products == [] || vendorItemsController.products.isEmpty == true ?
                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "No Product Available",
                          plainTextStringFontSize: 22.sp(context),
                          plainTextStringFontWeight: FontWeight.w700,
                          plainTextContainerAlignment: Alignment.center,
                          plainTextStringColor: ColorUtils.black29,
                          plainTextStringTextAlign: TextAlign.center,
                        ) :
                        CustomSpaceWidget.spacerWidget(),


                      ],
                    ),
                  ),
                )




              ],
            ),
          ),
        ),
      )),
    );
  }
}


