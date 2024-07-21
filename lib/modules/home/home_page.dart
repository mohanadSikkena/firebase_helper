import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_helper/models/controllers/chats/chat_cubit.dart';
import 'package:firebase_helper/shared/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../models/controllers/chats/message_model.dart';
import '../../shared/styles/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        lazy: false,
        create: (context) => ChatCubit()..getCurrentChats(context: context),
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
          },
          builder: (context, state) {
            return ListView(
              children: [
              DefaultButton(text: "send", onPressed: () {
              // ChatCubit.get(context).sendMessage();
            },),
                SizedBox(height: 20,),
                ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                    itemBuilder:(context,i)=>ListTile(
                      onTap: (){
                        // ChatCubit.get(context).messageSeen(chatModel: ChatCubit.get(context).chats[i]);
                        context.pushNamed("chatDetails" , pathParameters: {"chatId":ChatCubit.get(context).chats[i].chatId});
                      },
                      leading: CircleAvatar(
                        radius: 40,
                        child: CachedNetworkImage(imageUrl: ChatCubit.get(context).chats[i].chatImage,

                        ),
                      ),
                      title:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(ChatCubit.get(context).chats[i].chatName),
                          // Text(formattedTimeStamp(timeStampString: ChatCubit.get(context).chats[i].lastMessageTimeStamp ), style: TextStyle(color: Colors.black ,fontSize:12.sp),),
                          Text(ChatCubit.get(context).chats[i].lastMessageTimeStamp , style: TextStyle(color: Colors.black ,fontSize:12.sp),),
                        ],
                      ),
                      subtitle:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(ChatCubit.get(context).chats[i].lastMessage),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 2.w),
                            decoration: BoxDecoration(
                                color: ConstColors.primaryColor,
                                borderRadius: BorderRadius.circular(4.r)
                            ),
                            child:Text("${ChatCubit.get(context).chats[i].unSeenMessageCount}" , style: TextStyle(color: Colors.white ,fontSize:12.sp),) ,

                          ),
                        ],
                      ),

                      // trailing: Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //   ],
                      // ),
                      // trailing: CircleAvatar(
                      //
                      //
                      //   backgroundColor: Colors.red, minRadius:7.r,
                      //   maxRadius: 12.r,
                      //
                      //   child: Center(
                      //       child: Text("50" , style: TextStyle(color: Colors.white ,fontSize:12.sp),)),),
                    ) ,
                    separatorBuilder: (context , i)=>SizedBox(height: 20,),
                    itemCount: ChatCubit.get(context).chats.length)
              ],
            );
          },
        ),
      ),
    );
  }
}
