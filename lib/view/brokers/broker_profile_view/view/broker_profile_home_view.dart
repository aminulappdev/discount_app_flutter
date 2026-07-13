import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/brokers/broker_profile_view/view/broker_setting_view.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BrokerProfileHomeView extends StatelessWidget {
  BrokerProfileHomeView({super.key});


  @override
  Widget build(BuildContext context) {
    BrokerProfileHomeController brokerProfileHomeController = Get.put(BrokerProfileHomeController(context: context));
    return Scaffold(
      body: SafeArea(
        child: Obx(()=>Skeletonizer(
          effect: PulseEffect(),
          enabled: brokerProfileHomeController.isLoading.value,
          child: Container(
            height: 926.h(context),
            width: 428.w(context),
            decoration: BoxDecoration(
              color: ColorUtils.whiteColor,
            ),
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [

                SliverToBoxAdapter(
                  child: Column(
                    children: [

                      SpaceHelperWidget.v(20.h(context)),

                      UserProfileAppbarWidget(title: " Profile"),

                    ],
                  ),
                ),





                SliverFillRemaining(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      Get.delete<BrokerProfileHomeController>(force: true);
                      Get.to(()=>BrokerDashboardView(index: 3),preventDuplicates: false);
                    },
                    child: CustomScrollView(
                      slivers: [

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.vpm(context),horizontal: 16.hpm(context)),
                            child: SingleChildScrollView(
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
                                          imageFile: brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.image != "" ?
                                          brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.image :  null,
                                          imageUrl: brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.image != null && brokerProfileHomeController.profileImageFile.value.path == "" ?
                                          brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.image :
                                          null,
                                          imageAsset: brokerProfileHomeController.profileImageFile.value.path == "" && brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.image == null ?
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
                                                    "name" : brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.name ?? "",
                                                    "location": brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.location ?? "",
                                                    "contact": brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.contact ?? "",
                                                  };
                                                  await brokerProfileHomeController.pickProfileImage(
                                                      source: ImageSource.gallery,
                                                      context: context,
                                                      data: data,
                                                      brokerId: brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.sId ?? ""
                                                  );
                                                },
                                                cameraFunction: () async {
                                                  Map<String,dynamic> data = {
                                                    "name" : brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.name ?? "",
                                                    "location": brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.location ?? "",
                                                    "contact": brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.contact ?? "",
                                                  };
                                                  await brokerProfileHomeController.pickProfileImage(
                                                    source: ImageSource.camera,
                                                    context: context,
                                                    data: data,
                                                    brokerId: brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.sId ?? "",
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
                                        text: brokerProfileHomeController.formatBrokerName( brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.name ?? ""),
                                      ),

                                      SpaceHelperWidget.h(10.w(context)),


                                      InkWell(
                                        onTap: () async {
                                          ProfileDialogBox().nameEditDialogBox(
                                            context: context,
                                            firstNameController: brokerProfileHomeController.firstNameController.value,
                                            lastNameController: brokerProfileHomeController.lastNameController.value,
                                            title: "Broker Name",
                                            cancelFunction: () async {
                                              Navigator.pop(context);
                                            },
                                            editFunction: () async {
                                              Navigator.pop(context);
                                              brokerProfileHomeController.isLoading.value = true;
                                              Map<String,dynamic> data = {
                                                "name" : "${brokerProfileHomeController.firstNameController.value.text},${brokerProfileHomeController.lastNameController.value.text}",
                                                "location": brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.location ?? "",
                                                "contact": brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.contact ?? "",
                                              };
                                              print(data);
                                              await brokerProfileHomeController.brokerUpdateAccountController(
                                                context: context,
                                                data: data,
                                                brokerId: brokerProfileHomeController.getBrokerProfileResponseModel.value.data?.sId ?? "",
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
                                      Get.to(()=>BrokerEditProfileView(),preventDuplicates: false);
                                    },
                                  ),


                                  ProfileItemWidget(
                                    title: "Settings",
                                    icon: Image.asset(ImageUtils.settingIcon, scale: 5,),
                                    navigateIcon: Icon(Icons.navigate_next, size: 24.r(context), color: Colors.black54,),
                                    onTap: () {
                                      Get.to(()=>BrokerSettingView(),preventDuplicates: false);
                                    },
                                  ),


                                  ProfileItemWidget(
                                    title: "Logout",
                                    icon: Image.asset(ImageUtils.logout, scale: 5,),
                                    navigateIcon: Icon(Icons.navigate_next, size: 24.r(context), color: Colors.black54,),
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
                                  ),



                                ],
                              ),
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



