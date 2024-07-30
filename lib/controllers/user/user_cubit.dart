import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helper/core/cache/cache_helper.dart';
import 'package:firebase_helper/repositories/chat/chat_repository.dart';
import 'package:firebase_helper/repositories/images/image_repository.dart';
import 'package:firebase_helper/repositories/user/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user/user.dart';


part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  static UserCubit get(context) => BlocProvider.of(context);

  UserModel? _user;

  UserModel get user => _user!;




  List<UserModel> _users = [];

  List<UserModel> get users => _users;

  Future<void> getAllUsers() async {
    _users = [];
    emit(GetAllUsersDataLoadingState());
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      try {
        String myUid = CacheHelper.getData(key: "uId");
        for (var element in value.docs) {
          UserModel newUser = UserModel.fromMap(element.data());
          if (newUser.uId != myUid) {
            _users.add(newUser);
          }
        }
        emit(GetAllUsersDataSuccessState());
      } catch (e) {
        emit(GetAllUsersDataFailState());
      }
    });
  }

  initProfilePage({required String uId, required BuildContext context}) async {
    await getUser(uId: uId);
    if (_user != null) {
      if (context.mounted) {
        await CacheHelper.cacheUserImage(context: context, userImage: _user!.image);
      }

      emit(GetUserDataSuccessState());
    } else {
      emit(GetUserDataFailState());
    }
  }

  Future<UserModel?> getUser({required String uId}) async {
    emit(GetUserDataLoadingState());
   try{
     _user= await UserRepository.getUser(uId: uId);
     if(_user==null){
       emit(GetUserDataFailState());
     }
     return _user;
   }catch (e){
     emit(GetUserDataFailState());
   }
   return null;
  }

  Future<void> userSignOut() async {
    emit(UserSignOutLoadingState());
    try {
      await CacheHelper.sharedPreferences.clear();
      await FirebaseAuth.instance.signOut();
      emit(UserSignOutSuccessState());
    } catch (e) {
      emit(UserSignOutFailState());
    }
  }

  updateUserProfile(
      {required String name,
      required String phone,
      required String bio,
      required String date}) {
    emit(UpdateUserDataLoadingState());
    UserModel model = _user!
        .copyWith(name: name, phoneNumber: phone, bio: bio, dateOfBirth: date);
    String uId = CacheHelper.getData(key: "uId");
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(UpdateUserDataSuccessState());
    }).catchError((e) {
      emit(UpdateUserDataFailState());
    });
  }

  updateUserProfileImage({
    required String image,
  }) {
    emit(UpdateUserImageLoadingState());
    UserModel model = _user!.copyWith(image: image);
    String uId = CacheHelper.getData(key: "uId");
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(UpdateUserImageSuccessState());
      _getAndUpdateAllUserChatImage(image: image);
      // _getAllUserChatsIds();
    }).catchError((e) {
      emit(UpdateUserImageFailState());
    });
  }


  compressAndUploadImageToFirebase({required File image})async{
    emit(UploadUserImageToFirebaseLoadingState(image));
    var (success ,url)  =await ImageRepository.compressAndUploadImageToFirebase(image: image, distension: "users/${user.uId}");
    if(!success){
      emit(UploadUserImageToFirebaseFailState());
      return;
    }
    emit(UploadUserImageToFirebaseSuccessState());
    updateUserProfileImage(image: url);
  }


  Future <void> _getAndUpdateAllUserChatImage({required String image})async{
    List<String> chats = await _getAllUserChatsIds();
    await _updateAllChatsImageAfterUpdatingImage(chats: chats,image: image);
  }
  Future <void> _updateAllChatsImageAfterUpdatingImage({required List<String> chats ,required String image})async{

    for (var chatId in chats) {
      ChatRepository.updateChatImage(chatId: chatId, uId: user.uId, image: image);
    }
  }
  Future <List<String>> _getAllUserChatsIds()async{
    List<String> chats = [];
    await FirebaseFirestore.instance.collection("users").doc(user.uId).collection("chats").get().then((value) {
      for (var element in value.docs) {
        chats . add(element.id);
      }
    } );

    return chats;
  }




}
