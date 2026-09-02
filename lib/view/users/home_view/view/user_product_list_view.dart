import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProductListView extends StatelessWidget {
  const UserProductListView({
    super.key,
    required this.categoryId,
    required this.storeId,  
  }); 

  final String categoryId;
  final String storeId;

  double? _toDouble(dynamic value) => double.tryParse(value?.toString() ?? '');

  String _formatPrice(double value) =>
      value.toStringAsFixed(value % 1 == 0 ? 0 : 2);

  @override
  Widget build(BuildContext context) {
    final UserProductListController userProductListController = Get.put(
      UserProductListController(
        context: context,
        categoryId: categoryId,
        storeId: storeId,
      ),
    );
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
        child: Obx(
          () => Skeletonizer(
            effect: PulseEffect(),
            enabled: userProductListController.isLoading.value,
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                    child: Column(
                      children: [
                        SpaceHelperWidget.v(20.h(context)),

                        Container(
                          width: 428.w(context),
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        size: 22.r(context),
                                        Icons.arrow_back_ios,
                                        color: ColorUtils.black29,
                                      ),
                                    ),

                                    SpaceHelperWidget.h(10.w(context)),

                                    Expanded(
                                      child: Center(
                                        child:
                                            ImageHelperWidget.assetImageWidget(
                                              context: context,
                                              height: 56.h(context),
                                              width: 170.w(context),
                                              imageString:
                                                  ImageUtils.discountMeLogo,
                                            ),
                                      ),
                                    ),

                                    SpaceHelperWidget.h(5.w(context)),
                                  ],
                                ),
                              ),

                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => UserNotificationView(),
                                        duration: const Duration(
                                          milliseconds: 100,
                                        ),
                                        preventDuplicates: false,
                                      );
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
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.notifications,
                                        color: ColorUtils.whiteColor,
                                        size: 25.r(context),
                                      ),
                                    ),
                                  ),

                                  SpaceHelperWidget.h(6.w(context)),

                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => CartView(),
                                        duration: const Duration(
                                          milliseconds: 100,
                                        ),
                                        preventDuplicates: false,
                                      );
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
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: ColorUtils.whiteColor,
                                        size: 22.r(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SpaceHelperWidget.v(20.h(context)),

                        TextFormFieldWidget.build(
                          context: context,
                          hintText: "Search",
                          controller:
                              userProductListController.searchController.value,
                          keyboardType: TextInputType.text,
                          fillColor: ColorUtils.white253,
                          onChanged: (search) {
                            final query = (search ?? '').trim().toLowerCase();
                            final allProducts = userProductListController
                                    .productsResponseModel.value.data?.data ??
                                [];

                            userProductListController.products.value =
                                query.isEmpty
                                    ? List.of(allProducts)
                                    : allProducts.where((product) {
                                        final name = (product.name ?? '')
                                            .toString()
                                            .toLowerCase();
                                        final description =
                                            (product.description ?? '')
                                                .toString()
                                                .toLowerCase();
                                        return name.contains(query) ||
                                            description.contains(query);
                                      }).toList();
                          },
                          borderColor: ColorUtils.white202,
                          enableBorderColor: ColorUtils.white202,
                          focusedBorderColor: ColorUtils.secondaryColor,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(20.r(context)),
                            child: ImageHelperWidget.assetImageWidget(
                              context: context,
                              height: 24.h(context),
                              width: 24.w(context),
                              imageString: ImageUtils.searchNormalImage,
                            ),
                          ),
                        ),

                        SpaceHelperWidget.v(20.h(context)),

                        userProductListController
                                        .categoriesResponseModel
                                        .value
                                        .categories
                                        ?.isNotEmpty ==
                                    true ||
                                userProductListController
                                        .categoriesResponseModel
                                        .value
                                        .categories !=
                                    null
                            ? Container(
                                height: 120.h(context),
                                width: 428.w(context),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: userProductListController
                                      .categoriesResponseModel
                                      .value
                                      .categories
                                      ?.length,
                                  padding: EdgeInsets.all(5.r(context)),
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => InkWell(
                                        onTap: () async {
                                          userProductListController
                                                  .products
                                                  .value =
                                              [];
                                          userProductListController
                                              .updatedCategoryId
                                              .value = userProductListController
                                              .categoriesResponseModel
                                              .value
                                              .categories![index]
                                              .sId;
                                          userProductListController
                                                  .isLoading
                                                  .value =
                                              true;
                                          await userProductListController
                                              .getProductsByCategoryApiService(
                                                categoryId:
                                                    userProductListController
                                                        .categoriesResponseModel
                                                        .value
                                                        .categories![index]
                                                        .sId,
                                                context: context,
                                              );
                                        },
                                        child: Container(
                                          width: 90.w(context),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.hpm(context),
                                            vertical: 10.vpm(context),
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                userProductListController
                                                        .categoriesResponseModel
                                                        .value
                                                        .categories![index]
                                                        .sId ==
                                                    userProductListController
                                                        .updatedCategoryId
                                                        .value
                                                ? Colors.blueGrey
                                                : Colors
                                                      .white, // Color of the container
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.08,
                                                ), // Shadow color with opacity
                                                spreadRadius:
                                                    0, // Spread radius of the shadow
                                                blurRadius:
                                                    8, // Blur radius of the shadow
                                                offset: Offset(
                                                  0,
                                                  2,
                                                ), // Offset of the shadow (x, y)
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(
                                              8.r(context),
                                            ),
                                          ),
                                          margin: EdgeInsets.only(
                                            right: 10.rpm(context),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ImageHelperWidget.styledImage(
                                                context: context,
                                                height: 40,
                                                width: 40,
                                                borderRadius: 0,
                                                fit: BoxFit.fill,
                                                imageUrl:
                                                    userProductListController
                                                        .categoriesResponseModel
                                                        .value
                                                        .categories?[index]
                                                        .icon,
                                              ),

                                              SpaceHelperWidget.v(6.h(context)),

                                              TextHelperClass.headingTextWithoutWidth(
                                                context: context,
                                                text: userProductListController
                                                    .categoriesResponseModel
                                                    .value
                                                    .categories?[index]
                                                    .name,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                textColor: ColorUtils.black29,
                                                textAlign: TextAlign.center,
                                                alignment: Alignment.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                height: 120.h(context),
                                width: 428.w(context),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                              ),

                        SpaceHelperWidget.v(20.h(context)),
                      ],
                    ),
                  ),
                ),

                if (userProductListController.products != [] &&
                    userProductListController.products.isNotEmpty == true) ...[
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                    sliver: SliverFillRemaining(
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, int index) {
                                final product =
                                    userProductListController.products[index];
                                final price = _toDouble(product.price);
                                final discount =
                                    _toDouble(product.discount) ?? 0.0;
                                final discountedPrice =
                                    price == null
                                        ? null
                                        : discount > 0
                                        ? price - ((price * discount) / 100)
                                        : price;

                                return TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () async {
                                    Get.to(
                                      () => SingleProductViewScreen(
                                        productId: userProductListController
                                            .products[index]
                                            .sId,
                                        isSingleStoreScreen: false,
                                        isHomeScreen: false,
                                        storeId: '',
                                        isProductListPage: true,
                                        isExplorePage: false,
                                        isStoreScreen: false,
                                      ),
                                      duration: Duration(milliseconds: 100),
                                      preventDuplicates: false,
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: 10.bpm(context),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        15.r(context),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                            0.1,
                                          ), // Subtle shadow for elevation
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: Offset(
                                            0,
                                            2,
                                          ), // Slight shadow for depth
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Top image with discount badge on the top-right corner
                                        Stack(
                                          children: [
                                            product.images?.isEmpty == true
                                                ? Container(
                                                    height: 180.h(context),
                                                    width: 428.w(context),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          ImageUtils.carousel1,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  15.r(
                                                                    context,
                                                                  ),
                                                                ),
                                                          ),
                                                      color: Color.fromRGBO(
                                                        175,
                                                        175,
                                                        175,
                                                        1,
                                                      ),
                                                    ),
                                                  )
                                                : ImageHelperWidget.styledImage(
                                                    context: context,
                                                    height: 250.h(context),
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    topLeftRadius: 15,
                                                    topRightRadius: 15,
                                                    bottomLeftRadius: 0,
                                                    bottomRightRadius: 0,
                                                    imageUrl:
                                                        product.images?.first,
                                                    errorWidget: Container(
                                                      height: 140.h(context),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                            ImageUtils
                                                                .carousel1,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                              top:
                                                                  Radius.circular(
                                                                    15.r(
                                                                      context,
                                                                    ),
                                                                  ),
                                                            ),
                                                        color: Color.fromRGBO(
                                                          175,
                                                          175,
                                                          175,
                                                          1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            if (price != null && discount > 0)
                                              Positioned(
                                                top: 12.h(context),
                                                right: 12.w(context),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 14.w(context),
                                                    vertical: 8.h(context),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils
                                                        .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.r(context),
                                                        ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    "${_formatPrice(discount)}% OFF",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp(context),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                        // Padding around the text and details
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.hpm(context),
                                            vertical: 8.vpm(context),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Title
                                              TextHelperClass.headingTextWithoutWidth(
                                                context: context,
                                                text:
                                                    userProductListController
                                                        .products[index]
                                                        .name ??
                                                    "N/A",
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                                textColor: ColorUtils.black29,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                alignment: Alignment.centerLeft,
                                                textOverFlow:
                                                    TextOverflow.ellipsis,
                                              ),

                                              SpaceHelperWidget.v(5.h(context)),

                                              TextHelperClass.headingTextWithoutWidth(
                                                context: context,
                                                text:
                                                    userProductListController
                                                        .products[index]
                                                        .description ??
                                                    "N/A",
                                                fontSize: 16,
                                                maxLines: 3,
                                                fontWeight: FontWeight.w700,
                                                textColor: ColorUtils.black76,
                                                textAlign: TextAlign.start,
                                                alignment: Alignment.centerLeft,
                                                textOverFlow:
                                                    TextOverflow.ellipsis,
                                              ),

                                              SpaceHelperWidget.v(
                                                10.h(context),
                                              ),

                                              // Bottom section with icons, labels, and price
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Icons with labels (Time estimate and rating)
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        // Time icon and label
                                                        Icon(
                                                          Icons.ac_unit,
                                                          size: 16.r(context),
                                                          color: ColorUtils
                                                              .yellow136,
                                                        ),

                                                        SpaceHelperWidget.h(
                                                          6.w(context),
                                                        ),

                                                        TextHelperClass.headingTextWithoutWidth(
                                                          context: context,
                                                          text:
                                                              userProductListController
                                                                      .products[index]
                                                                      .quantity !=
                                                                  null
                                                              ? "${userProductListController.products[index].quantity} pics"
                                                              : "N/A",
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          textColor: ColorUtils
                                                              .black76,
                                                          textAlign:
                                                              TextAlign.start,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                        ),

                                                        SpaceHelperWidget.h(
                                                          10.w(context),
                                                        ),

                                                        // Rating icon and label
                                                        Icon(
                                                          Icons.star,
                                                          size: 16.r(context),
                                                          color: ColorUtils
                                                              .yellow136,
                                                        ),
                                                        SpaceHelperWidget.h(
                                                          6.w(context),
                                                        ),

                                                        TextHelperClass.headingTextWithoutWidth(
                                                          context: context,
                                                          text:
                                                              userProductListController
                                                                      .products[index]
                                                                      .ratings !=
                                                                  null
                                                              ? "${userProductListController.products[index].ratings}"
                                                              : "N/A",
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          textColor: ColorUtils
                                                              .black76,
                                                          textAlign:
                                                              TextAlign.start,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      if (price != null &&
                                                          discount > 0)
                                                        Text(
                                                          "\$${_formatPrice(price)}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .grey
                                                                .shade600,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                        ),
                                                      SpaceHelperWidget.v(
                                                        2.h(context),
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
                                                            TextAlign.end,
                                                        alignment: Alignment
                                                            .centerRight,
                                                      ),
                                                    ],
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
                              childCount:
                                  userProductListController.products.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (userProductListController.products == [] ||
                    userProductListController.products.isEmpty == true) ...[
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                    sliver: SliverFillRemaining(
                      child: TextHelperClass.headingTextWithoutWidth(
                        context: context,
                        text: "No Product Available",
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        textColor: ColorUtils.black29,
                        textAlign: TextAlign.center,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ] else ...[
                  SliverFillRemaining(child: SizedBox.shrink()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
