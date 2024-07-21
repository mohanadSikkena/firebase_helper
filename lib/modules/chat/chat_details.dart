import 'dart:developer';

import 'package:firebase_helper/models/controllers/chats/chat_cubit.dart';
import 'package:firebase_helper/modules/chat/message_widget.dart';
import 'package:firebase_helper/shared/widgets/custom_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatDetails extends StatelessWidget {
  final String chatId;
  ChatDetails({super.key , required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatCubit()..getChatUserLastSeen(chatId: chatId)..getChatMessages(chatId: chatId)..getAndUpdateCurrentChat(chatId: chatId),

      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {

        },
        builder: (context, state) {


          return Scaffold(
            resizeToAvoidBottomInset: true,
            bottomSheet: Container(
                height: 55.h,
                child: CustomTextField(text: 'Type a message ...',
                  controller: ChatCubit.get(context).messageTextController,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: (){
                      ChatCubit.get(context).sendMessage(
                        message: ChatCubit.get(context).messageTextController.text,
                        receiverId: chatId
                      );
                      ChatCubit.get(context).messageTextController.clear();
                    },
                  ),
                )),
            appBar: AppBar(),

            body: Padding(
              padding:  EdgeInsets.only( right: 24.w , left: 24.w , bottom: 70.h),
              // duration: Duration(milliseconds: 20),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  itemBuilder: (
                      context,i)=>messageWidget(context:context,i: i),
                  itemCount: ChatCubit.get(context).chatMessages.length,
              ),
            ),
          );
        },
      ),
    );
  }

}
