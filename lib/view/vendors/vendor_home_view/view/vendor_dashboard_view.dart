import 'package:discount_me_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:get/get.dart';

class VendorDashboardView extends StatelessWidget {
  const VendorDashboardView({super.key,required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final DashboardVendorController dashboardVendorController = Get.put(DashboardVendorController(
      index: index,
      width: (MediaQuery.of(context).size.width / 1),
    ), permanent: true,);
    return Obx(()=> Scaffold(
      body: dashboardVendorController.pages[dashboardVendorController.selectedIndex.value],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom, // ✅ key fix
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return SizedBox(
              height: 75.h(context),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  /// 🔥 Notch Background
                  ClipPath(
                    clipper: UserNotchedNavBarClipper(
                      notchCenter: dashboardVendorController.notchX.value,
                      context: context,
                    ),
                    child: Container(
                      height: 75.h(context),
                      color: const Color(0xFF16A34A),
                    ),
                  ),

                  /// 🔵 Top Circle
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    top: -6.h(context),
                    left: dashboardVendorController.notchX.value - (5.w(context)),
                    child: Container(
                      width: 10.w(context),
                      height: 10.w(context),
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  /// 🧭 Items

                  Row(
                    children: List.generate(dashboardVendorController.items.length, (index) {
                      final item = dashboardVendorController.items[index];
                      final bool isSelected = dashboardVendorController.selectedIndex.value == index;
                      return Expanded(
                        child: InkWell(
                          onTap: () {
                            dashboardVendorController.changeIndex(index: index, width: width);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              isSelected ?
                              SpaceHelperWidget.v(12.h(context)) :
                              SizedBox.shrink(),

                              isSelected ?
                              ImageHelperWidget.assetImageWidget(
                                context: context,
                                height: 24.h(context),
                                width: 24.w(context),
                                imageString: item['select'] ?? "",
                              ) :
                              ImageHelperWidget.assetImageWidget(
                                context: context,
                                height: 24.h(context),
                                width: 24.w(context),
                                imageString: item['unselected'] ?? "",
                              ),


                              SpaceHelperWidget.v(6.h(context)),

                              isSelected ?
                              TextHelperClass.headingTextWithoutWidth(
                                context: context,
                                alignment: Alignment.center,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                textColor: isSelected ? ColorUtils.white253 : ColorUtils.white253,
                                text: item['label'] ?? "",
                              ) :
                              SizedBox.shrink(),

                              SpaceHelperWidget.v(4.h(context)),


                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }
}


class VendorNotchedNavBarClipper extends CustomClipper<Path> {
  final double notchCenter;
  final BuildContext context;

  VendorNotchedNavBarClipper({
    required this.notchCenter,
    required this.context,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    final r = 13.5.r(context);
    final d = 13.5.r(context);
    final s = 6.r(context);

    /// Start
    path.lineTo(notchCenter - r - s, 0);

    /// Left entry curve
    path.quadraticBezierTo(
      notchCenter - r,
      0,
      notchCenter - r,
      s,
    );

    /// Left curve
    path.quadraticBezierTo(
      notchCenter - r * 0.55,
      d,
      notchCenter,
      d,
    );

    /// Right curve
    path.quadraticBezierTo(
      notchCenter + r * 0.55,
      d,
      notchCenter + r,
      s,
    );

    /// Right exit curve
    path.quadraticBezierTo(
      notchCenter + r,
      0,
      notchCenter + r + s,
      0,
    );

    /// Close
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
