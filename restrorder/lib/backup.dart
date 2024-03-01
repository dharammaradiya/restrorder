import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() => runApp(const MaterialApp(home: InAppWebViewExample()));

class InAppWebViewExample extends StatelessWidget {
  const InAppWebViewExample({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter InAppWebView example'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('https://flutter.dev')),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          ),
        ),
      ),
    );
  }
}
