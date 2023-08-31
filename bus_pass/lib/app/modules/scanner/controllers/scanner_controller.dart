import 'package:bus_pass/app/data/providers/bus_pass_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;
  bool isVisible = false;
  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      if (isVisible == false &&
          BusPassProvider.falseDatas.contains(scanData.code!) == false) {
        isVisible = true;
        update();
      }
    });
  }

  getDetails(BuildContext context) async {
    if (result!.code != null) {
      await BusPassProvider().getBusPassScan(result!.code!, context);
    }
  }

  Future<bool> onPop() async {
    isVisible = false;
    return Future.value(true);
  }

  @override
  void onClose() {
    isVisible = false;
    qrController?.dispose();
    super.onClose();
  }
}
