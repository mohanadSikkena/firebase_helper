import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helper/models/errors/error.dart';
import 'package:firebase_helper/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../validation/validator.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context)=>BlocProvider.of(context);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  LoginValidation loginValidator = LoginValidation();
  login()async{
    emit(LoginLoadingState());
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text)
        .then((value){
          CacheHelper.putData(key: "uId", value: value.user!.uid);
          emit(LoginSuccessState());
        });
    } on FirebaseAuthException catch (e){
      log(e.code);
      emit(LoginFailState(ErrorHelper.firebaseAuthErrors(error: e.code)));
    }
  }

}
