import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/colors.dart';

class TextFieldStyle{
  static InputBorder mainBorder=OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(8.r)
  );
  static InputBorder errorBorder=OutlineInputBorder(
    borderSide:const BorderSide(color: Colors.red, width: 1),
    borderRadius: BorderRadius.circular(8.r)
  );
  static InputDecoration inputDecoration=InputDecoration(
    contentPadding: EdgeInsets.only(left:12.w),
    fillColor:const Color(0xffF0EFFF),
    hintStyle: TextStyle(color: ConstColors.secondaryColor,fontSize: 15.sp,fontWeight: FontWeight.w400),
    filled: true,
      disabledBorder:mainBorder,
    suffixIconColor: ConstColors.secondaryColor,
    border: mainBorder,
    enabledBorder: mainBorder,
    errorBorder: errorBorder,
    focusedBorder: mainBorder,
    focusedErrorBorder: errorBorder

  );
}