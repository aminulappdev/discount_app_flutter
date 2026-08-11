import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';


class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  double? _toDouble(dynamic value) => double.tryParse(value?.toString() ?? '');

  String _formatPrice(double value) =>
      value.toStringAsFixed(value % 1 == 0 ? 0 : 2);

  @override
  Widget build(BuildContext context) {
    final ExploreController exploreController = Get.put(ExploreController(context: context));
    return Scaffold(
      body: Container(
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
        child: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: exploreController.isLoading.value,
          child: RefreshIndicator(
            onRefresh: () async {
              Get.to(()=>UserDashboardView(index: 2,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
            },
            child: CustomScrollView(
              slivers: [

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                    child: Column(
                      children: [

                        SpaceHelperWidget.v(40.h(context)),


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
                                      imageAsset: exploreController.userProfileResponseModel.value.data?.image ==  null ? ImageUtils.noImage : null,
                                      imageUrl: exploreController.userProfileResponseModel.value.data?.image,
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

                                  SpaceHelperWidget.h(6.w(context)),


                                  InkWell(
                                    onTap: () {
                                      Get.to(()=> CartView(),preventDuplicates: false,duration: const Duration(milliseconds: 100));
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


                        TextFormFieldWidget.build(
                          context: context,
                          hintText: "Search",
                          controller: exploreController.searchController.value,
                          keyboardType: TextInputType.emailAddress,
                          fillColor: ColorUtils.white253,
                          onTap: () async {
                            exploreController.updatedCategoryId.value = "";
                            await exploreController.getSearchProductsApiService(
                              context: context,
                            );
                          },
                          onChanged: (search) async {
                            if(search != null) {
                              exploreController.products.value = exploreController.productsResponseModel.value.data!.data!.where((e)=>e.name.toString().contains(search)).toList();
                            }
                          },
                          borderColor: ColorUtils.white202,
                          enableBorderColor: ColorUtils.white202,
                          focusedBorderColor: ColorUtils.secondaryColor,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(20.r(context)),
                            child: InkWell(
                              onTap: () async {},
                              child: ImageHelperWidget.assetImageWidget(
                                context: context,
                                height: 24.h(context),
                                width: 24.w(context),
                                imageString: ImageUtils.searchNormalImage,
                              ),
                            ),
                          ),
                        ),



                        // Container(
                        //   width: 428.w(context),
                        //   decoration: BoxDecoration(
                        //     color: Colors.transparent,
                        //     borderRadius: BorderRadius.circular(8.r(context)),
                        //     border:Border.all(width: 1, color: ColorUtils.whiteDark),
                        //   ),
                        //   child: TextField(
                        //     onTap: () async {
                        //       exploreController.updatedCategoryId.value = "";
                        //       await exploreController.getSearchProductsApiService(
                        //         context: context,
                        //       );
                        //     },
                        //     onChanged: (search) async {
                        //       exploreController.products.value = exploreController.productsResponseModel.value.data!.data!.where((e)=>e.name.toString().contains(search)).toList();
                        //     },
                        //     decoration: InputDecoration(
                        //       hintText: "Search",
                        //       prefixIcon: Icon(
                        //         Icons.search_outlined,
                        //         color: Colors.grey,
                        //         size: 32.r(context),
                        //       ),
                        //       border: OutlineInputBorder(
                        //         borderSide: BorderSide.none,
                        //         borderRadius: BorderRadius.circular(10.r(context),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        SpaceHelperWidget.v(20.h(context)),


                        exploreController.categoriesResponseModel.value.categories?.isNotEmpty == true ||
                            exploreController.categoriesResponseModel.value.categories != null ?
                        Container(
                          height: 120.h(context),
                          width: 428.w(context),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: exploreController.categoriesResponseModel.value.categories?.length,
                            padding: EdgeInsets.all(5.r(context)),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Obx(()=>Container(
                                width: 90.w(context),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.hpm(context),
                                  vertical: 10.vpm(context),
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: exploreController.categoriesResponseModel.value.categories![index].sId == exploreController.updatedCategoryId.value ?
                                  Colors.blueGrey : Colors.white, // Color of the container
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08), // Shadow color with opacity
                                      spreadRadius: 0, // Spread radius of the shadow
                                      blurRadius: 8, // Blur radius of the shadow
                                      offset: Offset(0, 2), // Offset of the shadow (x, y)
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8.r(context)),
                                ),
                                margin: EdgeInsets.only(right: 10.rpm(context)),
                                child: TextButton(
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  onPressed: () async {
                                    exploreController.isLoading.value = true;
                                    exploreController.products.value = [];
                                    exploreController.updatedCategoryId.value = exploreController.categoriesResponseModel.value.categories![index].sId;
                                    await exploreController.getProductsByCategoryApiService(
                                      categoryId: exploreController.categoriesResponseModel.value.categories![index].sId,
                                      context: context
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ImageHelperWidget.styledImage(
                                        context: context,
                                        height: 40,
                                        width: 40,
                                        borderRadius: 0,
                                        fit: BoxFit.fill,
                                        imageUrl: exploreController.categoriesResponseModel.value.categories?[index].icon,
                                      ),

                                      SpaceHelperWidget.v(6.h(context)),

                                      TextHelperClass.headingTextWithoutWidth(
                                        context: context,
                                        text: exploreController.categoriesResponseModel.value.categories?[index].name,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        textColor: ColorUtils.black29,
                                        textAlign: TextAlign.center,
                                        alignment: Alignment.center,
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


                        SpaceHelperWidget.v(20.h(context)),


                        exploreController.products != [] && exploreController.products.isNotEmpty == true ?
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: exploreController.products.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () async {
                                Get.to(()=> SingleProductViewScreen(
                                  productId: exploreController.products[index].sId,
                                  isSingleStoreScreen: false,isHomeScreen: false,storeId: '',isProductListPage: false,isExplorePage: true, isStoreScreen: false,
                                ), duration: Duration(milliseconds: 100),preventDuplicates: false,);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20.bpm(context)),
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
                                    // Top Image with rounded corners


                                    exploreController.products[index].images?.isEmpty == true ?
                                    Container(
                                      height: 180.h(context),
                                      width: 428.w(context),
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
                                      height: 180,
                                      width: 428,
                                      fit: BoxFit.cover,
                                      topLeftRadius: 15,
                                      topRightRadius: 15,
                                      bottomLeftRadius: 0,
                                      bottomRightRadius: 0,
                                      imageUrl: exploreController.products[index].images!.first,
                                      errorWidget: Container(
                                        height: 180.h(context),
                                        width: 428.w(context),
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

                                          TextHelperClass.headingTextWithoutWidth(
                                            context: context,
                                            text: exploreController.products[index].name ?? "N/A",
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            textColor: ColorUtils.black29,
                                            textAlign: TextAlign.start,
                                            alignment: Alignment.centerLeft,
                                            maxLines: 1,
                                            textOverFlow: TextOverflow.ellipsis,
                                          ),

                                          SpaceHelperWidget.v(5.h(context)),


                                          TextHelperClass.headingTextWithoutWidth(
                                            context: context,
                                            text: exploreController.products[index].description != null ?
                                            "${exploreController.products[index].description.toString().length > 50 ?
                                            exploreController.products[index].description.toString().substring(0,50) :
                                            exploreController.products[index].description.toString()}...." : "N/A",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            textColor: ColorUtils.black76,
                                            textAlign: TextAlign.start,
                                            alignment: Alignment.centerLeft,
                                            maxLines: 3,
                                            textOverFlow: TextOverflow.ellipsis,
                                          ),


                                          SpaceHelperWidget.v(10.h(context)),


                                          // Bottom section with icons, labels, and price
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Icons with labels (Time estimate and rating)
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    // Time icon and label
                                                    Icon(Icons.ac_unit, size: 16.r(context), color: Colors.orange),

                                                    SpaceHelperWidget.h(6.w(context)),


                                                    TextHelperClass.headingTextWithoutWidth(
                                                      context: context,
                                                      text: exploreController.products[index].quantity != null ?
                                                      "${exploreController.products[index].quantity} pics" : "N/A",
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      textColor: ColorUtils.black76,
                                                      textAlign: TextAlign.start,
                                                      alignment: Alignment.centerLeft,
                                                    ),


                                                    SpaceHelperWidget.h(10.w(context)),


                                                    // Rating icon and label
                                                    Icon(Icons.star, size: 16.r(context), color: Colors.orange),
                                                    SpaceHelperWidget.h(6.w(context)),

                                                    TextHelperClass.headingTextWithoutWidth(
                                                      context: context,
                                                      text: exploreController.productsResponseModel.value.data?.data?[index].ratings != null ?
                                                      "${exploreController.productsResponseModel.value.data?.data?[index].ratings}" : "N/A",
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      textColor: ColorUtils.black76,
                                                      textAlign: TextAlign.start,
                                                      alignment: Alignment.centerLeft,
                                                    ),

                                                  ],
                                                ),
                                              ),


                                              Builder(
                                                builder: (_) {
                                                  final product =
                                                      exploreController
                                                          .products[index];
                                                  final price = _toDouble(
                                                    product.price,
                                                  );
                                                  final discount = _toDouble(
                                                        product.discount,
                                                      ) ??
                                                      0.0;
                                                  final discountedPrice =
                                                      price == null
                                                      ? null
                                                      : discount > 0
                                                      ? price -
                                                            ((price *
                                                                    discount) /
                                                                100)
                                                      : price;

                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      if (price != null &&
                                                          discount > 0)
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                right: 6.w(
                                                                  context,
                                                                ),
                                                                bottom: 2.h(
                                                                  context,
                                                                ),
                                                              ),
                                                          child: Text(
                                                            "\$${_formatPrice(price)}",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .grey
                                                                  .shade600,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                          ),
                                                        ),
                                                      TextHelperClass.headingTextWithoutWidth(
                                                        context: context,
                                                        text:
                                                            discountedPrice !=
                                                                null
                                                            ? "\$${_formatPrice(discountedPrice)}"
                                                            : "N/A",
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        textColor:
                                                            ColorUtils.black29,
                                                        textAlign:
                                                            TextAlign.start,
                                                        alignment:
                                                            Alignment
                                                                .centerLeft,
                                                      ),
                                                    ],
                                                  );
                                                },
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
                        exploreController.products.isEmpty == true ?
                        TextHelperClass.headingTextWithoutWidth(
                          context: context,
                          text: "No Product Available",
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          textColor: ColorUtils.black29,
                          textAlign: TextAlign.center,
                          alignment: Alignment.center,
                        ) :
                        SizedBox.shrink(),


                      ],
                    ),
                  ),
                )


              ],
            ),
          ),
        )),
      ),
    );
  }
}
