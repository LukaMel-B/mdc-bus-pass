// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:bus_pass/app/data/models/bus_pass_model.dart';
import 'package:bus_pass/app/modules/home/controllers/home_controller.dart';
import 'package:bus_pass/app/modules/home/views/pass_details_view.dart';
import 'package:bus_pass/app/modules/scanner/controllers/scanner_controller.dart';
import 'package:flutter/material.dart';
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
          SnackbarMessage().snackBarMessage(errorMessage, context);
          falseDatas.add(id);
        }
      } catch (e) {
        SnackbarMessage().snackBarMessage(
          'Oops! Something went wrong! Check again and try',
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
              .snackBarMessage('$errorMessage, Try again', context);
          scannerController.isVisible = false;
          scannerController.update();
          falseDatas.add(id);
        }
      } catch (e) {
        SnackbarMessage().snackBarMessage(
          'Invalid QR or Network error, Try again',
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
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text(message),
      backgroundColor: const Color(0xff1E1E1E),
      duration: const Duration(seconds: 4),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
