import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/users/chat_view/controller/chat_controller.dart';
import 'package:discount_me_app/view/users/chat_view/view/user_chat_screen.dart';
import '../../../../res/res.dart';
import '../../../view.dart';

class SingleStoreViewScreenWidget extends GetxController {

  Rx<ProductsResponseModel> productsResponseModel = ProductsResponseModel().obs;
  Rx<SingleStoreResponseModel> singleStoreResponseModel = SingleStoreResponseModel().obs;
  Rx<UserProfileResponseModel> userProfileResponseModel = UserProfileResponseModel().obs;
  RxBool isLoading = false.obs;
  RxBool isChatOpening = false.obs;

  final BuildContext context;
  final String storeId;

  SingleStoreViewScreenWidget({required this.context,required this.storeId});

  Rx<PageController> pageController = PageController(initialPage: 0).obs; // Start at the first page
  var currentPage = 0.obs;
  Timer? _timer;



  void onPageChanged(int page) {
    currentPage.value = page;
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

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Radius of the Earth in meters

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distanceInMeters = earthRadius * c; // Distance in meters
    double distanceInKilometers = distanceInMeters / 1000; // Convert to kilometers

    return distanceInKilometers;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }


  Future<double?> calculateDistanceFromCurrentLocation(double targetLat, double targetLon) async {
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double distance = calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      targetLat,
      targetLon,
    );
    return distance;
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

  Future<void> openSupportChat() async {
    final vendorId = _currentVendorId();
    if (vendorId.isEmpty) {
      MessageSnackBarWidget.errorSnackBarWidget(
        context: context,
        message: "Vendor not found",
      );
      return;
    }

    isChatOpening.value = true;
    final chatController = Get.put(ChatController());
    final conversation = await chatController.createConversation(vendorId);
    isChatOpening.value = false;

    if (conversation == null) {
      MessageSnackBarWidget.errorSnackBarWidget(
        context: context,
        message: chatController.errorMessage.value.isEmpty
            ? "Unable to start chat"
            : chatController.errorMessage.value,
      );
      return;
    }

    await chatController.openConversation(conversation);
    Get.to(
      () => UserChatScreen(conversation: conversation),
      preventDuplicates: false,
      duration: const Duration(milliseconds: 100),
    );
  }

  String _currentVendorId() {
    final storeVendorId = singleStoreResponseModel.value.data?.vendorId?.toString() ?? "";
    if (storeVendorId.isNotEmpty) return storeVendorId;

    final firstProductStore = productsResponseModel.value.data?.data?.isNotEmpty == true
        ? productsResponseModel.value.data!.data!.first.store
        : null;
    return _readId(firstProductStore) ?? "";
  }

  String? _readId(dynamic value) {
    if (value == null) return null;
    if (value is String) return null;
    if (value is Map) {
      return value['vendorId']?.toString() ??
          value['vendor_id']?.toString() ??
          value['ownerId']?.toString() ??
          value['owner_id']?.toString() ??
          _readId(value['vendor']) ??
          _readId(value['owner']);
    }
    return null;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await SingleStoreViewController.getSingleStoreViewApiService(
          storeId: storeId,
          onSuccess: (e) async {
            singleStoreResponseModel.value = SingleStoreResponseModel.fromJson(e);
            await SingleStoreViewController.getAllProductByStoreIdApiService(
                storeId: storeId,
                onSuccess: (e) {
                  productsResponseModel.value = ProductsResponseModel.fromJson(e);
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
          onExceptionFail: (e) {
            isLoading.value = false;
            CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
          },
      );
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
      await checkLocationPermission();
    });
  }


  Widget singleStoreViewScreenWidget({required BuildContext context,required bool isHomePage,required bool isStorePage}) {
    return Container(
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

                    CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),


                    Container(
                      height: 250.h(context),
                      width: 428.w(context),
                      child: singleStoreResponseModel.value.data?.coverImages != null ?
                      Column(
                        children: [
                          Expanded(
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
                          CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),
                          SmoothPageIndicator(
                            controller: pageController.value,
                            count: singleStoreResponseModel.value.data!.coverImages!.length,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                plainTextString: singleStoreResponseModel.value.data?.name ?? "N/A",
                                plainTextStringFontSize: 20.sp(context),
                                plainTextStringFontWeight: FontWeight.w700,
                                plainTextContainerAlignment: Alignment.centerLeft,
                                plainTextStringColor: ColorUtils.black29,
                                plainTextStringTextAlign: TextAlign.start,
                              ),

                              CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.grey, size: 16.r(context)),
                                  SizedBox(width: 5.w(context)),
                                  CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),
                                  singleStoreResponseModel.value.data?.location?.coordinates != null ?
                                  FutureBuilder(
                                      future: calculateDistanceFromCurrentLocation(singleStoreResponseModel.value.data!.location!.coordinates!.last,
                                          singleStoreResponseModel.value.data!.location!.coordinates!.first),
                                      builder: (context, snapshot) {
                                        return Row(
                                          children: [

                                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                              plainTextString: snapshot.data != null ? "${snapshot.data!.toInt()} km from Location" : "Location not found",
                                              plainTextStringFontSize: 14.sp(context),
                                              plainTextStringFontWeight: FontWeight.w600,
                                              plainTextContainerAlignment: Alignment.centerLeft,
                                              plainTextStringColor: ColorUtils.blackColor,
                                              plainTextStringTextAlign: TextAlign.start,
                                            ),
                                          ],
                                        );
                                      }
                                  ) :
                                  CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: "Location not found",
                                    plainTextStringFontSize: 14.sp(context),
                                    plainTextStringFontWeight: FontWeight.w600,
                                    plainTextContainerAlignment: Alignment.centerLeft,
                                    plainTextStringColor: ColorUtils.blackColor,
                                    plainTextStringTextAlign: TextAlign.start,
                                  ),
                                ],
                              )

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
                                  Get.to(()=>StorePositionScreenPage(
                                    long: singleStoreResponseModel.value.data!.location!.coordinates!.first,
                                    lat: singleStoreResponseModel.value.data!.location!.coordinates!.last,
                                    storeId: storeId,
                                    isHomePage: isHomePage,
                                    isStoreListPage: isStorePage,
                                    isVendorHomePage: false,
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
                      plainTextString: singleStoreResponseModel.value.data?.description != null ?
                      "${singleStoreResponseModel.value.data?.description}" : "N/A",
                      plainTextStringFontSize: 18.sp(context),
                      plainTextStringFontWeight: FontWeight.w500,
                      plainTextContainerAlignment: Alignment.centerLeft,
                      plainTextStringColor: Colors.grey.shade700,
                      plainTextStringTextAlign: TextAlign.start,
                    ),


                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Products",
                          plainTextStringFontSize: 22.sp(context),
                          plainTextStringFontWeight: FontWeight.w700,
                          plainTextContainerAlignment: Alignment.centerLeft,
                          plainTextStringColor: ColorUtils.black29,
                          plainTextStringTextAlign: TextAlign.start,
                        ),

                        Container(
                          height: 30.h(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.hpm(context),
                            vertical: 5.vpm(context),
                          ),
                          decoration: BoxDecoration(
                            color: ColorUtils.greenLightHover,
                            borderRadius: BorderRadius.circular(50.r(context)),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {
                              Get.to(()=>UserProductListView(categoryId: "",storeId: storeId,),preventDuplicates: false,duration: Duration(milliseconds: 100));
                            },
                            child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "See all",
                              plainTextStringFontSize: 14.sp(context),
                              plainTextStringFontWeight: FontWeight.w400,
                              plainTextContainerAlignment: Alignment.center,
                              plainTextStringColor: ColorUtils.primaryColor,
                              plainTextStringTextAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),

                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                    productsResponseModel.value.data?.data != null && productsResponseModel.value.data?.data?.isNotEmpty == true ?
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: productsResponseModel.value.data?.data?.length,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.sizeOf(context).width < 600.w(context) ? 2 : 3, // Responsive columns
                        mainAxisSpacing: 10.h(context),
                        crossAxisSpacing: 10.w(context),
                        childAspectRatio: (MediaQuery.sizeOf(context).width / 2) / (MediaQuery.sizeOf(context).height * 0.35), // Adjust child aspect ratio dynamically
                      ),
                      itemBuilder: (context, index) {
                        return TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () async {
                            Get.to(SingleProductViewScreen(
                              productId: productsResponseModel.value.data!.data![index].sId,
                              isHomeScreen: false,
                              isSingleStoreScreen: true,
                              storeId: storeId,
                              isProductListPage: false,
                              isExplorePage: false,
                              isStoreScreen: false,
                            ),duration: Duration(milliseconds: 100),preventDuplicates: false);
                          },
                          child: Container(
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
                                productsResponseModel.value.data!.data![index].images?.isEmpty == true ?
                                Container(
                                  height: 174.h(context), // Responsive height
                                  width: double.infinity,
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
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.r(context))), // Responsive border radius
                                  child: Image.network(
                                    productsResponseModel.value.data!.data![index].images!.first, // Replace with your image path
                                    height: 174.h(context), // Responsive height
                                    width: double.infinity, // Full width
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      return Container(
                                        height: 174.h(context), // Responsive height
                                        width: double.infinity,
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
                                        plainTextString: productsResponseModel.value.data?.data?[index].name != null ?
                                        "${productsResponseModel.value.data!.data![index].name.toString().length > 10 ?
                                        productsResponseModel.value.data!.data![index].name.toString().substring(0,10) :
                                        productsResponseModel.value.data!.data![index].name.toString()}...." : "N/A",
                                        plainTextStringFontSize: 18.sp(context),
                                        plainTextStringFontWeight: FontWeight.w700,
                                        plainTextContainerAlignment: Alignment.centerLeft,
                                        plainTextStringColor: ColorUtils.black29,
                                        plainTextStringTextAlign: TextAlign.start,
                                      ),

                                      CustomSpaceWidget.spacerWidget(spaceHeight: 5.h(context)),

                                      CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                        plainTextString: productsResponseModel.value.data?.data?[index].description != null ?
                                        "${productsResponseModel.value.data!.data![index].description.toString().length > 20 ?
                                        productsResponseModel.value.data!.data![index].description.toString().substring(0,20) :
                                        productsResponseModel.value.data!.data![index].description.toString()}...." : "N/A",
                                        plainTextStringFontSize: 14.sp(context),
                                        plainTextStringFontWeight: FontWeight.w700,
                                        plainTextContainerAlignment: Alignment.centerLeft,
                                        plainTextStringColor: Colors.grey.shade600,
                                        plainTextStringTextAlign: TextAlign.start,
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
                                                Icon(Icons.ac_unit, size: 16.r(context), color: Colors.orange),
                                                SizedBox(width: 4.w(context)),
                                                CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                                  plainTextString: productsResponseModel.value.data?.data?[index].quantity != null ?
                                                  "${productsResponseModel.value.data?.data?[index].quantity} pics" : "N/A",
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
                    productsResponseModel.value.data?.data != null && productsResponseModel.value.data?.data?.isEmpty == true ?
                    CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                      plainTextString: "No Product Available",
                      plainTextStringFontSize: 22.sp(context),
                      plainTextStringFontWeight: FontWeight.w700,
                      plainTextContainerAlignment: Alignment.center,
                      plainTextStringColor: ColorUtils.black29,
                      plainTextStringTextAlign: TextAlign.center,
                    ):
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

Widget _buildScalingTransition(String image, int index) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0.8, end: 1.0), // Scaling from 50% to 100%
    duration: const Duration(milliseconds: 600),
    builder: (context, double scale, child) {
      return Transform.scale(
        scale: scale, // Scale the image
        child: Image.network(
          image,
          scale: 10,
          fit: BoxFit.fill,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Container(
              height: 180.h(context),
              width: 90.w(context),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageUtils.carousel1),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(5.r(context)),
                color: Color.fromRGBO(175, 175, 175, 1),
              ),
            );
          },
        ),
      );
    },
  );
}
