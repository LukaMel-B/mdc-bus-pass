import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TableRowWidget extends GetView {
  final String title;
  final String text;
  const TableRowWidget({required this.title, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
          width: screenSize / 1.5,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat Regular',
              fontSize: 18.sp,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat SemiBold',
                fontSize: 18.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
