

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helper/models/errors/error.dart';
import 'package:firebase_helper/shared/network/local/cache_helper.dart';
import 'package:firebase_helper/shared/network/remote/remote_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../validation/validator.dart';
import '../user/user.dart';
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  static SignupCubit get(context)=>BlocProvider.of(context);

  final TextEditingController numberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();


  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  int selectedGenderValue = 1;
  EmailValidation emailValidator = EmailValidation();


  changeGenderValue(int newValue){
    selectedGenderValue = newValue;
    emit(ChangeSelectedGenderValue());
  }

  signup()async{
    emit(SignupLoadingState());
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text)
          .then((value) async{
        emit(SignupSuccessState());

        sendEmailVerification(value.user);
        createUser(uid: value.user!.uid);
      });
    } on FirebaseAuthException catch (e){
      emit(SignupFailState(ErrorHelper.firebaseAuthErrors(error: e.code)));
    }
  }

  createUser({required String uid})async{
    UserModel user=UserModel(
        uId: uid,
        gender: selectedGenderValue==1?"Male":"Female",
        dateOfBirth: dateOfBirthController.text,
        phoneNumber: numberController.text,
        name: usernameController.text,
        email: emailController.text,
        bio: "Hello I`m new to Firebase Helper",
        image: RemoteImages.getRandomImage(gender:selectedGenderValue));
    emit(CreateUserLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(user.uId)
        .set(user.toMap())
        .then((value) {
      CacheHelper.putData(key: "uId", value: user.uId);
      emit(CreateUserSuccessState());})
        .catchError((e){


          emit(CreateUserFailState(ErrorHelper.firebaseAuthErrors(error: e)));
    });
  }



  sendEmailVerification(User?user){
    user!.sendEmailVerification();
  }
}