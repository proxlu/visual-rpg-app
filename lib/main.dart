import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importe para usar SystemChrome
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    // Configura a cor da barra de status
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF2d2d2d), // Cor da barra de status
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2d2d2d), // Cor de fundo do Scaffold
      body: SafeArea(
        child: Stack(
          children: [
            // WebView
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri("https://93.189.91.101:8443/")),
              initialSettings: InAppWebViewSettings(
                transparentBackground: true, // Torna o fundo transparente
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onProgressChanged: (controller, progressValue) {
                setState(() {
                  progress = progressValue / 100;
                });
              },
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
              },
              onLoadStart: (controller, url) {
                // Quando o carregamento começar, só atualiza o estado
                setState(() {});
              },
              onLoadStop: (controller, url) {
                // Quando o carregamento terminar, atualiza o estado
                setState(() {});
              },
            ),

            // Círculo de carregamento ficará atrás da WebView
            if (progress < 1.0)
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF2d2d2d), // Cor de fundo do círculo
                  child: Center(
                    child: SizedBox(
                      width: 70,  // Aumenta o tamanho do círculo
                      height: 70, // Aumenta o tamanho do círculo
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 10.0, // Aumentando o tamanho do círculo
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
