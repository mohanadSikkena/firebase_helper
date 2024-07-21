
import 'package:firebase_helper/shared/network/local/cache_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context)=>BlocProvider.of(context);

  int currentTab = 0;
  void changeTab(BuildContext context ,int value){
    switch (value){
      case 0 : context.goNamed("home");
      case 1 : context.goNamed("profile", pathParameters: {"id":CacheHelper.getData(key: "uId")});
    }
    currentTab = value;
  }
}
