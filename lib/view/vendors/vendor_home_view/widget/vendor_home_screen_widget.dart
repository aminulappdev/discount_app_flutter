import 'dart:async';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/view/vendors/vendor_profile_view/model/vendor_profile_response_model.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../res/common_widget/RoundButton.dart';
import '../../vendor_earning_view/view/vendor_earning_home_screen.dart';
import '../../vendor_subscription_view/view/vendor_subscription_view.dart';
import '../view/vendor_order_manage_screen.dart';

class VendorHomeScreenWidget extends GetxController {


  Rx<ProductsResponseModel> productsResponseModel = ProductsResponseModel().obs;
  Rx<SingleStoreResponseModel> singleStoreResponseModel = SingleStoreResponseModel().obs;
  Rx<VendorProfileResponseModel> vendorProfileResponseModel = VendorProfileResponseModel().obs;
  RxBool isLoading = false.obs;

  final BuildContext context;

  VendorHomeScreenWidget({required this.context});

  Rx<PageController> pageController = PageController(initialPage: 0).obs; // Start at the first page
  var currentPage = 0.obs;
  Timer? _timer;
  RxString vendorAddress = "".obs;



  void onPageChanged(int page) {
    currentPage.value = page;
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    print("call");
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      vendorAddress.value = "${place.street}, ${place.locality}, ${place.subAdministrativeArea},${place.administrativeArea}, ${place.country}";
    } catch (e) {
      print("Place in not found");
    }
  }

  Future<void> startAutoPlay() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage.value < 2) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }
      if (pageController.value.hasClients) {
        pageController.value.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 350),
          curve: Curves.linearToEaseOut, // Swapping-like effect
        );
      }
    });
  }

  Future<void> determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude);
    print(position.latitude);
  }



  Future<void> checkLocationPermission() async {
    Future.delayed(const Duration(milliseconds: 500),() async {
      LocationPermission permission;
      var checkPermission = await Geolocator.checkPermission();
      permission = await Geolocator.requestPermission();
      print(permission);
      if(permission == LocationPermission.denied){
        await checkLocationPermission();
      }else if(permission == LocationPermission.deniedForever){
        CustomSnackBar().errorCustomSnackBar(context: context, message: "Location Permission need.Please go to app setting or unInstall the app");
      }else {
        await determinePosition();
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await VendorProfileDetailsController.getVendorProfileApiService(
        onSuccess: (e) async {
          vendorProfileResponseModel.value = VendorProfileResponseModel.fromJson(e);
          await SingleStoreViewController.getSingleStoreViewApiService(
            storeId: vendorProfileResponseModel.value.data?.store?.sId ?? "",
            onSuccess: (e) async {
              isLoading.value = false;
              singleStoreResponseModel.value = SingleStoreResponseModel.fromJson(e);
              await checkLocationPermission();
              await _getAddressFromLatLng(singleStoreResponseModel.value.data?.location?.coordinates?.last ?? 0.0,
                  singleStoreResponseModel.value.data?.location?.coordinates?.first ?? 0.0);
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
        onFail: (e) {
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
        },
        onExceptionFail: (e) async {
          if(e == "jwt expired") {
            await AppLocalStorage.removeKey(key: "Login");
            await Get.off(()=>SignInView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
          }
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
        },
      );
    });
  }



  Widget vendorHomeScreenWidget({required BuildContext context}) {
    return Obx(()=>Container(
      height: 928.h(context),
      width: 428.w(context),
      decoration: BoxDecoration( 
          color: Colors.white
      ),
      child: Skeletonizer(
        effect: PulseEffect(),
        enabled: isLoading.value,
        child: RefreshIndicator(
          onRefresh: () async {
            Get.off(()=>VendorDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
          },
          child: CustomScrollView(
            slivers: [


              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.vpm(context),horizontal: 16.hpm(context)),
                  child: Column(
                    children: [


                      CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                // Container(
                                //   height: 35.h(context),
                                //   width: 35.w(context),
                                //   decoration: BoxDecoration(
                                //     color: Colors.transparent,
                                //   ),
                                //   child: IconButton(
                                //     padding: EdgeInsets.zero,
                                //     onPressed: () async {},
                                //     icon: Icon(Icons.menu,color: Colors.black,),
                                //     iconSize: 32.r(context),
                                //   ),
                                // ),

                                CustomSpaceWidget.spacerWidget(spaceWidth: 20.w(context)),

                                Icon(Icons.location_on, size: 32.r(context),),

                                CustomSpaceWidget.spacerWidget(spaceWidth: 5.w(context)),

                                Expanded(
                                  child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: vendorAddress.value,
                                    plainTextStringFontSize: 16.sp(context),
                                    plainTextStringFontWeight: FontWeight.w600,
                                    plainTextContainerAlignment: Alignment.centerLeft,
                                    plainTextStringColor: ColorUtils.blackColor,
                                    plainTextStringTextAlign: TextAlign.start,
                                  ),
                                ),

                              ],
                            ),
                          ),


                          Container(
                            height: 35.h(context),
                            width: 35.w(context),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {},
                              icon: Icon(Icons.notifications,color: ColorUtils.primaryColor,),
                              iconSize: 32.r(context),
                            ),
                          ),
                        ],
                      ),

                      CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),


                      Container(
                        height: 220.h(context),
                        width: 428.w(context),
                        decoration: BoxDecoration(
                          color: Colors.transparent
                        ),
                        child: singleStoreResponseModel.value.data?.coverImages != null ?
                        Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r(context)),
                                child: PageView.builder(
                                  onPageChanged: (value) {
                                    onPageChanged(value);
                                  },
                                  controller: pageController.value,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: singleStoreResponseModel.value.data!.coverImages!.length,
                                  itemBuilder: (context, index) {
                                    return _buildScalingTransition(singleStoreResponseModel.value.data!.coverImages![index], index);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ) :
                        CustomSpaceWidget.spacerWidget(),
                      ),

                      CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                  plainTextString: singleStoreResponseModel.value.data?.name ?? "N/A",
                                  plainTextStringFontSize: 20.sp(context),
                                  plainTextStringFontWeight: FontWeight.w700,
                                  plainTextContainerAlignment: Alignment.centerLeft,
                                  plainTextStringColor: ColorUtils.black29,
                                  plainTextStringTextAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [

                              singleStoreResponseModel.value.data?.ratings != null ? Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(5, (Index) {
                                      // Calculate the fill amount for each star
                                      double starValue = double.parse(singleStoreResponseModel.value.data!.ratings.toString()) - Index;
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
                                    plainTextString: singleStoreResponseModel.value.data!.ratings.toStringAsFixed(1).toString(),
                                    plainTextStringFontSize: 18.sp(context),
                                    plainTextStringFontWeight: FontWeight.w600,
                                    plainTextContainerAlignment: Alignment.center,
                                    plainTextStringColor: ColorUtils.black29,
                                    plainTextStringTextAlign: TextAlign.start,
                                  ),
                                ],
                              ) :  CustomSpaceWidget.spacerWidget(),

                              CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),
                              Container(
                                height: 16.h(context),
                                child: TextButton(
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  onPressed: () async {
                                    Get.off(()=>StorePositionScreenPage(
                                      long: singleStoreResponseModel.value.data!.location!.coordinates!.first,
                                      lat: singleStoreResponseModel.value.data!.location!.coordinates!.last,
                                      storeId: "",
                                      isHomePage: false,
                                      isStoreListPage: false,
                                      isVendorHomePage: true,
                                    ),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                  },
                                  child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: "View on Google Maps",
                                    plainTextStringFontSize: 12.sp(context),
                                    plainTextStringFontWeight: FontWeight.w600,
                                    plainTextContainerAlignment: Alignment.center,
                                    plainTextStringColor: ColorUtils.primaryColor,
                                    plainTextStringTextAlign: TextAlign.start,
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),

                      CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                      GridView(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.70,
                        ),
                        children: [

                          _itemWidget(
                            img: ImageUtils.itemAddBg,
                            title: "Items Add",
                            context: context,
                            onTap: () {
                              Get.off(()=>VendorAddItemScreen(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                            },),

                          _itemWidget(
                            img: ImageUtils.orderManageBg,
                            title: "Order Manage",
                            context: context,
                            onTap: () {
                              Get.to(()=>VendorOrderManageScreen());
                            },),

                          _itemWidget(
                            img: ImageUtils.subscriptionBg,
                            title: "Subscription",
                            context: context,
                            onTap: () {
                              Get.to(()=>VendorSubscriptionView());
                            },),

                          _itemWidget(
                            img: ImageUtils.paymentRevBg,
                            title: "Payment & Revenue",
                            context: context,
                            onTap: () {
                              Get.to(()=>VendorEaringHomeScreen());
                            },),


                        ],
                      ),




                    ],
                  ),
                ),
              )



            ],
          ),
        ),
      ),
    ));
  }



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


Widget _itemWidget({required String img, required String title, required VoidCallback onTap,required BuildContext context}){
  return Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r(context)),
        border: Border.all(color: Color(0xff8c8c8c)),
        boxShadow: [
          BoxShadow(
            color: Color(0xff000000).withOpacity(0.025),
            offset: Offset(0, 4.29),
            blurRadius: 4.29,
            spreadRadius: 0,
          )
        ]
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          child: Image.asset(
            img,
            fit: BoxFit.cover,
          ),
        ),
        Roundbutton(
          title: title,
          buttonColor: ColorUtils.secondaryColor,
          borderRadius: 5.r(context),
          fontSize: 16.sp(context),
          titleColor: Colors.white,
          onTap: onTap,
        )
      ],
    ),
  );
}