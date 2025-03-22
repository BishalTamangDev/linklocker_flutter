import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScannerResultPage extends StatefulWidget {
  const QrScannerResultPage({
    super.key,
    required this.qrData,
  });

  final Map<String, dynamic> qrData;

  @override
  State<QrScannerResultPage> createState() => _QrScannerResultPageState();
}

class _QrScannerResultPageState extends State<QrScannerResultPage> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    data = widget.qrData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text("Link Data"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: QrImageView(
                  data: widget.qrData.toString(),
                  version: QrVersions.auto,
                  size: 180.0,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(data.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
