// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:bus_pass/app/data/providers/bus_pass_provider.dart';
import 'package:bus_pass/app/modules/home/controllers/home_controller.dart';
import 'package:bus_pass/app/modules/home/views/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.height;
    double containerSize = screenSize / 1.4;
    double spacerSize = screenSize * .05;
    return Scaffold(
        backgroundColor: const Color(0xffCEEBD7),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffCEEBD7),
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
            ),
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
        body: SingleChildScrollView(
          reverse: true,
          physics:
              const BouncingScrollPhysics(parent: FixedExtentScrollPhysics()),
          child: Wrap(
            runSpacing: spacerSize,
            runAlignment: WrapAlignment.spaceBetween,
            children: [
              Container(),
              Center(
                child: Text(
                  'Bus Pass',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat Black',
                    fontSize: 40.sp,
                  ),
                ),
              ),
              Container(
                height: containerSize,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.h),
                        topRight: Radius.circular(50.h))),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 40.h, horizontal: 30.h),
                  child: Column(
                    children: [
                      Text(
                        'Validate Pass',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat Bold',
                          fontSize: 28.sp,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          Get.to(
                            () => const ScannerView(),
                          );
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/images/scanner.svg',
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Scan QR',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat Bold',
                                fontSize: 21.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat SemiBold',
                          fontSize: 25.sp,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15.w,
                          ),
                          Text(
                            'Pass ID',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat SemiBold',
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: Form(
                              key: controller.formKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enableInteractiveSelection: true,
                                controller: controller.bussPassController,
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return "Id is required!";
                                  } else {
                                    return null;
                                  }
                                }),
                                decoration: controller.textfieldDeco,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          GetBuilder<HomeController>(builder: (controller) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffCEEBD7),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!controller.loading.value) {
                                    if (controller.formKey.currentState!
                                        .validate()) {
                                      controller.loading.value = true;
                                      controller.loadingOn();
                                      final passId = controller
                                          .bussPassController.text
                                          .trim();
                                      await BusPassProvider()
                                          .getBusPass(passId, context);
                                      FocusScope.of(context).unfocus();
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                      vertical: controller.visibleH.value,
                                      horizontal: controller.visibleW.value),
                                  elevation: 7,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: Colors.transparent,
                                ),
                                child: Obx(() {
                                  return (controller.loading.value)
                                      ? Transform.scale(
                                          scale: 0.6,
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeWidth: 1.7,
                                          ),
                                        )
                                      : Text(
                                          'Submit',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: 'Montserrat Bold',
                                              color: Colors.black),
                                        );
                                }),
                              ),
                            );
                          })
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            left: 15,
            right: 25,
            bottom: 20.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff4BA695),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final Uri url = Uri(scheme: 'tel', path: '8086500023');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      log('cannot call');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 35.w),
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.transparent,
                  ),
                  child: Wrap(
                    spacing: 9.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Image.asset('assets/images/Phone.png'),
                      Text(
                        'Call for Help',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Montserrat Bold',
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
