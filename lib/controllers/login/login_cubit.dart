import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helper/core/cache/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/helpers/errors/error.dart';
import '../../utils/helpers/validation/validator.dart';

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
      log("Login Failed ${e.code}");
      emit(LoginFailState(ErrorHelper.firebaseAuthErrors(error: e.code)));
    }
  }

}
