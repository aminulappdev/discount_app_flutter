import 'package:flutter/material.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorOrderDeliveredWidget extends StatelessWidget {
  const VendorOrderDeliveredWidget({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.statusBackgroundColor,
    required this.statusTextColor,
    this.image = "",
    this.subtitle = "",
  });

  final String title;
  final String subtitle;
  final String image;
  final double amount;
  final String date;
  final String status;
  final Color statusBackgroundColor;
  final Color statusTextColor;

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r(context)),
        color: ColorUtils.greyLightHover,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r(context)),
              child: image.isEmpty
                  ? Image.asset(
                      ImageUtils.orderItemBg,
                      scale: 4,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      image,
                      height: 70.h(context),
                      width: 70.w(context),
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title text
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.blackColor,
                      fontSize: 20.sp(context),
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        fontSize: 14.sp(context),
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.blackColor.withOpacity(0.65),
                      ),
                    ),
                  ],
                  SizedBox(height: 6),
                  // Amount text
                  Text(
                    'Amount: \$${amount.toStringAsFixed(2)}',
                    style: GoogleFonts.urbanist(
                      fontSize: 18.sp(context),
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.blackColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Date text
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                              text: 'Date: ',
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w600,
                                color: ColorUtils.primaryColor,
                              ),
                            ),
                            TextSpan(
                              text: date,
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w600,
                                color: ColorUtils.blackColor,
                              ),
                            )
                          ]
                      )
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Ongoing background: #FFC60B;
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBackgroundColor,
                    borderRadius: BorderRadius.circular(5.r(context)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp(context),
                    ),
                  ),
                ),

                SizedBox(height: 30),
                // Arrow icon for navigation
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp(context),
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
