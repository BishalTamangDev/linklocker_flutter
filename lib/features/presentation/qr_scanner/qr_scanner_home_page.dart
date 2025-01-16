import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_functions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerHomePage extends StatefulWidget {
  const QrScannerHomePage({super.key});

  @override
  State<QrScannerHomePage> createState() => _QrScannerHomePageState();
}

class _QrScannerHomePageState extends State<QrScannerHomePage> {
  // variables
  bool doneScanning = false;
  Barcode? _barcode;
  bool validQr = true;
  MobileScannerController mobileScannerController = MobileScannerController();

  // function
  _resumeScanning() {
    mobileScannerController.start();
    setState(() {
      doneScanning = false;
    });
  }

  @override
  void dispose() {
    mobileScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("QR Scanner"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  spacing: 10.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Text>[
                    Text(
                      "Place the QR Code inside the box.",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text("Scanning will start automatically.",
                        style: Theme.of(context).textTheme.labelLarge!),
                  ],
                ),
              ),

              // scanner appears here
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: MobileScanner(
                      controller: mobileScannerController,
                      onDetect: (barcodes) async {
                        if (!doneScanning) {
                          setState(() {
                            _barcode = barcodes.barcodes.firstOrNull;
                          });

                          if (_barcode != null) {
                            try {
                              Map<String, dynamic> jsonData =
                                  jsonDecode(_barcode!.rawValue.toString());

                              setState(() {
                                doneScanning = true;
                              });

                              // valid data
                              if (AppFunctions.checkQrValidity(jsonData)) {
                                mobileScannerController.stop();
                                setState(() {
                                  validQr = true;
                                });

                                context
                                    .push('/link/qr_add', extra: jsonData)
                                    .then((_) => _resumeScanning());
                              } else {
                                mobileScannerController.start();
                                setState(() {
                                  validQr = false;
                                  doneScanning = false;
                                });
                                _resumeScanning();
                              }
                            } catch (e) {
                              setState(() {
                                validQr = false;
                                doneScanning = false;
                              });
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  spacing: 24.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !validQr
                        ? Text(
                            "Invalid QR",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.red),
                          )
                        : SizedBox(),
                    doneScanning
                        ? Text(
                            "Successful!",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.green),
                          )
                        : Column(
                            spacing: 16.0,
                            children: [
                              CircularProgressIndicator(),
                              Opacity(
                                opacity: 0.6,
                                child: const Text("Scanning"),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
