import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeController extends GetxController {
  Barcode? result;
  String scannedData = '';
  GlobalKey<FormState> formKey = GlobalKey();
  var isVisible = false.obs;
  var loading = false.obs;
  var visibleH = 18.h.obs;
  var visibleW = 20.w.obs;
  loadingOn() {
    isVisible.value = true;
    visibleH.value = 8.h;
    visibleW.value = 32.w;
    update();
  }

  loadingOff() {
    isVisible.value = false;
    visibleH.value = 18.h;
    visibleW.value = 20.w;
    update();
  }

  TextEditingController bussPassController = TextEditingController();
  final textfieldDeco = InputDecoration(
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF5A5A5A), width: .8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF5A5A5A), width: .8),
      ),
      contentPadding: const EdgeInsets.all(15),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF5A5A5A), width: .8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF5A5A5A), width: .8),
      ),
      hintText: 'Enter Pass ID...',
      hintStyle: TextStyle(
        fontSize: 17.sp,
        fontFamily: 'Montserrat SemiBold',
        color: const Color(0xffADADAD),
      ));
}
