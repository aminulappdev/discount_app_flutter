import 'dart:io';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/riders/rider_profile_view/widget/rider_edit_profile_dialog_box.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../res/res.dart';


class RiderProfileEditScreen extends StatelessWidget {
  const RiderProfileEditScreen({super.key});


  @override
  Widget build(BuildContext context) {
    RiderProfileEditController riderProfileEditController = Get.put(RiderProfileEditController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,onPopInvoked) {
        Get.to(()=>RiderDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
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
            enabled: riderProfileEditController.isLoading.value,
            child: CustomScrollView(
              slivers: [

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                    child: Column(
                      children: [

                        CustomSpaceWidget.spacerWidget(spaceHeight: 40.h(context)),

                        UserProfileAppbarWidget(
                          title: "Edit Profile",
                          onTap: () {
                            Get.to(()=>RiderDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                          },
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          height: 250.h(context),
                          width: 428.w(context),
                          curve: Curves.easeIn,
                          child: Center(
                            child: Stack(
                              children: [
                                Container(
                                  height: 120.h(context),
                                  width: 120.w(context),
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent
                                  ),
                                ),

                                if(riderProfileEditController.image.value != "" &&  riderProfileEditController.imageFile.value.path == "")...[
                                  Positioned(
                                    child: CustomImageContainer.networkImageContainer(
                                      height: 220.h(context),
                                      width: 220.w(context),
                                      networkImage: riderProfileEditController.image.value,
                                      boxFit: BoxFit.fitWidth,
                                      boxShape: BoxShape.circle,
                                      borderColors: ColorUtils.primaryColor,
                                      borderWidth: 1,
                                    ),
                                  ),
                                ] else if(riderProfileEditController.imageFile.value.path != "" && riderProfileEditController.image.value == "")...[
                                  Positioned(
                                    child:CustomImageContainer.fileImageContainer(
                                      height: 220.h(context),
                                      width: 220.w(context),
                                      file: riderProfileEditController.imageFile.value,
                                      boxFit: BoxFit.fitWidth,
                                      boxShape: BoxShape.circle,
                                      borderColors: ColorUtils.primaryColor,
                                      borderWidth: 1,
                                    ),
                                  ),
                                ] else if(riderProfileEditController.image.value == "" &&  riderProfileEditController.imageFile.value.path == "")...[
                                  Positioned(
                                    child: CustomImageContainer.assetImageContainer(
                                      height: 220.h(context),
                                      width: 220.w(context),
                                      assetImage: ImageUtils.imagePickerIcon,
                                      boxFit: BoxFit.fitWidth,
                                      boxShape: BoxShape.circle,
                                      borderColors: ColorUtils.primaryColor,
                                      borderWidth: 1,
                                    ),
                                  ),
                                ] else...[
                                  Positioned(
                                    child: CustomSpaceWidget.spacerWidget(),
                                  ),
                                ],


                                Positioned(
                                  top: 155.h(context),
                                  left: 155.w(context),
                                  child: Container(
                                    width: 60.h(context),
                                    height: 60.w(context),
                                    decoration: BoxDecoration(
                                        color: ColorUtils.white253,
                                        shape: BoxShape.circle,
                                    ),
                                    child: TextButton(
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                      onPressed: () {
                                        RiderEditProfileDialogBox().riderEditProfileDialogBox(
                                          context: context,
                                          riderProfileEditController: riderProfileEditController,
                                        );
                                      },
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: ColorUtils.secondaryColor,
                                        size: 28.r(context),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: "First name",
                                    plainTextStringFontSize: 20.sp(context),
                                    plainTextStringFontWeight: FontWeight.w600,
                                    plainTextContainerAlignment: Alignment.centerLeft,
                                    plainTextStringColor: ColorUtils.black29,
                                  ),

                                  CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                                  TextFormFieldWidget.build(
                                    context: context,
                                    hintText: "First name",
                                    controller: riderProfileEditController.firstNameController.value,
                                    keyboardType: TextInputType.text,
                                    borderColor: Color.fromRGBO(29, 36, 45, 1),
                                    enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                                    focusedBorderColor: ColorUtils.orange125,
                                    contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                                  ),
                                ],
                              ),
                            ),

                            CustomSpaceWidget.spacerWidget(spaceWidth: 10.w(context)),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                                    plainTextString: "Last name",
                                    plainTextStringFontSize: 20.sp(context),
                                    plainTextStringFontWeight: FontWeight.w600,
                                    plainTextContainerAlignment: Alignment.centerLeft,
                                    plainTextStringColor: ColorUtils.black29,
                                  ),

                                  CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                                  TextFormFieldWidget.build(
                                    context: context,
                                    hintText: "Last name",
                                    controller: riderProfileEditController.lastNameController.value,
                                    keyboardType: TextInputType.text,
                                    borderColor: Color.fromRGBO(29, 36, 45, 1),
                                    enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                                    focusedBorderColor: ColorUtils.orange125,
                                    contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextContainer.plainTextContainerWidgetWithoutHeightWidth(
                              plainTextString: "Email address",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                            TextFormFieldWidget.build(
                              context: context,
                              readOnly: true,
                              hintText: "Enter your email address",
                              controller: riderProfileEditController.emailController.value,
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
                              plainTextString: "Location",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),

                            TextFormFieldWidget.build(
                              context: context,
                              hintText: "Enter your location",
                              controller: riderProfileEditController.locationController.value,
                              keyboardType: TextInputType.text,
                              prefixIcon: Icon(Icons.location_on_outlined, color: Colors.black54),
                              borderColor: Color.fromRGBO(29, 36, 45, 1),
                              enableBorderColor: Color.fromRGBO(29, 36, 45, 1),
                              focusedBorderColor: ColorUtils.orange125,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.vpm(context),horizontal: 16.hpm(context)),
                            ),
                          ],
                        ),



                        // country code picker

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
                                    riderProfileEditController.contact.value = number.phoneNumber.toString();
                                  },
                                  selectorConfig: SelectorConfig(
                                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                    useEmoji: true,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle: const TextStyle(color: Colors.black),
                                  initialValue: PhoneNumber(isoCode: 'BD',phoneNumber: riderProfileEditController.contact.value),
                                  formatInput: true,
                                  inputDecoration: const InputDecoration(
                                    hintText: 'Enter your number',
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
                              plainTextString: "Upload Driving License ",
                              plainTextStringFontSize: 20.sp(context),
                              plainTextStringFontWeight: FontWeight.w600,
                              plainTextContainerAlignment: Alignment.centerLeft,
                              plainTextStringColor: ColorUtils.black29,
                            ),

                            CustomSpaceWidget.spacerWidget(spaceHeight: 10.h(context)),


                            riderProfileEditController.document.value != "" ?
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
                                    riderProfileEditController.documentFile.value = File(file.path!);
                                  } else {
                                    CustomSnackBar().normalCustomSnackBar(context: context, message: "No file selected");
                                  }
                                },
                                child: riderProfileEditController.documentFile.value.path == "" && riderProfileEditController.document.value != ""?
                                Image.network(
                                  riderProfileEditController.document.value,
                                  width: 428.w(context),
                                  height: 200.h(context),
                                  fit: BoxFit.fill,
                                ) : Image.file(
                                  riderProfileEditController.documentFile.value,
                                  width: 428.w(context),
                                  height: 200.h(context),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ) :
                            CustomDottedWidget(
                              dottedColor: Colors.white,
                              textColor: Colors.white,
                              buttonColor: Colors.white,
                              lable: riderProfileEditController.documentFile.value.path.split('/').last,
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
                                  riderProfileEditController.documentFile.value = File(file.path!);
                                } else {
                                  CustomSnackBar().normalCustomSnackBar(context: context, message: "No file selected");
                                }
                              },
                            ),
                          ],
                        ),


                        CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                        riderProfileEditController.isSubmit.value == true ?
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
                            await riderProfileEditController.updateRiderProfileController(
                              context: context,
                              riderId: riderProfileEditController.riderProfileResponse.value.data?.sId ?? "",
                              name: "${riderProfileEditController.firstNameController.value.text} ${riderProfileEditController.lastNameController.value.text}",
                              email: riderProfileEditController.emailController.value.text,
                              location: riderProfileEditController.locationController.value.text,
                              contact: riderProfileEditController.contact.value,
                              image: riderProfileEditController.imageFile.value,
                              document: riderProfileEditController.documentFile.value,
                            );
                          },
                          plainButtonHint: "Update",
                          plainButtonHintFontSize: 22.sp(context),
                          plainButtonColor: ColorUtils.green176,
                          plainButtonHintFontColor: ColorUtils.white255,
                        ),


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
