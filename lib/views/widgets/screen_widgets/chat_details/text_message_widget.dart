import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/message/message_model.dart';
import '../../../../theme/colors/colors.dart';

class SenderTextMessageWidget extends StatelessWidget {
  final MessageModel messageModel;
  const SenderTextMessageWidget({super.key , required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
            padding: EdgeInsets.only(
                left:messageModel.message.length>5 ?16.w:(16+(5-messageModel.message.length)*6).w,
                bottom: 12.h,
                top: 12.h,
                right: 16.w
            ),
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.only(
                    topLeft:Radius.circular( 16.r),topRight:Radius.circular( 16.r),bottomLeft: Radius.circular( 16.r)
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(messageModel.message),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(messageModel.stringTimeStamp),
                    SizedBox(width: 4.w,),
                    Icon(
                      messageModel.isSent ? messageModel.isMessageSeen? Icons.check_circle:Icons.check_circle_outline:Icons.radio_button_unchecked,
                      color: ConstColors.primaryColor,
                      size: 14.r,
                    ),
                  ],
                )
              ],
            )));
  }
}
class ReceiverTextMessageWidget extends StatelessWidget {
  final MessageModel messageModel;
  const ReceiverTextMessageWidget({super.key , required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: EdgeInsets.only(
                right:messageModel.message.length>5 ?16.w:(16+(5-messageModel.message.length)*6).w,
                bottom: 12.h,
                top: 12.h,
                left: 16.w
            ),
            decoration: BoxDecoration(
                color: ConstColors.lightGrey,
                borderRadius: BorderRadius.only(
                  topLeft:Radius.circular( 16.r),
                  topRight:Radius.circular( 16.r),
                  bottomRight: Radius.circular( 16.r),
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(messageModel.message),
                SizedBox(height: 10.h,),
                Text(messageModel.stringTimeStamp),
              ],
            )));
  }
}

