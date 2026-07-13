import 'package:discount_me_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProfileEditView extends StatelessWidget {
  const UserProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileEditController userProfileEditController = Get.put(UserProfileEditController(context: context));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop,onPopInvoked) {
        Get.to(()=>UserDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
      },
      child: Scaffold(
        body: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: userProfileEditController.isLoading.value,
          child: Container(
            height: 926.h(context),
            width: 428.w(context),
            decoration: BoxDecoration(
              color: ColorUtils.whiteColor,
              image: DecorationImage(
                image: AssetImage(ImageUtils.homeBg),
                alignment: Alignment.topRight,
                opacity: 0.5,
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                      child: Column(
                        children: [

                          UserProfileAppbarWidget(
                            onTap: () async {
                              Get.to(()=>UserDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                            },
                            title: "Edit Profile",
                          ),

                          SpaceHelperWidget.v(20.h(context)),



                        ],
                      ),
                    ),
                  ),


                  SliverFillRemaining(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        Get.delete<BrokerEditProfileController>(force: true);
                        Get.to(()=>BrokerEditProfileView(),preventDuplicates: false);
                      },
                      child: CustomScrollView(
                        slivers: [

                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [

                                    SizedBox(
                                      width: 170.w(context),
                                      height: 170.h(context),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [

                                          // Profile Picture
                                          ImageHelperWidget.circleImageHelperWidget(
                                            width: 170,
                                            height: 170,
                                            context: context,
                                            verticalPadding: 2,
                                            horizontalPadding: 2,
                                            backgroundColor: ColorUtils.primaryColor,
                                            radius: 75,
                                            imageFile: userProfileEditController.userProfileResponseModel.value.data?.image != "" ?
                                            userProfileEditController.userProfileResponseModel.value.data?.image :  null,
                                            imageUrl: userProfileEditController.userProfileResponseModel.value.data?.image != null && userProfileEditController.profileImageFile.value.path == "" ?
                                            userProfileEditController.userProfileResponseModel.value.data?.image :
                                            null,
                                            imageAsset: userProfileEditController.profileImageFile.value.path == "" && userProfileEditController.userProfileResponseModel.value.data?.image == null ?
                                            ImageUtils.noImage : null,
                                          ),


                                          // Edit Icon Button
                                          Positioned(
                                            bottom: 10.h(context),
                                            right: 10.w(context),
                                            child: InkWell(
                                              onTap: () async {
                                                ProfileDialogBox().chooseProfilePhotoEditDialogBox(
                                                  context: context,
                                                  galleryFunction: () async {
                                                    await userProfileEditController.pickProfileImage(
                                                      source: ImageSource.gallery,
                                                    );
                                                  },
                                                  cameraFunction: () async {
                                                    await userProfileEditController.pickProfileImage(
                                                      source: ImageSource.camera,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: 40.w(context),
                                                height: 40.w(context),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: ColorUtils.secondaryColor,
                                                  size: 28.r(context),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),



                                    SpaceHelperWidget.v(15.h(context)),


                                    Row(
                                      children: [

                                        Expanded(
                                          child: Column(
                                            children: [

                                              TextHelperClass.headingTextWithoutWidth(
                                                context: context,
                                                alignment: Alignment.centerLeft,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                textColor: ColorUtils.black96,
                                                text: "First Name",
                                              ),

                                              SpaceHelperWidget.v(10.h(context)),


                                              TextFormFieldWidget.build(
                                                context: context,
                                                hintText: "First Name",
                                                controller: userProfileEditController.firstNameController.value,
                                                keyboardType: TextInputType.emailAddress,
                                                borderColor: ColorUtils.whiteNormalActive,
                                                enableBorderColor: ColorUtils.whiteNormalActive,
                                                focusedBorderColor: ColorUtils.secondaryColor,
                                              ),

                                            ],
                                          ),
                                        ),


                                        SpaceHelperWidget.h(10.w(context)),


                                        Expanded(
                                          child: Column(
                                            children: [

                                              TextHelperClass.headingTextWithoutWidth(
                                                context: context,
                                                alignment: Alignment.centerLeft,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                textColor: ColorUtils.black96,
                                                text: "Last Name",
                                              ),

                                              SpaceHelperWidget.v(10.h(context)),


                                              TextFormFieldWidget.build(
                                                context: context,
                                                hintText: "Last Name",
                                                controller: userProfileEditController.lastNameController.value,
                                                keyboardType: TextInputType.emailAddress,
                                                borderColor: ColorUtils.whiteNormalActive,
                                                enableBorderColor: ColorUtils.whiteNormalActive,
                                                focusedBorderColor: ColorUtils.secondaryColor,
                                              ),

                                            ],
                                          ),
                                        ),


                                      ],
                                    ),


                                    SpaceHelperWidget.v(15.h(context)),


                                    TextHelperClass.headingTextWithoutWidth(
                                      context: context,
                                      alignment: Alignment.centerLeft,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      textColor: ColorUtils.black96,
                                      text: "Email Address",
                                    ),

                                    SpaceHelperWidget.v(10.h(context)),


                                    TextFormFieldWidget.build(
                                      context: context,
                                      hintText: "Enter your email",
                                      readOnly: true,
                                      controller: userProfileEditController.emailController.value,
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
                                            imageString: ImageUtils.emailImage,
                                          ),
                                        ),
                                      ),
                                    ),



                                    SpaceHelperWidget.v(15.h(context)),

                                    TextHelperClass.headingTextWithoutWidth(
                                      context: context,
                                      alignment: Alignment.centerLeft,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      textColor: ColorUtils.black96,
                                      text: "Location",
                                    ),

                                    SpaceHelperWidget.v(10.h(context)),


                                    TextFormFieldWidget.build(
                                      context: context,
                                      hintText: "Enter your location",
                                      controller: userProfileEditController.locationController.value,
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


                                    SpaceHelperWidget.v(15.h(context)),


                                    TextHelperClass.headingTextWithoutWidth(
                                      context: context,
                                      alignment: Alignment.centerLeft,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      textColor: ColorUtils.blackColor,
                                      text: "Contact Number",
                                    ),

                                    SpaceHelperWidget.v(10.h(context)),


                                    TextFormFieldWidget.buildIntlPhoneField(
                                      context: context,
                                      key: ValueKey(userProfileEditController.initialCountryCode.value),
                                      hintText: 'Enter your number',
                                      borderColor: ColorUtils.whiteNormalActive,
                                      enableBorderColor: ColorUtils.whiteNormalActive,
                                      focusedBorderColor: ColorUtils.secondaryColor,
                                      controller: userProfileEditController.phoneNumberController.value,
                                      initialCountryCode: userProfileEditController.initialCountryCode.value,
                                      onChanged: (phone) {
                                        userProfileEditController.phoneNumber.value = phone.completeNumber.isNotEmpty ?
                                        phone.completeNumber :
                                        "${phone.countryCode}${phone.number}";
                                      },
                                      onCountryChanged: (country) {
                                        userProfileEditController.initialCountryCode.value = country.code;
                                        userProfileEditController.phoneNumber.value = "+${country.dialCode}${userProfileEditController.phoneNumberController.value.text}";
                                      },
                                    ),

                                    SpaceHelperWidget.v(20.h(context)),


                                    userProfileEditController.isSubmit.value == true ?
                                    LoadingHelperWidget.loadingHelperWidget(
                                      context: context,
                                    ) :
                                    ButtonHelperWidget.customButtonWidget(
                                      context: context,
                                      onPressed: () async {
                                        userProfileEditController.isSubmit.value = true;
                                        Map<String,dynamic> data = {
                                          "name" : "${userProfileEditController.firstNameController.value.text},${userProfileEditController.lastNameController.value.text}",
                                          "location": userProfileEditController.locationController.value.text,
                                          "contact": userProfileEditController.phoneNumber.value == "" ?
                                          userProfileEditController.userProfileResponseModel.value.data?.contact :
                                          userProfileEditController.phoneNumber.value,
                                          "isCbtHolder": false,
                                        };
                                        print(data);
                                        await userProfileEditController.userUpdateAccountController(
                                          context: context,
                                          data: data,
                                          profileImageFile: userProfileEditController.profileImageFile.value,
                                        );
                                      },
                                      text: "Update",
                                      borderRadius: 8,
                                      backgroundColor:  ColorUtils.secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      textColor: ColorUtils.white255,
                                    ),


                                    SpaceHelperWidget.v(20.h(context)),




                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
