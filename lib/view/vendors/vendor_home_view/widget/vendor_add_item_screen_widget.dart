import 'dart:io';

import 'package:discount_me_app/res/res.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:discount_me_app/utils/utils.dart';
import '../../../../res/common_widget/RoundTextField.dart';
import '../../../../res/common_widget/custom_text.dart';
import '../../../view.dart';
import 'package:dio/dio.dart' as dio;

class VendorAddItemScreenWidget extends GetxController {



  BuildContext context;
  VendorAddItemScreenWidget({required this.context});

  RxBool isLoading = false.obs;
  RxBool isSubmit = false.obs;

  RxList<dio.MultipartFile> files = <dio.MultipartFile>[].obs;

  Rx<CategoriesResponseModel> categoriesResponseModel = CategoriesResponseModel().obs;
  Rx<Categories> singleCategory = Categories().obs;
  RxString updatedCategoryId = "".obs;
  RxList<File> coverImages = <File>[].obs;
  Rx<TextEditingController> itemName = TextEditingController().obs;
  Rx<TextEditingController> itemDetails = TextEditingController().obs;
  Rx<TextEditingController> itemPrice = TextEditingController().obs;
  Rx<TextEditingController> itemQuantity = TextEditingController().obs;
  Rx<TextEditingController> itemDiscount = TextEditingController().obs;

  AddProductController addProductController = Get.put(AddProductController());
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1),() async {
      await VendorProductCategoryDetailsController.getCategoriesApiService(
        onSuccess: (e) {
          categoriesResponseModel.value = CategoriesResponseModel.fromJson(e);
          isLoading.value = false;
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
    });
  }


  Widget vendorAddItemScreenWidget({required BuildContext context}) {
    return Obx(()=>Container(
      height: 928.h(context),
      width: 428.w(context),
      decoration: BoxDecoration(
          color: Colors.white
      ),
      child: Skeletonizer(
        effect: PulseEffect(),
        enabled: isLoading.value,
        child: CustomScrollView(
          slivers: [ 

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.vpm(context),horizontal: 16.hpm(context)),
                child: Column(
                  children: [

                    CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                    UserProfileAppbarWidget(
                      title: "Add Item",
                      onTap: () {
                        Get.to(()=>VendorDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                      },
                    ),

                    CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),



                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        CustomText(title: "Upload Food Image",
                          color: ColorUtils.blackColor,
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w600,
                        ),
                        CustomSpaceWidget.spacerWidget(spaceHeight: 12.h(context)),

                        CustomDottedWidget(
                            dottedColor: Colors.black87,
                            buttonColor: Colors.black87,
                            textColor: Colors.black87,
                            lable: coverImages.isNotEmpty == true ? "${coverImages.first.path.toString().split("/").last } and ${coverImages.length -1} more files uploaded" : "",
                            onPress: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowMultiple: true,
                                allowedExtensions: ['jpg', 'jpeg', 'png', 'svg'],
                              );
                              if (result != null) {
                                // The user has selected a file
                                PlatformFile file = result.files.first;
                                // Do something with the file (e.g., upload it)
                                print('File selected: ${file.name}');
                                result.files.forEach((value) {
                                  coverImages.add(File(value.path!));
                                });
                                result.files.forEach((value) async {
                                  files.add(
                                    await dio.MultipartFile.fromFile(
                                      value.path!,
                                      filename: value.path!.split('/').last,
                                      contentType: dio.DioMediaType(CustomMimeType.getMimeType(value.path!).split('/').first,CustomMimeType.getMimeType(value.path!).split('/').last),
                                    ),
                                  );
                                });
                              } else {
                                CustomSnackBar().normalCustomSnackBar(context: context, message: "No file selected");
                              }
                            }
                        ),
                      ],
                    ),
                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(title: "Item Name",
                          color: ColorUtils.blackColor,
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w600,
                        ),
                        CustomSpaceWidget.spacerWidget(spaceHeight: 12.h(context)),
                        RoundTextField(
                          hint: "Enter Item Name",
                          controller: itemName.value,
                        ),
                      ],
                    ),
                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(title: "Item Details",
                          color: ColorUtils.blackColor,
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w600,
                        ),
                        CustomSpaceWidget.spacerWidget(spaceHeight: 12.h(context)),
                        RoundTextField(
                          hint: "Enter Item Description",
                          controller: itemDetails.value,
                        ),
                      ],
                    ),
                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(title: "Select Items Category",
                          color: ColorUtils.blackColor,
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w600,
                        ),
                        CustomSpaceWidget.spacerWidget(spaceHeight: 12.h(context)),
                        Container(
                          height: 64.h(context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r(context)),
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey,width: 1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Categories>(
                                isExpanded: true,
                                value: singleCategory.value.name != null ? singleCategory.value : null,
                                dropdownColor: Colors.white,
                                hint: CustomText(
                                  title: "Select Items Category",
                                  color: Color(0xffAFAFAF),
                                  fontSize: 20.sp(context),
                                  fontWeight: FontWeight.w400,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.hpm(context),
                                  vertical: 10.vpm(context),
                                ),
                                items: categoriesResponseModel.value.categories?.map<DropdownMenuItem<Categories>>((Categories categories) {
                                  return DropdownMenuItem<Categories>(
                                    value: categories,
                                    child: CustomText(
                                      title: categories.name,
                                      color: Colors.black87,
                                      fontSize: 16.sp(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (categories) {
                                  singleCategory.value = categories!;
                                },
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(title: "Item Price",
                          color: ColorUtils.blackColor,
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w600,
                        ),
                        CustomSpaceWidget.spacerWidget(spaceHeight: 12.h(context)),
                        RoundTextField(
                          hint: "Enter Item Price",
                          controller: itemPrice.value,
                        ),
                      ],
                    ),

                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(title: "Item Quantity",
                          color: ColorUtils.blackColor,
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w600,
                        ),
                        CustomSpaceWidget.spacerWidget(spaceHeight: 12.h(context)),
                        RoundTextField(
                          hint: "Enter Item Quantity",
                          controller: itemQuantity.value,
                        ),
                      ],
                    ),

                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(title: "Discount",
                          color: ColorUtils.blackColor,
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.w600,
                        ),
                        CustomSpaceWidget.spacerWidget(spaceHeight: 12.h(context)),
                        RoundTextField(
                          hint: "Enter Discount (Percentage)",
                          controller: itemDiscount.value,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),


                    CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                    isSubmit.value == true ?
                    Container(
                      height: 65.h(context),
                      width: 428.h(context),
                      decoration: const BoxDecoration(
                          color: Colors.transparent
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: ColorUtils.black29,),
                      ),
                    ) :
                    Container(
                      height: 65.h(context),
                      width: 428.w(context),
                      decoration: BoxDecoration(
                        color: ColorUtils.green176,
                        borderRadius: BorderRadius.circular(12.r(context)),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if(coverImages.isEmpty == true) {
                            CustomSnackBar().errorCustomSnackBar(context: context, message: "Please select item cover photo");
                          }else if(itemName.value.text == "") {
                            CustomSnackBar().errorCustomSnackBar(context: context, message: "Please the item name");
                          }else if(itemDetails.value.text == "") {
                            CustomSnackBar().errorCustomSnackBar(context: context, message: "Please the item details");
                          }else if(itemPrice.value.text == "") {
                            CustomSnackBar().errorCustomSnackBar(context: context, message: "Please the item price");
                          }else if(itemQuantity.value.text == "") {
                            CustomSnackBar().errorCustomSnackBar(context: context, message: "Please the item quantity");
                          }else if(itemDiscount.value.text == "") {
                            CustomSnackBar().errorCustomSnackBar(context: context, message: "Please the item discount");
                          }else if(singleCategory.value.name == null) {
                            CustomSnackBar().errorCustomSnackBar(context: context, message: "Please the select category");
                          }else {
                            isSubmit.value = true;
                            addProductController.getProductAddResponse(
                              images: files,
                              name: itemName.value.text,
                              details: itemDetails.value.text,
                              category: singleCategory.value.sId,
                              price: double.parse(itemPrice.value.text),
                              quantity: double.parse(itemQuantity.value.text),
                              discount: double.parse(itemDiscount.value.text),
                              onSuccess: (e) async {
                                await Get.to(()=>VendorDashboardView(index: 2),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                isSubmit.value = false;
                              },
                              onFail: (e) {
                                isSubmit.value = false;
                                CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
                              },
                              onExceptionFail: (e) async {
                                if(e == "jwt expired") {
                                  await AppLocalStorage.removeKey(key: "Login");
                                  await Get.to(()=>SignInView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                }
                                isSubmit.value = false;
                                CustomSnackBar().errorCustomSnackBar(context: context, message: "${e}");
                              },
                            );
                          }
                        },
                        child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Add item",
                          plainTextStringFontSize: 22.sp(context),
                          plainTextStringFontWeight: FontWeight.w700,
                          plainTextContainerAlignment: Alignment.center,
                          plainTextStringColor: ColorUtils.white246,
                          plainTextStringTextAlign: TextAlign.center,
                        ),
                      ),
                    ),


                    CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                  ],
                ),
              ),
            )


          ],
        ),
      ),
    ));
  }



}
