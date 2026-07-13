import 'dart:io';
import 'package:discount_me_app/view/vendors/vendor_profile_view/controller/vendor_edit_profile_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../res/res.dart';
import 'package:discount_me_app/view/view.dart';


class VendorProfileEditView extends StatelessWidget {
  VendorProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final VendorEditProfileController vendorEditProfileController = Get.put(VendorEditProfileController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onPopInvoked) {
        Get.to(()=>VendorDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Obx(()=>Container(
          height: 926.h(context),
          width: 428.w(context),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Skeletonizer(
            effect: PulseEffect(),
            enabled: vendorEditProfileController.isLoading.value,
            child: CustomScrollView(
              slivers: [


                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context),vertical: 16.vpm(context)),
                    child: Column(
                      children: [


                        CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                        UserProfileAppbarWidget(
                          title: "Edit Profile",
                          onTap: () {
                            Get.to(()=>VendorDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          },
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "Restaurant Name",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                            TextFormFieldWidget.build(
                              context: context,
                              hintText: "Enter restaurant name",
                              controller: vendorEditProfileController.restaurantName.value,
                              keyboardType: TextInputType.text,
                              borderColor: Color.fromRGBO(29, 36, 45, 1),
                              enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                              focusedBorderColor: ColorUtils.orange125,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                            ),
                          ],
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "Restaurant Description",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                            TextFormFieldWidget.textFiledWithMaxLineBuild(
                              context: context,
                              hintText: "restaurant description .....",
                              maxLines: 5,
                              controller: vendorEditProfileController.restaurantDescription.value,
                              keyboardType: TextInputType.text,
                              borderColor: Color.fromRGBO(29, 36, 45, 1),
                              enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                              focusedBorderColor: ColorUtils.orange125,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                            ),
                          ],
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "Email",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                            TextFormFieldWidget.textFiledWithMaxLineBuild(
                              context: context,
                              hintText: "Enter email address",
                              controller: vendorEditProfileController.emailAddress.value,
                              keyboardType: TextInputType.emailAddress,
                              readOnly: true,
                              borderColor: Color.fromRGBO(29, 36, 45, 1),
                              enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                              focusedBorderColor: ColorUtils.orange125,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                            ),
                          ],
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                        //       plainTextString: "Location",
                        //       plainTextStringFontSize: 20.sp(context),
                        //       plainTextStringFontWeight: FontWeight.w600,
                        //       plainTextContainerAlignment: Alignment.centerLeft,
                        //       plainTextStringColor: ColorUtils.black29,
                        //     ),
                        //
                        //     CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),
                        //
                        //     TextFormFieldWidget.build(
                        //       context: context,
                        //       hintText: "Enter your location",
                        //       controller: vendorEditProfileController.locationAddress.value,
                        //       keyboardType: TextInputType.text,
                        //       prefixIcon: Icon(Icons.location_on_outlined, color: Colors.black54),
                        //       borderColor: Color.fromRGBO(29, 36, 45, 1),
                        //       enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                        //       focusedBorderColor: ColorUtils.orange125,
                        //       contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                        //     ),
                        //   ],
                        // ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "Contact",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 10.hpm(context)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r(context)),
                                  border: Border.all(width: 1, color: Colors.grey)
                              ),
                              child: Material( // Wrapping with Material
                                color: Colors.transparent, // Keep transparent if needed
                                child: InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    vendorEditProfileController.restaurantContact.value = number.phoneNumber.toString();
                                  },
                                  selectorConfig: SelectorConfig(
                                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                    useEmoji: true,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle: const TextStyle(color: Colors.black),
                                  initialValue: PhoneNumber(isoCode: 'BD',phoneNumber: vendorEditProfileController.restaurantContact.value),
                                  formatInput: true,
                                  inputDecoration: const InputDecoration(
                                    hintText: 'Enter phone number',
                                    hintStyle: TextStyle(
                                        color: Colors.grey
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "Update Cover Photo ",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                            vendorEditProfileController.coverDocument.value != "" ?
                            Container(
                              height: 200.h(context),
                              width: 428.w(context),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'svg'],
                                  );
                                  if (result != null) {
                                    // The user has selected a file
                                    PlatformFile file = result.files.first;
                                    // Do something with the file (e.g., upload it)
                                    print('File selected: ${file.name}');
                                    vendorEditProfileController.coverFile.value = File(file.path!);
                                  } else {
                                    CustomSnackBar().normalCustomSnackBar(context: context, message: "No file selected");
                                  }
                                },
                                child: vendorEditProfileController.coverFile.value.path == "" && vendorEditProfileController.coverDocument.value != ""?
                                Image.network(
                                  vendorEditProfileController.coverDocument.value,
                                  width: 428.w(context),
                                  height: 200.h(context),
                                  fit: BoxFit.fill,
                                ) : Image.file(
                                  vendorEditProfileController.coverFile.value,
                                  width: 428.w(context),
                                  height: 200.h(context),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ) :
                            CustomDottedWidget(
                              dottedColor: Colors.black,
                              textColor: Colors.black,
                              buttonColor: Colors.black,
                              lable: vendorEditProfileController.coverFile.value.path.split('/').last,
                              onPress: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'svg'],
                                );
                                if (result != null) {
                                  // The user has selected a file
                                  PlatformFile file = result.files.first;
                                  // Do something with the file (e.g., upload it)
                                  print('File selected: ${file.name}');
                                  vendorEditProfileController.coverFile.value = File(file.path!);
                                } else {
                                  CustomSnackBar().normalCustomSnackBar(context: context, message: "No file selected");
                                }
                              },
                            ),
                          ],
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "Update Tax Document ",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                            vendorEditProfileController.textDocument.value != "" ?
                            Container(
                              height: 200.h(context),
                              width: 428.w(context),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'svg'],
                                  );
                                  if (result != null) {
                                    // The user has selected a file
                                    PlatformFile file = result.files.first;
                                    // Do something with the file (e.g., upload it)
                                    print('File selected: ${file.name}');
                                    vendorEditProfileController.textDocumentFile.value = File(file.path!);
                                  } else {
                                    CustomSnackBar().normalCustomSnackBar(context: context, message: "No file selected");
                                  }
                                },
                                child: vendorEditProfileController.textDocumentFile.value.path == "" && vendorEditProfileController.textDocument.value != ""?
                                Image.network(
                                  vendorEditProfileController.textDocument.value,
                                  width: 428.w(context),
                                  height: 200.h(context),
                                  fit: BoxFit.fill,
                                ) : Image.file(
                                  vendorEditProfileController.textDocumentFile.value,
                                  width: 428.w(context),
                                  height: 200.h(context),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ) :
                            CustomDottedWidget(
                              dottedColor: Colors.black,
                              textColor: Colors.black,
                              buttonColor: Colors.black,
                              lable:  vendorEditProfileController.textDocumentFile.value.path.split('/').last,
                              onPress: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'svg'],
                                );
                                if (result != null) {
                                  // The user has selected a file
                                  PlatformFile file = result.files.first;
                                  // Do something with the file (e.g., upload it)
                                  print('File selected: ${file.name}');
                                  vendorEditProfileController.textDocumentFile.value = File(file.path!);
                                } else {
                                  CustomSnackBar().normalCustomSnackBar(context: context, message: "No file selected");
                                }
                              },
                            ),
                          ],
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        vendorEditProfileController.isSubmit.value == true ?
                        Container(
                          height: 64.h(context),
                          width: 428.h(context),
                          decoration: const BoxDecoration(
                              color: Colors.transparent
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(color: ColorUtils.green176,),
                          ),
                        ) :
                        CustomButtonContainer.plainButtonContainer(
                          plainButtonHeight: 64.h(context),
                          plainButtonWidth: 428.w(context),
                          plainButtonRadius: 8.r(context),
                          plainButtonOnPress:  () async {
                            vendorEditProfileController.updateVendorProfileController(
                              context: context,
                              vendorId: vendorEditProfileController.vendorProfileResponseModel.value.data?.sId ?? "",
                              email: vendorEditProfileController.emailAddress.value.text,
                              restaurantName: vendorEditProfileController.restaurantName.value.text,
                              restaurantDescription: vendorEditProfileController.restaurantDescription.value.text,
                              contact: vendorEditProfileController.restaurantContact.value,
                              image: vendorEditProfileController.coverFile.value,
                              document: vendorEditProfileController.textDocumentFile.value,
                            );
                          },
                          plainButtonHint: "Update",
                          plainButtonHintFontSize: 22.sp(context),
                          plainButtonColor: ColorUtils.green176,
                          plainButtonHintFontColor: ColorUtils.white255,
                        ),

                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),



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