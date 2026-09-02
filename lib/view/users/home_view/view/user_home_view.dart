import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({super.key});

  double? _toDouble(dynamic value) => double.tryParse(value?.toString() ?? '');

  String _formatPrice(double value) =>
      value.toStringAsFixed(value % 1 == 0 ? 0 : 2);

  @override
  Widget build(BuildContext context) {
    final UserHomeController userHomeController = Get.put(
      UserHomeController(context: context),
    );

    void openSearch() {
      Get.to(
        () => UserProductListView(categoryId: "", storeId: ""),
        preventDuplicates: false,
        duration: const Duration(milliseconds: 100),
      );
    }

    return Scaffold(
      body: Container(
        height: 926.h(context),
        width: 428.w(context),
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
            enabled: userHomeController.isLoading.value,
            child: RefreshIndicator(
              onRefresh: () async {
                Get.to(
                  () => UserDashboardView(index: 0),
                  duration: const Duration(milliseconds: 100),
                  preventDuplicates: false,
                );
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.hpm(context),
                        vertical: 16.vpm(context),
                      ),
                      child: Column(
                        children: [
                          SpaceHelperWidget.v(40.h(context)),

                          // App Bar
                          Container(
                            width: 428.w(context), 
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      ImageHelperWidget.circleImageHelperWidget(
                                        width: 40,
                                        height: 40,
                                        verticalPadding: 1,
                                        horizontalPadding: 1,
                                        backgroundColor: ColorUtils.orange213,
                                        radius: 25,
                                        context: context,
                                        imageAsset:
                                            userHomeController
                                                    .userProfileResponseModel
                                                    .value
                                                    .data
                                                    ?.image ==
                                                null
                                            ? ImageUtils.noImage
                                            : null,
                                        imageUrl: userHomeController
                                            .userProfileResponseModel
                                            .value
                                            .data
                                            ?.image,
                                      ),

                                      SpaceHelperWidget.h(10.w(context)),

                                      // ImageHelperWidget.assetImageWidget(
                                      //   context: context,
                                      //   height: 24.h(context),
                                      //   width: 24.w(context),
                                      //   imageString: ImageUtils.locationImage,
                                      // ),

                                      // SpaceHelperWidget.h(5.w(context)),
                                      Expanded(
                                        child:
                                            TextHelperClass.headingTextWithoutWidth(
                                              context: context,
                                              text:
                                                  userHomeController
                                                      .userProfileResponseModel
                                                      .value
                                                      .data
                                                      ?.name ??
                                                  "N/A",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              alignment: Alignment.centerLeft,
                                              textColor: ColorUtils.black29,
                                              textAlign: TextAlign.start,
                                            ),
                                      ),
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

                          SpaceHelperWidget.v(15.h(context)),

                          //======================Search Section================================
                          TextFormFieldWidget.build(
                            context: context,
                            hintText: "Search",
                            controller:
                                userHomeController.searchController.value,
                            keyboardType: TextInputType.emailAddress,
                            fillColor: ColorUtils.white253,
                            readOnly: true,
                            onTap: openSearch,
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

                          Container(
                            height: 250.h(context),
                            width: 428.w(context),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child:
                                userHomeController
                                            .getAllBannersResponseModel
                                            .value
                                            .data
                                            ?.isNotEmpty ==
                                        true ||
                                    userHomeController
                                            .getAllBannersResponseModel
                                            .value
                                            .data !=
                                        null
                                ? Column(
                                    children: [
                                      Expanded(
                                        child: PageView.builder(
                                          onPageChanged: (value) {
                                            userHomeController.onPageChanged(
                                              value,
                                            );
                                          },
                                          controller: userHomeController
                                              .pageController
                                              .value,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: userHomeController
                                              .imageList
                                              .length,
                                          itemBuilder: (context, index) {
                                            return _buildScalingTransition(
                                              image: userHomeController
                                                  .getAllBannersResponseModel
                                                  .value
                                                  .data?[index]
                                                  .image,
                                              index: index,
                                            );
                                          },
                                        ),
                                      ),
                                      SpaceHelperWidget.v(10.h(context)),
                                      SmoothPageIndicator(
                                        controller: userHomeController
                                            .pageController
                                            .value,
                                        count: userHomeController
                                            .getAllBannersResponseModel
                                            .value
                                            .data!
                                            .length,
                                        effect: ExpandingDotsEffect(
                                          activeDotColor: ColorUtils.black51,
                                          dotColor: ColorUtils.black51,
                                          dotHeight: 11.h(context),
                                          dotWidth: 11.w(context),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                          ),

                          SpaceHelperWidget.v(20.h(context)),

                          userHomeController
                                          .categoriesResponseModel
                                          .value
                                          .categories
                                          ?.isNotEmpty ==
                                      true ||
                                  userHomeController
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
                                    itemCount: userHomeController
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
                                            Get.to(
                                              () => UserProductListView(
                                                categoryId: userHomeController
                                                    .categoriesResponseModel
                                                    .value
                                                    .categories![index]
                                                    .sId,
                                                storeId: "",
                                              ),
                                              preventDuplicates: false,
                                              duration: Duration(
                                                milliseconds: 100,
                                              ),
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
                                              color: Colors
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
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                                  imageUrl: userHomeController
                                                      .categoriesResponseModel
                                                      .value
                                                      .categories?[index]
                                                      .icon,
                                                ),

                                                SpaceHelperWidget.v(
                                                  6.h(context),
                                                ),

                                                TextHelperClass.headingTextWithoutWidth(
                                                  context: context,
                                                  text: userHomeController
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
 
                          // Popular Recipes.......
                          SpaceHelperWidget.v(20.h(context)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                text: "Popular Products",
                                fontSize: 22, 
                                fontWeight: FontWeight.w700, 
                                textColor: ColorUtils.black29,
                                textAlign: TextAlign.start,
                                alignment: Alignment.centerLeft,
                              ), 

                              ButtonHelperWidget.customButtonWidget(
                                context: context,
                                onPressed: () async {
                                  Get.to(
                                    () => UserProductListView(
                                      categoryId: "",
                                      storeId: "",
                                    ),
                                    preventDuplicates: false,
                                    duration: Duration(milliseconds: 100),
                                  );
                                },
                                text: "See all",
                                padding: EdgeInsets.symmetric(
                                  vertical: 14.5.vpm(context),
                                ),
                                alignment: Alignment.centerRight,
                                fontSize: 18,
                                textColor: ColorUtils.primaryColor, 
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.transparent,
                              ),
                            ],
                          ),

                          SpaceHelperWidget.v(10.h(context)),

                          userHomeController
                                          .productsResponseModel
                                          .value
                                          .data
                                          ?.data
                                          ?.isNotEmpty ==
                                      true ||
                                  userHomeController
                                          .productsResponseModel
                                          .value
                                          .data
                                          ?.data !=
                                      null
                              ? Container(
                                  height: 290.h(context),
                                  width: 428.w(context),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: ListView.builder(
                                    itemCount: userHomeController
                                        .productsResponseModel
                                        .value
                                        .data
                                        ?.data
                                        ?.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final product =
                                          userHomeController
                                              .productsResponseModel
                                              .value
                                              .data
                                              ?.data?[index];
                                      final price = _toDouble(product?.price);
                                      final discount =
                                          _toDouble(product?.discount) ?? 0.0;
                                      final discountedPrice =
                                          price == null
                                              ? null
                                              : discount > 0
                                                  ? price -
                                                      ((price * discount) / 100)
                                                  : price;

                                      return Obx(
                                        () => Stack(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                Get.to(
                                                  SingleProductViewScreen(
                                                    productId: userHomeController
                                                        .productsResponseModel
                                                        .value
                                                        .data!
                                                        .data![index]
                                                        .sId,
                                                    isSingleStoreScreen: false,
                                                    isHomeScreen: true,
                                                    isProductListPage: false,
                                                    isExplorePage: false,
                                                    storeId: '',
                                                    isStoreScreen: false,
                                                  ),
                                                  duration: Duration(
                                                    milliseconds: 100,
                                                  ),
                                                  preventDuplicates: false,
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                              ),
                                              child: Container(
                                                width: 280.w(
                                                  context,
                                                ), // Adjust width based on your requirement
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 5.vpm(context),
                                                  horizontal: 5.hpm(context),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        15.r(context),
                                                      ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
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
                                                        product?.images
                                                                    ?.isEmpty ==
                                                                true
                                                            ? Container(
                                                                height: 140.h(
                                                                  context,
                                                                ),
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        AssetImage(
                                                                      ImageUtils
                                                                          .carousel1,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                      15.r(
                                                                        context,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  color: Color
                                                                      .fromRGBO(
                                                                    175,
                                                                    175,
                                                                    175,
                                                                    1,
                                                                  ),
                                                                ),
                                                              )
                                                            : ImageHelperWidget
                                                                .styledImage(
                                                                context:
                                                                    context,
                                                                height: 140,
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                                topLeftRadius:
                                                                    15,
                                                                topRightRadius:
                                                                    15,
                                                                bottomLeftRadius:
                                                                    0,
                                                                bottomRightRadius:
                                                                    0,
                                                                imageUrl:
                                                                    product
                                                                        ?.images
                                                                        ?.first,
                                                                errorWidget:
                                                                    Container(
                                                                  height: 140.h(
                                                                    context,
                                                                  ),
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                        ImageUtils
                                                                            .carousel1,
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                        15.r(
                                                                          context,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                      175,
                                                                      175,
                                                                      175,
                                                                      1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                        if (price != null &&
                                                            discount > 0)
                                                          Positioned(
                                                            top: 12.h(context),
                                                            right: 12.w(context),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                horizontal: 14.w(
                                                                  context,
                                                                ),
                                                                vertical: 8.h(
                                                                  context,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ColorUtils
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                  12.r(
                                                                    context,
                                                                  ),
                                                                ),
                                                                boxShadow: const [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    blurRadius:
                                                                        6,
                                                                    offset:
                                                                        Offset(
                                                                      0,
                                                                      2,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Text(
                                                                "${_formatPrice(discount)}% OFF",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14.sp(
                                                                    context,
                                                                  ),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),

                                                    // Padding around the text and details
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10.hpm(
                                                              context,
                                                            ),
                                                            vertical: 8.vpm(
                                                              context,
                                                            ),
                                                          ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Title
                                                          TextHelperClass.headingTextWithoutWidth(
                                                            context: context,
                                                            text:
                                                                userHomeController
                                                                    .productsResponseModel
                                                                    .value
                                                                    .data
                                                                    ?.data?[index]
                                                                    .name ??
                                                                "N/A",
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            textColor:
                                                                ColorUtils
                                                                    .black29,
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 1,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            textOverFlow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),

                                                          SpaceHelperWidget.v(
                                                            5.h(context),
                                                          ),

                                                          TextHelperClass.headingTextWithoutWidth(
                                                            context: context,
                                                            text:
                                                                userHomeController
                                                                    .productsResponseModel
                                                                    .value
                                                                    .data
                                                                    ?.data?[index]
                                                                    .description ??
                                                                "N/A",
                                                            fontSize: 18.sp(context),
                                                            maxLines: 2,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            textColor:
                                                                ColorUtils
                                                                    .black76,
                                                            textAlign:
                                                                TextAlign.start,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            textOverFlow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                                      Icons
                                                                          .ac_unit,
                                                                      size: 16.r(
                                                                        context,
                                                                      ),
                                                                      color: ColorUtils
                                                                          .yellow136,
                                                                    ),

                                                                    SpaceHelperWidget.h(
                                                                      6.w(
                                                                        context,
                                                                      ),
                                                                    ),

                                                                    TextHelperClass.headingTextWithoutWidth(
                                                                      context:
                                                                          context,
                                                                      text:
                                                                          userHomeController.productsResponseModel.value.data?.data?[index].quantity !=
                                                                              null
                                                                          ? "${userHomeController.productsResponseModel.value.data?.data?[index].quantity} pics"
                                                                          : "N/A",
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      textColor:
                                                                          ColorUtils
                                                                              .black76,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                    ),

                                                                    SpaceHelperWidget.h(
                                                                      10.w(
                                                                        context,
                                                                      ),
                                                                    ),

                                                                    // Rating icon and label
                                                                    Icon(
                                                                      Icons
                                                                          .star,
                                                                      size: 16.r(
                                                                        context,
                                                                      ),
                                                                      color: ColorUtils
                                                                          .yellow136,
                                                                    ),
                                                                    SpaceHelperWidget.h(
                                                                      6.w(
                                                                        context,
                                                                      ),
                                                                    ),

                                                                    TextHelperClass.headingTextWithoutWidth(
                                                                      context:
                                                                          context,
                                                                      text:
                                                                          userHomeController.productsResponseModel.value.data?.data?[index].ratings !=
                                                                              null
                                                                          ? "${userHomeController.productsResponseModel.value.data?.data?[index].ratings}"
                                                                          : "N/A",
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      textColor:
                                                                          ColorUtils
                                                                              .black76,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  if (price !=
                                                                          null &&
                                                                      discount >
                                                                          0)
                                                                    Text(
                                                                      "\$${_formatPrice(price)}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color:
                                                                            Colors.grey.shade600,
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
                                                                      ),
                                                                    ),
                                                                  SpaceHelperWidget.v(
                                                                    2.h(
                                                                      context,
                                                                    ),
                                                                  ),
                                                                  TextHelperClass.headingTextWithoutWidth(
                                                                    context:
                                                                        context,
                                                                    text:
                                                                        discountedPrice !=
                                                                                null
                                                                            ? "\$${_formatPrice(discountedPrice)}"
                                                                            : "N/A",
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    textColor:
                                                                        ColorUtils
                                                                            .black29,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    alignment:
                                                                        Alignment
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
                                            ),

                                            Positioned(
                                              top: 100.h(context),
                                              left: 10.w(context),
                                              child:
                                                  userHomeController
                                                              .selectProductId
                                                              .value ==
                                                          userHomeController
                                                              .productsResponseModel
                                                              .value
                                                              .data
                                                              ?.data?[index]
                                                              .sId &&
                                                      userHomeController
                                                              .isAdd
                                                              .value ==
                                                          true
                                                  ? LoadingHelperWidget.loadingHelperWithoutHeightWidget(
                                                      context: context,
                                                    )
                                                  : ButtonHelperWidget.customButtonWidget(
                                                      height: 40,
                                                      context: context,
                                                      onPressed: () async {
                                                        userHomeController
                                                                .selectProductId
                                                                .value =
                                                            userHomeController
                                                                .productsResponseModel
                                                                .value
                                                                .data
                                                                ?.data?[index]
                                                                .sId;
                                                        userHomeController
                                                                .isAdd
                                                                .value =
                                                            true;
                                                        Map<String, dynamic>
                                                        data = {
                                                          "product":
                                                              userHomeController
                                                                  .productsResponseModel
                                                                  .value
                                                                  .data
                                                                  ?.data?[index]
                                                                  .sId,
                                                          "quantity": 1,
                                                        };
                                                        print(data);
                                                        await userHomeController
                                                            .addProductToCartResponse(
                                                              data: data,
                                                              context: context,
                                                            );
                                                      },
                                                      text: "Add To Cart",
                                                      textColor:
                                                          ColorUtils.black29,
                                                      alignment:
                                                          Alignment.center,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      backgroundColor:
                                                          ColorUtils.white246,
                                                      borderRadius: 12,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 15.hpm(
                                                              context,
                                                            ),
                                                          ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  height: 320.h(context),
                                  width: 428.w(context),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),

                          // Popular resturant.......
                          SpaceHelperWidget.v(20.h(context)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                text: "Popular Stores",
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                textColor: ColorUtils.black29, 
                                textAlign: TextAlign.start,
                                alignment: Alignment.centerLeft, 
                              ),

                              ButtonHelperWidget.customButtonWidget(
                                context: context, 
                                onPressed: () async {
                                  Get.to(
                                    () => StoreListViewScreen(),
                                    preventDuplicates: false,
                                    duration: Duration(milliseconds: 100),
                                  );
                                },
                                text: "See all",
                                padding: EdgeInsets.symmetric(
                                  vertical: 14.5.vpm(context),
                                ),
                                alignment: Alignment.centerRight,
                                fontSize: 18,
                                textColor: ColorUtils.primaryColor,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.transparent,
                              ),
                            ],
                          ),

                          userHomeController
                                          .storesResponseModel
                                          .value
                                          .data
                                          ?.data
                                          ?.isNotEmpty ==
                                      true ||
                                  userHomeController
                                          .storesResponseModel
                                          .value
                                          .data
                                          ?.data !=
                                      null
                              ? Container(
                                  height: 200.h(context),
                                  width: 428.w(context),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: userHomeController
                                        .storesResponseModel
                                        .value
                                        .data
                                        ?.data
                                        ?.length,
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                          left: 10.lpm(context),
                                          right: 2.rpm(context),
                                          top: 10.tpm(context),
                                          bottom: 10.bpm(context),
                                        ),
                                        child: TextButton(
                                          onPressed: () async {
                                            Get.to(
                                              () => SingleStoreViewScreen(
                                                storeId: userHomeController
                                                    .storesResponseModel
                                                    .value
                                                    .data! 
                                                    .data![index]
                                                    .sId,
                                                isHomePage: true,
                                                isStoreListPage: false,
                                              ),
                                              preventDuplicates: false,
                                              duration: Duration(
                                                milliseconds: 100,
                                              ),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: Container(
                                            width: 310.w(context),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.vpm(context),
                                              horizontal: 10.hpm(context),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    4.r(context),
                                                  ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  spreadRadius: 0,
                                                  blurRadius: 10,
                                                  offset: const Offset(
                                                    0,
                                                    2,
                                                  ), // Shadow position
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Restaurant Image
                                                ImageHelperWidget.styledImage(
                                                  context: context,
                                                  height: 180,
                                                  width: 90,
                                                  fit: BoxFit.cover,
                                                  borderRadius: 5,
                                                  imageUrl: userHomeController
                                                      .storesResponseModel
                                                      .value
                                                      .data!
                                                      .data![index]
                                                      .coverImages!
                                                      .first,
                                                  errorWidget: Container(
                                                    height: 180.h(context),
                                                    width: 90.w(context),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          ImageUtils.carousel1,
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  15.r(context),
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

                                                SpaceHelperWidget.h(
                                                  10.w(context),
                                                ),

                                                // Right Section
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      // Top Row with Restaurant Name and Rating
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          // Restaurant Name
                                                          Expanded(
                                                            child: TextHelperClass.headingTextWithoutWidth(
                                                              context: context,
                                                              text:
                                                                  userHomeController
                                                                      .storesResponseModel
                                                                      .value
                                                                      .data
                                                                      ?.data?[index]
                                                                      .name ??
                                                                  "",
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              textColor:
                                                                  ColorUtils
                                                                      .black29,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              maxLines: 1,
                                                              textOverFlow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),

                                                          SpaceHelperWidget.h(
                                                            5.w(context),
                                                          ),

                                                          // Rating
                                                          Row(
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: List.generate(5, (
                                                                  Index,
                                                                ) {
                                                                  // Calculate the fill amount for each star
                                                                  double
                                                                  starValue =
                                                                      double.parse(
                                                                        userHomeController
                                                                            .storesResponseModel
                                                                            .value
                                                                            .data!
                                                                            .data![index]
                                                                            .ratings
                                                                            .toString(),
                                                                      ) -
                                                                      Index;
                                                                  bool
                                                                  isFilled =
                                                                      starValue >=
                                                                      1.0;
                                                                  bool
                                                                  isHalfFilled =
                                                                      starValue >
                                                                          0.0 &&
                                                                      starValue <
                                                                          1.0;

                                                                  return Icon(
                                                                    isFilled
                                                                        ? Icons
                                                                              .star
                                                                        : isHalfFilled
                                                                        ? Icons
                                                                              .star_half
                                                                        : Icons
                                                                              .star_border,
                                                                    size: 14.r(
                                                                      context,
                                                                    ),
                                                                    color:
                                                                        isFilled ||
                                                                            isHalfFilled
                                                                        ? Colors
                                                                              .amber
                                                                        : Colors
                                                                              .grey
                                                                              .shade600,
                                                                  );
                                                                }),
                                                              ),

                                                              SpaceHelperWidget.h(
                                                                5.w(context),
                                                              ),

                                                              TextHelperClass.headingTextWithoutWidth(
                                                                context:
                                                                    context,
                                                                text: userHomeController
                                                                    .storesResponseModel
                                                                    .value
                                                                    .data!
                                                                    .data![index]
                                                                    .ratings
                                                                    .toStringAsFixed(
                                                                      1,
                                                                    )
                                                                    .toString(),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                textColor:
                                                                    ColorUtils
                                                                        .black29,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                      SpaceHelperWidget.v(
                                                        6.h(context),
                                                      ),

                                                      Expanded(
                                                        child: TextHelperClass.headingTextWithoutWidth(
                                                          context: context,
                                                          text:
                                                              userHomeController
                                                                  .storesResponseModel
                                                                  .value
                                                                  .data
                                                                  ?.data?[index]
                                                                  .description ??
                                                              "",
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          textColor: ColorUtils
                                                              .blackColor,
                                                          textAlign:
                                                              TextAlign.start,
                                                          alignment: Alignment
                                                              .topLeft,
                                                          maxLines: 3,
                                                          textOverFlow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      ),

                                                      SpaceHelperWidget.v(
                                                        6.h(context),
                                                      ),

                                                      // Location
                                                      FutureBuilder(
                                                        future: userHomeController
                                                            .getAddressFromLatLng(
                                                              userHomeController
                                                                  .storesResponseModel
                                                                  .value
                                                                  .data!
                                                                  .data![index]
                                                                  .location!
                                                                  .coordinates!
                                                                  .last,
                                                              userHomeController
                                                                  .storesResponseModel
                                                                  .value
                                                                  .data!
                                                                  .data![index]
                                                                  .location!
                                                                  .coordinates!
                                                                  .first,
                                                            ),
                                                        builder: (context, snapshot) {
                                                          return Row(
                                                            children: [
                                                              ImageHelperWidget.assetImageWidget(
                                                                context:
                                                                    context,
                                                                height: 24.h(
                                                                  context,
                                                                ),
                                                                width: 24.w(
                                                                  context,
                                                                ),
                                                                imageString:
                                                                    ImageUtils
                                                                        .locationImage,
                                                              ),

                                                              SpaceHelperWidget.h(
                                                                6.h(context),
                                                              ),

                                                              Expanded(
                                                                child: TextHelperClass.headingTextWithoutWidth(
                                                                  context:
                                                                      context,
                                                                  text:
                                                                      "${snapshot.data}",
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  textColor:
                                                                      ColorUtils
                                                                          .blackColor,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  maxLines: 1,
                                                                  textOverFlow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
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
                                  height: 156.h(context),
                                  width: 428.w(context),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),

                          SpaceHelperWidget.v(56.h(context)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScalingTransition({required String image, required int index}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0), // Scaling from 50% to 100%
      duration: const Duration(milliseconds: 600),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale, // Scale the image
          child: ImageHelperWidget.styledImage(
            context: context,
            height: 250,
            width: 428,
            fit: BoxFit.fill,
            borderRadius: 10,
            imageUrl: image,
            errorWidget: Container(
              height: 250.h(context),
              width: 428.w(context),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageUtils.carousel1),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15.r(context)),
                ),
                color: Color.fromRGBO(175, 175, 175, 1),
              ),
            ),
          ),
        );
      },
    );
  }
}
