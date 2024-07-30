
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_helper/generated/assets.dart';
import 'package:firebase_helper/repositories/chat/chat_repository.dart';
import 'package:firebase_helper/repositories/images/image_repository.dart';
import 'package:firebase_helper/repositories/vidos/video_repository.dart';
import 'package:firebase_helper/views/widgets/screen_widgets/chat_details/message_widget.dart';
import 'package:firebase_helper/views/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../controllers/chats/chat_cubit.dart';
import '../../../theme/colors/colors.dart';
import '../../widgets/screen_widgets/chat_details/mdeia_selection.dart';


class ChatDetails extends StatelessWidget {
  final String chatId;
  const ChatDetails({super.key , required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatCubit()..getTargetUserLastSeenFromCache(uId: chatId)..getChatUserLastSeen(chatId: chatId)..getChatMessages(chatId: chatId),

      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        buildWhen: (lastState , currentState){
          return currentState is GetChatMessagesFailState || currentState is GetChatMessagesSuccessState;
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,

            bottomSheet: SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: CustomTextField(text: 'Type a message ...',
                        maxLines: null,
                        controller: ChatCubit.get(context).messageTextController,
                      ),
                    ),
                    IconButton(
                      color: ConstColors.primaryColor,
                      icon: const Icon(Icons.attach_file),
                      onPressed: (){
                        showMediaPickerDialog(context,chatId);
                      },
                    ),
                    IconButton(
                      color: ConstColors.primaryColor,
                      icon: const Icon(Icons.send),
                      onPressed: (){
                        if(ChatCubit.get(context).messageTextController.text.isNotEmpty){
                          ChatRepository.sendTextMessage(
                              message: ChatCubit.get(context).messageTextController.text,
                              receiverId: chatId
                          );
                        }
                        ChatCubit.get(context).messageTextController.clear();
                      },
                    ),

                  ],
                )),
            appBar: AppBar(
              leadingWidth: 80.w,
              // centerTitle: true,
              leading:ChatCubit.get(context).currentChat!=null? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: (){
                    context.pop();
                  }
                  , icon: Icon(Icons.arrow_back)
                  ),
                  CircleAvatar(
                    radius: 16.r,
                    child: CachedNetworkImage(
                      imageUrl: ChatCubit.get(context).currentChat?.chatImage??"",
                      errorWidget: (context,imageUrl,object)=>Image.asset(Assets.defaultProfileImage),
                    )
                  )
                ],
              ):null,
              title: ChatCubit.get(context).currentChat!=null?Text("${ChatCubit.get(context).currentChat?.chatName}"):null,
            ),

            body: Padding(
              padding:  EdgeInsets.only( right: 24.w , left: 24.w , bottom: 70.h),
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
