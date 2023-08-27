// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:bus_pass/app/data/models/bus_pass_model.dart';
import 'package:bus_pass/app/modules/home/controllers/home_controller.dart';
import 'package:bus_pass/app/modules/home/controllers/scanner_controller.dart';
import 'package:bus_pass/app/modules/home/views/pass_details_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class BusPassProvider extends GetConnect {
  ScannerController scannerController = Get.find();
  HomeController homeController = Get.find();
  getBusPass(String id, BuildContext context) async {
    try {
      final response = await http.post(
          Uri.parse('https://app.conext.in/bus_pass/checker/'),
          body: {'pass_id': id});
      log(response.body.toString());
      var data = jsonDecode(response.body.toString());
      if (data['Bus_Pass'].toString() != "No Such Pass Alloted") {
        BusPass busPass = busPassFromJson(response.body);
        scannerController.busPass = busPass.student;
        SnackbarMessage()
            .snackBarMessage('Your pass send successfully', context);
        Get.to(() => const PassDetailsView());
        homeController.loading.value = false;
        homeController.loadingOff();
      } else if ('Error: ${data['Bus_Pass'].toString()}' ==
          "No Such Pass Alloted") {
        var data = jsonDecode(response.body.toString());
        SnackbarMessage()
            .snackBarMessage((data['Bus_Pass'].toString()), context);
        homeController.loading.value = false;
        homeController.loadingOff();
      } else {
        SnackbarMessage()
            .snackBarMessage((data['Bus_Pass'].toString()), context);
        homeController.loading.value = false;
        homeController.loadingOff();
      }
    } catch (e) {
      log(e.toString());
      SnackbarMessage().snackBarMessage(
          'Oops! something went wrong! Check again and try', context);
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
