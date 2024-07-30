


import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../theme/colors/colors.dart';


class ShimmerLoading extends StatelessWidget {
  final Widget child;
  const ShimmerLoading({super.key , required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ConstColors.grey,
      highlightColor: ConstColors.lightGrey.withOpacity(0.6),
      child:child,
    );
  }
}
