import 'package:bus_pass/app/data/models/bus_pass_model.dart';
import 'package:get/get.dart';

class ScannerController extends GetxController {
  Student? busPass;
  List<String> titleList = [
    'Name:',
    'Pass ID:',
    'Year of Join:',
    'Boarding Place:',
    'Validity:'
  ];
}
