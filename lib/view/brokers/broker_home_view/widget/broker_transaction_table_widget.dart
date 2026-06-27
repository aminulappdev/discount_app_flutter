import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/brokers/broker_home_view/model/broker_earnings_response_model.dart';
import 'package:discount_me_app/view/brokers/broker_home_view/view/broker_transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BrokerTransactionTableWidget extends StatelessWidget {
  const BrokerTransactionTableWidget({
    super.key,
    required this.earnings,
  });

  final List<BrokerEarningItem> earnings;

  @override
  Widget build(BuildContext context) {
    if (earnings.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.vpm(context)),
        child: TextHelperClass.headingTextWithoutWidth(
          context: context,
          alignment: Alignment.center,
          textAlign: TextAlign.center,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          textColor: ColorUtils.black114,
          text: "No earnings found",
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: DataTable(
          showCheckboxColumn: false,
          headingRowColor: MaterialStateProperty.all(ColorUtils.secondaryColor),
          headingTextStyle: const TextStyle(color: Colors.white),
          columns: const [
            DataColumn(label: Text('#SI')),
            DataColumn(label: Text('Full Name')),
            DataColumn(label: Text('Transaction ID')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Company Fee')),
          ],
          rows: earnings.asMap().entries.map((entry) {
            final item = entry.value;
            final amount = _asDouble(item.amount);
            final companyFee = _asDouble(item.companyFee);
            return DataRow(
              cells: [
                _cell((entry.key + 1).toString().padLeft(2, '0'), item),
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: item.payerImage == null
                            ? AssetImage(ImageUtils.homeProfileAvatar)
                            : NetworkImage(item.payerImage.toString())
                                as ImageProvider,
                        radius: 15,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 120.w(context),
                        child: Text(
                          item.payerName?.toString() ?? "N/A",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _openDetails(item),
                ),
                _cell(item.transactionId?.toString() ?? "N/A", item),
                _cell(_formatDate(item.date), item),
                _cell("\$${amount.toStringAsFixed(2)}", item),
                _cell("\$${companyFee.toStringAsFixed(2)}", item),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  DataCell _cell(String value, BrokerEarningItem item) {
    return DataCell(Text(value), onTap: () => _openDetails(item));
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

  void _openDetails(BrokerEarningItem item) {
    Get.to(
      () => BrokerTransactionDetailsScreen(earningItem: item),
      duration: const Duration(milliseconds: 100),
      preventDuplicates: false,
    );
  }
}
