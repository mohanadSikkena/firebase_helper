import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:firebase_helper/controllers/video_message/video_message_cubit.dart';
import 'package:firebase_helper/controllers/video_message/video_message_cubit.dart';
import 'package:firebase_helper/repositories/vidos/video_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../models/message/message_model.dart';
import '../../../../theme/colors/colors.dart';



class SenderVideoMessageWidget extends StatelessWidget {
  final MessageModel messageModel;

  const SenderVideoMessageWidget({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(left: 50.w),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.r),
          child: InkWell(
            onTap: () {
            },
            child: Image.file(
              File(messageModel.thumbnail!),
              errorBuilder: (c,o,s)=>Container(
                height: 100,
                color: Colors.black,
              ),

            ),

          ),
        ));
  }
}

class ReceiverVideoMessageWidget extends StatelessWidget {
  final MessageModel messageModel;

  const ReceiverVideoMessageWidget({super.key, required this.messageModel});

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
                  print(messageModel.stringTimeStamp);
                  return CircularProgressIndicator();
                },
              ),
            )));
  }
}
