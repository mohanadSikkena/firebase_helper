
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../models/user/user.dart';
import '../../../../../theme/colors/colors.dart';

Widget informationList(
    {required UserModel user, required BuildContext context}) =>
    Padding(
      padding: EdgeInsets.only(top: 25.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          informationWidget(
              mainText: "Phone", mainValue: user.phoneNumber, context: context),
          informationWidget(
              mainText: "Gender", mainValue: user.gender, context: context),
          informationWidget(
              mainText: "Birthday",
              mainValue: user.dateOfBirth,
              context: context),
          informationWidget(
              mainText: "Email", mainValue: user.email, context: context),
          informationWidget(
              mainText: "Bio", mainValue: user.bio, context: context),

        ],
      ),
    );
Widget informationWidget(
    {required String mainText,
      required mainValue,
      required BuildContext context}) =>
    Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$mainText :",
            style: TextStyle(
                color: ConstColors.lightGrey,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: 8.w,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              mainValue,
              style: TextStyle(
                color: ConstColors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
            ),
          ),
          // Fe(child:const SizedBox()),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 20.r,
              width: 20.r,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: mainValue))
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('$mainText copied to your clipboard !'),
                      duration: const Duration(seconds: 1),
                    ));
                  });
                },
                iconSize: 20.r,
                splashRadius: 20.r,
                color: ConstColors.black,
                icon: const Icon(
                  Icons.copy,
                ),
              ),
            ),
          )
        ],
      ),
    );