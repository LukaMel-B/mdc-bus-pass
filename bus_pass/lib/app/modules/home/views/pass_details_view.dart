import 'dart:developer';
import 'package:bus_pass/app/modules/home/bindings/home_binding.dart';
import 'package:bus_pass/app/modules/home/controllers/details_controller.dart';
import 'package:bus_pass/app/modules/home/views/scanner_view.dart';
import 'package:bus_pass/app/modules/home/widgets/table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PassDetailsView extends GetView<DetailsController> {
  const PassDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.only(left: 10)),
            child: const Icon(
              FontAwesomeIcons.arrowLeftLong,
              color: Colors.black,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                'Connect',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat Medium',
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
          children: [
            (controller.busPass!.busPass == "Valid Pass")
                ? SvgPicture.asset('assets/images/valid.svg')
                : SvgPicture.asset('assets/images/invalid.svg'),
            SizedBox(
              height: 15.h,
            ),
            (controller.busPass!.busPass == "Valid Pass")
                ? Text(
                    'Valid Bus Pass',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat Black',
                      fontSize: 30.sp,
                    ),
                  )
                : Text(
                    'Bus Pass Expired',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat Black',
                      fontSize: 30.sp,
                    ),
                  ),
            SizedBox(
              height: 50.h,
            ),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return detailsMethod(index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 30.h,
                );
              },
              itemCount: controller.titleList.length,
            ),
            SizedBox(
              height: 50.h,
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.to(() => const ScannerView(), binding: ScannerBinding());
              },
              child: Column(
                children: [
                  Text(
                    'Scan Next',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat Bold',
                      fontSize: 21.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SvgPicture.asset(
                    'assets/images/scanner.svg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRowWidget detailsMethod(int index) {
    List<dynamic> titleList = [
      controller.busPass!.student.studentName,
      controller.busPass!.student.passId,
      controller.busPass!.student.yearOfJoin,
      controller.busPass!.student.boardingPlace,
      DateFormat.yMMMd().format(controller.busPass!.student.validTill),
    ];
    log(titleList[index].toString());
    return TableRowWidget(
        title: controller.titleList[index], text: titleList[index].toString());
  }
}
