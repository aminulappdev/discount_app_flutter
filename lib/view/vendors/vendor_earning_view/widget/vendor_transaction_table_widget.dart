import 'package:discount_me_app/view/vendors/vendor_earning_view/view/vendor_transaction_details_screen.dart';
import 'package:discount_me_app/view/vendors/vendor_earning_view/model/vendor_earnings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VendorTransactionTableWidget extends StatelessWidget {
  const VendorTransactionTableWidget({
    super.key,
    required this.earnings,
  });

  final List<VendorEarningItem> earnings;

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
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(ColorUtils.secondaryColor),
            headingTextStyle: TextStyle(color: Colors.white),
            columns: <DataColumn>[
              DataColumn(label: Text('#SI')),
              DataColumn(label: Text('Full Name')),
              DataColumn(label: Text('Transaction ID')),
              DataColumn(
                label: Row(
                  children: [
                    Text('Date'),
                    Icon(Icons.arrow_upward, size: 16),
                  ],
                ),
              ),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Company Fee')),
              DataColumn(label: Text('Net')),
            ],
            rows: earnings.asMap().entries.map(
                  (entry) {
                final item = entry.value;
                final amount = _asDouble(item.amount);
                final companyFee = _asDouble(item.companyFee);
                return DataRow(
                  cells: [
                    DataCell(
                      Text((entry.key + 1).toString().padLeft(2, '0')),
                      onTap: () => _openDetails(item),
                    ),

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
                          SizedBox(width: 10),
                          // Instead of Flexible, use Expanded inside the Row
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

                    DataCell(
                      Text(item.transactionId?.toString() ?? "N/A"),
                      onTap: () => _openDetails(item),
                    ),
                    DataCell(
                      Text(_formatDate(item.date)),
                      onTap: () => _openDetails(item),
                    ),
                    DataCell(
                      Text("\$${amount.toStringAsFixed(2)}"),
                      onTap: () => _openDetails(item),
                    ),
                    DataCell(
                      Text("\$${companyFee.toStringAsFixed(2)}"),
                      onTap: () => _openDetails(item),
                    ),
                    DataCell(
                      Text("\$${(amount - companyFee).toStringAsFixed(2)}"),
                      onTap: () => _openDetails(item),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
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

  void _openDetails(VendorEarningItem item) {
    Get.to(
      () => VendorTransactionDetailsScreen(
        earningItem: item,
      ),
      duration: const Duration(milliseconds: 100),
      preventDuplicates: false,
    );
  }
}
