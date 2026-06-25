import 'dart:convert';

import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class UserShareReviewScreen extends StatefulWidget {
  const UserShareReviewScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  State<UserShareReviewScreen> createState() => _UserShareReviewScreenState();
}

class _UserShareReviewScreenState extends State<UserShareReviewScreen> {
  final TextEditingController reviewController = TextEditingController();
  double rating = 2;
  bool isSubmitting = false;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  Future<void> submitReview(BuildContext context) async {
    if (isSubmitting) return;

    final reviewText = reviewController.text.trim();
    if (reviewText.isEmpty) {
      MessageSnackBarWidget.errorSnackBarWidget(
        context: context,
        message: "Please write your review",
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final loginData = jsonDecode(
      LocalStorageUtils.getString(AppConstantUtils.loginResponse)!,
    );

    await BaseApiUtils.post(
      url: ApiUtils.reviews,
      authorization: loginData["data"]?["accessToken"]?.toString() ?? "",
      data: {
        "product": widget.productId,
        "stars": rating.toInt(),
        "text": reviewText,
      },
      onSuccess: (message, data) async {
        setState(() {
          isSubmitting = false;
        });
        MessageSnackBarWidget.successSnackBarWidget(
          context: context,
          message: message,
        );
        if (!mounted) return;
        Navigator.of(context).pop(true);
      },
      onFail: (message, data) {
        setState(() {
          isSubmitting = false;
        });
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
      onExceptionFail: (message, data) {
        setState(() {
          isSubmitting = false;
        });
        MessageSnackBarWidget.errorSnackBarWidget(
          context: context,
          message: message,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(ImageUtils.homeBg),
          alignment: Alignment.topRight,
          opacity: 0.5,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.heightBox,
                  HomeResturantAppBar(),
                  50.heightBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '4.8 *',
                                style: GoogleFonts.urbanist(
                                  fontSize: 20.sp(context),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '1,64,002 Ratings\n&\n 5,922 Reviews',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontSize: 10.sp(context),
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              children: [
                                ratingBar(5, 0.8, context),
                                ratingBar(4, 0.6, context),
                                ratingBar(3, 0.4, context),
                                ratingBar(2, 0.2, context),
                                ratingBar(1, 0.1, context),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          'What is your rate?',
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp(context),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 12,
                          ),
                          onRatingUpdate: (value) {
                            setState(() {
                              rating = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: reviewController,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: "Write your review",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r(context)),
                            borderSide: BorderSide(
                              color: ColorUtils.white202,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r(context)),
                            borderSide: BorderSide(
                              color: ColorUtils.white202,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r(context)),
                            borderSide: BorderSide(
                              color: ColorUtils.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: isSubmitting
                            ? LoadingHelperWidget.loadingHelperWidget(
                                context: context,
                              )
                            : Roundbutton(
                                title: "Share Review",
                                buttonColor: ColorUtils.primaryColor,
                                borderRadius: 8.r(context),
                                onTap: () {
                                  submitReview(context);
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ratingBar(int starCount, double fillPercent, BuildContext context) {
    return Row(
      children: [
        Text(
          '$starCount *',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 5.h(context),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                widthFactor: fillPercent,
                child: Container(
                  height: 5.h(context),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
