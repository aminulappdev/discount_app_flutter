import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/users/chat_view/view/user_chat_vendor_list_screen.dart';
import 'package:discount_me_app/view/users/user_profile_order_view/view/user_profile_order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:discount_me_app/view/view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController(context: context));
    return Scaffold(
      body: Container(
        height: 926.h(context),
        width: 428.w(context),
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
          enabled: profileController.isLoading.value,
          child: SafeArea(
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [


                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                    child: Column(
                      children: [

                        UserProfileAppbarWidget(title: " Profile"),


                        SpaceHelperWidget.v(20.h(context)),


                      ],
                    ),
                  ),
                ),


                SliverFillRemaining(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      Get.delete<ProfileController>(force: true);
                      Get.to(()=>UserDashboardView(index: 3,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                    },
                    child: CustomScrollView(
                      slivers: [

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.hpm(context)),
                            child: Column(
                              children: [


                                SpaceHelperWidget.v(20.h(context)),

                                SizedBox(
                                  width: 170.w(context),
                                  height: 170.h(context),
                                  child: Stack(
                                    children: [

                                      // Profile Picture
                                      ImageHelperWidget.circleImageHelperWidget(
                                        width: 170,
                                        height: 170,
                                        verticalPadding: 2,
                                        horizontalPadding: 2,
                                        backgroundColor: ColorUtils.primaryColor,
                                        radius: 75,
                                        context: context,
                                        imageFile: profileController.userProfileResponseModel.value.data?.image != "" ?
                                        profileController.userProfileResponseModel.value.data?.image :  null,
                                        imageUrl: profileController.userProfileResponseModel.value.data?.image != null && profileController.profileImageFile.value.path == "" ?
                                        profileController.userProfileResponseModel.value.data?.image :
                                        null,
                                        imageAsset: profileController.profileImageFile.value.path == "" && profileController.userProfileResponseModel.value.data?.image == null ?
                                        ImageUtils.noImage : null,
                                      ),


                                      // Edit Icon Button
                                      Positioned(
                                        bottom: 14.h(context),
                                        right: 14.w(context),
                                        child: InkWell(
                                          onTap: () async {
                                            ProfileDialogBox().chooseProfilePhotoEditDialogBox(
                                              context: context,
                                              galleryFunction: () async {
                                                Map<String,dynamic> data = {
                                                  "name": profileController.userProfileResponseModel.value.data?.name ?? "",
                                                  "location": profileController.userProfileResponseModel.value.data?.location ?? "",
                                                  "contact": profileController.userProfileResponseModel.value.data?.contact ?? "",
                                                };
                                                await profileController.userPickProfileImage(
                                                  source: ImageSource.gallery,
                                                  context: context,
                                                  data: data,
                                                );
                                              },
                                              cameraFunction: () async {
                                                Map<String,dynamic> data = {
                                                  "name": profileController.userProfileResponseModel.value.data?.name ?? "",
                                                  "location": profileController.userProfileResponseModel.value.data?.location ?? "",
                                                  "contact": profileController.userProfileResponseModel.value.data?.contact ?? "",
                                                };
                                                await profileController.userPickProfileImage(
                                                  source: ImageSource.camera,
                                                  context: context,
                                                  data: data,
                                                );
                                              },
                                            );
                                          },


                                          child: ImageHelperWidget.assetImageWidget(
                                            context: context,
                                            height: 32.h(context),
                                            width: 32.w(context),
                                            imageString: ImageUtils.editButtonImage,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                                SpaceHelperWidget.v(20.h(context)),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    TextHelperClass.headingTextWithoutWidth(
                                      context: context,
                                      alignment: Alignment.center,
                                      fontSize: 18,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w700,
                                      textColor: ColorUtils.blackColor,
                                      text: profileController.formatBrokerName(profileController.userProfileResponseModel.value.data?.name ?? ""),
                                    ),

                                    SpaceHelperWidget.h(10.w(context)),


                                    InkWell(
                                      onTap: () async {
                                        ProfileDialogBox().nameEditDialogBox(
                                          context: context,
                                          firstNameController: profileController.firstNameController.value,
                                          lastNameController: profileController.lastNameController.value,
                                          title: "User Name",
                                          cancelFunction: () async {
                                            Navigator.pop(context);
                                          },
                                          editFunction: () async {
                                            Navigator.pop(context);
                                            profileController.isLoading.value = true;
                                            Map<String,dynamic> data = {
                                              "name" : "${profileController.firstNameController.value.text},${profileController.lastNameController.value.text}",
                                              "location": profileController.userProfileResponseModel.value.data?.location ?? "",
                                              "contact": profileController.userProfileResponseModel.value.data?.contact ?? "",
                                            };
                                            print(data);
                                            await profileController.userUpdateAccountController(
                                              context: context,
                                              data: data,
                                            );
                                          },
                                        );
                                      },
                                      child: ImageHelperWidget.assetImageWidget(
                                        context: context,
                                        height: 32.h(context),
                                        width: 32.w(context),
                                        imageString: ImageUtils.nameEditButtonImage,
                                      ),
                                    ),


                                  ],
                                ),


                                SpaceHelperWidget.v(40.h(context)),

                                ProfileItemWidget(
                                  title: "Edit Profile",
                                  icon: Image.asset(ImageUtils.userEdite, scale: 5,),
                                  navigateIcon: Icon(Icons.navigate_next, size: 24.r(context), color: Colors.black54,),
                                  onTap: () {
                                    Get.to(()=>UserProfileEditView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                  },
                                ),

                                ProfileItemWidget(
                                  title: "Card",
                                  icon: Image.asset(ImageUtils.shoppingCardIcon, scale: 5,),
                                  navigateIcon: Icon(Icons.navigate_next,size: 24.r(context), color: Colors.black54,),
                                  onTap: () {
                                    Get.to(()=>CartView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                  },
                                ),

                                ProfileItemWidget(
                                  title: "Order",
                                  icon: Image.asset(ImageUtils.userOrder, scale: 5,),
                                  navigateIcon: Icon(Icons.navigate_next,size: 24.r(context), color: Colors.black54,),
                                  onTap: () {
                                    Get.to(()=>UserProfileOrderView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                  },
                                ),

                                ProfileItemWidget( 
                                  title: "Picked Order",
                                  icon: Image.asset(ImageUtils.userOrder, scale: 5,),
                                  navigateIcon: Icon(Icons.navigate_next,size: 24.r(context), color: Colors.black54,),
                                  onTap: () {
                                    Get.to(()=>UserProfilePickedOrderView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                  },
                                ),
 
                                ProfileItemWidget(
                                  title: "Voucher",
                                  icon: Icon(Icons.confirmation_number_outlined, size: 24.r(context), color: ColorUtils.black29,),
                                  navigateIcon: Icon(Icons.navigate_next,size: 24.r(context), color: Colors.black54,),
                                  onTap: () {
                                    Get.to(()=>GetVoucherScreen(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                  },
                                ),


                                ProfileItemWidget(
                                  title: "Support Chat",
                                  icon: Image.asset(ImageUtils.chat, scale: 5,),
                                  navigateIcon: Icon(Icons.navigate_next,size: 24.r(context), color: Colors.black54,),
                                  onTap: () {
                                    Get.to(ChatListScreen());
                                  },
                                ),


                                ProfileItemWidget(
                                  title: "Notification",
                                  icon: Image.asset(ImageUtils.userNotification, scale: 5,),
                                  navigateIcon: Icon(Icons.navigate_next,size: 24.r(context), color: Colors.black54,),
                                  onTap: () {
                                    Get.to(()=>UserNotificationView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                  },
                                ),

                                ProfileItemWidget(
                                  title: "Settings",
                                  icon: Image.asset(ImageUtils.settingIcon, scale: 5,),
                                  navigateIcon: Icon(Icons.navigate_next,size: 24.r(context), color: Colors.black54,),
                                  onTap: () {
                                    Get.to(()=>UserProfileSettingView(),preventDuplicates: false,duration: Duration(milliseconds: 100));
                                  },
                                ),


                                ProfileItemWidget(title: "Logout",
                                  icon: Image.asset(ImageUtils.logout, scale: 5,),
                                  onTap: () {
                                    ProfileDialogBox().logOutDialogBox(
                                      context: context,
                                      cancelFunction: () async {
                                        Navigator.pop(context);
                                      },
                                      logoutFunction: () async {
                                        await LocalStorageUtils.remove(AppConstantUtils.loginResponse);
                                        await LocalStorageUtils.remove(AppConstantUtils.loginCredentialResponse);
                                        await Get.offAll(()=>SignInView(),duration: Duration(milliseconds: 100));
                                      },
                                    );
                                  },
                                  widget: SizedBox(),
                                ),

                              ],
                            ),
                          ),
                        )


                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),
        )),
      ),
    );
  }
}
