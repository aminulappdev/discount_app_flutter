import 'package:discount_me_app/view/users/user_profile_order_view/view/user_profile_order_view.dart';
import 'package:flutter/material.dart';

class UserProfilePickedOrderView extends StatelessWidget {
  const UserProfilePickedOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserProfileOrderView(
      title: "Picked Order",
      emptyMessage: "No Picked Order Available",
      fulfillmentType: "pickup",
      showTabs: false,
      fixedStatus: "received",
    );
  }
}
