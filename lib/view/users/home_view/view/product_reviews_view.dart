import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductReviewsView extends StatelessWidget {
  ProductReviewsView({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    final ProductReviewsController productReviewsController = Get.put(
      ProductReviewsController(
        context: context,
        productId: productId,
      ),
    );

    return Scaffold(
      backgroundColor: ColorUtils.white253,
      body: Obx(
        () => Skeletonizer(
          effect: PulseEffect(),
          enabled: productReviewsController.isLoading.value,
          child: Container(
            height: 926.h(context),
            width: 428.w(context),
            decoration: BoxDecoration(
              color: ColorUtils.white253,
              image: DecorationImage(
                image: AssetImage(ImageUtils.homeBg),
                alignment: Alignment.topRight,
                opacity: 0.5,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.hpm(context),
                  vertical: 16.vpm(context),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: ColorUtils.black29,
                            size: 22.r(context),
                          ),
                        ),
                        Expanded(
                          child: TextHelperClass.headingTextWithoutWidth(
                            context: context,
                            alignment: Alignment.center,
                            textAlign: TextAlign.center,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            textColor: ColorUtils.black29,
                            text: "All Reviews",
                          ),
                        ),
                        SizedBox(width: 48.w(context)),
                      ],
                    ),
                    SpaceHelperWidget.v(20.h(context)),
                    Expanded(
                      child: _reviewList(
                        context: context,
                        productReviewsController: productReviewsController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewList({
    required BuildContext context,
    required ProductReviewsController productReviewsController,
  }) {
    final reviews =
        productReviewsController.productReviewsResponseModel.value.data ?? [];

    if (!productReviewsController.isLoading.value && reviews.isEmpty) {
      return Center(
        child: TextHelperClass.headingTextWithoutWidth(
          context: context,
          alignment: Alignment.center,
          textAlign: TextAlign.center,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          textColor: ColorUtils.black114,
          text: "No reviews found",
        ),
      );
    }

    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Container(
          width: 428.w(context),
          margin: EdgeInsets.only(bottom: 12.bpm(context)),
          padding: EdgeInsets.symmetric(
            horizontal: 14.hpm(context),
            vertical: 14.vpm(context),
          ),
          decoration: BoxDecoration(
            color: ColorUtils.white255,
            borderRadius: BorderRadius.circular(8.r(context)),
            boxShadow: [
              BoxShadow(
                color: ColorUtils.blue108,
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(8, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ImageHelperWidget.circleImageHelperWidget(
                    width: 46,
                    height: 46,
                    verticalPadding: 1,
                    horizontalPadding: 1,
                    backgroundColor: ColorUtils.orange213,
                    radius: 25,
                    context: context,
                    imageAsset: review.user?.image == null
                        ? ImageUtils.noImage
                        : null,
                    imageUrl: review.user?.image,
                  ),
                  SpaceHelperWidget.h(12.w(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.user?.name?.toString() ?? "Unknown user",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(
                            fontSize: 17.sp(context),
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.black29,
                          ),
                        ),
                        SpaceHelperWidget.v(4.h(context)),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (starIndex) {
                                final stars =
                                    int.tryParse(review.stars.toString()) ?? 0;
                                return Icon(
                                  starIndex < stars
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16.r(context),
                                );
                              }),
                            ),
                            SpaceHelperWidget.h(8.w(context)),
                            Text(
                              _formatDate(review.createdAt),
                              style: GoogleFonts.urbanist(
                                fontSize: 12.sp(context),
                                fontWeight: FontWeight.w500,
                                color: ColorUtils.black114,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SpaceHelperWidget.v(12.h(context)),
              Text(
                review.text?.toString() ?? "",
                style: GoogleFonts.urbanist(
                  fontSize: 15.sp(context),
                  fontWeight: FontWeight.w500,
                  color: ColorUtils.black61,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) return "";
    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(value.toString()));
    } catch (_) {
      return value.toString();
    }
  }
}
