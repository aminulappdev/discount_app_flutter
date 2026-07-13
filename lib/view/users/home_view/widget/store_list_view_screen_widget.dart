import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../res/res.dart';
import '../../../view.dart';
import 'package:discount_me_app/utils/utils.dart';

class StoreListViewScreenWidget extends GetxController {
  Rx<StoresResponseModel> storesResponseModel = StoresResponseModel().obs;
  Rx<UserProfileResponseModel> userProfileResponseModel =
      UserProfileResponseModel().obs;
  
  RxBool isLoading = false.obs;
  BuildContext context;
  RxList<Stores> stores = <Stores>[].obs;
  StoreListViewScreenWidget({required this.context});
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;

  Future<void> determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    lat.value = position.latitude;
    long.value = position.longitude;
    print(lat.value);
    print(long.value);
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.subAdministrativeArea},${place.administrativeArea}, ${place.country}";
    } catch (e) {
      return "Place in not found";
    }
  }

  Future<void> checkLocationPermission() async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      LocationPermission permission;
      var checkPermission = await Geolocator.checkPermission();
      permission = await Geolocator.requestPermission();
      print(permission);
      if (permission == LocationPermission.denied) {
        await checkLocationPermission();
      } else if (permission == LocationPermission.deniedForever) {
        CustomSnackBar().errorCustomSnackBar(
          context: context,
          message:
              "Location Permission need.Please go to app setting or unInstall the app",
        );
      } else {
        await determinePosition();
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1), () async {
      await StoreListViewController.getStoriesApiService(
        onSuccess: (e) {
          storesResponseModel.value = StoresResponseModel.fromJson(e);
          stores.value = storesResponseModel.value.data!.data!;
        },
        onFail: (e) {
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(
            context: context,
            message: "${e}",
          );
        },
        onExceptionFail: (e) {
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(
            context: context,
            message: "${e}",
          );
        },
      );
      await UserProfileController.getUserProfileApiService(
        onSuccess: (e) {
          isLoading.value = false;
          userProfileResponseModel.value = UserProfileResponseModel.fromJson(e);
        },
        onFail: (e) {
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(
            context: context,
            message: "${e}",
          );
        },
        onExceptionFail: (e) async {
          if (e == "jwt expired") {
            await AppLocalStorage.removeKey(key: "Login");
            Get.to(
              () => SignInView(),
              preventDuplicates: false,
              duration: Duration(milliseconds: 100),
            );
          }
          isLoading.value = false;
          CustomSnackBar().errorCustomSnackBar(
            context: context,
            message: "${e}",
          );
        },
      );
      await checkLocationPermission();
    });
  }

  Widget storeListViewScreenWidget({required BuildContext context}) {
    return Container(
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
          enabled: isLoading.value,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.hpm(context),
              vertical: 16.vpm(context),
            ),
            child: Column(
              children: [
                CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),
                Container(
                  width: 428.w(context),
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: ColorUtils.black29,
                            size: 24.r(context),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            userProfileResponseModel.value.data?.image == null
                                ? Container(
                                    width: 45.w(context),
                                    height: 45.h(context),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.lightBlueAccent,
                                      image: DecorationImage(
                                        image: AssetImage(
                                          ImageUtils.homeProfileAvatar,
                                        ),
                                        fit: BoxFit.cover,
                                        scale: 1,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 45.w(context),
                                    height: 45.h(context),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.lightBlueAccent,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          userProfileResponseModel
                                              .value
                                              .data!
                                              .image,
                                        ),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),

                            CustomSpaceWidget.spacerWidget(
                              spaceWidth: 20.w(context),
                            ),

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
                                BoxShadow(
                                  color: ColorUtils.whiteColor,
                                  blurRadius: 10,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                Get.to(
                                  () => UserNotificationView(),
                                  preventDuplicates: false,
                                  duration: const Duration(milliseconds: 100),
                                );
                              },
                              child: Icon(
                                Icons.notifications,
                                color: ColorUtils.whiteColor,
                                size: 25.r(context),
                              ),
                            ),
                          ),

                          CustomSpaceWidget.spacerWidget(
                            spaceWidth: 6.w(context),
                          ),

                          Container(
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
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                Get.to(
                                  () => CartView(),
                                  preventDuplicates: false,
                                  duration: const Duration(milliseconds: 100),
                                );
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

                CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                  plainTextString: "Find Nearby Restaurants",
                  plainTextStringFontSize: 20.sp(context), 
                  plainTextStringFontWeight: FontWeight.w700,
                  plainTextContainerAlignment: Alignment.centerLeft,
                  plainTextStringColor: ColorUtils.black29,
                  plainTextStringTextAlign: TextAlign.start,
                ),

                CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

                Container(
                  width: 428.w(context),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r(context)),
                    border: Border.all(width: 1, color: ColorUtils.whiteDark),
                  ),
                  child: TextField(
                    onTap: () async {
                      // await UserHomeController.getStoriesApiService(
                      //     onSuccess: (e) {
                      //       storesResponseModel.value = StoresResponseModel.fromJson(e);
                      //       stores.value = storesResponseModel.value.data!.data!;
                      //       isLoading.value = false;
                      //     },
                      //     onFail: (e) {
                      //       isLoading.value = false;
                      //       CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
                      //     },
                      //     onExceptionFail: (e) {
                      //       isLoading.value = false;
                      //       CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
                      //     }
                      // );
                    },
                    onChanged: (search) async {
                      stores.value = storesResponseModel.value.data!.data!
                          .where((e) => e.name.toString().contains(search))
                          .toList();
                    },
                    decoration: InputDecoration(
                      hintText: "Search by store name",
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        color: Colors.grey,
                        size: 32.r(context),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.r(context)),
                      ),
                    ),
                  ),
                ),

                Container(
                  height: 34.h(context),
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () async {
                      isLoading.value = false;
                      await StoreListViewController.getStoriesApiServiceSearchWithLatLongValue(
                        lat: lat.value,
                        long: long.value,
                        onSuccess: (e) {
                          storesResponseModel.value =
                              StoresResponseModel.fromJson(e);
                          stores.value = storesResponseModel.value.data!.data!;
                          isLoading.value = false;
                        },
                        onFail: (e) {
                          isLoading.value = false;
                          CustomSnackBar().errorCustomSnackBar(
                            context: context,
                            message: "${e}",
                          );
                        },
                        onExceptionFail: (e) {
                          isLoading.value = false;
                          CustomSnackBar().errorCustomSnackBar(
                            context: context,
                            message: "${e}",
                          );
                        },
                      );
                    },
                    child:
                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Find Nearby Restaurants",
                          plainTextStringFontSize: 16.sp(context),
                          plainTextStringFontWeight: FontWeight.w600,
                          plainTextContainerAlignment: Alignment.centerRight,
                          plainTextStringColor: ColorUtils.primaryColor,
                          plainTextStringTextAlign: TextAlign.end,
                        ),
                  ),
                ),

                CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                Expanded(
                  child: stores.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: stores.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 150.h(context),

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
                                      storeId: stores[index].sId,
                                      isHomePage: false,
                                      isStoreListPage: true,
                                    ),
                                    preventDuplicates: false,
                                    duration: Duration(milliseconds: 100),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Container(
                                  width: 428.w(context),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.vpm(context),
                                    horizontal: 10.hpm(context),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      4.r(context),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Restaurant Image
                                      SizedBox(
                                        width: 100.w(context),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            5.r(context),
                                          ),
                                          child: Image.network(
                                            stores[index].coverImages!.first,
                                            scale: 10,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                  BuildContext context,
                                                  Object exception,
                                                  StackTrace? stackTrace,
                                                ) {
                                                  return Container(
                                                    height: 180.h(context),
                                                    width: 120.w(context),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          ImageUtils.carousel1,
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5.r(context),
                                                          ),
                                                      color: Color.fromRGBO(
                                                        175,
                                                        175,
                                                        175,
                                                        1,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 10.w(context)),

                                      // Right Section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                                    plainTextString:
                                                        stores[index].name,
                                                    plainTextStringFontSize: 14
                                                        .sp(context),
                                                    plainTextStringFontWeight:
                                                        FontWeight.w700,
                                                    plainTextContainerAlignment:
                                                        Alignment.centerLeft,
                                                    plainTextStringColor:
                                                        ColorUtils.black29,
                                                    plainTextStringTextAlign:
                                                        TextAlign.start,
                                                  ),
                                                ),

                                                SizedBox(width: 5.w(context)),

                                                // Rating
                                                Row(
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: List.generate(5, (
                                                        Index,
                                                      ) {
                                                        // Calculate the fill amount for each star
                                                        double starValue =
                                                            double.parse(
                                                              stores[index]
                                                                  .ratings
                                                                  .toString(),
                                                            ) -
                                                            Index;
                                                        bool isFilled =
                                                            starValue >= 1.0;
                                                        bool isHalfFilled =
                                                            starValue > 0.0 &&
                                                            starValue < 1.0;

                                                        return Icon(
                                                          isFilled
                                                              ? Icons.star
                                                              : isHalfFilled
                                                              ? Icons.star_half
                                                              : Icons
                                                                    .star_border,
                                                          size: 14.r(context),
                                                          color:
                                                              isFilled ||
                                                                  isHalfFilled
                                                              ? Colors.amber
                                                              : Colors
                                                                    .grey
                                                                    .shade600,
                                                        );
                                                      }),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w(context),
                                                    ),
                                                    CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                                      plainTextString:
                                                          stores[index].ratings
                                                              .toStringAsFixed(
                                                                1,
                                                              )
                                                              .toString(),
                                                      plainTextStringFontSize:
                                                          14.sp(context),
                                                      plainTextStringFontWeight:
                                                          FontWeight.w600,
                                                      plainTextContainerAlignment:
                                                          Alignment.center,
                                                      plainTextStringColor:
                                                          ColorUtils.black29,
                                                      plainTextStringTextAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 6.h(context)),

                                            // Description Text
                                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                              plainTextString:
                                                  stores[index].description !=
                                                      null
                                                  ? "${stores[index].description.toString().length > 50 ? stores[index].description.toString().substring(0, 50) : stores[index].description.toString()}...."
                                                  : "N/A",
                                              plainTextStringFontSize: 14.sp(
                                                context,
                                              ),
                                              plainTextStringFontWeight:
                                                  FontWeight.w700,
                                              plainTextContainerAlignment:
                                                  Alignment.centerLeft,
                                              plainTextStringColor:
                                                  ColorUtils.blackColor,
                                              plainTextStringTextAlign:
                                                  TextAlign.start,
                                            ),

                                            SizedBox(height: 6.h(context)),

                                            // Location
                                            FutureBuilder(
                                              future: _getAddressFromLatLng(
                                                stores[index]
                                                    .location!
                                                    .coordinates!
                                                    .last,
                                                stores[index]
                                                    .location!
                                                    .coordinates!
                                                    .first,
                                              ),
                                              builder: (context, snapshot) {
                                                return Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.grey,
                                                      size: 16,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w(context),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        maxLines: 2,
                                                        snapshot.data ?? "N/A",
                                                        style: GoogleFonts.urbanist(
                                                          fontSize: 12.sp(
                                                            context,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              const Color.fromARGB(
                                                                255,
                                                                88,
                                                                88,
                                                                88,
                                                              ),
                                                        ),
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
                        )
                      : Center(
                          child:
                              CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                plainTextString: "No Store Available",
                                plainTextStringFontSize: 22.sp(context),
                                plainTextStringFontWeight: FontWeight.w700,
                                plainTextContainerAlignment: Alignment.center,
                                plainTextStringColor: ColorUtils.black29,
                                plainTextStringTextAlign: TextAlign.center,
                              ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
