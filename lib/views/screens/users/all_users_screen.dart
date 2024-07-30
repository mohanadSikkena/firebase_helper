import 'package:firebase_helper/views/widgets/screen_widgets/all_users/user_widget.dart';
import 'package:firebase_helper/views/widgets/screen_widgets/all_chats/chats_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/user/user_cubit.dart';

class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      UserCubit()
        ..getAllUsers(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<UserCubit, UserState>(
          buildWhen: (lastState,currentState){
            return
              currentState is GetAllUsersDataSuccessState
                ||
                currentState is GetAllUsersDataLoadingState;
          },
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            // return ChatsShimmerLoading();
            return state is GetAllUsersDataSuccessState?  ListView.separated(
                itemBuilder: (context,i)=>AllUsersWidget(userModel: UserCubit.get(context).users[i]),
                separatorBuilder: (context,i)=>SizedBox(height: 10,),
                itemCount: UserCubit.get(context).users.length):const ChatsShimmerLoading();
          },
        )
        ,
      ),
    );
  }
}
