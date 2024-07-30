
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/colors/colors.dart';
import '../../../../theme/text_styles/text_styles.dart';

class IntroductionWidget extends StatelessWidget {
  final bool isLoginPage;
  const IntroductionWidget({super.key , this.isLoginPage = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(isLoginPage ?"Sign in to ":"Sign in up" , style: ConstTextStyles.mainStyle.copyWith(fontSize: 26.sp , fontWeight: FontWeight.w600),),
        Text("FireBase Helper is simply  " , style: ConstTextStyles.mainStyle,),
        SizedBox(height: 32.h,),
        Text("If you ${isLoginPage?"don’t":"already"} have an account register " , style: ConstTextStyles.mainStyle.copyWith(fontSize: 14.sp , fontWeight: FontWeight.w400),),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("You can   " , style: ConstTextStyles.mainStyle.copyWith(fontSize: 14.sp , fontWeight: FontWeight.w400),),
            TextButton(onPressed: (){
              context.go(!isLoginPage?"/login":"/signup");
            },
              child: Text(isLoginPage ?"Register here !":"Login here !" , style: ConstTextStyles.mainStyle.copyWith(fontSize: 14.sp , fontWeight: FontWeight.w600, color: ConstColors.primaryColor),),
            ),
          ],
        )
      ],
    );
  }
}
