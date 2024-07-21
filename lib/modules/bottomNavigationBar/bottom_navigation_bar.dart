

import 'package:firebase_helper/models/controllers/app/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeBottomNavigationBar extends StatelessWidget {

  final Widget widget;
  const HomeBottomNavigationBar({super.key , required this.widget});

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: ()async{
        if(AppCubit.get(context).currentTab==0){
          return false;
        }
        if(context.canPop()){
          return false;
        }
        AppCubit.get(context).changeTab(context, 0);
        return true;
      },
      child: Scaffold(
        body: widget,
        bottomNavigationBar: BottomNavigationBar(
          items: const[
            BottomNavigationBarItem(icon: Icon(Icons.home) , label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.person) , label: "profile")
          ],
          currentIndex: AppCubit.get(context).currentTab,
          onTap: (value){
            AppCubit.get(context).changeTab(context, value);
          },
        ),
      ),
    );
  }
}
