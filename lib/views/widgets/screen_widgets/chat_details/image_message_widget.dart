import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/message/message_model.dart';
import '../../../../theme/colors/colors.dart';

class SenderImageMessageWidget extends StatelessWidget {
  final MessageModel messageModel;
  const SenderImageMessageWidget({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
            padding: EdgeInsets.all(8.r),
            margin: EdgeInsets.only(left: 50.w),

            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: Colors.yellow,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r))),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r)),
                  child: CachedNetworkImage(
                    imageUrl: messageModel.message,
                    errorWidget: (context, url, object) {
                     return Stack(
                       children: [
                         Image.file(File(url),
                             errorBuilder: (c,o,s){
                           return CircularProgressIndicator();
                         }),
                         const Center(child: CircularProgressIndicator())
                       ],
                     );
                    },
                  ),
                ),
                Icon(
                  messageModel.isSent &&messageModel.message.startsWith("https:") ? messageModel.isMessageSeen? Icons.check_circle:Icons.check_circle_outline:Icons.radio_button_unchecked,
                  color: ConstColors.primaryColor,
                  size: 14.r,
                ),
              ],
            )));
  }
}

class ReceiverImageMessageWidget extends StatelessWidget {
  final MessageModel messageModel;
  const ReceiverImageMessageWidget({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
                color: ConstColors.lightGrey,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r)),
              child: CachedNetworkImage(
                maxHeightDiskCache: 300,
                imageUrl: messageModel.message,
                errorWidget: (context, url, object) {
                  return CircularProgressIndicator();
                },
              ),
            )));
  }
}
