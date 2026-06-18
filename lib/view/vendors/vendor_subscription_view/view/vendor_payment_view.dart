import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:discount_me_app/view/view.dart';



class VendorPaymentView extends StatefulWidget {
  const VendorPaymentView({super.key,required this.paymentUrl});
  final String paymentUrl;
  @override
  State<VendorPaymentView> createState() => _VendorPaymentViewState();
}

class _VendorPaymentViewState extends State<VendorPaymentView> {
  late final WebViewController _controller;
  final VendorPaymentController vendorPaymentController = Get.put(VendorPaymentController());
  bool _paymentHandled = false;
  @override
  void initState() {
    super.initState();
    // Initialize WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Show loading indicator if needed
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            // Page loaded
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            // Handle errors
            print('Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) async {
            print("hello ${request.url}");
            final lowerUrl = request.url.toLowerCase();
            if (!_paymentHandled && (lowerUrl.contains('success') || lowerUrl.contains('failure') || lowerUrl.contains('cancel'))) {
              _paymentHandled = true;
              await vendorPaymentController.getPaymentController(context: context, paymentUrl: request.url);
              //Handle payment result
              //_handlePaymentResult(request.url);

              return NavigationDecision.prevent; // Prevent navigation in WebView
            }
            if (_paymentHandled) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl)); // Load the Paymob URL
  }

  // Handle payment result based on redirect URL
  // void _successPage({required PaymentSuccessFullResponse paymentSuccessFullResponse}) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentConfirmationScreen(paymentSuccessFullResponse: paymentSuccessFullResponse)));
  // }


  // void _failedPage() {
  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionScreen()));
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
