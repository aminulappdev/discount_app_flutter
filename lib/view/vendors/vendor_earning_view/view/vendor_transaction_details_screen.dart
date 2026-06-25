import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/view/vendors/vendor_earning_view/model/vendor_earnings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:intl/intl.dart';

class VendorTransactionDetailsScreen extends StatelessWidget {
  const VendorTransactionDetailsScreen({
    super.key,
    required this.earningItem,
  });

  final VendorEarningItem earningItem;

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;
    final amount = _asDouble(earningItem.amount);
    final companyFee = _asDouble(earningItem.companyFee);
    final finalAmount = amount - companyFee;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          title: "Earnings",
          color: ColorUtils.blackColor,
          fontSize: 24.sp(context),
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r(context)),
                  child: earningItem.payerImage == null
                      ? Image.asset(
                          ImageUtils.transactionDetailsBg,
                          height: 90.h(context),
                          width: 90.w(context),
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          earningItem.payerImage.toString(),
                          height: 90.h(context),
                          width: 90.w(context),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              ImageUtils.transactionDetailsBg,
                              height: 90.h(context),
                              width: 90.w(context),
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
                10.widthBox,
                Expanded(
                  child: Container(
                    width: width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _userDetails(
                          title: "Full name :",
                          value: earningItem.payerName?.toString() ?? "N/A",
                          context: context,
                        ),
                        5.heightBox,
                        _userDetails(
                          title: "Transaction :",
                          value: earningItem.transactionId?.toString() ?? "N/A",
                          context: context,
                        ),
                        5.heightBox,
                        _userDetails(
                          title: "Date :",
                          value: _formatDate(earningItem.date),
                          context: context,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            40.heightBox,
            CustomText(
              title: "Transaction details :",
              fontWeight: FontWeight.w600,
              fontSize: 18.sp(context),
              color: Colors.black,
            ),
            20.heightBox,
            _transactionDetailsWidget(
              title: "Transaction ID : ",
              value: earningItem.transactionId?.toString() ?? "N/A",
              context: context,
            ),
            8.heightBox,
            _transactionDetailsWidget(
              title: "Payer name:",
              value: earningItem.payerName?.toString() ?? "N/A",
              context: context,
            ),
            8.heightBox,
            _transactionDetailsWidget(
              title: "Date:",
              value: _formatDate(earningItem.date),
              context: context,
            ),
            8.heightBox,
            _transactionDetailsWidget(
              title: "Received amount:",
              value: "\$ ${amount.toStringAsFixed(2)}",
              context: context,
            ),
            8.heightBox,
            _transactionDetailsWidget(
              title: "Company fee:",
              value: "\$ ${companyFee.toStringAsFixed(2)}",
              context: context,
            ),
            8.heightBox,
            _transactionDetailsWidget(
              title: "Final Amount:",
              value: "\$ ${finalAmount.toStringAsFixed(2)}",
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _userDetails({required String title, required String value, required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomText(
            title: title,
            fontSize: 16.sp(context),
            fontWeight: FontWeight.w400,
            color: ColorUtils.blackColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16.sp(context),
              fontWeight: FontWeight.w600,
              color: ColorUtils.blackColor,
            ),
          ),
        ),
      ],
    );
  }


  Widget _transactionDetailsWidget({required String title, required String value, required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomText(
            title: title,
            fontSize: 16.sp(context),
            fontWeight: FontWeight.w400,
            color: Color(0xff47586E),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16.sp(context),
              fontWeight: FontWeight.w400,
              color: Color(0xff47586E),
            ),
          ),
        ),
      ],
    );
  }

  double _asDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? "0") ?? 0;
  }

  String _formatDate(dynamic value) {
    if (value == null) return "N/A";
    try {
      return DateFormat("dd-MM-yyyy").format(DateTime.parse(value.toString()));
    } catch (_) {
      return value.toString();
    }
  }
}
