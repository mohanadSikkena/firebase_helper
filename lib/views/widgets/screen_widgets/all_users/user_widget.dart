import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/assets.dart';
import '../../../../models/user/user.dart';

class AllUsersWidget extends StatelessWidget {
  final UserModel userModel;
  const AllUsersWidget({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          context.pushNamed("chatDetails",
              pathParameters: {"chatId": userModel.uId});
        },
        visualDensity:const VisualDensity(vertical:4),
        leading: CircleAvatar(
          radius: 40.r,
          onForegroundImageError:(o,s){},
          onBackgroundImageError: (o,s){},
          foregroundImage: CachedNetworkImageProvider(
            userModel.image,
          ),
          backgroundImage:const AssetImage(Assets.defaultProfileImage),
        ),
        title: Text(userModel.name),
        subtitle: Text(userModel.email));
  }
}
