import 'package:bus_pass/app/modules/home/controllers/scanner_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PassDetailsView extends GetView<ScannerController> {
  const PassDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(
          FontAwesomeIcons.arrowLeftLong,
          color: Colors.black,
        ),
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/valid.svg'),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  'Valid Bus Pass',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat Black',
                    fontSize: 35.sp,
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                ListView.separated(
                    itemBuilder: (context, index) {
                      return;
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 30.h,
                      );
                    },
                    itemCount: controller.titleList.length)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
