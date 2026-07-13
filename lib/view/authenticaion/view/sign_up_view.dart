
import 'dart:ui';
import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/authenticaion/widget/sign_up_widget/role_wise_form_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});
  
  final SignUpController signUpController = Get.put(SignUpController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          Get.to(()=>WelcomeView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
        },
        child: Obx(()=>Container(
          height: 926.h(context),
          width: 428.w(context),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
          
              Container(
                height: 926.h(context),
                width: 428.w(context),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageUtils.authBg),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
          
          
          
              /// Blur Effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  height: 926.h(context),
                  width: 428.w(context),
                  color: ColorUtils.black36,
                ),
              ),
          
          
              Container(
                height: 926.h(context),
                width: 428.w(context),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                            
                            
                      CustomAppBarContainer().authScreenAppBar(
                        context: context,
                        title: "Create Account",
                        onPress: () async {
                          Get.to(()=>WelcomeView(),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                        },
                      ),
                            
                            
                      SliverToBoxAdapter(
                        child: Container(
                          width: 428.w(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.hpm(context),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              
                              
                              SpaceHelperWidget.v(20.h(context)),
                            

                              ProfileImagePicker().profileImagePicker(
                                context: context,
                                selectedRole: signUpController.selectedRole.value,
                                signUpController: signUpController,
                              ),


                              SpaceHelperWidget.v(20.h(context)),


                              RoleSelectRadioButton().roleSelectRadioButton(
                                context: context,
                                roles: const ["User", "Rider", "Vendor", "Broker"],
                                signUpController: signUpController,
                                onChanged: (value) async {
                                  signUpController.changeRole(value);

                                  await signUpController.resetFunction();
                                },
                              ),
                            
                            
                              CustomSpaceWidget.spacerWidget(spaceHeight: 20.h(context)),


                              RoleWiseFormField().roleWiseFormFields(
                                context: context,
                                selectedRole: signUpController.selectedRole.value,
                                controller: signUpController,
                              ),

                              SpaceHelperWidget.v(20.h(context)),

                              signUpController.isSubmit.value == true ?
                              LoadingHelperWidget.loadingHelperWidget(
                                context: context,
                              ) :
                              ButtonHelperWidget.customButtonWidget(
                                context: context,
                                onPressed: () async {
                                  final role = signUpController.selectedRole.value;

                                  String? error = _validateForm(role);

                                  if (error != null) {
                                    MessageSnackBarWidget.errorSnackBarWidget(context: context, message: error);
                                    return;
                                  }

                                  signUpController.isSubmit.value = true;

                                  try {
                                    switch (role) {
                                      case "User":
                                        await signUpController.getUserSignUpResponse(
                                          image: signUpController.imageFile.value,
                                          document: signUpController.documentFile.value,
                                          data: _userData(),
                                          context: context,
                                        );
                                        break;

                                      case "Rider":
                                        await signUpController.getRiderSignUpResponse(
                                          image: signUpController.imageFile.value,
                                          document: signUpController.drivingLicenceFile.value,
                                          data: _riderData(),
                                          context: context,
                                        );
                                        break;

                                      case "Vendor":
                                        await signUpController.getVendorSignUpResponse(
                                          coverImage: signUpController.coverFile.value,
                                          taxFile: signUpController.taxFile.value,
                                          data: _vendorData(),
                                          context: context,
                                        );
                                        break;
                                      default:
                                        await signUpController.getBrokerSignUpResponse(
                                          data: _brokerData(),
                                          profileImageFile: signUpController.imageFile.value,
                                          context: context,
                                        );
                                    }
                                  } catch (e) {
                                    signUpController.isSubmit.value = false;
                                  }
                                },
                                text: "Sign Up",
                                borderRadius: 8,
                                backgroundColor: ColorUtils.primaryColor,
                                fontWeight: FontWeight.w700,
                                textColor: ColorUtils.white255,
                              ),

                              SpaceHelperWidget.v(20.h(context)),


                              RichTextHelperWidget.headingRichText(
                                context: context,
                                alignment: Alignment.center,
                                textAlign: TextAlign.center,
                                textSpans: [
                                  CustomTextSpan(
                                    text: "Already have an account? ",
                                    fontSize: 20,
                                    color: ColorUtils.white253,
                                    fontWeight: FontWeight.w500,
                                  ).toTextSpan(),
                                  CustomTextSpan(
                                    text: "Log In",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.orange125,
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      Get.to(()=>SignInView(), duration: const Duration(milliseconds: 100),preventDuplicates: false);
                                    },
                                  ).toTextSpan(),
                                ],
                              ),

                              SpaceHelperWidget.v(40.h(context)),
                            
                            
                            ],
                          ),
                        ),
                      ),
                            
                            
                            
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }


  String? _validateForm(String role) {
    final c = signUpController;

    // Common validations
    if (c.emailController.value.text.isEmpty) return "Please Enter Your Email";
    if (c.phoneNumber.value.isEmpty) return "Please Enter Your Contact Number";
    if (c.passwordController.value.text.isEmpty) return "Please Enter Your Password";
    if (c.confirmPasswordController.value.text.isEmpty) return "Please Enter Your Confirm Password";
    if (c.confirmPasswordController.value.text != c.passwordController.value.text) {
      return "Password is Not Matching";
    }

    // Role-specific validations
    switch (role) {
      case "User":
        if (c.imageFile.value.path.isEmpty) return "Please Pick A Profile Image";
        if (c.firstNameController.value.text.isEmpty) return "Please Enter Your First Name";
        if (c.lastNameController.value.text.isEmpty) return "Please Enter Your Last Name";
        if (c.documentFile.value.path.isEmpty) {
          return "Please upload your document file to verify";
        }
        break;

      case "Rider":
        if (c.imageFile.value.path.isEmpty) return "Please Pick A Profile Image";
        if (c.locationController.value.text.isEmpty) return "Please Enter Your Location";
        if (c.drivingLicenceFile.value.path.isEmpty) {
          return "Please upload your driving Licence Document";
        }
        if (c.firstNameController.value.text.isEmpty) return "Please Enter Your First Name";
        if (c.lastNameController.value.text.isEmpty) return "Please Enter Your Last Name";
        break;

      case "Vendor":
        if (c.locationController.value.text.isEmpty) return "Please Enter Your Location";
        if (c.lat.value.isEmpty || c.long.value.isEmpty) return "Please Pick Your Location";
        if (c.restaurantNameController.value.text.isEmpty) return "Please Enter Your Restaurant Name";
        if (c.restaurantDescriptionController.value.text.isEmpty) return "Please Enter Your Restaurant Description";
        if (c.taxFile.value.path.isEmpty) return "Please upload your tax Document";
        break;

      default:
        if (c.imageFile.value.path.isEmpty) return "Please Pick A Profile Image";
        if (c.locationController.value.text.isEmpty) return "Please Enter Your Location";
        if (c.firstNameController.value.text.isEmpty) return "Please Enter Your First Name";
        if (c.lastNameController.value.text.isEmpty) return "Please Enter Your Last Name";
    }

    return null;
  }


  Map<String, dynamic> _userData() {
    final c = signUpController;

    return {
      "name": "${c.firstNameController.value.text.trim()} ${c.lastNameController.value.text.trim()}",
      "password": c.passwordController.value.text,
      "email": c.emailController.value.text,
      "contact": c.phoneNumber.value,
      if (c.selectedFirstResponderType.value.isNotEmpty)
        "first_responder_type": c.selectedFirstResponderType.value,
    };
  }


  Map<String, dynamic> _riderData() {
    final c = signUpController;

    return {
      "name": "${c.firstNameController.value.text.trim()} ${c.lastNameController.value.text.trim()}",
      "password": c.passwordController.value.text,
      "email": c.emailController.value.text,
      "location": c.locationController.value.text,
      "contact": c.phoneNumber.value,
    };
  }


  Map<String, dynamic> _brokerData() {
    final c = signUpController;

    return {
      "name": "${c.firstNameController.value.text.trim()} ${c.lastNameController.value.text.trim()}",
      "password": c.passwordController.value.text,
      "email": c.emailController.value.text,
      "location": c.locationController.value.text,
      "contact": c.phoneNumber.value,
    };
  }


  Map<String, dynamic> _vendorData() {
    final c = signUpController;

    return {
      "email": c.emailController.value.text,
      "password": c.passwordController.value.text,
      "store_name": c.restaurantNameController.value.text,
      "store_description": c.restaurantDescriptionController.value.text,
      "contact": c.phoneNumber.value,
      "broker_referral": c.referralCodeController.value.text,
      "location": {
        "coordinates": [
          double.parse(c.long.value),
          double.parse(c.lat.value)
        ]
      }
    };
  }



}
