

import 'package:firebase_helper/views/widgets/screen_widgets/profile/profile_information/update_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../controllers/user/user_cubit.dart';
import '../../../../../theme/colors/colors.dart';
import '../../../common/default_button.dart';



Widget editProfileButton({required BuildContext context})=>DefaultButton(
    text: "Edit Profile",
    icon: const Icon(
      Icons.edit,
      color: ConstColors.white,
    ),
    onPressed: () {
      showModalBottomSheet(context: context, builder: (newContext)=> BlocProvider.value(value: UserCubit.get(context) , child: const EditProfileBottomSheet(),)
        , isScrollControlled: true );
    });
Widget logOutButton({required BuildContext context}) => Padding(
  padding: EdgeInsets.only(top: 16.0.h),
  child: DefaultButton(
      text: "Logout",
      textColor: Colors.red,
      color: const Color(0xffFEECEB),
      icon: const Icon(
        Icons.logout,
        color: Colors.red,
      ),
      onPressed: () {
        UserCubit.get(context).userSignOut();
      }),
);
