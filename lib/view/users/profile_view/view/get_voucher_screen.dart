import 'dart:convert';
import 'dart:typed_data';

import 'package:discount_me_app/res/res.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GetVoucherScreen extends StatelessWidget {
  const GetVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GetVoucherController getVoucherController = Get.put(
      GetVoucherController(context: context),
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, onOpoInvoked) {
        Get.off(
          () => UserDashboardView(index: 3),
          duration: const Duration(milliseconds: 100),
          preventDuplicates: false,
        );
      },
      child: Scaffold(
        body: Container(
          height: 926.h(context),
          width: 428.w(context),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(ImageUtils.homeBg),
              alignment: Alignment.topRight,
              opacity: 0.5,
            ),
          ),
          child: SafeArea(
            child: Obx(
              () => Skeletonizer(
                effect: PulseEffect(),
                enabled: getVoucherController.isLoading.value,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await getVoucherController.getMyVouchersController(
                      context: context,
                    );
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.hpm(context),
                          ),
                          child: Column(
                            children: [
                              SpaceHelperWidget.v(20.h(context)),
                              UserProfileAppbarWidget(
                                title: "Voucher",
                                onTap: () {
                                  Get.off(
                                    () => UserDashboardView(index: 3),
                                    duration: const Duration(milliseconds: 100),
                                    preventDuplicates: false,
                                  );
                                },
                              ),
                              SpaceHelperWidget.v(30.h(context)),
                            ],
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.hpm(context),
                          ),
                          child: Obx(() {
                            final vouchers =
                                getVoucherController
                                    .getMyVouchersResponseModel
                                    .value
                                    .data ??
                                [];

                            if (vouchers.isEmpty &&
                                !getVoucherController.isLoading.value) {
                              return Center(
                                child: TextHelperClass.headingTextWithoutWidth(
                                  context: context,
                                  text: "No Voucher Available",
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  textColor: ColorUtils.black21,
                                  alignment: Alignment.center,
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: vouchers.length,
                              itemBuilder: (context, index) {
                                final voucher = vouchers[index];
                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: 14.bpm(context),
                                  ),
                                  padding: EdgeInsets.all(14.r(context)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      8.r(context),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.07),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child:
                                                TextHelperClass.headingTextWithoutWidth(
                                                  context: context,
                                                  text:
                                                      voucher
                                                          .order
                                                          ?.store
                                                          ?.name ??
                                                      "N/A",
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  textColor: ColorUtils.black29,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.hpm(context),
                                              vertical: 5.vpm(context),
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorUtils.green176
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    20.r(context),
                                                  ),
                                            ),
                                            child:
                                                TextHelperClass.headingTextWithoutWidth(
                                                  context: context,
                                                  text: _statusLabel(
                                                    voucher.status,
                                                  ),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  textColor:
                                                      ColorUtils.green139,
                                                ),
                                          ),
                                        ],
                                      ),
                                      SpaceHelperWidget.v(8.h(context)),
                                      _infoRow(
                                        context: context,
                                        title: "Order",
                                        value: voucher.order?.orderId ?? "N/A",
                                      ),
                                      _infoRow(
                                        context: context,
                                        title: "Total",
                                        value:
                                            "Rs ${voucher.order?.total ?? "N/A"}",
                                      ),
                                      _infoRow(
                                        context: context,
                                        title: "Expires",
                                        value: _formatDate(voucher.expiresAt),
                                      ),
                                      SpaceHelperWidget.v(12.h(context)),
                                      GestureDetector(
                                        onTap: () {
                                          _showVoucherScanDialog(
                                            context: context,
                                            barcodeUrl: voucher.barcodeUrl,
                                            code: voucher.code,
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: ColorUtils.green176
                                                .withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(
                                              20.r(context),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: Text(
                                                "Redeem Voucher",
                                                style: TextStyle(
                                                  fontSize: 14.sp(context),
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorUtils.green139,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.bpm(context)),
      child: Row(
        children: [
          SizedBox(
            width: 85.w(context),
            child: TextHelperClass.headingTextWithoutWidth(
              context: context,
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textColor: ColorUtils.black29,
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(
            child: TextHelperClass.headingTextWithoutWidth(
              context: context,
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: ColorUtils.black29,
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }

  Widget _barcodeImage({
    required BuildContext context,
    required String? barcodeUrl,
  }) {
    final Uint8List? bytes = _decodeBarcode(barcodeUrl);
    if (bytes == null) {
      return SizedBox(
        height: 120.h(context),
        child: Center(
          child: TextHelperClass.headingTextWithoutWidth(
            context: context,
            text: "Barcode unavailable",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textColor: ColorUtils.black29,
          ),
        ),
      );
    }

    return Image.memory(
      bytes,
      height: 140.h(context),
      width: 180.w(context),
      fit: BoxFit.contain,
    );
  }

  void _showVoucherScanDialog({
    required BuildContext context,
    required String? barcodeUrl,
    required String? code,
  }) {
    final Uint8List? bytes = _decodeBarcode(barcodeUrl);
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r(context)),
          ),
          child: Padding(
            padding: EdgeInsets.all(18.r(context)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      size: 24.r(context),
                      color: ColorUtils.black29,
                    ),
                  ),
                ),
                if (bytes == null)
                  SizedBox(
                    height: 180.h(context),
                    child: Center(
                      child: TextHelperClass.headingTextWithoutWidth(
                        context: context,
                        text: "Barcode unavailable",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textColor: ColorUtils.black29,
                      ),
                    ),
                  )
                else
                  Image.memory(
                    bytes,
                    width: 320.w(context),
                    height: 320.h(context),
                    fit: BoxFit.contain,
                  ),
                SpaceHelperWidget.v(12.h(context)),
                TextHelperClass.headingTextWithoutWidth(
                  context: context,
                  text: code ?? "N/A",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  textColor: ColorUtils.black29,
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Uint8List? _decodeBarcode(String? barcodeUrl) {
    if (barcodeUrl == null || barcodeUrl.isEmpty) return null;
    try {
      final base64String = barcodeUrl.contains(",")
          ? barcodeUrl.split(",").last
          : barcodeUrl;
      return base64Decode(base64String);
    } catch (_) {
      return null;
    }
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return "N/A";
    try {
      return DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.parse(value));
    } catch (_) {
      return value;
    }
  }

  String _statusLabel(String? value) {
    if (value == null || value.isEmpty) return "N/A";
    if (value.toLowerCase() == "generated") return "Active";
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
