


import 'package:firebase_helper/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function ()? onPressed;
  final Color ?color;
  final Icon ? icon;
  final Color ? textColor;
  const DefaultButton({super.key,required this.text , required this.onPressed,this.color , this.icon , this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 59.h,
      width: 1.sw,
      decoration: BoxDecoration(
        color: color??ConstColors.primaryColor,
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon !=null? Padding(
              padding: EdgeInsets.only(right:10.0.w),
              child: icon,
            ):const SizedBox(),
            Text(text,style: TextStyle(color: textColor?? ConstColors.white, fontSize: 16.sp,fontWeight: FontWeight.w500),),
          ],
        )
      ),
    );
  }
}
