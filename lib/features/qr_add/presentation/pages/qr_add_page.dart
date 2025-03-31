import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/link/presentation/blocs/link_add/link_add_bloc.dart';
import 'package:linklocker/features/qr_add/presentation/blocs/qr_add_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrAddPage extends StatelessWidget {
  const QrAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrAddBloc(),
      child: QrAddView(),
    );
  }
}

class QrAddView extends StatefulWidget {
  const QrAddView({super.key});

  @override
  State<QrAddView> createState() => _QrAddViewState();
}

class _QrAddViewState extends State<QrAddView> {
  // variables
  bool doneScanning = false;
  MobileScannerController mobileScannerController = MobileScannerController();

  // function
  void _resumeScanning() {
    mobileScannerController.start();
    if (doneScanning) {
      setState(() {
        doneScanning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    mobileScannerController.start();
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
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("QR Scanner"),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Center(
        child: Column(
          children: [
            // heading
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64.0),
              child: Column(
                spacing: 16.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR Code inside the box.",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      "Scanning will start automatically.",
                      style: Theme.of(context).textTheme.labelLarge!,
                    ),
                  ),
                ],
              ),
            ),

            // scanner view
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: MobileScanner(
                      controller: mobileScannerController,
                      onDetect: (data) {
                        if (!doneScanning) {
                          BarcodeCapture barcodeCapture = data;
                          context.read<QrAddBloc>().add(QrAddScannedEvent(barcodeCapture: barcodeCapture));
                          setState(() {
                            doneScanning = true;
                          });
                          // mobileScannerController.pause();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),

            // listener
            Expanded(
              child: Column(
                spacing: 12.0,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Column(
                    spacing: 16.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      Opacity(
                        opacity: 0.6,
                        child: Text("Scanning"),
                      ),
                    ],
                  ),
                  BlocConsumer<QrAddBloc, QrAddState>(
                    listenWhen: (previous, current) => current is QrAddActionState,
                    buildWhen: (previous, current) => current is! QrAddActionState,
                    listener: (context, state) {
                      if (state is QrAddNavigateActionState) {
                        context.read<LinkAddBloc>().add(LinkAddQrDataLoadEvent(linkEntity: state.linkEntity, contacts: state.contacts));
                        mobileScannerController.pause();
                        context.push('/link/qr_add').then((_) => _resumeScanning());
                      } else if (state is QrAddInvalidActionState) {
                        _resumeScanning();
                      }
                    },
                    builder: (context, state) {
                      if (state is QrAddInvalidState) {
                        return Opacity(
                          opacity: 0.6,
                          child: Text(
                            "Invalid Qr",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is QrAddValidState) {
                        return Opacity(
                          opacity: 0.6,
                          child: Text(
                            "Valid Qr",
                            style: TextStyle(color: Colors.green),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
