import 'package:firebase_helper/views/widgets/screen_widgets/all_chats/chat_widget.dart';
import 'package:firebase_helper/views/widgets/screen_widgets/all_chats/chats_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../controllers/chats/chat_cubit.dart';
import '../../../theme/colors/colors.dart';

class AllChatsScreen extends StatelessWidget {
  const AllChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => ChatCubit()..getCurrentChats(context: context),
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButton: BlocConsumer<ChatCubit, ChatState>(
          buildWhen: (lastState, currentState) {
            return currentState is ChangeChatsScreenScrollDirection;
          },
          listener: (context, state) {},
          builder: (context, state) {
            return FloatingActionButton.extended(
                onPressed: () {
                  context.pushNamed("allUsers");
                },
                autofocus: true,
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                        child:  Icon(
                      Icons.message,
                      color: ConstColors.primaryColor,
                    )),
                    ChatCubit.get(context).hideLabel ||
                        ChatCubit.get(context).showFABLabel
                        ? const SizedBox(
                            width: 8,
                          )
                        : const SizedBox(),
                    AnimatedSlide(
                        onEnd: () {
                          ChatCubit.get(context).onEnd();
                        },
                        duration: const Duration(seconds: 1),
                        offset: ChatCubit.get(context).showFABLabel
                            ? const Offset(0, 0)
                            : const Offset(2, 0),
                        child: ChatCubit.get(context).hideLabel ||
                                ChatCubit.get(context).showFABLabel
                            ? const Text("start chat")
                            : const SizedBox())
                  ],
                ));
          },
        ),
        body: BlocConsumer<ChatCubit, ChatState>(
          buildWhen: (prevState, currentState) {
            return currentState is GetUserChatsSuccessState
            || currentState is GetUserChatsLoadingState;
            // return false;
          },
          listener: (context, state) {},
          builder: (context, state) {
            return NotificationListener<UserScrollNotification>(
              onNotification:
                  ChatCubit.get(context).chatsScreenChangeScrollDirection,
              child: state is GetUserChatsSuccessState ?ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) => ChatWidget(
                       chatModel: ChatCubit.get(context).chats[i]),
                  separatorBuilder: (context, i) => const SizedBox(
                        height: 20,
                      ),
                  // itemCount:  100),
                  itemCount: ChatCubit.get(context).chats.length):const ChatsShimmerLoading(),
            );
          },
        ),
      ),
    );
  }
}
