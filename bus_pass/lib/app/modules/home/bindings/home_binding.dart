import 'package:bus_pass/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import 'package:bus_pass/app/modules/home/controllers/scanner_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScannerController>(
      () => ScannerController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
