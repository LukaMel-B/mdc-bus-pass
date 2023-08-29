import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({Key? key}) : super(key: key);

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  String scannedData = '';
  QRViewController? qrController;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    }
    qrController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (qrController != null && mounted) {
      qrController!.pauseCamera();
      qrController!.resumeCamera();
    }
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('Scan Bus Pass QR'),
        ),
        backgroundColor: Colors.black54,
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: onQRView,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.teal[200]!,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: scanArea),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(scannedData),
            )
          ],
        ));
  }

  void onQRView(QRViewController qrViewController) {
    qrViewController = qrController!;
    qrViewController.scannedDataStream.listen((data) {
      setState(() {
        result = data;
        scannedData = data.code!;
        log(scannedData);
      });
    });
    qrController!.pauseCamera();
    qrController!.resumeCamera();
  }

  @override
  void dispose() {
    qrController?.dispose();
    log('dispose worked');
    super.dispose();
  }
}
