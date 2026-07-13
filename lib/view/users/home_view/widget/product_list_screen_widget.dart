import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:discount_me_app/utils/utils.dart';
import '../../../../res/res.dart';
import '../../../view.dart';

class ProductListScreenWidget extends GetxController {


  RxBool isLoading = false.obs;

  Rx<CategoriesResponseModel> categoriesResponseModel = CategoriesResponseModel().obs;
  Rx<ProductsResponseModel> productsResponseModel = ProductsResponseModel().obs;
  BuildContext context;
  String categoryId = "";
  String storeId = "";
  RxList<Products> products = <Products>[].obs;
  Rx<UserProfileResponseModel> userProfileResponseModel = UserProfileResponseModel().obs;
  ProductListScreenWidget({required this.context,required this.categoryId,required this.storeId});
  RxString updatedCategoryId = "".obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    updatedCategoryId.value = categoryId;
    Future.delayed(Duration(seconds: 1),() async {
      await ProductListViewController.getCategoriesApiService(
        onSuccess: (e) {
          categoriesResponseModel.value = CategoriesResponseModel.fromJson(e);
        },
        onFail: (e) {
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
        },
        onExceptionFail: (e) {
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
        },
      );
      if(categoryId == "" && storeId == "") {
        await ProductListViewController.getProductsApiService(
            onSuccess: (e) {
              productsResponseModel.value = ProductsResponseModel.fromJson(e);
              products.value = productsResponseModel.value.data!.data!;
            },
            onFail: (e) {
              isLoading.value = false;
              CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
            },
            onExceptionFail: (e) {
              isLoading.value = false;
              CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
            }
        );
      } else {
        if(categoryId != "") {
          await ProductListViewController.getProductsByCategoryApiService(
            categoryId: categoryId,
            onSuccess: (e) {
              productsResponseModel.value = ProductsResponseModel.fromJson(e);
              products.value = productsResponseModel.value.data!.data!;
            },
            onFail: (e) {
              isLoading.value = false;
              CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
            },
            onExceptionFail: (e) {
              isLoading.value = false;
              CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
            },
          );
        } else {
          await ProductListViewController.getProductsByStoreApiService(
            storeId: storeId,
            onSuccess: (e) {
              productsResponseModel.value = ProductsResponseModel.fromJson(e);
              products.value = productsResponseModel.value.data!.data!;
            },
            onFail: (e) {
              isLoading.value = false;
              CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
            },
            onExceptionFail: (e) {
              isLoading.value = false;
              CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
            },
          );
        }
      }
      await UserProfileController.getUserProfileApiService(
          onSuccess: (e) {
            isLoading.value = false;
            userProfileResponseModel.value = UserProfileResponseModel.fromJson(e);
          },
          onFail: (e) {
            isLoading.value = false;
            CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
          },
          onExceptionFail: (e) async {
            if(e == "jwt expired") {
              await AppLocalStorage.removeKey(key: "Login");
              Get.to(()=>SignInView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
            }
            isLoading.value = false;
            CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
          }
      );
    });
  }



  Widget productListScreenWidget({required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(ImageUtils.homeBg),
          alignment: Alignment.topRight,
          opacity: 0.5,
        ),
      ),
      child: Obx(()=>Skeletonizer(
        effect: PulseEffect(),
        enabled: isLoading.value,
        child: CustomScrollView(
          slivers: [

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                child: Column(
                  children: [

                    CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),


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

                                userProfileResponseModel.value.data?.image == null ?
                                Container(
                                  width: 45.w(context),
                                  height: 45.h(context),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.lightBlueAccent,
                                      image: DecorationImage(
                                        image: AssetImage(ImageUtils.homeProfileAvatar),
                                        fit: BoxFit.fitHeight,
                                      )
                                  ),
                                ) :
                                Container(
                                  width: 45.w(context),
                                  height: 45.h(context),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.lightBlueAccent,
                                      image: DecorationImage(
                                        image: NetworkImage(userProfileResponseModel.value.data!.image),
                                        fit: BoxFit.fitHeight,
                                      )
                                  ),
                                ),

                                CustomSpaceWidget.spacerWidget(spaceWidth: 20.w(context)),

                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      ImageUtils.discountMeLogo,
                                      scale: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [

                              Container(
                                width: 45.w(context),
                                height: 45.h(context),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorUtils.primaryColor,
                                    boxShadow: const [
                                      BoxShadow(color: ColorUtils.whiteColor,
                                          blurRadius: 10, offset: Offset(0, 1))
                                    ]
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  onPressed: () {
                                    Get.to(()=>UserNotificationView(),preventDuplicates: false,duration: const Duration(milliseconds: 100));
                                  },
                                  child: Icon(
                                    Icons.notifications,
                                    color: ColorUtils.whiteColor,
                                    size: 25.r(context),
                                  ),
                                ),
                              ),

                              CustomSpaceWidget.spacerWidget(spaceWidth: 6.w(context)),


                              Container(
                                width: 45.w(context),
                                height: 45.h(context),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorUtils.primaryColor,
                                    boxShadow: const [
                                      BoxShadow(color: ColorUtils.whiteColor,
                                          blurRadius: 10, offset: Offset(0, 2))
                                    ]
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  onPressed: () {
                                    Get.to(()=>CartView(),preventDuplicates: false,duration: const Duration(milliseconds: 100));
                                  },
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
                          updatedCategoryId.value = "";
                          await ProductListViewController.getProductsApiService(
                              onSuccess: (e) {
                                isLoading.value = false;
                                productsResponseModel.value = ProductsResponseModel.fromJson(e);
                                products.value = productsResponseModel.value.data!.data!;
                              },
                              onFail: (e) {
                                isLoading.value = false;
                                CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
                              },
                              onExceptionFail: (e) {
                                isLoading.value = false;
                                CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
                              }
                          );
                        },
                        onChanged: (search) async {
                          products.value = productsResponseModel.value.data!.data!.where((e)=>e.name.toString().contains(search)).toList();
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

                    categoriesResponseModel.value.categories?.isNotEmpty == true || categoriesResponseModel.value.categories != null ?
                    Container(
                      height: 120.h(context),
                      width: 428.w(context),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoriesResponseModel.value.categories?.length,
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
                                color: categoriesResponseModel.value.categories![index].sId == updatedCategoryId.value ? Colors.blueGrey : Colors.white, // Color of the container
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
                                products.value = [];
                                updatedCategoryId.value = categoriesResponseModel.value.categories![index].sId;
                                isLoading.value = true;
                                await ProductListViewController.getProductsByCategoryApiService(
                                  categoryId: categoriesResponseModel.value.categories![index].sId,
                                  onSuccess: (e) {
                                    isLoading.value = false;
                                    productsResponseModel.value = ProductsResponseModel.fromJson(e);
                                    products.value = productsResponseModel.value.data!.data!;
                                  },
                                  onFail: (e) {
                                    isLoading.value = false;
                                    CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
                                  },
                                  onExceptionFail: (e) {
                                    isLoading.value = false;
                                    CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
                                  },
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomImageContainer.networkImageContainer(
                                      height: 40.h(context),
                                      width: 40.w(context),
                                      networkImage: categoriesResponseModel.value.categories?[index].icon
                                  ),
                                  CustomSpaceWidget.spacerWidget(spaceHeight: 6.h(context)),
                                  CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: categoriesResponseModel.value.categories?[index].name,
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

                    products != [] && products.isNotEmpty == true ?
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () async {
                            Get.to(SingleProductViewScreen(
                              productId: products[index].sId,
                              isSingleStoreScreen: false,isHomeScreen: false,storeId: '',isProductListPage: true,isExplorePage: false,isStoreScreen: false,
                            ),duration: Duration(milliseconds: 100),preventDuplicates: false);
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
                                // Top Image with rounded corners
                                products[index].images?.isEmpty == true ?
                                Container(
                                  height: 180.h(context),
                                  width: 428.w(context),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(ImageUtils.carousel1),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15.r(context))),
                                    color: Color.fromRGBO(175, 175, 175, 1),
                                  ),
                                ) :
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.r(context))),
                                  child: Image.network(
                                    products[index].images!.first,
                                    height: 180.h(context), // Responsive height
                                    width: 428.w(context), // Full width
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      return Container(
                                        height: 180.h(context),
                                        width: 428.w(context),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(ImageUtils.carousel1),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(15.r(context))),
                                          color: Color.fromRGBO(175, 175, 175, 1),
                                        ),
                                      );
                                    },
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
                                        plainTextString: products[index].name ?? "N/A",
                                        plainTextStringFontSize: 22.sp(context),
                                        plainTextStringFontWeight: FontWeight.w700,
                                        plainTextContainerAlignment: Alignment.centerLeft,
                                        plainTextStringColor: ColorUtils.black29,
                                        plainTextStringTextAlign: TextAlign.start,
                                      ),

                                      CustomSpaceWidget.spacerWidget(spaceHeight: 5.h(context)),


                                      // Description
                                      CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                        plainTextString:  products[index].description != null ?
                                        "${products[index].description.toString().length > 50 ?
                                        products[index].description.toString().substring(0,50) :
                                        products[index].description.toString()}...." : "N/A",
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
                                                Icon(Icons.ac_unit, size: 16.r(context), color: Colors.orange),
                                                SizedBox(width: 4.w(context)),
                                                CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                                  plainTextString: products[index].quantity != null ?
                                                  "${products[index].quantity} pics" : "N/A",
                                                  plainTextStringFontSize: 14.sp(context),
                                                  plainTextStringFontWeight: FontWeight.w500,
                                                  plainTextContainerAlignment: Alignment.centerLeft,
                                                  plainTextStringColor: Colors.grey.shade700,
                                                  plainTextStringTextAlign: TextAlign.start,
                                                ),



                                                SizedBox(width: 10.w(context)),

                                                // Rating icon and label
                                                Icon(Icons.star, size: 16.r(context), color: Colors.orange),
                                                SizedBox(width: 4.w(context)),

                                                CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                                  plainTextString: productsResponseModel.value.data?.data?[index].ratings != null ?
                                                  "${productsResponseModel.value.data?.data?[index].ratings}" : "N/A",
                                                  plainTextStringFontSize: 14.sp(context),
                                                  plainTextStringFontWeight: FontWeight.w500,
                                                  plainTextContainerAlignment: Alignment.centerLeft,
                                                  plainTextStringColor: Colors.grey.shade700,
                                                  plainTextStringTextAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),


                                          CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                            plainTextString: productsResponseModel.value.data?.data?[index].price != null ?
                                            "${"\$"}${productsResponseModel.value.data!.data![index].price.toString()}" : "N/A",
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
                    products == [] || products.isEmpty == true ?
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
      )),
    );
  }


}