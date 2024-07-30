import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_helper/views/widgets/common/custom_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controllers/user/user_cubit.dart';
import '../../../core/cache/cache_helper.dart';
import '../../../models/user/user.dart';
import '../../../theme/colors/colors.dart';
import '../../../theme/text_styles/text_styles.dart';
import '../../widgets/common/default_button.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/screen_widgets/profile/profile_buttons/profile_buttons.dart';
import '../../widgets/screen_widgets/profile/profile_information/profile_information.dart';
import '../../widgets/screen_widgets/profile/profile_picture/profile_picture.dart';

class ProfileScreen extends StatefulWidget {
  final String userUid;
  const ProfileScreen({super.key, required this.userUid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserCubit()..initProfilePage(uId: widget.userUid, context: context),
      child: BlocConsumer<UserCubit, UserState>(
       
        listener: homePageScreenHandleStates,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Share.share(
                        "app://firebase-helper.com/profile/${widget.userUid}");
                  },
                  icon: const Icon(Icons.share),
                  color: ConstColors.primaryColor,
                ),
              ],
            ),
            body: BlocProvider.value(
                value: UserCubit.get(context),
                child: state is GetUserDataSuccessState ||
                 state is UploadUserImageToFirebaseLoadingState


                    ? ProfileScreenMainPage(user: UserCubit.get(context).user)
                    : state is GetUserDataFailState
                        ? ProfileScreenFailPage(
                            userUid: widget.userUid,
                          )
                        : const ProfileScreenLoadingPage()),
          );
        },
      ),
    );
  }

  void homePageScreenHandleStates(BuildContext context, UserState state) {
    if (state is UpdateUserDataLoadingState ||
        state is UpdateUserImageLoadingState || state is UploadUserImageToFirebaseLoadingState) {
      if(context.canPop()){
        context.pop();
      }
    }

    if (state is UpdateUserDataSuccessState ||
        state is UploadUserImageToFirebaseSuccessState||
        state is UploadUserImageToFirebaseFailState||
        state is UpdateUserDataFailState ||
        state is UpdateUserImageFailState ||
        state is UpdateUserImageSuccessState) {
      UserCubit.get(context).initProfilePage(
        uId: widget.userUid,
        context: context,
      );
    }

    if (state is UserSignOutLoadingState) {
      showStyledPopLoading(context);
    }
    if (state is UserSignOutFailState) {
      if(context.canPop()){
        context.pop();
      }
      showUndefinedErrorAlert(context);
    }
    if (state is UserSignOutSuccessState) {
      if(context.canPop()){
        context.pop();
      }
      context.go("/login");
    }
  }
}

class ProfileScreenMainPage extends StatelessWidget {
  final UserModel user;
  const ProfileScreenMainPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListView(
        children: [
          profilePhoto(image: user.image, uId: user.uId, context: context),
          Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                user.name,
                style: ConstTextStyles.mainStyle,
              ),
            ),
          ),
          informationList(user: user, context: context),
          if (user.uId == CacheHelper.getData(key: "uId"))
            SizedBox(height: 55.h, child: editProfileButton(context: context)),
          logOutButton(context: context)
        ],
      ),
    );
  }
}

class ProfileScreenFailPage extends StatelessWidget {
  final String userUid;
  const ProfileScreenFailPage({super.key, required this.userUid});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 30),
            const Text(
              'Oops!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: ConstColors.black,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Failed to get your data. Please try again.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: ConstColors.black),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                UserCubit.get(context)
                    .initProfilePage(uId: userUid, context: context);
              },
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Or You Can.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: ConstColors.black),
            ),
            FirebaseAuth.instance.currentUser == null
                ? DefaultButton(text: "Sign In", onPressed: () {})
                : logOutButton(context: context)
          ],
        ),
      ),
    );
  }
}

class ProfileScreenLoadingPage extends StatelessWidget {
  const ProfileScreenLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListView(
        children: [
          const CircleAvatar(
            radius: 80,
            child: CircularProgressIndicator(),
            // child: Image.network(cubit.user.image),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 25.h, left: 0.5.sw - (110.w), right: 0.5.sw - (110.w)),
            color: Colors.black,
            height: 26.h,
            width: 128,
          ),
          SizedBox(
            height: 32.h,
          ),
          for (int i = 0; i <= 5; i++)
            Container(
              margin: EdgeInsets.only(bottom: 16.h),
              height: 21.h,
              color: Colors.black,
            ),
          Container(
            height: 55,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(9.r)),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(9.r)),
            margin: EdgeInsets.only(top: 16.h),
            height: 55,
          ),
        ],
      ),
    ));
  }
}
