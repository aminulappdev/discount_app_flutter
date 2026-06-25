import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StripeConnectRequiredView extends StatelessWidget {
  StripeConnectRequiredView({
    super.key,
    required this.role,
  });

  final String role;
  final StripeConnectController stripeConnectController =
      Get.put(StripeConnectController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ColorUtils.white253,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 21.hpm(context),
              vertical: 24.vpm(context),
            ),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  height: 96.h(context),
                  width: 96.w(context),
                  decoration: BoxDecoration(
                    color: ColorUtils.green247,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: ColorUtils.primaryColor,
                    size: 46.r(context),
                  ),
                ),
                SpaceHelperWidget.v(28.h(context)),
                TextHelperClass.headingTextWithoutWidth(
                  context: context,
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  textColor: ColorUtils.black29,
                  text: "Your Stripe account must be connected",
                ),
                SpaceHelperWidget.v(12.h(context)),
                TextHelperClass.headingTextWithoutWidth(
                  context: context,
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: ColorUtils.black114,
                  maxLines: 3,
                  text: "Connect your Stripe account to receive payouts before continuing to the dashboard.",
                ),
                const Spacer(),
                Obx(
                  () => stripeConnectController.isLoading.value
                      ? LoadingHelperWidget.loadingHelperWidget(
                          context: context,
                        )
                      : ButtonHelperWidget.customButtonWidget(
                          context: context,
                          onPressed: () async {
                            await stripeConnectController.createOnboardingLink(
                              context: context,
                              role: role,
                            );
                          },
                          text: "Connect Now",
                          borderRadius: 8,
                          backgroundColor: ColorUtils.primaryColor,
                          fontWeight: FontWeight.w700,
                          textColor: ColorUtils.white255,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
