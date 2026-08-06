import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/res/res.dart';
import 'package:image_picker/image_picker.dart';

class RoleWiseFormField {


  Widget roleWiseFormFields({
    required BuildContext context,
    required String selectedRole,
    required SignUpController controller,
  }) {
    bool isVendor = selectedRole == "Vendor";
    bool isUser = selectedRole == "User";
    bool isRider = selectedRole == "Rider";
    bool isBroker = selectedRole == "Broker";

    bool isBasicUser = isUser || isRider || isBroker;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// ================= VENDOR FIELDS =================
        if (isVendor) ...[

          /// Restaurant Name
          _label(text: "Restaurant Name", context: context),
          _space8(context: context),
          TextFormFieldWidget.build(
            context: context,
            hintText: "Restaurant Name",
            controller: controller.restaurantNameController.value,
            keyboardType: TextInputType.emailAddress,
            borderColor: ColorUtils.whiteNormalActive,
            enableBorderColor: ColorUtils.whiteNormalActive,
            focusedBorderColor: ColorUtils.secondaryColor,
          ),

          _space20(context: context),

          /// Restaurant Description
          _label(text: "Restaurant Description", context: context),
          _space8(context: context),
          TextFormFieldWidget.textFiledWithMaxLineBuild(
            context: context,
            maxLines: 5,
            hintText: "Enter description...",
            controller: controller.restaurantDescriptionController.value,
            keyboardType: TextInputType.emailAddress,
            borderColor: ColorUtils.whiteNormalActive,
            enableBorderColor: ColorUtils.whiteNormalActive,
            focusedBorderColor: ColorUtils.secondaryColor,
          ),

          _space20(context: context),

          /// Vendor Location (read-only)
          _label(text: "Location", context: context),
          _space8(context: context),
          TextFormFieldWidget.build(
            context: context,
            hintText: "Enter Location",
            controller: controller.locationController.value,
            keyboardType: TextInputType.emailAddress,
            borderColor: ColorUtils.whiteNormalActive,
            enableBorderColor: ColorUtils.whiteNormalActive,
            focusedBorderColor: ColorUtils.secondaryColor,
            prefixIcon: Padding(
              padding: EdgeInsets.all(20.r(context)),
              child: InkWell(
                onTap: () async {},
                child: ImageHelperWidget.assetImageWidget(
                  context: context,
                  height: 24.h(context),
                  width: 24.w(context),
                  imageString: ImageUtils.locationImage,
                ),
              ),
            ),
          ),


          _space20(context: context),
        ],

        /// ================= BASIC USER FIELDS =================
        if (isBasicUser) ...[
          Row(
            children: [
              Expanded(
                child: _textFieldColumn(
                  context: context,
                  label: "First Name",
                  controller: controller.firstNameController.value,
                  hint: "First Name",
                ),
              ),

              _spaceWidth10(context: context),

              Expanded(
                child: _textFieldColumn(
                  context: context,
                  label: "Last Name",
                  controller: controller.lastNameController.value,
                  hint: "Last Name",
                ),
              ),
            ],
          ),

          _space20(context: context),

          _label(text: "Location", context: context),
          _space8(context: context),
          TextFormFieldWidget.build(
            context: context,
            hintText: "Enter Location",
            controller: controller.locationController.value,
            keyboardType: TextInputType.emailAddress,
            borderColor: ColorUtils.whiteNormalActive,
            enableBorderColor: ColorUtils.whiteNormalActive,
            focusedBorderColor: ColorUtils.secondaryColor,
            prefixIcon: Padding(
              padding: EdgeInsets.all(20.r(context)),
              child: InkWell(
                onTap: () async {},
                child: ImageHelperWidget.assetImageWidget(
                  context: context,
                  height: 24.h(context),
                  width: 24.w(context),
                  imageString: ImageUtils.locationImage,
                ),
              ),
            ),
          ),

          _space20(context: context),
        ],

        /// ================= EMAIL (ALL ROLES) =================
        if (isUser || isRider || isVendor || isBroker) ...[
          _label(text: "Email address", context: context),
          _space8(context: context),
          TextFormFieldWidget.build(
            context: context,
            hintText: "Enter Email Address",
            controller: controller.emailController.value,
            keyboardType: TextInputType.emailAddress,
            fillColor: ColorUtils.white253,
            borderColor: ColorUtils.white202,
            enableBorderColor: ColorUtils.white202,
            focusedBorderColor: ColorUtils.secondaryColor,
            prefixIcon: Padding(
              padding: EdgeInsets.all(20.r(context)),
              child: InkWell(
                onTap: () async {},
                child: ImageHelperWidget.assetImageWidget(
                  context: context,
                  height: 24.h(context),
                  width: 24.w(context),
                  imageString: ImageUtils.emailImage,
                ),
              ),
            ),
          ),

          _space20(context: context),
        ],


        if (isUser || isRider || isVendor)...[

          _label(text: "Referral Code", context: context),
          _space8(context: context),
          TextFormFieldWidget.build(
            context: context,
            hintText: "Referral Code",
            controller: controller.referralCodeController.value,
            keyboardType: TextInputType.emailAddress,
            borderColor: ColorUtils.whiteNormalActive,
            enableBorderColor: ColorUtils.whiteNormalActive,
            focusedBorderColor: ColorUtils.secondaryColor,
          ),

          _space20(context: context),

        ],


        /// ================= CONTACT =================
        _label(text: "Contact", context: context),
        _space8(context: context),
        _phoneField(context: context, controller: controller),
        _space20(context: context),

        /// ================= DOCUMENTS =================
        if (isUser) ...[
          _label(text: "Please upload documents to verify", context: context),
          _space8(context: context),
          CustomDottedWidget(
            dottedColor: Colors.white,
            textColor: Colors.white,
            buttonColor: Colors.white,
            lable: controller.documentFile.value.path.split('/').last,
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
                controller.documentFile.value = File(file.path!);
              } else {
                MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "No file selected");
              }
            },
          ),
          _space20(context: context),
        ],

        if (isRider) ...[
          _label(text: "Upload driving license", context: context),
          _space8(context: context),
          CustomDottedWidget(
            dottedColor: Colors.white,
            buttonColor: Colors.white,
            textColor: Colors.white,
            lable: controller.drivingLicenceFile.value.path.split('/').last,
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
                controller.drivingLicenceFile.value = File(file.path!);
              } else {
                MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "No file selected");
              }
            },
          ),
          _space20(context: context),
        ],

        if (isVendor) ...[
          _label(text: "Upload Cover Photo", context: context),
          _space8(context: context),
          CustomDottedWidget(
            dottedColor: Colors.white,
            buttonColor: Colors.white,
            textColor: Colors.white,
            lable: controller.coverFile.value.path.split('/').last,
            onPress: () {
              chooseProfilePhotoEditDialogBox(
                context: context,
                galleryFunction: () async {
                  await controller.pickCoverImage(
                    source: ImageSource.gallery,
                    context: context,
                  );
                },
                cameraFunction: () async {
                  await controller.pickCoverImage(
                    source: ImageSource.camera,
                    context: context,
                  );
                },
              );
            },
          ),

          _space20(context: context),

          _label(text: "Upload Tax Document", context: context),
          _space8(context: context),
          CustomDottedWidget(
            dottedColor: Colors.white,
            buttonColor: Colors.white,
            textColor: Colors.white,
            lable: controller.taxFile.value.path.split('/').last,
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
                controller.taxFile.value = File(file.path!);
              } else {
                MessageSnackBarWidget.errorSnackBarWidget(context: context, message: "No file selected");
              }
            },
          ),

          _space20(context: context),
        ],

        /// ================= PASSWORD =================
        _label(text: "Enter Password",context: context),
        _space8(context: context),
        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter Password",
          borderColor: ColorUtils.white202,
          enableBorderColor: ColorUtils.white202,
          focusedBorderColor: ColorUtils.secondaryColor,
          obscureText: controller.isPasswordVisible.value,
          controller: controller.passwordController.value,
          fillColor: ColorUtils.white253,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Padding(
            padding: EdgeInsets.all(20.r(context)),
            child: InkWell(
              onTap: () async {},
              child: ImageHelperWidget.assetImageWidget(
                context: context,
                height: 24.h(context),
                width: 24.w(context),
                imageString: ImageUtils.blackLockImage,
              ),
            ),
          ),
          suffixIcon:  Padding(
            padding: EdgeInsets.all(20.r(context)),
            child: InkWell(
              onTap: () async {
                if(controller.isPasswordVisible.value == false) {
                  controller.isPasswordVisible.value = true;
                } else {
                  controller.isPasswordVisible.value = false;
                }
              },
              child: ImageHelperWidget.assetImageWidget(
                context: context,
                height: 24.h(context),
                width: 24.w(context),
                imageString: controller.isPasswordVisible.value == false ?
                ImageUtils.blackVisibleImage : ImageUtils.blackUnvisibleImage,
              ),
            ),
          ),
        ),

        _space20(context: context),

        _label(text: "Enter Confirm Password",context: context),
        _space8(context: context),
        TextFormFieldWidget.build(
          context: context,
          hintText: "Enter Confirm Password",
          borderColor: ColorUtils.white202,
          enableBorderColor: ColorUtils.white202,
          focusedBorderColor: ColorUtils.secondaryColor,
          obscureText: controller.isConfirmPasswordVisible.value,
          controller: controller.confirmPasswordController.value,
          fillColor: ColorUtils.white253,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Padding(
            padding: EdgeInsets.all(20.r(context)),
            child: InkWell(
              onTap: () async {},
              child: ImageHelperWidget.assetImageWidget(
                context: context,
                height: 24.h(context),
                width: 24.w(context),
                imageString: ImageUtils.blackLockImage,
              ),
            ),
          ),
          suffixIcon:  Padding(
            padding: EdgeInsets.all(20.r(context)),
            child: InkWell(
              onTap: () async {
                if(controller.isConfirmPasswordVisible.value == false) {
                  controller.isConfirmPasswordVisible.value = true;
                } else {
                  controller.isConfirmPasswordVisible.value = false;
                }
              },
              child: ImageHelperWidget.assetImageWidget(
                context: context,
                height: 24.h(context),
                width: 24.w(context),
                imageString: controller.isConfirmPasswordVisible.value == false ?
                ImageUtils.blackVisibleImage : ImageUtils.blackUnvisibleImage,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _label({required String text,required BuildContext context}) {
    return TextHelperClass.headingTextWithoutWidth(
      context: context,
      alignment: Alignment.centerLeft,
      textAlign: TextAlign.start,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      textColor: ColorUtils.white253,
      text: text,
    );
  }

  Widget _space8({required BuildContext context}) {
    return SpaceHelperWidget.v(10.h(context));
  }


  Widget _space20({required BuildContext context}) {
    return SpaceHelperWidget.v(20.h(context));
  }


  Widget _spaceWidth10({required BuildContext context}) {
    return SpaceHelperWidget.h(10.w(context));
  }


  Widget _textFieldColumn({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      children: [
        _label(
          text:label,
          context:context,
        ),
        _space8(context: context),
        TextFormFieldWidget.build(
          context: context,
          hintText: hint,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          borderColor: ColorUtils.whiteNormalActive,
          enableBorderColor: ColorUtils.whiteNormalActive,
          focusedBorderColor: ColorUtils.secondaryColor,
        ),
      ],
    );
  }

  Widget _phoneField({required BuildContext context, required SignUpController controller}) {
    return TextFormFieldWidget.buildIntlPhoneField(
      context: context,
      key: ValueKey(controller.initialCountryCode.value),
      hintText: 'Enter your number',
      borderColor: ColorUtils.whiteNormalActive,
      enableBorderColor: ColorUtils.whiteNormalActive,
      focusedBorderColor: ColorUtils.secondaryColor,
      controller: controller.phoneNumberController.value,
      initialCountryCode: controller.initialCountryCode.value,
      onChanged: (phone) {
        controller.phoneNumber.value = phone.completeNumber.isNotEmpty ?
        phone.completeNumber :
        "${phone.countryCode}${phone.number}";
      },
      onCountryChanged: (country) {
        controller.initialCountryCode.value = country.code;
        controller.phoneNumber.value = "+${country.dialCode}${controller.phoneNumberController.value.text}";
      },
    );
  }


  void chooseProfilePhotoEditDialogBox({
    required BuildContext context,
    required Function() galleryFunction,
    required Function() cameraFunction,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true, // user must tap a button
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.hpm(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r(context)),
          ),
          child: IntrinsicHeight(
            child: Container(
              width: 428.w(context),
              decoration: BoxDecoration(
                color: ColorUtils.white238,
                borderRadius: BorderRadius.circular(20.r(context)),
              ),
              padding: EdgeInsets.fromLTRB(
                16.lpm(context),
                20.tpm(context),
                16.rpm(context),
                20.bpm(context),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// ===== Title Text =====

                  TextHelperClass.headingTextWithoutWidth(
                    context: context,
                    alignment: Alignment.center,
                    textAlign: TextAlign.center,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    textColor: ColorUtils.black64,
                    text: "Select Profile Picture",
                  ),


                  SpaceHelperWidget.v(32.h(context)),


                  ButtonHelperWidget.customButtonWidget(
                    context: context,
                    onPressed: galleryFunction,
                    text: "Choose Gallery",
                    borderRadius: 16,
                    backgroundColor: ColorUtils.white255,
                    fontWeight: FontWeight.w600,
                    textColor: ColorUtils.black48,
                  ),


                  SpaceHelperWidget.v(10.h(context)),


                  ButtonHelperWidget.customButtonWidget(
                    context: context,
                    onPressed: cameraFunction,
                    text: "Choose Camera",
                    borderRadius: 16,
                    backgroundColor: ColorUtils.white255,
                    fontWeight: FontWeight.w600,
                    textColor: ColorUtils.black48,
                  ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }





}
