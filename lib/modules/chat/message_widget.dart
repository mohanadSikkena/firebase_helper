

import 'package:firebase_helper/models/controllers/chats/chat_cubit.dart';
import 'package:firebase_helper/models/controllers/chats/message_model.dart';
import 'package:firebase_helper/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';




Widget messageWidget({required BuildContext context ,required int i }){



  ChatCubit cubit = ChatCubit.get(context);

  MessageModel messageModel = cubit.chatMessages[i];
  double topPadding = 16.h;
  if(i > 0){
    MessageModel lastMessageeModel = cubit.chatMessages[i-1];
    if(lastMessageeModel.isSender==messageModel.isSender){
      topPadding=8.h;
    }
  }

  return Padding(
    padding: EdgeInsets.only(top: topPadding),
  child: messageModel.isSender? SenderMessageWidget(messageModel: messageModel,): ReceiverMessageWidget(messageModel: messageModel,)
  );
}


class SenderMessageWidget extends StatelessWidget {
  final MessageModel messageModel;
  const SenderMessageWidget({super.key , required this.messageModel});

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
                    Text(messageModel.timeStamps),
                    SizedBox(width: 4.w,),
                    Icon(
                      messageModel.isSent ? messageModel.isMessageSeen? Icons.check_circle:Icons.check:Icons.radio_button_unchecked,
                        // messageModel.isSent?Icons.check_circle:messageModel.isMessageSeen?Icons.radio_button_unchecked:Icons.check,
                      color: ConstColors.primaryColor,
                      size: 14.r,
                    ),
                  ],
                )
              ],
            )));
  }
}

class ReceiverMessageWidget extends StatelessWidget {
  final MessageModel messageModel;
  const ReceiverMessageWidget({super.key , required this.messageModel});

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
                Text(messageModel.timeStamps),
              ],
            )));
  }
}

