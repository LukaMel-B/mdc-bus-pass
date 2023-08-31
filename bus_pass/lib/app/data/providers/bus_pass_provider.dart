// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:bus_pass/app/data/models/bus_pass_model.dart';
import 'package:bus_pass/app/modules/home/controllers/home_controller.dart';
import 'package:bus_pass/app/modules/home/views/pass_details_view.dart';
import 'package:bus_pass/app/modules/scanner/controllers/scanner_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class BusPassProvider extends GetConnect {
  static List<String> falseDatas = [];
  HomeController homeController = Get.find();
  Future<void> getBusPass(String id, BuildContext context) async {
    if (!falseDatas.contains(id)) {
      try {
        final response = await http.post(
          Uri.parse('https://app.conext.in/bus_pass/checker/'),
          body: {'pass_id': id},
        );

        final responseData = jsonDecode(response.body);
        if (responseData['Bus_Pass'] != "No Such Pass Alloted") {
          final busPass = busPassFromJson(response.body);
          homeController.busPass = busPass;
          Get.to(() => const PassDetailsView());
          homeController.bussPassController.clear();
        } else {
          final errorMessage = responseData['Bus_Pass'] as String;
          SnackbarMessage()
              .snackBarMessage('$errorMessage, Try again', context);
          falseDatas.add(id);
          homeController.bussPassController.clear();
        }
      } catch (e) {
        SnackbarMessage().snackBarMessage(
          'Invalid QR or Network error, Try again',
          context,
        );
        falseDatas.add(id);
      } finally {
        homeController.loading.value = false;
        homeController.loadingOff();
      }
    }
  }

  Future<void> getBusPassScan(String id, BuildContext context) async {
    ScannerController scannerController = Get.find();
    if (!falseDatas.contains(id)) {
      try {
        final response = await http.post(
          Uri.parse('https://app.conext.in/bus_pass/checker/'),
          body: {'pass_id': id},
        );
        final responseData = jsonDecode(response.body);
        if (responseData['Bus_Pass'] != "No Such Pass Alloted") {
          final busPass = busPassFromJson(response.body);
          homeController.busPass = busPass;
          Get.off(() => const PassDetailsView());
        } else {
          final errorMessage = responseData['Bus_Pass'] as String;
          SnackbarMessage()
              .snackBarMessage('$errorMessage! Try again', context);
          scannerController.isVisible = false;
          scannerController.update();
          falseDatas.add(id);
        }
      } catch (e) {
        SnackbarMessage().snackBarMessage(
          'Invalid QR or Network Error! Try again',
          context,
        );
        scannerController.isVisible = false;
        scannerController.update();
        falseDatas.add(id);
      }
    } else {
      scannerController.isVisible = false;
      scannerController.update();
    }
  }
}

class SnackbarMessage {
  snackBarMessage(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 3,
            backgroundColor: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                Text(
                  'Error!!!',
                  style: TextStyle(
                      fontSize: 25.sp,
                      fontFamily: 'Montserrat Bold',
                      color: const Color(0xFFDB1C0E)),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'Montserrat SemiBold',
                      color: const Color(0xDD0C0C0C)),
                ),
                const SizedBox(height: 20),
                const Divider(
                  color: Colors.black45,
                  thickness: .5,
                  height: .2,
                ),
                InkWell(
                  highlightColor: Colors.grey[200],
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontFamily: 'Montserrat SemiBold',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
