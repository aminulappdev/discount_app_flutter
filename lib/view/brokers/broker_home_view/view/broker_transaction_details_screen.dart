import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/brokers/broker_home_view/model/broker_earnings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BrokerTransactionDetailsScreen extends StatelessWidget {
  const BrokerTransactionDetailsScreen({
    super.key,
    required this.earningItem,
  });

  final BrokerEarningItem earningItem;

  @override
  Widget build(BuildContext context) {
    final amount = _asDouble(earningItem.amount);
    final companyFee = _asDouble(earningItem.companyFee);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r(context)),
                  child: _payerImage(context),
                ),
                10.widthBox,
                Expanded(
                  child: Column(
                    children: [
                      _detailsRow(
                        context,
                        "Full name:",
                        earningItem.payerName?.toString() ?? "N/A",
                      ),
                      5.heightBox,
                      _detailsRow(
                        context,
                        "Transaction:",
                        earningItem.transactionId?.toString() ?? "N/A",
                      ),
                      5.heightBox,
                      _detailsRow(context, "Date:", _formatDate(earningItem.date)),
                    ],
                  ),
                ),
              ],
            ),
            40.heightBox,
            CustomText(
              title: "Transaction details:",
              fontWeight: FontWeight.w600,
              fontSize: 18.sp(context),
              color: Colors.black,
            ),
            20.heightBox,
            _detailsRow(
              context,
              "Transaction ID:",
              earningItem.transactionId?.toString() ?? "N/A",
            ),
            8.heightBox,
            _detailsRow(
              context,
              "Payer name:",
              earningItem.payerName?.toString() ?? "N/A",
            ),
            8.heightBox,
            _detailsRow(context, "Date:", _formatDate(earningItem.date)),
            8.heightBox,
            _detailsRow(context, "Received amount:", "\$ ${amount.toStringAsFixed(2)}"),
            8.heightBox,
            _detailsRow(context, "Company fee:", "\$ ${companyFee.toStringAsFixed(2)}"),
            8.heightBox,
            _detailsRow(
              context,
              "Broker earning:",
              "\$ ${amount.toStringAsFixed(2)}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _payerImage(BuildContext context) {
    final image = earningItem.payerImage?.toString();
    if (image == null || image.isEmpty) {
      return _fallbackImage(context);
    }
    return Image.network(
      image,
      height: 90.h(context),
      width: 90.w(context),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackImage(context),
    );
  }

  Widget _fallbackImage(BuildContext context) {
    return Image.asset(
      ImageUtils.transactionDetailsBg,
      height: 90.h(context),
      width: 90.w(context),
      fit: BoxFit.cover,
    );
  }

  Widget _detailsRow(BuildContext context, String title, String value) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            title: title,
            fontSize: 16.sp(context),
            fontWeight: FontWeight.w400,
            color: const Color(0xff47586E),
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
              fontWeight: FontWeight.w500,
              color: const Color(0xff47586E),
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
