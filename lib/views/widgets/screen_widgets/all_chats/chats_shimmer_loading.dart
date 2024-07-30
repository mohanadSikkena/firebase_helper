

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/shimmer_loading.dart';




class ChatsShimmerLoading extends StatelessWidget {
  const ChatsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, i) => ListTile(
            leading: CircleAvatar(
              radius: 40.r,
            ),
            title: Container(
              margin: EdgeInsets.only(right: 110.w),
              color: Colors.black,
              height: 18.h,
            ),
            subtitle: Container(
              color: Colors.black,
              height: 18.h,
              margin: EdgeInsets.only(right: 140.w,top: 10.h),

            ),
          ),
          separatorBuilder: (context, i) => const SizedBox(
            height: 20,
          ),
          // itemCount:  100),
          itemCount: 9),
    );
  }
}



