import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

/// PASS 인증 웹뷰 페이지
class PassWebViewPage extends StatefulWidget {
  /// 인증 URL
  final String url;

  /// 생성자
  const PassWebViewPage({super.key, required this.url});

  @override
  State<PassWebViewPage> createState() => _PassWebViewPageState();
}

class _PassWebViewPageState extends State<PassWebViewPage> {
  InAppWebViewController? _controller;

  Future<void> _launchExternalApp(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  bool _isExternalScheme(String url) {
    return url.startsWith("intent://") ||
        url.startsWith("ispmobile://") ||
        url.startsWith("kftc-bankpay://") ||
        url.startsWith("market://");
  }

  bool _isSuccessRedirect(String url) {
    return url.contains("/pass-success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("본인 인증")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          supportMultipleWindows: true,
          useShouldOverrideUrlLoading: true,
          javaScriptCanOpenWindowsAutomatically: true,
        ),
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final url = navigationAction.request.url.toString();
          print("WEBVIEW URL: $url");

          if (_isExternalScheme(url)) {
            await _launchExternalApp(url);
            return NavigationActionPolicy.CANCEL;
          }

          if (_isSuccessRedirect(url)) {
            if (context.mounted) {
              Navigator.pop(context, true);
            }
            return NavigationActionPolicy.CANCEL;
          }

          return NavigationActionPolicy.ALLOW;
        },
        onCreateWindow: (controller, createWindowAction) async {
          final url = createWindowAction.request.url;

          if (url != null) {
            await _controller?.loadUrl(urlRequest: URLRequest(url: url));
          }

          return true;
        },
      ),
    );
  }
}
