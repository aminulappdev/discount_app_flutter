import 'dart:async';

import 'package:discount_me_app/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeConnectWebView extends StatefulWidget {
  const StripeConnectWebView({
    super.key,
    required this.onboardingUrl,
    required this.role,
  });

  final String onboardingUrl;
  final String role;

  @override
  State<StripeConnectWebView> createState() => _StripeConnectWebViewState();
}

class _StripeConnectWebViewState extends State<StripeConnectWebView> {
  late final WebViewController _controller;
  final StripeConnectController stripeConnectController =
      Get.put(StripeConnectController());

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint("Stripe Connect page started loading: $url");
          },
          onPageFinished: (String url) {
            debugPrint("Stripe Connect page finished loading: $url");
            unawaited(_handleRenderedCallbackIfNeeded(url));
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Stripe Connect error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (stripeConnectController
                .isStripeConnectCallbackUrl(request.url)) {
              await stripeConnectController.handleOnboardingCallback(
                context: context,
                callbackUrl: request.url,
                role: widget.role,
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.onboardingUrl));
  }

  Future<void> _handleRenderedCallbackIfNeeded(String url) async {
    if (!stripeConnectController.isStripeConnectCallbackUrl(url)) return;

    try {
      final responseText = await _controller.runJavaScriptReturningResult(
        "document.body.innerText",
      );

      if (!mounted) return;
      await stripeConnectController.handleRenderedOnboardingResponse(
        context: context,
        responseText: responseText.toString(),
        role: widget.role,
      );
    } catch (e) {
      debugPrint("Stripe Connect rendered callback read failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
