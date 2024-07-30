
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_helper/models/message/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../generated/assets.dart';
import '../../../../models/chat/chat_model.dart';
import '../../../../theme/colors/colors.dart';


class ChatWidget extends StatelessWidget {

  final ChatModel chatModel;
  const ChatWidget({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        context.pushNamed("chatDetails" , pathParameters: {"chatId":chatModel.chatId});

      },

      visualDensity:const VisualDensity(vertical: 4 , ),
      leading: CircleAvatar(
        radius: 40.r,
        onBackgroundImageError: (o,s){},
        foregroundImage: CachedNetworkImageProvider(
          chatModel.chatImage,
        ),
        backgroundImage: AssetImage(Assets.defaultProfileImage),
      ),
      title:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(chatModel.chatName),
          Text(chatModel.stringTimeStamp , style: TextStyle(color: Colors.black ,fontSize:12.sp),),
        ],
      ),
      subtitle:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          chatModel.lastMessageType==MessageTypes.text? Text(chatModel.lastMessage):const Icon(Icons.image , color: ConstColors.primaryColor,),
          chatModel.unSeenMessageCount >0?Container(
            padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 2.w),
            decoration: BoxDecoration(
                color: ConstColors.primaryColor,
                borderRadius: BorderRadius.circular(4.r)
            ),
            child:Text("${chatModel.unSeenMessageCount}" , style: TextStyle(color: Colors.white ,fontSize:12.sp),) ,

          ):SizedBox(),
        ],
      ),
    );
  }
}

