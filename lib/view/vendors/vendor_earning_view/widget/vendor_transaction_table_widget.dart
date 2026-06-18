import 'package:discount_me_app/view/vendors/vendor_earning_view/view/vendor_transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:get/get.dart';

class VendorTransactionTableWidget extends StatelessWidget {
  VendorTransactionTableWidget({super.key});

  final List<Map<String, String>> transactions = List.generate(
    8,
        (index) => {
      'name': 'Robert Fox',
      'account': '(516) 831-1111',
      'date': '02-24-2024',
      'amount': '\$200',
    }, 
  );

  @override
   Widget build(BuildContext context) {
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
              DataColumn(label: Text('Acc Number')),
              DataColumn(
                label: Row(
                  children: [
                    Text('Date'),
                    Icon(Icons.arrow_upward, size: 16),
                  ],
                ),
              ),
              DataColumn(label: Text('Amount')),
            ],
            rows: transactions.asMap().entries.map(
                  (entry) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text((entry.key + 1).toString().padLeft(2, '0')),
                      onTap: () => Get.to(VendorTransactionDetailsScreen()),
                    ),

                    DataCell(
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(ImageUtils.homeProfileAvatar),
                            radius: 15,
                          ),
                          SizedBox(width: 10),
                          // Instead of Flexible, use Expanded inside the Row
                          Expanded(
                            child: Text(
                              entry.value['name']!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Get.to(VendorTransactionDetailsScreen()),
                    ),

                    DataCell(
                      Text(entry.value['account']!),
                      onTap: () => Get.to(VendorTransactionDetailsScreen()),
                    ),
                    DataCell(
                      Text(entry.value['date']!),
                      onTap: () => Get.to(VendorTransactionDetailsScreen()),
                    ),
                    DataCell(
                      Text(entry.value['amount']!),
                      onTap: () => Get.to(VendorTransactionDetailsScreen()),
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
}
