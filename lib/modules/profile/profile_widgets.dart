

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_helper/modules/profile/update_profile.dart';
import 'package:firebase_helper/modules/profile/update_profile_image.dart';
import 'package:firebase_helper/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/controllers/user/user.dart';
import '../../models/controllers/user/user_cubit.dart';
import '../../shared/styles/colors.dart';
import '../../shared/widgets/default_button.dart';

Widget profilePhoto({required String image , required String uId,required BuildContext context}) => SizedBox(
  height: 160.h,
  width: 160.h,
  child: Align(
    alignment: Alignment.center,
    child: Stack(
      fit: StackFit.loose,
      alignment: Alignment.topRight,
      children: [
        CircleAvatar(
          radius: 80.r,
          child: CachedNetworkImage(
            imageUrl: image,
          ),
        ),
        if(uId==CacheHelper.getData(key: "uId"))
          Container(
          alignment: Alignment.center,
          height: 36.h,
          width: 36.h,
          decoration:const BoxDecoration(
              color: ConstColors.primaryColor, shape: BoxShape.circle),
          child: IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            onPressed: () {
              showModalBottomSheet(context: context, builder: (newContext)=>
                  BlocProvider.value(value: UserCubit.get(context),child: const UpdateProfileImage()),
                  isScrollControlled: true );
            },
            iconSize: 24.r,
            color: ConstColors.white,
            icon: const Icon(Icons.edit),
          ),
        ),
      ],
    ),
  ),
);

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
