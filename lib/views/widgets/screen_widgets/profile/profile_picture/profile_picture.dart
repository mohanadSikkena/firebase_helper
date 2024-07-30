




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../controllers/user/user_cubit.dart';
import '../../../../../core/cache/cache_helper.dart';
import '../../../../../generated/assets.dart';
import '../../../../../theme/colors/colors.dart';
import 'update_profile_image.dart';

Widget profilePhoto({required String image , required String uId,required BuildContext context}) => SizedBox(
  height: 160.h,
  width: 160.h,
  child: BlocBuilder<UserCubit, UserState>(
    builder: (context, state) {
      return Align(
        alignment: Alignment.center,
        child:state is UploadUserImageToFirebaseLoadingState ?CircleAvatar(
          radius: 80.r,
          backgroundImage: FileImage(
            state.image,
          ),
        ): Stack(
          fit: StackFit.loose,
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: 80.r,
              foregroundImage: CachedNetworkImageProvider(image,errorListener: (o){}),
              backgroundImage:const AssetImage(Assets.defaultProfileImage),
              onForegroundImageError: (o,s){},
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
      );
    },
  ),
);
