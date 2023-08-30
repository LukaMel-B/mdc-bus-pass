import 'dart:developer';

import 'package:bus_pass/app/data/providers/bus_pass_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;
  bool isVisible = false;
  int timesChecked = 0;
  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      if (isVisible == false || BusPassProvider.isCorrectScan == 'Failed') {
        isVisible = true;
        update();
      }
    });
  }

  getDetails(BuildContext context) async {
    if (result!.code != null && timesChecked == 0) {
      await BusPassProvider().getBusPassScan(result!.code!, context);
    }
  }

  Future<bool> onPop() async {
    isVisible = false;
    return Future.value(true);
  }

  @override
  void onClose() {
    log('onclose working');
    isVisible = false;
    qrController?.dispose();
    super.onClose();
  }
}
