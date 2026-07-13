import 'package:discount_me_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:discount_me_app/view/view.dart';

class UserNotificationView extends StatelessWidget {
  const UserNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: SafeArea(
          child: CustomScrollView(
            slivers: [


              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.hpm(context), vertical: 16.vpm(context)),
                  child: Column(
                    children: [

                      UserProfileAppbarWidget(
                        title: "Notification",
                        onTap: () {
                          Get.to(()=>UserDashboardView(index: 0,),duration: const Duration(milliseconds: 100),preventDuplicates: false);
                        },
                      ),


                    ],
                  ),
                ),
              ),
              
              SliverFillRemaining(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.hpm(context),),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SpaceHelperWidget.v(30.h(context)),


                      Expanded(
                        child: ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20.bpm(context)),
                                child: _notificationWidget(context: context),
                              ),
                            );
                          },
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationWidget({required BuildContext context}) {
    return Row(
      children: [

        Row(
          children: [
            Container(
              width: 16.w(context), height: 16.h(context),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black
              ),
            ),
            10.widthBox,
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r(context)),
                  color: ColorUtils.greenLight
              ),
              child: Image.asset(ImageUtils.userNotification, scale: 4,),
            )
          ],
        ),
        20.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextHelperClass.headingTextWithoutWidth(
              context: context,
              text: "Welcome to Discount Me",
              textColor: ColorUtils.blackColor,
              fontWeight: FontWeight.w400,
              fontSize: 23,
            ),
            TextHelperClass.headingTextWithoutWidth(
              context: context,
              text: "1 day ago",
              textColor: ColorUtils.whiteDarkActive,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ],
        )
      ],
    );
  }
}
