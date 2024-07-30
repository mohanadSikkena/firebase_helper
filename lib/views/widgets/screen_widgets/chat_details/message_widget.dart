import 'package:firebase_helper/views/widgets/screen_widgets/chat_details/image_message_widget.dart';
import 'package:firebase_helper/views/widgets/screen_widgets/chat_details/text_message_widget.dart';
import 'package:firebase_helper/views/widgets/screen_widgets/chat_details/video_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../controllers/chats/chat_cubit.dart';
import '../../../../models/message/message_model.dart';
import '../../../../theme/colors/colors.dart';




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
  child: messageModel.isSender? senderMessageWidgets(messageModel: messageModel,): receiverMessageWidgets(messageModel: messageModel,)
  );
}



Widget senderMessageWidgets({required MessageModel messageModel})=>switch(messageModel.messageType){
  MessageTypes.image=>SenderImageMessageWidget(messageModel: messageModel,),
  _=>SenderTextMessageWidget(messageModel: messageModel,)
};

Widget receiverMessageWidgets({required MessageModel messageModel})=>switch(messageModel.messageType){
  MessageTypes.image=>ReceiverImageMessageWidget(messageModel: messageModel,),

  _=>ReceiverTextMessageWidget(messageModel: messageModel,)
};



