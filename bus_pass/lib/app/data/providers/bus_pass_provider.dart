// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:bus_pass/app/data/models/bus_pass_model.dart';
import 'package:bus_pass/app/modules/home/controllers/home_controller.dart';
import 'package:bus_pass/app/modules/home/controllers/details_controller.dart';
import 'package:bus_pass/app/modules/home/controllers/scanner_controller.dart';
import 'package:bus_pass/app/modules/home/views/pass_details_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class BusPassProvider extends GetConnect {
  static String isCorrectScan = 'Success';
  DetailsController scannerController = Get.find();
  HomeController homeController = Get.find();
  Future<void> getBusPass(String id, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://app.conext.in/bus_pass/checker/'),
        body: {'pass_id': id},
      );

      final responseData = jsonDecode(response.body);
      if (responseData['Bus_Pass'] != "No Such Pass Alloted") {
        final busPass = busPassFromJson(response.body);
        scannerController.busPass = busPass;
        SnackbarMessage()
            .snackBarMessage('Your pass sent successfully', context);
        Get.to(() => const PassDetailsView());
        homeController.bussPassController.clear();
      } else {
        final errorMessage = responseData['Bus_Pass'] as String;
        SnackbarMessage().snackBarMessage(errorMessage, context);
      }
    } catch (e) {
      log(e.toString());
      SnackbarMessage().snackBarMessage(
        'Oops! Something went wrong! Check again and try',
        context,
      );
    } finally {
      homeController.loading.value = false;
      homeController.loadingOff();
    }
  }

  Future<void> getBusPassScan(String id, BuildContext context) async {
    ScannerController scanController = Get.find();
    DetailsController scannerController = Get.find();
    try {
      final response = await http.post(
        Uri.parse('https://app.conext.in/bus_pass/checker/'),
        body: {'pass_id': id},
      );

      final responseData = jsonDecode(response.body);

      if (responseData['Bus_Pass'] != "No Such Pass Alloted") {
        final busPass = busPassFromJson(response.body);
        scannerController.busPass = busPass;
        scanController.isVisible = false;
        Get.off(() => const PassDetailsView());
        homeController.bussPassController.clear();
        isCorrectScan = 'Successfull';
      } else {
        final errorMessage = responseData['Bus_Pass'] as String;
        SnackbarMessage().snackBarMessage(errorMessage, context);
        isCorrectScan = 'Failed';
      }
    } catch (e) {
      log(e.toString());
      SnackbarMessage().snackBarMessage(
        'Oops! Something went wrong! Check again and try',
        context,
      );
      isCorrectScan = 'Failed';
    } finally {
      homeController.loading.value = false;
      homeController.loadingOff();
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
