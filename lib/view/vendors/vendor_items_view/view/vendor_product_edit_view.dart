import 'dart:io';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/vendors/vendor_items_view/controller/vendor_product_edit_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../res/res.dart';
import 'package:discount_me_app/view/view.dart';

class VendorProductEditView extends StatelessWidget {
  const VendorProductEditView({super.key,required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final VendorProductEditController vendorProductEditController = Get.put(VendorProductEditController(context: context, productId: productId));
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
          child: Obx(()=> Skeletonizer(
            effect: PulseEffect(),
            enabled: vendorProductEditController.isLoading.value,
            child: CustomScrollView(
              slivers: [

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                    child: Column(
                      children: [

                        CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                        UserProfileAppbarWidget(
                          title: "Product Edit",
                          onTap: () {
                            Get.to(()=>VendorDashboardView(index: 2,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          },
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [

                                Expanded(
                                  child: CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: "Upload Food Image",
                                    plainTextStringFontSize: 20.sp(context),
                                    plainTextStringFontWeight: FontWeight.w600,
                                    plainTextContainerAlignment: Alignment.centerLeft,
                                    plainTextStringColor: ColorUtils.black29,
                                  ),
                                ),


                                CustomSpaceWidget.spacerWidget(spaceWidth: 10.w(context)),

                                IconButton(
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(
                                      12.lpm(context),
                                      12.tpm(context),
                                      0,
                                      12.bpm(context)
                                    ),
                                  ),
                                  onPressed: () async {
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
                                      vendorProductEditController.coverScreenSorts.clear();
                                      result.files.forEach((value) {
                                        vendorProductEditController.coverImages.add(File(value.path!));
                                      });
                                    } else {
                                      CustomSnackBar().normalCustomSnackBar(context: context, message: "No file selected");
                                    }
                                  },
                                  icon: Icon(Icons.add, size: 32.r(context), color: Colors.black),
                                )

                              ],
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

                            vendorProductEditController.coverScreenSorts.isNotEmpty == true || vendorProductEditController.coverImages.isNotEmpty == true ?
                            Container(
                              height: 250.h(context),
                              width: 428.w(context),
                              child: vendorProductEditController.coverScreenSorts.isNotEmpty == true ?
                              Column(
                                children: [
                                  Expanded(
                                    child: PageView.builder(
                                      onPageChanged: (value) {
                                        vendorProductEditController.onPageChanged(value);
                                      },
                                      controller: vendorProductEditController.pageController.value,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: vendorProductEditController.coverScreenSorts.length,
                                      itemBuilder: (context, index) {
                                        return _buildScalingTransition(vendorProductEditController.coverScreenSorts[index], index);
                                      },
                                    ),
                                  ),
                                  CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),
                                  SmoothPageIndicator(
                                    controller: vendorProductEditController.pageController.value,
                                    count: vendorProductEditController.coverScreenSorts.length,
                                    effect: ExpandingDotsEffect(
                                      activeDotColor: Colors.deepPurple,
                                      dotColor: Colors.deepPurple.shade100,
                                      dotHeight: 10,
                                      dotWidth: 10,
                                    ),
                                  ),
                                ],
                              ) :
                              Column(
                                children: [
                                  Expanded(
                                    child: PageView.builder(
                                      onPageChanged: (value) {
                                        vendorProductEditController.onPageChanged(value);
                                      },
                                      controller: vendorProductEditController.pageController.value,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: vendorProductEditController.coverImages.length,
                                      itemBuilder: (context, index) {
                                        return _fileBuildScalingTransition(vendorProductEditController.coverImages[index], index);
                                      },
                                    ),
                                  ),
                                  CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),
                                  SmoothPageIndicator(
                                    controller: vendorProductEditController.pageController.value,
                                    count: vendorProductEditController.coverImages.length,
                                    effect: ExpandingDotsEffect(
                                      activeDotColor: Colors.deepPurple,
                                      dotColor: Colors.deepPurple.shade100,
                                      dotHeight: 10,
                                      dotWidth: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ) :
                            SizedBox.shrink(),


                          ],
                        ),


                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Item Name",
                          plainTextStringFontSize: 20.sp(context),
                          plainTextStringFontWeight: FontWeight.w600,
                          plainTextContainerAlignment: Alignment.centerLeft,
                          plainTextStringColor: ColorUtils.black29,
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

                        TextFormFieldWidget.build(
                          context: context,
                          hintText: "Enter Item Name",
                          controller: vendorProductEditController.itemNameController.value,
                          keyboardType: TextInputType.text,
                          borderColor: Color.fromRGBO(29, 36, 45, 1),
                          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                          focusedBorderColor: ColorUtils.orange125,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Item Details",
                          plainTextStringFontSize: 20.sp(context),
                          plainTextStringFontWeight: FontWeight.w600,
                          plainTextContainerAlignment: Alignment.centerLeft,
                          plainTextStringColor: ColorUtils.black29,
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

                        TextFormFieldWidget.textFiledWithMaxLineBuild(
                          context: context,
                          maxLines: 5,
                          hintText: "Enter Item Details.....",
                          controller: vendorProductEditController.itemDetailsController.value,
                          keyboardType: TextInputType.text,
                          borderColor: Color.fromRGBO(29, 36, 45, 1),
                          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                          focusedBorderColor: ColorUtils.orange125,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Select Items Category",
                          plainTextStringFontSize: 20.sp(context),
                          plainTextStringFontWeight: FontWeight.w600,
                          plainTextContainerAlignment: Alignment.centerLeft,
                          plainTextStringColor: ColorUtils.black29,
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),


                        CustomDropdownHelperClass<Categories>(
                          value: vendorProductEditController.singleCategory.value.name == null ? null : vendorProductEditController.singleCategory.value,
                          items: vendorProductEditController.categoriesResponseModel.value.categories ?? [],
                          onChanged: (value) {
                            vendorProductEditController.singleCategory.value = value!;
                          },
                          borderColor: Color.fromRGBO(29, 36, 45, 1),
                          itemBuilder: (Categories value) {
                            return CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextStringColor: ColorUtils.black29,
                              plainTextStringFontWeight: FontWeight.w700,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextString: value.name,
                              plainTextStringFontSize: 20.sp(context),
                            );
                          },
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Item Price",
                          plainTextStringFontSize: 20.sp(context),
                          plainTextStringFontWeight: FontWeight.w600,
                          plainTextContainerAlignment: Alignment.centerLeft,
                          plainTextStringColor: ColorUtils.black29,
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

                        TextFormFieldWidget.build(
                          context: context,
                          hintText: "Enter Item Price",
                          controller: vendorProductEditController.itemPriceController.value,
                          keyboardType: TextInputType.number,
                          borderColor: Color.fromRGBO(29, 36, 45, 1),
                          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                          focusedBorderColor: ColorUtils.orange125,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                        CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                          plainTextString: "Item Quantity",
                          plainTextStringFontSize: 20.sp(context),
                          plainTextStringFontWeight: FontWeight.w600,
                          plainTextContainerAlignment: Alignment.centerLeft,
                          plainTextStringColor: ColorUtils.black29,
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 8.h(context)),

                        TextFormFieldWidget.build(
                          context: context,
                          hintText: "Enter Item Quantity",
                          controller: vendorProductEditController.itemQuantityController.value,
                          keyboardType: TextInputType.number,
                          borderColor: Color.fromRGBO(29, 36, 45, 1),
                          enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                          focusedBorderColor: ColorUtils.orange125,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),



                        vendorProductEditController.isSubmit.value == true ?
                        Container(
                          height: 64.h(context),
                          width: 428.h(context),
                          decoration: const BoxDecoration(
                              color: Colors.transparent
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(color: ColorUtils.green139,),
                          ),
                        ) :
                        CustomButtonContainer.plainButtonContainer(
                          plainButtonHeight: 64.h(context),
                          plainButtonWidth: 428.w(context),
                          plainButtonRadius: 8.r(context),
                          plainButtonOnPress:  () async {
                            if(vendorProductEditController.coverImages.isEmpty == true && vendorProductEditController.coverScreenSorts.isEmpty == true) {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Pick Some Item Cover Screen ");
                            } else if(vendorProductEditController.singleCategory.value.name == null) {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Item Category");
                            } else if(vendorProductEditController.itemNameController.value.text == "") {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Item Name");
                            } else if(vendorProductEditController.itemQuantityController.value.text == "") {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Item Quantity");
                            } else if(vendorProductEditController.itemPriceController.value.text == "") {
                              CustomSnackBar().errorCustomSnackBar(context: context, message: "Please Enter Item Price");
                            } else {
                              print(vendorProductEditController.coverScreenSorts.length);
                              await vendorProductEditController.editProductController(
                                context: context,
                                productId: productId,
                                name: vendorProductEditController.itemNameController.value.text,
                                category: vendorProductEditController.singleCategory.value.sId,
                                price: vendorProductEditController.itemPriceController.value.text,
                                description: vendorProductEditController.itemDetailsController.value.text,
                                quantity: vendorProductEditController.itemQuantityController.value.text,
                                oldImgsToKeep: vendorProductEditController.coverScreenSorts.isEmpty == true ? [] :
                                vendorProductEditController.singleProductResponseModel.value.data?.images ?? [],
                                imagesToDelete: vendorProductEditController.coverImages.isNotEmpty == true ?
                                vendorProductEditController.singleProductResponseModel.value.data?.images ?? [] : [],
                                pickedImage: vendorProductEditController.coverImages,
                              );
                            }
                          },
                          plainButtonHint: "Product Edit",
                          plainButtonHintFontSize: 22.sp(context),
                          plainButtonColor: ColorUtils.green176,
                          plainButtonHintFontColor: ColorUtils.white255,
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 30.h(context)),

                      ],
                    ),
                  ),
                ),


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


  Widget _fileBuildScalingTransition(File image, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0), // Scaling from 50% to 100%
      duration: const Duration(milliseconds: 600),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale, // Scale the image
          child: Image.file(
            image,
            fit: BoxFit.fill,
          ),
        );
      },
    );
  }

}
